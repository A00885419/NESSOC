// VGA ROM top level test.

// Tests the following:
// VGA output operation - working but glitchy 
// NES colour decoding - passed 

// Right now we need to solve the "square problem"
// some anomalies are observed on the right side of the screen 


// This thing also tests uart_port TX and RX loopback

// (PPU REPLACED BY TEST_IMG_DUMMY_ROM) -> 
module vga_rom_test_top( 
	input logic uart_port_DI,// gpio 31
	output logic uart_port_DO, // gpio 33
	input logic CLOCK_50, rst,
	output logic [2:0]RED,
	output logic [2:0]GREEN,
	output logic [2:0]BLUE,
	output logic HSYNC, VSYNC);

	// ====== RX signals ======
		logic [15:0]read_ptr; // buffer read pointer 
		logic rx_clear;  
		logic read_valid;
		logic [7:0]uart_DO;
		//===== tx signals =======
		logic[15:0]send_ptr;
		logic tx_clear;
		logic [7:0]tx_DI;
		logic send_done;
	

	uart_port uart_0(.clk(ppu_clk),.*);
	
	logic nios_clk;
	logic pix_clk;
	logic ppu_clk;
	logic ppu_slow_clk;
	logic A203_clk;
	
	logic [5:0]test_read_col[240];
	
	logic [7:0]fb_ptr_x;
	logic [7:0]fb_ptr_y;
	
	logic [7:0]ppu_ptr_x;
	logic [7:0]ppu_ptr_y;
	logic [8:0]rgb;
	logic [5:0]testColours;
	
	// PIN outputs
	logic vsync;
	logic hsync;	
	logic [8:0]rgb_OUT;
	
	assign RED = rgb_OUT[8:6];
	assign GREEN = rgb_OUT[5:3];
	assign BLUE = rgb_OUT[2:0];
	assign VSYNC = vsync;
	assign HSYNC = hsync;

	
	// Test variables 
	integer i, j, k; 
	logic [7:0]grid_center;// rolls over at 128
	logic [7:0]h_line = 120;// rolls over at 128
	logic [7:0]y_line = 0;// rolls over at 128
	logic [7:0]h_line_values[3:0];
	logic [7:0]y_line_values[3:0];
	integer n_line = 0;
	integer progState;
	
	assign h_line = grid_center;
	assign y_line = grid_center;
	initial begin
		h_line_values[0] = 0;
		h_line_values[1] = 255 - 10;
		h_line_values[2] = 255 - 10;
		h_line_values[3] = 0;
		
		y_line_values[0] = 0;
		y_line_values[1] = 000;
		y_line_values[2] = 239 - 10;
		y_line_values[3] = 239 - 10;
	end 
	always_ff@(posedge ppu_clk) begin //
		if(progState < 256) begin // state 0 = reset
			i = 0;
			progState = progState + 1;
		end else begin
			if(i < (240*256 + 1)) begin
				if(ppu_ptr_x == 255) 
					ppu_ptr_y = ppu_ptr_y +1;
				ppu_ptr_x = ppu_ptr_x+1;	
				
				if(ppu_ptr_x <y_line)begin
					if(ppu_ptr_y <h_line)
							testColours = 'h27; // Orange
						else
							testColours = 'h14;// magenta 
				end else begin
					if(ppu_ptr_y <h_line)
						testColours = 'h01;// blue 
					else
						testColours = 'h2b;// green
				end
							
				i = i + 1;
			end else i = 0; // Draw again
			// Every 1/12th of a second, move the grid_center
			// diagonally 
			if(k < 1200000) k = k +1;
			else begin 
				k = 0;
				grid_center = grid_center+1;
			end 
		end
	end

	// VGA output initialization 
	vga_out vgao_dut(
		.pix_clk(pix_clk), .rgb_buf(rgb), 
		.pix_ptr_x(fb_ptr_x), .pix_ptr_y(fb_ptr_y),
		.rgb(rgb_OUT),. vsync(vsync), .hsync(hsync)
		);
	
	// frame buffer initialization
	vga_fb fb_dut(
		.ppu_ptr_x(ppu_ptr_x), .ppu_ptr_y(ppu_ptr_y),
		.ppu_ctl_clk(ppu_clk), .CS(1), 
		.ppu_DI(testColours),
		.pix_ptr_x(fb_ptr_x), .pix_ptr_y(fb_ptr_y),
		.rgb(rgb), .pix_clk(pix_clk)		
		);
		
	initial begin
		progState = 0;
		$readmemh("pixtest.txt", test_read_col);
	end 
	
	// initialize clocks
	clocks	clock_inst (
	.inclk0 ( CLOCK_50 ), // 50Mhz input 
	.c0 ( nios_clk ),			// 50Mhz Output Phase locked  
	.c1 ( ppu_clk ),			// 21.428 Mhz ppu clock 
	.c2 ( ppu_slow_clk ),			// ppu div 4 5.35 mhz clk 
	.c3 ( A203_clk ),			// 1.785 Mhz 6502 clock
	.c4 ( pix_clk )			// 12.5Mhz vga Clock
	);

endmodule



