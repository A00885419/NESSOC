/*
	uart_rx_tb.sv

	
	tests functionality of the uart_rx module 
*/

module uart_rx_tb();
	parameter baud = 115200;
	// INPUTS
	logic [15:0]read_ptr = 26; // buffer read pointer 
	logic clk = 0; 
	logic uart_clk = 0;
	logic clear = 1;  // control signals
	logic uart_port_DI = 1; // Read UART from pin  // it better be proper FTDI 
	// OUTPUTS
	logic [7:0]uart_DO;
	logic read_valid;
	
	logic [7:0]ascii_char = 65; // ascii char 'a'
	// test vars
	
	integer i, j, k, l;
	
	
	uart_port dut(.*);
	initial begin
		clk = 0;
		#8.68us;
		clear = 0;
		while(!read_valid)begin
			#8.68us; // Send Start Bit
			uart_port_DI = 0;
			for(i = 0; i < 8; i++)begin 
			#8.68us;
			uart_port_DI = !ascii_char[i];
			end 
			#8.68us; // Send Stop Bit
			uart_port_DI = 1;
			ascii_char = ascii_char + 1;
		end
	#8.68us;
	#8.68us;
	$stop;
	end 
	
	always begin 
		#4.34us;
		uart_clk = ~uart_clk;
	end
	always begin 
		#23.2ns;
		clk = ~clk;
	end 
			

endmodule