/*
	PPU.sv
*/

`include "nessoc.svh"

module ppu_top();

endmodule

module ppu_core( 				// PPU Component
	input logic [2:0] CPUA,		// PPU register select Selects ppu register 0-7 (mapped to $2000-$2007 by PPUMMC)
	input logic [7:0] CPUDI,  	// CPU data input
	output logic[7:0] CPUDO,  	// CPU data read 
	input logic CPUCLK,			// Cpu clock for read/write 
	input logic RW, 			// Read/Write
	input logic CS, 			// Chip Select
	input logic RST,			// Chip reset
	input logic PPUCLK,			// Input clock 21.47727 MHz for ppu functions
	output logic NMI,			// Non interruptable Interrupted (signifies the start of VBLANK)
	output logic ALE, 			// Address latch enable
	output logic [13:0] APPU, 	// Address and data pins 
	output logic [7:0] PPUDO, 	// PPU data output
	input logic [7:0] PPUDI, 	// PPU data input 
	input logic [3:0] EXTI, 	// EXT input (Probably gonna be unused)
	output logic [3:0] EXTO 	// EXT output (Probably gonna be unused)
);

logic startup =0; // determines if the ppu is in it's initial startup state 
logic 

// PPU line by line rendering fsm 
// Because the ppu has a very well defined timing diagram, the operation of 
// the rendering engine can be thought of as a state machine depending on the 
// clock only

// Each frame consists of 261 scanlines and 341 clock cycles per scanline
//              5.35M Cycles / Second
//  Framerate = -------------------------- = 241.3119 Fps
//                261*341 Cycles / Frame
// 

// Scanline States
`define VISIBLE 0
`define POSTRENDER 240	
`define VBLANK 241		// Vblank is set on the second clock cycle of this scanline 
`define PRE_RENDER 261 // The pre-render scanline also exists as the very first frame upon reset
`define FINAL 262


// Cycles States
`define IDLE 0
`define TILEFETCH 1 // Fetching tile data 2 cycles per fetch
`define TF_NT 0		// nametable fetch subcycle
`define TF_AT 2		// Attribute table fetch subcycle
`define TF_BMPL 4   // Bitmap Data Low Fetch Subcycle
`define TF_BMPH 6   // Bitmap data High Fetch Subcycle  
`define TF_END 8 // begins fetching next time on 8th cycle 
`define FETCH_NEXT 257 // Begins fetching the first two nametables' data for the next scanline 
						// 4 cycles are performed at this point 
`define UNDEFINED 337 // During this time the NES begins fetching data though the purpose of this is
					// unknown to the community, therefore this is effectively an idle period
`define CYC_FINAL 340 // Final cycle of the scanline 
`
logic integer n_line; // Current Scanline (starts at scanline = 0) and ends on scanline 261
logic integer n_cyc;// 341 cycles  per scanline
logic vblank;	// Blanking time at end of each frame
logic hblank; // blanking time at end of each scanline 
// Step Forward Scanline cycle
assign hblank = (n_cyc == 341); 

always_ff@(posedge PPUCLK) begin
		n_cyc = (n_cyc <= CYC) ? n_cyc  + 1 : 0;
		if()
end	

always_ff@(posedge)


endmodule

module ppu_name_tables(); 
endmodule 

module pattern_tables();
endmodule

module palletes(); // PPU pallets table  
endmodule


// PPU Sprite ram 
/*
	This ram is dual access, it is Written to by the DMA and accessed by the 	PPU	


	This is a separate area of ram (256 bytes in size) Specifically holds
	sprite data
	Byte data is stored as follows:
	Byte 0 - Stores y-co-ordinate of the top left of the sprite minus 1
	Byte 1 - Index Number of the sprite in the pattern tables
	Byte 2 - Stores attributes of sprites
	 	Bits 0&1 - MSB of colour
		Bit 5 - indicates whether or not sprite has priority over BG
		Bit 6 - inidcates whether to flip sprite horizontal
		Bit 7 - indicates whether to flip sprite vertically
		
*/
module spr_ram();
	logic [7:0] SPR_RAM[255:0];
endmodule
/*
	The DMA is where it gets a little bit weird
	The DMA reads from the CPU memory space and 
	writes to the SPR ram (Note the SPR_RAM exists in it's own address space) 
*/
module ppa_dma(
	input logic [15:0]source, // Exists in CPU address space
	input logic [7:0]dest,    // Exists in SPR address space
	output logic status,	  // DMA will steal CPU cycles and will prevent CPU
							  // from reading new instructions until DMA process
							  // is complete
						
);
endmodule

