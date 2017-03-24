// Vga_fb.sv

// This is the frame buffer for vga, The frame buffer in this case is basically ram within the ppu 
// It will be instantiated alongside not within the vga

module vga_fb(
	// Input control lines from ppu
	input logic ppu_ctl_clk,
	input logic [7:0]ppu_ptr_x,
	input logic [7:0]ppu_ptr_y,
	input logic [5:0]ppu_DI,
	input logic CS,
	// Output to vga_out Module
	input logic [7:0]pix_ptr_x,
	input logic [7:0]pix_ptr_y,
	output logic [8:0]rgb // output will be in the format of RRRGGGBBB r is always gonna be msb
);
	logic [5:0]pixel_code[255:0][239:0];
	logic [5:0]pix;
	logic [2:0]r; 
	logic [2:0]g; 
	logic [2:0]b;

	assign pix = pixel_code[pix_ptr_x][pix_ptr_y];

	decode_channels c_decode ( .c_code(pix), .R(r), .G(g), .B(b) );
	// PPU access (Write only)

	always_ff@(posedge ppu_ctl_clk) begin 
		if(CS) begin
			pixel_code[ppu_ptr_x][ppu_ptr_y] = ppu_DI;
		end
	end 

	// vag out access (Read only)
	assign rgb = {r[2:0],g[2:0],b[2:0]};

endmodule


//Colour Channels decode 
module decode_channels(input logic [5:0]c_code,
	output logic [2:0] R,
	output logic [2:0] G,
	output logic [2:0] B
);
	always_comb begin
		R = 0;
		G = 0;
		B = 0;
		case(c_code)	// Decode Red Channel
			6'h0: R = 3'b011;
			6'h1: R = 3'b001;
			6'h2: R = 3'b000;
			6'h3: R = 3'b010;
			6'h4: R = 3'b100;
			6'h5: R = 3'b101;
			6'h6: R = 3'b101;
			6'h7: R = 3'b011;
			6'h8: R = 3'b010;
			6'h9: R = 3'b000;
			6'h0A: R = 3'b000;
			6'h0B: R = 3'b000;
			6'h0C: R = 3'b001;
			6'h10: R = 3'b101;
			6'h11: R = 3'b000;
			6'h12: R = 3'b001;
			6'h13: R = 3'b100;
			6'h14: R = 3'b101;
			6'h15: R = 3'b110;
			6'h16: R = 3'b110;
			6'h17: R = 3'b110;
			6'h18: R = 3'b100;
			6'h19: R = 3'b000;
			6'h1A: R = 3'b000;
			6'h1B: R = 3'b000;
			6'h1C: R = 3'b000;
			6'h20: R = 3'b111;
			6'h21: R = 3'b010;
			6'h22: R = 3'b011;
			6'h23: R = 3'b101;
			6'h24: R = 3'b111;
			6'h25: R = 3'b111;
			6'h26: R = 3'b111;
			6'h27: R = 3'b111;
			6'h28: R = 3'b111;
			6'h29: R = 3'b100;
			6'h2A: R = 3'b010;
			6'h2B: R = 3'b010;
			6'h2C: R = 3'b000;
			6'h30: R = 3'b111;
			6'h31: R = 3'b101;
			6'h32: R = 3'b101;
			6'h33: R = 3'b110;
			6'h34: R = 3'b111;
			6'h35: R = 3'b111;
			6'h36: R = 3'b111;
			6'h37: R = 3'b111;
			6'h38: R = 3'b111;
			6'h39: R = 3'b110;
			6'h3A: R = 3'b101;
			6'h3B: R = 3'b101;
			6'h3C: R = 3'b100;
		endcase

		case(c_code)	// Decode Green Channel
			6'h0: G = 3'b011;
			6'h1: G = 3'b001;
			6'h2: G = 3'b000;
			6'h3: G = 3'b000;
			6'h4: G = 3'b000;
			6'h5: G = 3'b000;
			6'h6: G = 3'b000;
			6'h7: G = 3'b000;
			6'h8: G = 3'b001;
			6'h9: G = 3'b010;
			6'h0A: G = 3'b010;
			6'h0B: G = 3'b010;
			6'h0C: G = 3'b010;
			6'h10: G = 3'b101;
			6'h11: G = 3'b011;
			6'h12: G = 3'b010;
			6'h13: G = 3'b000;
			6'h14: G = 3'b000;
			6'h15: G = 3'b000;
			6'h16: G = 3'b001;
			6'h17: G = 3'b010;
			6'h18: G = 3'b011;
			6'h19: G = 3'b100;
			6'h1A: G = 3'b101;
			6'h1B: G = 3'b100;
			6'h1C: G = 3'b100;
			6'h20: G = 3'b111;
			6'h21: G = 3'b101;
			6'h22: G = 3'b100;
			6'h23: G = 3'b100;
			6'h24: G = 3'b011;
			6'h25: G = 3'b011;
			6'h26: G = 3'b011;
			6'h27: G = 3'b100;
			6'h28: G = 3'b101;
			6'h29: G = 3'b110;
			6'h2A: G = 3'b110;
			6'h2B: G = 3'b111;
			6'h2C: G = 3'b110;
			6'h30: G = 3'b111;
			6'h31: G = 3'b110;
			6'h32: G = 3'b110;
			6'h33: G = 3'b110;
			6'h34: G = 3'b101;
			6'h35: G = 3'b101;
			6'h36: G = 3'b101;
			6'h37: G = 3'b110;
			6'h38: G = 3'b110;
			6'h39: G = 3'b111;
			6'h3A: G = 3'b111;
			6'h3B: G = 3'b111;
			6'h3C: G = 3'b111;
		endcase 
		
		case(c_code)	// Decode Blue Channel
			6'h0: B = 3'b011;
			6'h1: B = 3'b100;
			6'h2: B = 3'b101;
			6'h3: B = 3'b100;
			6'h4: B = 3'b011;
			6'h5: B = 3'b001;
			6'h6: B = 3'b000;
			6'h7: B = 3'b000;
			6'h8: B = 3'b000;
			6'h9: B = 3'b000;
			6'h0A: B = 3'b000;
			6'h0B: B = 3'b001;
			6'h0C: B = 3'b011;
			6'h10: B = 3'b101;
			6'h11: B = 3'b111;
			6'h12: B = 3'b111;
			6'h13: B = 3'b111;
			6'h14: B = 3'b101;
			6'h15: B = 3'b011;
			6'h16: B = 3'b000;
			6'h17: B = 3'b000;
			6'h18: B = 3'b000;
			6'h19: B = 3'b000;
			6'h1A: B = 3'b000;
			6'h1B: B = 3'b010;
			6'h1C: B = 3'b100;
			6'h20: B = 3'b111;
			6'h21: B = 3'b111;
			6'h22: B = 3'b111;
			6'h23: B = 3'b111;
			6'h24: B = 3'b111;
			6'h25: B = 3'b101;
			6'h26: B = 3'b011;
			6'h27: B = 3'b010;
			6'h28: B = 3'b010;
			6'h29: B = 3'b001;
			6'h2A: B = 3'b010;
			6'h2B: B = 3'b100;
			6'h2C: B = 3'b110;
			6'h30: B = 3'b111;
			6'h31: B = 3'b111;
			6'h32: B = 3'b111;
			6'h33: B = 3'b111;
			6'h34: B = 3'b111;
			6'h35: B = 3'b110;
			6'h36: B = 3'b101;
			6'h37: B = 3'b101;
			6'h38: B = 3'b100;
			6'h39: B = 3'b100;
			6'h3A: B = 3'b101;
			6'h3B: B = 3'b110;
			6'h3C: B = 3'b111;
		endcase 
	end 
endmodule
