// nesTop.sv

// This is greater than the sum of its parts...

/*
	Top level NESOC Project file
*/


module nesTop(
// uart module I/O
	input logic uart_port_DI,
	output logic uart_port_DO,
	input logic CLOCK_50, rst,
	output logic [2:0]RED,
	output logic [2:0]GREEN,
	output logic [2:0]BLUE,
	output logic HSYNC, VSYNC
);

	
// Generated with qsys later	nessoc u0(.*);

endmodule
