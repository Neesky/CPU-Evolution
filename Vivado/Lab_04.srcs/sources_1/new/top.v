`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 17:41:30
// Design Name: 
// Module Name: top
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


module top(
    input clka, rst,
    //
    output wire inst_ram_ena, data_ram_ena, data_ram_wea,
    output wire [31:0] pc, instr, alu_result, mem_wdata, mem_rdata, result,
    output wire [4:0] rs, rt, rd
    );

//wire inst_ram_ena, data_ram_ena, data_ram_wea;
//wire [31:0] pc, instr, alu_result, mem_wdata, mem_rdata; 
assign rs = instr[25:21];
assign rt = instr[20:16];
assign rd = instr[15:11];
assign result = alu_result;
mips mips1(
    .clka(clka),
    .rst(rst),
    .inst_ram_ena(inst_ram_ena), 
    .data_ram_ena(data_ram_ena),
    .data_ram_wea(data_ram_wea),
    .pc(pc), 
    .instr(instr), 
    .alu_result(alu_result), 
    .mem_wdata(mem_wdata), 
    .mem_rdata(mem_rdata)
    );

    //inst_ram
inst_ram inst_ram (
  .clka(~clka),    // input wire clka
  .ena(inst_ram_ena),      // input wire ena
  .wea(4'b0000),      // input wire [3 : 0] wea
  .addra(pc[9:2]),  // input wire [7 : 0] addra
  .dina(32'b0),    // input wire [31 : 0] dina
  .douta(instr)  // output wire [31 : 0] douta
);

    //data_ram
data_ram data_ram (
  .clka(~clka),    // input wire clka
  .ena(data_ram_ena),      // input wire ena
  .wea({data_ram_wea,data_ram_wea,data_ram_wea,data_ram_wea}),      // input wire [3 : 0] wea, wea = 4'b1 when write
//  .addra(alu_result[9:0]),  // input wire [9 : 0] addra
  .addra(alu_result[11:2]),
  .dina(mem_wdata),    // input wire [31 : 0] dina
  .douta(mem_rdata)  // output wire [31 : 0] douta
);

//data_ram(
//    .clka(clka),    // input wire clka
//    .ena(data_ram_ena),      // input wire ena
//    .wea({data_ram_wea,data_ram_wea,data_ram_wea,data_ram_wea}),      // input wire [3 : 0] wea, wea = 4'b1 when write
//    //  .addra(alu_result[9:0]),  // input wire [9 : 0] addra
//    .addra(alu_result[9:0]),
//    .dina(mem_wdata),    // input wire [31 : 0] dina
//    .douta(mem_rdata) 
//);
endmodule
