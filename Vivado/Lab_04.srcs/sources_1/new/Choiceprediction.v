`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/14 02:59:32
// Design Name: 
// Module Name: Choiceprediction
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


module Choiceprediction(
    input wire clk, rst,
    input wire [31:0] pcF,
    input wire GHT,Lpred_take,Gpred_take,
    input wire branchF,branchE,LcorrectE,GcorrectE,
    output wire pred_takeF
); 


    parameter Strongly_not_taken = 2'b00, Weakly_not_taken = 2'b01, Weakly_taken = 2'b11, Strongly_taken = 2'b10;
    parameter PHT_DEPTH = 6;
    parameter BHT_DEPTH = 10;

    reg [1:0] PHT [(1<<PHT_DEPTH)-1:0];
    
    integer i,j;
    wire [(PHT_DEPTH-1):0] update_PHT_index;
    wire [(PHT_DEPTH-1):0] update_GHR_value;
 
    assign update_GHR_value = pcF[7:2] ^ GHT;  
    assign update_PHT_index = update_GHR_value;
    assign pred_takeF = PHT[update_PHT_index][1] & branchF; 
// ---------------------------------------PHT初始化以及更新---------------------------------------
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < (1<<PHT_DEPTH); i=i+1) begin
                PHT[i] <= Weakly_taken;
            end
        end
        else begin
            if(branchE) begin
            
            if({LcorrectE,GcorrectE}==2'b01) begin
            case(PHT[update_PHT_index])
	Strongly_not_taken: PHT[update_PHT_index] <=  Strongly_not_taken;
	Weakly_not_taken:  PHT[update_PHT_index] <=  Strongly_not_taken;
	Weakly_taken: PHT[update_PHT_index] <=  Weakly_not_taken;
	Strongly_taken: PHT[update_PHT_index] <=  Weakly_taken;
            endcase 
            end
            else if({LcorrectE,GcorrectE}==2'b10) begin
            case(PHT[update_PHT_index])
	Strongly_not_taken: PHT[update_PHT_index] <=  Weakly_not_taken;
	Weakly_not_taken:  PHT[update_PHT_index] <= Weakly_taken;
	Weakly_taken: PHT[update_PHT_index] <=  Strongly_taken;
	Strongly_taken: PHT[update_PHT_index] <=  Strongly_taken;
            endcase 
            end
        end
    end
    end

endmodule
