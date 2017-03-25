// VGA ROM top level test.

//
// (PPU REPLACED BY TEST_IMG_DUMMY_ROM) -> 
module vga_rom_test_top();
	logic pix_clk;
	logic ppu_clk;
	logic [5:0]TEST_IMG_DUMMY_ROM[255:0][239:0];
	
	logic [7:0]fb_ptr_x;
	logic [7:0]fb_ptr_y;
	
	logic [7:0]ppu_ptr_x;
	logic [7:0]ppu_ptr_y;
	logic [8:0]rgb;
	
	// PIN outputs
	logic vsync;
	logic hsync;	
	logic [8:0]rgb_OUT;
	// Test variables 
	integer i;
	integer progState;
	
	always_ff@(posedge ppu_clk) begin //
		if(rst) begin 
			progState = 0;
			i = 0;
		end else
	end 

	// VGA output initialization 
	vga_out vgao_dut(
		.pix_clk(pix_clk), .rgb_buf(rgb), 
		.pix_ptr_x(fb_ptr_x),.pix_ptr_y(fb_ptr_y),
		.rgb(rgb_OUT),.
		);
	
	// frame buffer initialization
	vga_fb fb_dut(
		.ppu_ptr_x(ppu_ptr_x),.ppu_ptr_y(ppu_ptr_y),
		.ppu_ctl_clk(ppu_clk),.CS(1), 
		.ppu_DI(TEST_IMG_DUMMY_ROM[ppu_ptr_x][ppu_ptr_y]),
		.pix_ptr_x(fb_ptr_x), .pix_ptr_y(fb_ptr_y),
		.rgb(rgb)		
		);
	initial begin
		for 
	end 
	
endmodule

