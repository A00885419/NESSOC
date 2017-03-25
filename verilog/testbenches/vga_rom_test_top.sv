// VGA ROM top level test.

//
// (PPU REPLACED BY TEST_IMG_DUMMY_ROM) -> 
module ();
	logic pix_clk;
	logic ppu_clk;
	logic [5:0]TEST_IMG_DUMMY_ROM[255:0][239:0];
	
	logic [7:0]fb_ptr_x;
	logic [7:0]fb_ptr_y;
	
	logic [7:0]ppu_ptr_x;
	logic [7:0]ppu_ptr_y;
	
	
	
	vga_fb fb_dut();

endmodule