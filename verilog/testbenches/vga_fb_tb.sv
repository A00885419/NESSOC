// vga_fb.sv test bench


module vga_fb_tb();
	// inputs
	logic ppu_ctl_clk;
	logic [7:0]ppu_ptr_x;
	logic [7:0]ppu_ptr_y;
	logic [5:0]ppu_DI;
	logic CS;
	logic [7:0]pix_ptr_x;
	logic [7:0]pix_ptr_y;
	//output
	logic [8:0]rgb;
	vga_fb dut(.pix_clk(ppu_ctl_clk),.*);
	
	integer i,j,k,l;
	initial begin
		CS = 1;
		ppu_ctl_clk = 0;
		ppu_ptr_x = 0;
		ppu_ptr_y = 23;
		pix_ptr_x = 0;
		pix_ptr_y = 23;
		ppu_DI = 03; // Should write 010 000 100 to rgb
		#80ns;
		for (i =0; i< 6; i++)begin
			for (j = 0; j<12; j++) begin		
			pix_ptr_x = j; ppu_ptr_x = j;
			pix_ptr_y = i; ppu_ptr_y = i;
			ppu_DI = i+j*6;
			#40ns;
			$display("p: %d %d code: %x rgb : %x ",pix_ptr_x, pix_ptr_y,ppu_DI,rgb);
			end
		end
		$stop;
	end 
	
	always begin 
		#20ns;
		ppu_ctl_clk = ~ppu_ctl_clk;
	end 
endmodule