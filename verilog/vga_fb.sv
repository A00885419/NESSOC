// Vga_fb.sv

// This is the frame buffer for vga, The frame buffer in this case is basically
// ram within the ppu It will be instantiated alongside not within the vga

/*
	Frame buffer relationships:
 +--------------+   c_codes   +----------+
 |              |   (eg. 18   |          |
 |              | +---------> |  vga     |
 |    ppu       |   gives a   |  Frame   |
 |              |   brownish  |  Buffer  |
 |              |   colour)   |          |
 |              |             +----------+
 +--------------+                  |rgb values
                                   |RRRGGGBBB
                                   v(eg. 000111000
         +--------------+           gives pure green)
         |              |     +----------+
         |   Video      |     |          |
         |              |     |  vga     |
         |              |     |  timing..|
         |              | <---+  logic.. |
         |              |     |  etc..   |
         |              |     +----------+
         +--------------+	
	
	
	frame buffer is a 2dimensional array read from it with 
	pix_ptr_x and pix_ptr_y
*/

module vga_fb(
	// Input control lines from ppu
	input logic ppu_ctl_clk,
	input logic [7:0]ppu_ptr_x,
	input logic [7:0]ppu_ptr_y,
	input logic [5:0]ppu_DI,
	input logic CS,
	// Output to vga_out Module
	input logic pix_clk,
	input logic [7:0]pix_ptr_x,
	input logic [7:0]pix_ptr_y,
	output logic [8:0]rgb // format of RRRGGGBBB r is always gonna be msb
);
	logic [5:0]pixel_code[255:0][239:0];	// Frame buffer RAM
	logic [5:0]pix;
	logic [2:0]r; 
	logic [2:0]g; 
	logic [2:0]b;
	logic [8:0]coloursDecode[63:0];
	logic [8:0]dec;
	
	initial begin
		$readmemh("vga_colours_rgb.txt",coloursDecode);
	end 
	
	always_ff@(posedge pix_clk) begin
	 pix = pixel_code[pix_ptr_x][pix_ptr_y];
	end
	
	
	// PPU access (Write only)
	always_ff@(posedge ppu_ctl_clk) begin 
		if(CS) begin
			pixel_code[ppu_ptr_x][ppu_ptr_y] = ppu_DI;
		end
	end 
	assign dec = coloursDecode[pix];
	// vga out access (Read only)
	assign rgb = {dec[8:6],dec[5:3],dec[2:0]};

endmodule