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
	
	always begin 
		#20ns
		cpu_clk = ~cpu_clk;
		ppu_clk = ~ppu_clk;
	end 
	rom_master rom_dut(.*);
	
	initial begin 
		$readmemh("")
		cpu_clk = 0;
		ppu_clk = 0;
		// test CHR Rom ppu $0000 -> $2000
		// test PRG Rom (inc. mirror) $C000 -> $FFFF
		//===============CPU TEST ================
		//===========RST vector test==============
		cpu_ab = 'hFFFC;
		#21ns;
		$display( "lower rst vector :%x, exp: 07", cpu_do);
		cpu_ab = 'hFFFC+1;	// test reset vector
		#20ns;
		$display( "upper rst vector :%x exp: C0", cpu_do);
		//===========FIRST instruction test ======
		cpu_ab = 'hC007;
		#20ns;
		$display( "FIRST vector :%x exp:SEI (78)", cpu_do);	
		//========== END OF CPU TEST =============
		
		//===============PPU TEST ================
		//============= vector test===============
		$display("pm\t fm\t v"); //pm = ppu memory, fm= file memory, 
		for (i =0; i<64; i++) begin  // Don't need to read all of em 
			ppu_ab = i;
			#20;
			$display("%x\t %x\t %x", ppu_ab, ppu_ab+'h4010, ppu_do);
		end
		//========== END OF PPU TEST =============
		$stop
	end 
	

endmodule
