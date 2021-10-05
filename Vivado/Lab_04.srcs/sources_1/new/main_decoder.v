`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 20:17:14
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(
//    input  [5:0] op,
//    output wire jump, regwrite, regdst, alusrc, beanch, memwrite, memtoreg,memen,
//    output [1:0] aluop
//    );
    
//    reg [1:0] aluop_reg;
//    reg [7:0] sigs;
    
//    assign aluop = aluop_reg;
//    assign {jump, regwrite, regdst, alusrc, beanch, memwrite, memtoreg, memen} = sigs;
    
//    always @ (*) begin
//        case (op)
//            6'b000000: begin
//                aluop_reg <= 2'b10;
//                sigs <= 8'b01100001;
//            end
//            6'b100011: begin
//                aluop_reg <= 2'b00;
//                sigs <= 8'b01010011;
//            end
//            6'b101011: begin
//                aluop_reg <= 2'b00;
//                sigs <= 8'b0001011;
//            end
//            6'b000100: begin
//                aluop_reg <= 2'b01;
//                sigs <= 8'b0000101;
//            end
//            6'b001000: begin
//                aluop_reg <= 2'b00;
//                sigs <= 8'b0101001;
//            end
//            6'b000010: begin
//                aluop_reg <= 2'b00;
//                sigs <= 8'b1000001;
//            end
//            default: begin
//                aluop_reg <= 2'b00;
//                sigs <= 8'b0000001;
//            end
//        endcase
//    end
    
//endmodule
//    input wire clk,
	input wire[5:0] op,
	
    output wire [7:0] sigs,

//	output wire memtoreg,memwrite,
//	output wire branch,alusrc,
//	output wire regdst,regwrite,
//	output wire jump, memen,
	output wire[1:0] aluop
    );
	reg[9:0] controls;
//	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop, memen} = controls;
assign {sigs[0],sigs[1],sigs[2],sigs[3],sigs[4],sigs[5],sigs[6],aluop, sigs[7]} = controls;
	always @(*) begin
		case (op)
			6'b000000:controls <= 10'b1100000101;//R-TYRE
			6'b100011:controls <= 10'b1010010001;//LW
			6'b101011:controls <= 10'b0010100001;//SW
			6'b000100:controls <= 10'b0001000011;//BEQ
			6'b001000:controls <= 10'b1010000001;//ADDI
			6'b000010:controls <= 10'b0000001001;//J
			default:  controls <= 10'b0000000001;//illegal op
		endcase
//		$display("main_decoder, regwrite: %b,regdst: %b,alusrc: %b,branch: %b,memwrite: %b,memtoreg: %b,jump: %b,aluop: %b",regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop);
	end
//	always @(*) begin
//	   $display("main_decoder, regwrite: %b,regdst: %b,alusrc: %b,branch: %b,memwrite: %b,memtoreg: %b,jump: %b,aluop: %b",regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop);
//	end
endmodule

