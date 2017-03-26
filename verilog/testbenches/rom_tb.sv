// rom testbench

module rom_tb();
	logic clk;
	logic cpu_clk;
	logic [15:0]cpu_ab;
	logic [7:0]cpu_do;
	
	logic ppu_clk;
	logic [15:0]ppu_ab;
	logic [7:0]ppu_do;
	
	integer i = 0;
	assign cpu_clk = clk;
	assign ppu_clk = clk;
	
	rom_master rom_dut(.*);
	
	initial begin 
		clk = 0;
		// test CHR Rom ppu $0000 -> $2000
		// test PRG Rom (inc. mirror) $C000 -> $FFFF
		//===============CPU TEST ================
		//===========RST vector test==============
		cpu_ab = 'hFFFC;
		#210ns;
		$display( "lower rst vector :%x, exp: 04", cpu_do);
		cpu_ab = 'hFFFC+1;	// test reset vector
		#200ns;
		$display( "upper rst vector :%x exp: C0", cpu_do);
		//===========FIRST instruction test ======
		cpu_ab = 'hC004;
		#200ns;
		$display( "FIRST vector :%x exp: SEI (78)", cpu_do);	
		//===========Mirror test==================
		cpu_ab = 'h8004;
		#200ns;
		$display( "vector :%x exp: SEI (78)", cpu_do);	
		//========== END OF CPU TEST =============
		
		//===============PPU TEST ================
		//============= vector test===============
		$display("pm\t fm\t v"); //pm = ppu memory, fm= file memory, 
		for (i =0; i<64; i++) begin  // Don't need to read all of em 
			ppu_ab = i;
			#200ns;
			$display("%x\t %x\t %x", ppu_ab, ppu_ab+'h4010, ppu_do);
		end
		//========== END OF PPU TEST =============
		$stop;
	end 
	
	always begin 
		#100ns;
		clk = ~clk;
	end 
endmodule
