/*
  joypad.sv
  the dual joystick inputs
*/

`define JP1A 'h4016
`define JP2A 'h4017

module (
	input logic [15:0]AB,
	input logic [7:0] JPW[1:0],
	input logic RW,
	output logic [7:0]JPR[1:0]
	
);
