/*
	roms.sv
	
	Current version of rom implements something called 16k NROM 
	Support for cooler versions of nes games is not implemented and also quite 
	unlikely(right now anyway)
	
	the test ROM that we will be using for this project is the american release
	of Donkey Kong as it uses NROM.
	
	static program ROM (to be loaded before startup of CPU)
	NROM has the following characteristics 
	
		program ROM at C000 to FFFF 
		mirrored ROM at 8000 to BFFF
	
	ram at $6000 to $7FFF (ram's not that big but it is mirrored across this region)
	CHR ROM exists on the PPU's address space and can only be accesed through t
	he ppu address/data space 
*/


// Rom resides at C000 (1100 0 0 0 ) to FFFF in CPU address AND DMA address space
// This is also mirrored to $8000 to BFFF
module rom_master(
	// CPU Access bus
	input logic cpu_clk,
	input logic [15:0]cpu_ab,
	output logic [7:0]cpu_do,
	// PPU access bus 
	input logic ppu_clk,
	input logic [15:0]ppu_ab,
	output logic [7:0]ppu_do
);

logic [7:0]rom['h600f:0]// size of INES file, NROM style files with 16k Rom and 
						// 8k CHR Rom is supported only, total romdump size is 24k
initial begin 
	$readmemb("nestest.nes");
end 

endmodule
