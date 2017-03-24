/*
	clks.sv
	This generates the clock frequencies that are used in this project
	+--------------------------------------------------------+
	|  1.79 MHZ   |      21.477MHz    |    50MHz			 |
	|             <--Div By 5       <---+                 <------+ 50MHz
	|             |                   |                      |
	|             |                   |                      |
	|  CPU        |      PPU        --->  -Frame Buffer      |
	|             |                   |   -VGA OUTPUT        |
	|             |                   |                      |
	|             |                   |                      |
	|             |                   |                      |
	|             |                   |                      |
	+--------------------------------------------------------+

*/



/// Altera PLL Taken from ELEX 7660 Labs