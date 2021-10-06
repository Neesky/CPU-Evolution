`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 20:47:50
// Design Name: 
// Module Name: controller
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


module controller(
    input wire clka,
	input wire[5:0] op,funct,
	input wire zero,
	output wire memtoregE, memtoregM, memtoregW,memwrite,
	output wire alusrc,
	output wire regdst,regwriteE,regwriteM, regwriteW,
	output wire jump, memen,
	output wire[2:0] alucontrolE,
	output wire branch
    );
    wire [7:0] sigs;
	wire[1:0] aluop;
//	wire branch;

	main_decoder md( op,sigs, aluop);
	alu_dec ad(funct,aluop,alucontrolD);
	
//	assign branch = sigs[3];
	assign jump = sigs[6];
	
	//regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump, memen
	wire [2:0] alucontrolD;
	floprc #(3) alucontrol_E(
    .clk(clka), 
    .rst(rst), 
    .en(1'b1),
    .clear(1'b0),
    .d(alucontrolD),
    .q(alucontrolE)
    );
    
    assign branch = sigs[3];
    
    wire [7:0] sigsE;
	
	floprc #(8) sigs_E(
    .clk(clka), 
    .rst(rst), 
    .en(1'b1),
    .clear(1'b0),
    .d(sigs),
    .q(sigsE)
    );
    
    assign alusrc = sigsE[2];
    assign regdst = sigsE[1];
    assign memtoregE = sigsE[5];
    assign regwriteE = sigsE[0];
    
    //regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump, memen
    wire [7:0] sigsM;
    floprc #(8) sigs_M(
    .clk(clka), 
    .rst(rst), 
    .en(1'b1),
    .clear(1'b0),
    .d(sigsE),
    .q(sigsM)
    );
    
//    assign branch = sigsM[3];
    assign memwrite = sigsM[4];
    assign memen = sigsM[7];
    assign regwriteM = sigsM[0];
    assign memtoregM = sigsM[5];
    
    //regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump, memen
    wire [7:0] sigsW;
    floprc #(8) sigs_W(
    .clk(clka), 
    .rst(rst), 
    .en(1'b1),
    .clear(1'b0),
    .d(sigsM),
    .q(sigsW)
    );
    
    assign regwriteW = sigsW[0];
    assign memtoregW = sigsW[5];
//    assign regdst = sigsW[1];
    

	always @(posedge clka) begin
	   $display("controller,regwriteD:%b,regwriteE:%b,regwriteM:%b,regwriteW:%b, alucontrolE:%b",sigs[0], sigsE[0], sigsM[0], regwriteW, alucontrolD );
	   $display("controller, funct:%b,aluop:%b,alucontrolD:%b", funct,aluop,alucontrolD);
	end
endmodule
