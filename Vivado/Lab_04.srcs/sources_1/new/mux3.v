`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 22:33:32
// Design Name: 
// Module Name: mux3
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


module mux3 #(parameter WIDTH = 8)(
    input wire [WIDTH-1:0] d0, d1, d2,
    input wire [1:0] s,
    output wire [WIDTH-1:0] y
    );
    
    assign y = (s == 2'b00) ? d0 :
                (s == 2'b01) ? d1 :
                (s == 2'b10) ? d2 : d0;
endmodule
