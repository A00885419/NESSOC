/*
	soms.sv
	static program ROM (to be loaded before startup of CPU)
*/


// Rom resides at C000 (1100 0 0 0 ) to FFFF in CPU address AND DMA address space
module prg_rom(input logic [13:0]AB, // 
	input logic CS);
endmodule
