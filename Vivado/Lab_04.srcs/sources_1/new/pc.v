`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 09:21:15
// Design Name: 
// Module Name: pc
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


module pc(
    input wire clk, rst, en,
    input wire [31:0] din,
    output reg[31:0] q
    );
    
    always @(posedge clk) begin
//        if(rst) q <= 32'b0;
        if (rst) begin
            q <= 32'b0;
        end
        else if (en) begin
            q <= din;
        end else begin
            q <= q;
        end
//        q <= din;
    end
endmodule
