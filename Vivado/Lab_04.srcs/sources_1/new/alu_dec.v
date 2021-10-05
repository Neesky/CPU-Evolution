`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 18:13:34
// Design Name: 
// Module Name: alu_dec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_dec(
    input wire [5:0] funct,
    input wire [1:0] aluop,
    output wire [2:0] alucontrol
    );
//    assign alucontrol = (aluop == 2'b00)? 3'b010:
//                        (aluop == 2'b01)? 3'b110:
//                        (aluop == 2'b10)?
//                                        (funct == 6'b100000) ? 3'b010:
//                                        (funct == 6'b100010) ? 3'b110:
//                                        (funct == 6'b100100) ? 3'b000:
//                                        (funct == 6'b100101) ? 3'b001:
//                                        (funct == 6'b101010) ? 3'b111:
//                                        3'b000 : 3'b000;
//endmodule
    reg [2:0] alucontrol1;
	always @(*) begin
		case (aluop)
			2'b00: alucontrol1 <= 3'b010;//add (for lw/sw/addi)
			2'b01: alucontrol1 <= 3'b110;//sub (for beq)
			default : case (funct)
				6'b100000:alucontrol1 <= 3'b010; //add
				6'b100010:alucontrol1 <= 3'b110; //sub
				6'b100100:alucontrol1 <= 3'b000; //and
				6'b100101:alucontrol1 <= 3'b001; //or
				6'b101010:alucontrol1 <= 3'b111; //slt
				default:  alucontrol1 <= 3'b000;
			endcase
		endcase
		
		$display("alu_dec, alucontrol:%b",alucontrol);
	
	end
	assign alucontrol = alucontrol1;
endmodule
