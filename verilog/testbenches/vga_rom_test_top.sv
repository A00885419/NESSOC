// VGA ROM top level test.

//
// (PPU REPLACED BY TEST_IMG_DUMMY_ROM) 
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
	integer i, j, k;
	integer progState;
	
	always_ff@(posedge ppu_clk) begin //
		if(progState = 0) begin // state 0 = reset
			i = 0;
			progState = 1;
		end else begin 
			if(i < (240*256 + 1)) begin 
				ppu_ptr_x = ppu_ptr_x+1;
				if(ppu_ptr_x == 255) 
					ppu_ptr_y = ppu_ptr_y +1;	
				i = i + 1;
			end
		end 
	end 

	// VGA output initialization 
	vga_out vgao_dut(
		.pix_clk(pix_clk), .rgb_buf(rgb), 
		.pix_ptr_x(fb_ptr_x),.pix_ptr_y(fb_ptr_y),
		.rgb(rgb_OUT),. .vsync(vsync), .hsync(hsync)
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
		progState = 0;
		for (j = 0; i <256; j++) begin 
			$readmemh("pixtest.c_code", TEST_IMG_DUMMY_ROM);
		end 		
	end 
	
endmodule

