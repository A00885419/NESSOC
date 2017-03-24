/*
	CPUMMCs.sv 
	This file contains the Memmory Mapped Controllers for the CPU address space.
	The CPU address space is as follows.
	---------- $1 0000
	|Mirrors
	|0000-3FFF
	---------- $  4000
	|Mirrors
	|3F00-3F1F
	---------- $  3F20
	|
	---------- $  3F10
	|
	---------- $  3F00
	|
	---------- $  3000
    |
	---------- $  2FC0
	|
	---------- $  2C00
	|
	---------- $  2BC0
	|
	---------- $  2800
	|
	---------- $  27C0
	|
	---------- $  2400	
*/
module cpu_ppu_mmc( // Recieves address bus data from CPU and maps registers
			   //$ 2007 - $2000 to  PPU 7 - 0 
			   // Mirrors present due to imperfect decoding from 2008 to 4000
	input logic [15:0] AB,
	output logic [2:0] PPUA,
	output logic PPUCS);
	assign PPUCS = (AB < 'h4000 && AB > 'h2000);
	assign PPUA = AB[2:0];
endmodule

module cpu_ppu_dma_mmc( // Chip enable for the DMA 
	inout logic [15:0]AB,
	output logic dma_AB);
	assign dma_AB = (AB='h4014);
);
endmodule

