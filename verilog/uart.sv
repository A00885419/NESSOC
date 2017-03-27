// uart.sv

/*
	simple uart module used as a general purpose Comms channel with the FPGA
	We kinda need this for programming and controller anyway
	
	use USB to FTDI Card.
	
	asynch_in
	synch_out
	
	settings for com port
	19200 baud	
	1 start bit
	no parity
	2 stop bit 
	8 bit data 
	
	The buffer and uart are meant to be used together
	
	--- How to use ---
	
	- instantiate uart_port()
	simply connect your UART signal to uart-port-DI
	
	available data will be present in the 64kb buffer via read_ptr
	
	to prevent buffer from overflowing hold CLEAR signal high 
	to read after X number of bits are available set read_ptr to X and wait for read_valid 
	
	-------- an example --------
	logic cpu_read_complete;
	logic cpu_clk;
	logic cpu_read_ptr[15:0];
	logic uart_buf_valid;
	logic [7:0]cpu_read_val;
	
	// UART module and buffer wires
	logic uart_valid;
	logic uart_port_DI;
	logic [7:0]uart_rx_DO
	
	uart_buf uart_buffer(.read_ptr(cpu_read_ptr), .uart_DI(.uart_rx_DO), 
		.read_clk(cpu_clk), 
		.uart_valid(uart_valid), 
		.clear(cpu_read_complete), 
		.uart_DO(cpu_read_val), 
		.read_valid(uart_buf_valid)
	);
	uart_rx uart_reciever(
		.uart_DI(uart_port_DI), 
		.clk(cpu_clk), 
		.uart_valid(uart_valid), 
		.uart_DO(uart_rx_DO)
	);
	
	---- Or you can just use the uart_port module and call it day ----
	
*/


module uart_port( // EZmode instantiation encapsulates a whole bunch of stuff 
		input logic [15:0]read_ptr, // buffer read pointer 
		input logic clk, clear,  // control signals
		input logic uart_port_DI, // Read UART from pin  // it better be proper FTDI 
		output logic [7:0]uart_DO,
		output logic read_valid
	); 
	logic uart_valid;
	logic [7:0]uart_rx_DO;
	
	uart_buf uart_buffer(
		.read_ptr(read_ptr), .uart_DI(uart_rx_DO), 
		.read_clk(clk), 
		.uart_valid, 
		.clear, 
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


module uart_buf(//  64kb UART read buffer good for testing
	input logic [15:0]read_ptr,
	input logic [7:0]uart_DI,
	input logic uart_valid, read_clk, 
	input logic clear, // if purge is pulled high, the rx_ptr will go to 0
	output logic[7:0]uart_DO,
	output logic read_valid
); 
	logic [15:0]rx_ptr;
	logic [7:0]rx_buf['hFFFF:0];
	// On each read_clk data is read out to the controling module 
	always_ff@(posedge read_clk) begin 
		uart_DO = rx_buf[read_ptr];
		if(clear) begin 
			rx_ptr = 0;
		end 
	end
	assign read_valid = (rx_ptr >= read_ptr );   // data is valid so long as the rx_ptr 
												// is greater than the requested data location 
	// Data is read into the current ptr location and the pointer is incremented 
	always_ff@(posedge uart_valid)begin
		rx_buf[rx_ptr] = uart_DI;
		rx_ptr = rx_ptr + 1;
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
				if(count == NCLKS_PER_BIT * 1.5) begin 
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
	
	