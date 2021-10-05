`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 23:30:22
// Design Name: 
// Module Name: test_top
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


module test_top(

    );
    
    reg clka, rst;
    //
    wire inst_ram_ena, data_ram_ena, data_ram_wea;
    wire [31:0] pc, instr, alu_result, mem_wdata, mem_rdata;
    
top testtop1(
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
    
    initial begin
        clka = 1;
        rst = 1;
        # 10 rst = 0;
    end
    always #5
        clka = ~clka;
endmodule
