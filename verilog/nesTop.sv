/*
	Top Level NES module.
	
	By Peter Li and Cameron Morgan,

*/

//`define DEBUGGING 1 //  Enable debugging mode for use with test benches


module NESOC();
	// CPU Controls
	logic [15:0] AB; // CPU -> * see cpummc for memory structure
	logic clk;	 // CPU <- *
	logic reset;	 // CPU <- *
 	logic [7:0] DI;  // CPU <- *
	logic [7:0] DO;  // CPU -> *
	logic WE;	 // Write Enable
	logic IRQ;	 // CPU <- *
	logic NMI;	 // CPU <- * 
	logic RDY;	 // CPU <- ready signal pauses cpu when rdy=0 (not actually used by the NES system but may be useful for simulating delays )


endmodule
