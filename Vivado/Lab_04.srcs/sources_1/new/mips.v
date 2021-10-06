`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 17:28:41
// Design Name: 
// Module Name: mips
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


module mips(
    input wire clka, rst,
    output wire inst_ram_ena, data_ram_ena,
    output wire  data_ram_wea,
    output wire [31:0] pc, alu_result, mem_wdata, 
    input wire [31:0] instr, mem_rdata
    );
    
wire memtoregE,memtoregM, memtoregW, regwriteE;
wire [31:0] instrD;
wire pcsrc, zero;
wire [2:0] alucontrol;
assign inst_ram_ena = 1'b1;

wire branch;
wire stallD;
controller c(clka, instrD[31:26],instrD[5:0],zero,memtoregE,memtoregM,memtoregW,
    data_ram_wea,pcsrc,alusrc,regdst,regwriteE,regwriteM, regwriteW,jump,data_ram_ena, alucontrol, branch);
    
datapath datapath(
    .clka(clka),
    .rst(rst),
    .branch(branch),
    .memtoregM(memtoregM),
    .pcsrc(pcsrc),
    .instr(instr),
    .mem_rdata(mem_rdata),
    .pc(pc), 
    .alu_resultM(alu_result), 
//    .mem_wdata(mem_wdata),
    .writedataM(mem_wdata),
    .zeroM(zero),
    .stallD(stallD), 
    .jump(jump), 
//    .beanch(beanch), 
    .alusrc(alusrc), 
//    .memtorg(memtoreg),
    .memtoregE(memtoregE),
    .memtoregW(memtoregW),
    .regwriteE(regwriteE),
    .regwriteM(regwriteM), 
    .regwriteW(regwriteW), 
    .regdst(regdst),
    .alucontrol(alucontrol)
    );
    
    always @(clka, data_ram_wea, alu_result) begin
        $display("mips,data_ram_wea:%d,alu_result:%d, mem_wdata:%d",data_ram_wea,alu_result, mem_wdata);
    end
endmodule
