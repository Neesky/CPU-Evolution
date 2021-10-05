`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 20:46:00
// Design Name: 
// Module Name: alu_decoder
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


module alu_decoder(
    input wire [5:0] funct,
    input wire [1:0] aluop,
    output wire [2:0] alucontrol
    );
    
    assign alucontrol = (aluop == 2'b00)? 3'b010:
                        (aluop == 2'b01)? 3'b110:
                        (aluop == 2'b01)?
                                          (funct == 6'b100000)? 3'b010:
                                          (funct == 6'b100010)? 3'b110:
                                          (funct == 6'b100100)? 3'b000:
                                          (funct == 6'b100101)? 3'b001:
                                          (funct == 6'b101010)? 3'b111:
                                          3'b000: 3'b000;
endmodule
