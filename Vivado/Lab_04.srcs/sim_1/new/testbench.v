`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/03 19:11:52
// Design Name: 
// Module Name: testbench
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


module testbench();
    reg clka, rst;
    //
    wire inst_ram_ena, data_ram_ena, data_ram_wea;
    wire [31:0] pc, instr, alu_result, mem_wdata, mem_rdata, result;
    wire [4:0] rs, rt, rd;
    
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
    .mem_rdata(mem_rdata),
    .result(result),
    .rs(rs),
    .rt(rt),
    .rd(rd)
    );

	initial begin 
	   clka <= 1;
		rst <= 1;
		#200;
		rst <= 0;
	end
	
//	always #5
//	   clka = ~clka;

	always begin
		clka <= 1;
		#10;
		clka <= 0;
		#10;
	
	end
	
	always @(posedge clka) begin
	   $display("clka:%b---------------------------------------",clka);
	end

	always @(negedge clka) begin
//       $display("write2reg£º%b, regwrite: %d, pc: %d, instr: %h, instr[25:21]: %b, instr[20:16]: %b, rd1: %d, alu_srcB: %d",write2reg, regwrite, pc, instr, instr[25:21], instr[20:16], rd1, alu_srcB);
	   $display("data_ram_wea: %b, alu_result: %d, mem_wdata: %b", data_ram_wea, alu_result, mem_wdata);
//	   $stop;
		if(data_ram_wea==1'b1) begin
			/* code */
			if(alu_result === 84 & mem_wdata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(alu_result !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end
endmodule
