// VGA driver, takes a 256x240 image and scales it to 640x480@60Hz VGA
// by using a 12.5MHz pixel clock, and incorporating black borders on either side


// Frame buffer module instantiate within VGA_out
// Frame buffer is a 256x240 sized buffer that stores the current frame
module frame_buff();
endmodule

module vga_out(
input logic pix_clk,	// 12.5 MHz clock signal
output logic [8:0] rgb,	// 3 bits each for red, green, blue
output logic vsync,		// vertical syncing signal, active low
output logic hsync) ;	// horizonal syncing signal, active low

// 0-31 black
// 32-287 NES image
// 288-319 black
// 320-327 front porch
// 328-375 sync 
// 376-399 back porch

logic [9:0] pixel_x, pixel_y;

initial begin
	// reset pixel counters
	pixel_x = '0;
	pixel_y = '0;
	rgb = '0;
end 

always @(posedge pix_clk) begin

	// RGB control
	if (pixel_x < 32)
		rgb <= '0;
	else if (pixel_x < 288)
		// RGB gets NES info 
		//
		//
		//
		//
		//
		rgb <= 9'b111_111_111; 
	else 
		rgb <= '0;
		
	// HSYNC Control
	if (pixel_x > 327 && pixel_x < 376)
		hsync <= 0;
	else
		hsync <= 1;
		
	// VSYNC Control
	if (pixel_y > 489 && pixel_y < 492)
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

endmodule
