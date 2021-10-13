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


module branch_predict (
    input wire clk, rst,
    
    input wire flushD,
    input wire stallD,

    input wire [31:0] pcF,
    input wire [31:0] pcE,

    input wire branchE,         // M�׶��Ƿ��Ƿ�ָ֧��
    input wire actual_takeE,    // ʵ���Ƿ���ת

    input wire branchD,        // ����׶��Ƿ�����תָ��   
    output wire pred_takeD      // Ԥ���Ƿ���ת
);
    wire pred_takeF;
    reg pred_takeF_r;
   

// �������
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

// ---------------------------------------Ԥ���߼�---------------------------------------

    assign BHT_index = pcF[11:2];     
    assign BHR_value = BHT[BHT_index];  
    assign PHT_index = BHR_value;

    assign pred_takeF = PHT[PHT_index][1];      // ��ȡָ�׶�Ԥ���Ƿ����ת����������ˮ�ߴ��ݸ�����׶Ρ�

        // --------------------------pipeline------------------------------
            always @(posedge clk) begin
                if(rst | flushD) begin
                    pred_takeF_r <= 0;
                end
                else if(~stallD) begin
                    pred_takeF_r <= pred_takeF;
                end
            end
        // --------------------------pipeline------------------------------

// ---------------------------------------Ԥ���߼�---------------------------------------


// ---------------------------------------BHT��ʼ���Լ�����---------------------------------------
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
// ---------------------------------------BHT��ʼ���Լ�����---------------------------------------


// ---------------------------------------PHT��ʼ���Լ�����---------------------------------------
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
// ---------------------------------------PHT��ʼ���Լ�����---------------------------------------

    // ����׶�������յ�Ԥ����
    assign pred_takeD = branchD & pred_takeF_r;  
endmodule
