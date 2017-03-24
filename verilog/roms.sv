/*
	roms.sv
	
	Current version of rom implements something called 16k NROM 
	Support for cooler versions of nes games is not implemented and also quite unlikely
	
	the test ROM that we will be using for this project is the american release of 
	Donkey Kong it uses NROM.
	
	
	
	
	static program ROM (to be loaded before startup of CPU)
	NROM has the following characteristics 
	program ROM at C000 to FFFF 
	mirrored ROM at 8000 to BFFF
	ram at $6000 to $7FFF (ram's not that big but it is mirrored across this region)
*/


// Rom resides at C000 (1100 0 0 0 ) to FFFF in CPU address AND DMA address space
// This is also mirrored to $8000 to BFFF
module prg_rom(input logic [13:0]AB, // 
	input logic CS);
endmodule
