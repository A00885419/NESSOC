// uart.sv

/*
	simple uart module used as a general purpose Comms channel with the FPGA
	We kinda need this for programming and controller anyway
	
	use USB to FTDI Card.
	
	asynch_in
	synch_out
	
	settings for com port
	115200 baud	
	1 start bit
	no parity
	1 stop bit (or more, it doesnt matter on RX side, tx will output 1)
	8 bit data 
	
	--- How to use ---
	
	- instantiate uart_port()
	simply connect your UART signal to uart-port-DI
	
	tx data can be sent by writing to the buffer then incrementing the send_ptr,
	(in that order ) streams can be prepared by by holding tx_clear high and writing
	to tx_buf via send_ptr then the stream can be bursted out by resetting tx_clear 
	the data will be streamed from memory locations $0 to $(send_ptr - 1)
	though you can just write normally and it will still work becasuse the processing 
	clock will be much faster than the uart baud 
	
	available data will be present in the 64kB buffer, this is dereferenced via the read_ptr
	
	to prevent buffer from overflowing hold CLEAR signal high 
	to read after X number of bits are available set read_ptr
	to X and wait for read_valid 
	
	-------- an example for rx --------
	uart_port p1(.*);
	assumming uart_port_DI is connected to a pin recieving
	a uart signal at the above specifications,
	
	data is instantly available at $0 of the buffer after the 
	first 8 bit are passed in, subsequent bits are stored in
	an increasing manner in the buffer. (EG passing in the 
	stream "ABCDE") will store the following in memory
	
	$0 = A
	$1 = B
	etc ...
	
	the valid flag can be used to check if the memory location
	you are reading from has been written to by the pointer yet
	during this current frame. This can be useful to see if 
	a certain size of data has been recieved yet. EG if you 
	wanted to wait until exactly 256 bytes of data has been 
	recieved, you would set read_ptr to 255 then watch the 
	read_valid line until it goes high, at which point you 
	can parse the buffer from 0-255.
	
	by setting clear, the dataframe can be reset,
	the rx_ptr will go back to zero and new information will 
	overwrite the previous information
	
*/


module uart_port( // instantiates the entire port
		input logic clk, 
		// ====== RX signals ======
		input logic [15:0]read_ptr, // buffer read pointer 
		input logic rx_clear,  
		output logic read_valid,
		output logic [7:0]uart_DO,
		//===== tx signals =======
		input logic[15:0]send_ptr,
		input logic tx_clear,
		input logic [7:0]tx_DI,
		output logic send_done,
		// ===== Phyiscal output pins =======
		input logic uart_port_DI,
		output logic uart_port_DO
	); 
	logic uart_valid;
	logic [7:0]uart_rx_DO;
	uart_tx uart_transmitter(
		.send_ptr,
		.uart_port_DO,
		.clear(tx_clear),
		.tx_DI,
		.send_done,
		.clk
	);
	
	uart_buf uart_buffer(
		.read_ptr, .uart_DI(uart_rx_DO), 
		.read_clk(clk), 
		.uart_valid, 
		.clear(rx_clear), 
		.uart_DO(uart_DO), 
		.read_valid
	);
	uart_rx uart_reciever(
		.uart_DI(uart_port_DI), 
		.clk, 
		.uart_valid, 
		.uart_DO(uart_rx_DO)
	);
endmodule 

module uart_buf(//  64kB UART read buffer
	input logic [15:0]read_ptr,
	input logic [7:0]uart_DI,
	input logic uart_valid, read_clk, 
	input logic clear, // if purge is pulled high, the rx_ptr will go to 0
	output logic[7:0]uart_DO,
	output logic read_valid
); 
	logic [15:0]rx_ptr = 0;
	logic [15:0]rx_ptr_next = 0;
	logic [7:0]rx_buf['h600f:0];
	// On each read_clk data is read out to the controling module 
	always_ff@(posedge read_clk) begin 
		uart_DO = rx_buf[read_ptr];
		if(clear) begin 
			rx_ptr = 0;
		end else begin 
			rx_ptr = rx_ptr_next;
		end 
	end

	assign read_valid = (rx_ptr >= read_ptr );   
	// data is valid so long as the rx_ptr also if the buffer is full then all data locations are valid.
	// is greater than the requested data location 
	// Data is read into the current ptr location and the pointer is incremented 
	always_ff@(posedge uart_valid)begin
		rx_buf[rx_ptr] = uart_DI;
		rx_ptr_next = rx_ptr + 1;
	end
endmodule


module uart_rx( // uart in and parallel 8 bit out 
	input logic uart_DI,
	input logic clk,	// operates at will borrow a 21.477 mhz clk borrowed from the ppu_clk
	output logic uart_valid,
	output logic [7:0]uart_DO
);
	parameter NCLKS_PER_BIT = 186; // 21 477 000/(115200) ~= 186.4 Cycles of oversampling 
	
	// Depending on FTDI settings this could be different 
	parameter SPACE = 1;
	parameter MARK = 0;
	
	parameter IDLE = SPACE; // IDLE is always space 
	parameter START = !IDLE; // start is always the opposite of space
	parameter STOP = !START; // stop bit is always the opposite of start 
	
	// RX machine states 
	parameter WAITING = 0;
	parameter READING_DI = 1;
	parameter STOPPING = 2;
	parameter START_BIT = 3;
	logic [2:0]bit_ptr = 0;
	logic [1:0]state = WAITING;
	logic [15:0]count = 0;
	
	// RX fsm
	always_ff@(posedge clk) begin
		case(state)
			WAITING: begin 
				uart_valid <= 0;
				if(uart_DI == START) begin 
					state <= START_BIT; 		// proceed to start bit 
					count <= 0;					// Start the count
				end 
			end 
			START_BIT: begin 
				if(count == NCLKS_PER_BIT * 276) begin 
					count <= 0;
					bit_ptr <= bit_ptr + 1;
					uart_DO[bit_ptr] <= uart_DI ^ SPACE; 
					state <= READING_DI;
				end else begin 
					count <= count + 1;
				end
			end 
			READING_DI: begin 
				if(count == NCLKS_PER_BIT) begin 
					count <= 0;
					bit_ptr <= bit_ptr + 1;
					uart_DO[bit_ptr] <= uart_DI ^ SPACE; 
					if(bit_ptr == 7) state <= STOPPING;
				end else begin 
					count <= count + 1;
				end
			end
	
			STOPPING: begin 
				bit_ptr <= 0; // Should already be at zero but this will ensure
				if(count > NCLKS_PER_BIT/2)
					uart_valid <= 1;
					
				if(count == NCLKS_PER_BIT)begin
					count <=0;
					state <= WAITING;
				end else begin 
					count <= count + 1;
				end 
			end
		
		endcase
	end
endmodule 
	
module uart_tx(
	input logic clk,clear, // Same clock as RX
	input logic [7:0]tx_DI,
	input logic [15:0]send_ptr,
	output logic uart_port_DO,
	output logic send_done
);

	parameter NCLKS_PER_BIT = 186; // 21 477 000/(115200) ~= 
	parameter NCLKS_PER_BIT_1_5 = 276;
	//186.4 Cycles of oversampling 

	// Depending on FTDI settings this could be different 
	parameter SPACE = 1;
	parameter MARK = 0;

	parameter IDLE = SPACE; // IDLE is always space 
	parameter START = !IDLE; // start is always the opposite of 
	//space
	parameter STOP = !START; // stop bit is always the opposite of start

	parameter WAITING = 0;
	parameter SENDING_DO = 1;
	parameter STOPPING = 2;
	parameter START_BIT = 3;

	logic [7:0]tx_buf[7:0];	// 8 byte Output buffer
	logic [7:0]tx_ptr = 0;				// data control pointer
	logic [2:0]tx_bit_ptr =0;			// pointer for bitwise send
	logic [15:0]count = 0;				// Timing Counter for 
	logic [1:0]state = WAITING;				// state for the FSM

	// Per byte tx logic (fsm)
	always_ff@(posedge clk )begin 
		tx_buf[send_ptr] = tx_DI;
		send_done = (tx_ptr >= send_ptr); //data in buffer isnt considered valid unless the send pointer has already moved on.
		if(clear)begin 
			tx_ptr = 0;
		end 
		case(state)
			WAITING: begin
				uart_port_DO <= SPACE;
				// The user will increment 
				// send_ptr as soon as there
				// is data
				if(send_ptr > tx_ptr) begin 
					count <= 0;
					state <= START_BIT;
				end 
			end 
			
			START_BIT: begin // Send the start bit 
				uart_port_DO <= MARK;
				tx_bit_ptr = 0;
				if(count == NCLKS_PER_BIT)begin 
					count <= 0;
					state <= SENDING_DO;
				end else begin 
					count <= count+1;
				end 
			end 
			SENDING_DO: begin
				uart_port_DO <= SPACE^tx_buf[tx_ptr][tx_bit_ptr];
				if(count == NCLKS_PER_BIT) begin 
					count <= 0;
					tx_bit_ptr <= tx_bit_ptr + 1;
					if(tx_bit_ptr ==7) state <= STOPPING;
				end else begin 
					count <= count + 1;
				end 
			end 
			STOPPING: begin	// send the stop bit and end bytestream
				uart_port_DO <= STOP;
				tx_bit_ptr <= 0;
				tx_ptr <= tx_ptr + 1;
				if(count == NCLKS_PER_BIT) begin 
					count <=0;
					state <= WAITING;
				end else begin 
					count <= count + 1;
				end 
			end 
		endcase
	end 

endmodule
