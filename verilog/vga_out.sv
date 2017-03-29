// VGA driver, takes a 256x240 image and scales it to 640x480@60Hz VGA
// by using a 12.5MHz pixel clock, and incorporating black borders on either side

module vga_out(
	input logic pix_clk,	// 12.5 MHz clock signal

	input logic [8:0] rgb_buf,	// connect to rgb output of buffer
	output logic [7:0]pix_ptr_x,
	output logic [7:0]pix_ptr_y,

	output logic [8:0] rgb,	// 3 bits each for red, green, blue
	output logic vsync,		// vertical syncing signal, active low
	output logic hsync	    // horizonal syncing signal, active low
);
	// 0-31 black
	// 32-287 NES image
	// 288-319 black
	// 320-327 front porch 
	// 328-375 sync (47 cycles)
	// 376-399 back porch

	parameter NES_WIDTH = 256;
	parameter NES_HEIGHT = 240;
	
	// frame constants always check >= and <
	parameter L_BLANK = 0;
	parameter NES_W = 32;
	parameter R_BLANK = 288;
	parameter HF_PORCH = 320;
	parameter HSYNC_START = 328;
	parameter HB_PORCH = 376;
	parameter H_END = 400;
	
	parameter V_VISIBLE = 0;
	parameter VF_PORCH = 480;
	parameter VSYNC_START = 490;
	parameter VB_PORCH = 492;
	parameter V_END = 525;

	logic [9:0] pixel_x;
	logic [9:0]	pixel_y;
	
	initial begin
		// reset pixel counters
		pixel_x = '0;
		pixel_y = '0;
		rgb = '0;
	end 
	always_comb begin 
		rgb = (pixel_x >= NES_W && pixel_x < R_BLANK && pixel_y < VF_PORCH) ? rgb_buf : 0;
		if(pixel_x >= R_BLANK) rgb = 0;
	end 
	always_ff @(posedge pix_clk) begin

		// RGB control
		//if ( pixel_x >= L_BLANK && pixel_x < NES_W)
		//	rgb <= '0;
		//if (pixel_x >= NES_W && pixel_x < R_BLANK && pixel_y < VF_PORCH) begin
			// RGB gets NES info // Get the information from the framebuffer module 
		//	rgb = rgb_buf; 
		//end 
		//if (pixel_x >= R_BLANK)
		//	rgb = '0;
		
		// HSYNC Control
		if (pixel_x >= HSYNC_START && pixel_x < HB_PORCH)
			hsync <= 0;
		else
			hsync <= 1;
		
		// VSYNC Control
		if (pixel_y >= VSYNC_START && pixel_y < VB_PORCH)
			vsync <= 0;
		else
			vsync <= 1;
	
		// move to next pixel
		if (pixel_x == 10'd399) begin
			// reset x value
			pixel_x <= '0;
		
			// increment or reset y value
			if (pixel_y == 10'd524)
				pixel_y <= '0;
			else
				pixel_y <= pixel_y + 1'b1;
		end
		else
			pixel_x <= pixel_x + 1'b1;
	end 

	always_comb begin
		if (pixel_x >= NES_W && pixel_x < R_BLANK)	// before or after visible area
			pix_ptr_x = pixel_x - NES_W;
		else
			pix_ptr_x = 0;		// set pointer for next pixel to be rendered
		
		// lines are doubled to fill the screen
		if (pixel_y < VF_PORCH)
			pix_ptr_y = pixel_y >> 1;	// right-shift will duplicate lines
		else
			pix_ptr_y = '0;
	end
endmodule
