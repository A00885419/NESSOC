// nesTop.sv

// This is greater than the sum of its parts...

/*
	Top level NESOC Project file
*/


module nesTop(
// uart module I/O
	input logic uart_port_DI,
	output logic uart_port_DO,
	input logic CLOCK_50, rst,
	output logic [2:0]RED,
	output logic [2:0]GREEN,
	output logic [2:0]BLUE,
	output logic HSYNC, VSYNC
);

// ========= nes_state fsm ===========
parameter OFF = 0;		// nes is off can program/setup rom
parameter LOADING = 2;  // reading NES rom into rom module 
parameter RUNNING = 1;  // Executing
parameter VERIFYING = 4;
parameter VERIFICATION_END = 3;
// ========  NES NROM_Cartridge settings ========
parameter NROM_END = 'h600f; // Final address of NES NROM_Cartridge
// Clocks 
logic nios_clk;
logic pix_clk;		// 12.5 Mhz vga Pixel clock 
logic ppu_clk;		// 21.4 Mhz ppu clock 
logic ppu_slow_clk; // ppu_clk dived by 5
logic A203_clk;

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

// ==== A203 CPU signals 
logic [15:0]CPU_AB; // primary cpu address space 
logic [7:0]CPU_DO; // cpu output byte 
logic [7:0]CPU_DI; // cpu recieve data

// ==== PPU signals ==== 
logic [15:0]PPU_AB;
logic [7:0]PPU_DO;
logic [7:0]PPU_DI;

// === NON NES signals 
logic [7:0]rom_prog_di; 
logic rom_prog;

// Module instantiations
clocks	clock_inst (.inclk0 (CLOCK_50), .c0(nios_clk), .c1 ( ppu_clk ), .c2(ppu_slow_clk), .c3(A203_clk), .c4(pix_clk ));


// UART port 
uart_port uart_0(.clk(ppu_clk),.tx_clear(tx_clear||rst),.rx_clear(rx_clear||rst), .*);

logic [7:0] rom_0_cpu_DI;
logic [7:0] rom_0_ppu_DI;
// ROM inititialized 
rom_master rom_0(.cpu_clk(A203_clk), .cpu_ab(CPU_AB), .cpu_do(rom_0_cpu_DI), .ppu_clk(ppu_clk), .ppu_ab(PPU_AB), .ppu_do(rom_0_ppu_DI), .prog_di(rom_prog_di), .prog(rom_prog), .rst);

logic nes_state = OFF;
logic [7:0] valid_header[3:0];// expected top 3 bytes of the NES header
initial begin
	valid_header[0] = 'h4e; // N
	valid_header[1] = 'h45; // E
	valid_header[2] = 'h53; // S
	valid_header[3] = 'h1a; // \n
end 

// NES primary controler FSM

	always_ff@(posedge nios_clk) begin 
		if(rst)
			nes_state = OFF;
		case(nes_state)
			OFF: begin 
				rx_clear <= 0;
				tx_clear <= 0;
				send_ptr <= 0;
				read_ptr <= NROM_END; // Buffer read pointer 
				if (read_valid) begin  // read valid goes high after NROM_END
					nes_state <= VERIFYING;
					read_ptr <= 0;
				end 
			end 
			VERIFYING: begin 
				// Verifies  the NROM Cartridge loaded and checks header 
				if(uart_DO == valid_header[read_ptr])begin 
					read_ptr <= read_ptr + 1;
				end else begin  // send char "F" for failure and reset to off 
					nes_state <= VERIFICATION_END;
					tx_DI <= 'h46; 
					send_ptr <= 0;
				end 
				if(read_ptr == 4) begin 
					nes_state = VERIFICATION_END;
					tx_DI <= 'h53;
					send_ptr <= 0;
					// Sends char "S" for success on successful verification
				end 
			end 
			VERIFICATION_END: begin 
				send_ptr = 1;
				if(send_done)begin 
					case(tx_DI) 
						'h46: nes_state = OFF; // failed  
						'h53: nes_state = LOADING; // Success 
					endcase
				end
			end 
			
			// verification success TEST case atm do nothing
			LOADING :begin 
				nes_state = OFF;
			end 
			RUNNING: begin 
				nes_state = OFF;
			end 
		endcase
	end

	
// Generated with qsys later nios_system u0(.*);

endmodule
