`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 09:39:12
// Design Name: 
// Module Name: alu
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


module alu_always(
    input wire clk,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [2:0] f,
    output reg [31:0] y,
    output wire overflow, zero
    );
always@(*) begin
    case(f)
        3'b000: y <= a&b;
        3'b001: y <= a|b;
        3'b010: y <= a + b;
        3'b110: y <= a - b;
        3'b100: y <= ~a;
        3'b111: y <= (a < b)?1:0;
        default:y <= 32'b0;
    endcase
end
assign zero = (y == 0)? 32'h00000001:32'h00000000;
assign overflow = 1'b0;
endmodule

//module alu_always(
//    input wire clk,
//	input wire[31:0] a,b,
//	input wire[2:0] f,
//	output reg[31:0] y,
//	output reg overflow,
//	output wire zero
//    );

//	wire[31:0] s,bout;
//	assign bout = f[2] ? ~b : b;
//	assign s = a + bout + f[2];
//	always @(*) begin
//		case (f[1:0])
//			2'b00: y <= a & bout;
//			2'b01: y <= a | bout;
//			2'b10: y <= s;
//			2'b11: y <= s[31];
//			default : y <= 32'b0;
//		endcase	
//	end
//	assign zero = (y == 32'b0);

//	always @(*) begin
//		case (f[2:1])
//			2'b01:overflow <= a[31] & b[31] & ~s[31] |
//							~a[31] & ~b[31] & s[31];
//			2'b11:overflow <= ~a[31] & b[31] & s[31] |
//							a[31] & ~b[31] & ~s[31];
//			default : overflow <= 1'b0;
//		endcase	
//		$display("alu, zero:%b, a:%b, b:%b, f:%b",zero,a,b,f);
//	end
//endmodule
