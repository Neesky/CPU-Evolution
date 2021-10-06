`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 21:34:45
// Design Name: 
// Module Name: hazard
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


module hazard(
    input wire [4:0] rsD, rtD, rsE, rtE, writeregE, writeregM, writeregW,
    input wire regwriteE, regwriteM, regwriteW, memtoregE,memtoregM, branchD,branchM,actual_takeM,pred_takeM,pred_takeD,
    output wire [1:0] forwardAE, forwardBE,
    output wire forwardAD, forwardBD,
    output wire stallF, stallD, flushE,flushD,flushF
    );

assign flushD = (branchM & (actual_takeM!=pred_takeM))|pred_takeD;
assign flushF = (branchM & (actual_takeM!=pred_takeM));


assign forwardAE = ((rsE != 5'b0) & (rsE == writeregM) & regwriteM) ? 2'b10:
                   ((rsE != 5'b0) & (rsE == writeregW) & regwriteW) ? 2'b01: 2'b00;
//                        : 2'b00;
                        
assign forwardBE = ((rtE != 5'b0) & (rtE == writeregM) & regwriteM) ? 2'b10:
                   ((rtE != 5'b0) & (rtE == writeregW) & regwriteW) ? 2'b01: 2'b00;
//                        : 2'b00;

assign forwardAD = ((rsD != 5'b0) & (rsD == writeregM)) & regwriteM;
assign forwardBD = ((rtD != 5'b0) & (rtD == writeregM)) & regwriteM;

wire lwstall, branch_stall;
assign lwstall = ((rsD == rtE) | (rtD == rtE)) && memtoregE;
assign branch_stall = branchD & regwriteE &((writeregE == rsD) |  (writeregE == rtD)) |
                        branchD & memtoregM &((writeregM == rsD) |  (writeregM == rtD));

assign stallF = lwstall ;
assign stallD = lwstall ;
assign flushE = lwstall | (branchM & (actual_takeM!=pred_takeM));

always @(*) begin
    $display("hazard,lwstall:%b,branch_stall:%b",lwstall, branch_stall);
end
                        
endmodule
