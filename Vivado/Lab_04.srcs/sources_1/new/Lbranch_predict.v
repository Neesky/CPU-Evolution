`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/06 11:28:16
// Design Name: 
// Module Name: branch_predict
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


module Lbranch_predict (
    input wire clk, rst,
    
    input wire flushD,
    input wire stallD,

    input wire [31:0] pcF,
    input wire [31:0] pcE,

    input wire branchE,         // M阶段是否是分支指�?
    input wire actual_takeE,    // 实际是否跳转

    input wire branchF,        // 译码阶段是否是跳转指�?   
    output wire pred_takeF      // 预测是否跳转
);
   

// 定义参数
    parameter Strongly_not_taken = 2'b00, Weakly_not_taken = 2'b01, Weakly_taken = 2'b11, Strongly_taken = 2'b10;
    parameter PHT_DEPTH = 6;
    parameter BHT_DEPTH = 10;

// 
    reg [5:0] BHT [(1<<BHT_DEPTH)-1 : 0];
    reg [1:0] PHT [(1<<PHT_DEPTH)-1:0];
    
    integer i,j;
    wire [(PHT_DEPTH-1):0] PHT_index;
    wire [(BHT_DEPTH-1):0] BHT_index;
    wire [(PHT_DEPTH-1):0] BHR_value;

// ---------------------------------------预测逻辑---------------------------------------

    assign BHT_index = pcF[11:2];     
    assign BHR_value = BHT[BHT_index];  
    assign PHT_index = BHR_value;

    assign pred_takeF = PHT[PHT_index][1] & branchF;      // 在取指阶段预测是否会跳转，并经过流水线传递给译码阶段�?

        // --------------------------pipeline------------------------------
        // --------------------------pipeline------------------------------

// ---------------------------------------预测逻辑---------------------------------------


// ---------------------------------------BHT初始化以及更�?---------------------------------------
    wire [(PHT_DEPTH-1):0] update_PHT_index;
    wire [(BHT_DEPTH-1):0] update_BHT_index;
    wire [(PHT_DEPTH-1):0] update_BHR_value;

    assign update_BHT_index = pcE[11:2];     
    assign update_BHR_value = BHT[update_BHT_index];  
    assign update_PHT_index = update_BHR_value;

    always@(posedge clk) begin
        if(rst) begin
            for(j = 0; j < (1<<BHT_DEPTH); j=j+1) begin
                BHT[j] <= 0;
            end
        end
        else if(branchE) begin
            if(actual_takeE) begin
                 BHT[update_BHT_index] = BHT[update_BHT_index]<<1 + 1'b1;
            end
            else begin
                 BHT[update_BHT_index] = BHT[update_BHT_index]<<1;
            end
        end
    end
// ---------------------------------------BHT初始化以及更�?---------------------------------------


// ---------------------------------------PHT初始化以及更�?---------------------------------------
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < (1<<PHT_DEPTH); i=i+1) begin
                PHT[i] <= Weakly_taken;
            end
        end
        else begin
        if(branchE)
            case(PHT[update_PHT_index])
	Strongly_not_taken: PHT[update_PHT_index] =  (actual_takeE?Weakly_not_taken:Strongly_not_taken);
	Weakly_not_taken:  PHT[update_PHT_index] =  (actual_takeE?Weakly_taken:Strongly_not_taken);
	Weakly_taken: PHT[update_PHT_index] =  (actual_takeE?Strongly_taken:Weakly_not_taken);
	Strongly_taken: PHT[update_PHT_index] =  (actual_takeE?Strongly_taken:Weakly_taken);
            endcase 
        end
    end
// ---------------------------------------PHT初始化以及更�?---------------------------------------


endmodule