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
    inout wire pred_takeE,
    input wire [31:0] pcF,pcD,
    input wire [31:0] pcE,
    input wire branchF,
    input wire branchE,         // M�׶��Ƿ��Ƿ�ָ֧��
    input wire actual_takeE,    // ʵ���Ƿ���ת

    input wire branchD,        // ����׶��Ƿ�����תָ��   
    output wire pred_takeF      // Ԥ���Ƿ���ת
); 


// �������
    parameter Strongly_not_taken = 2'b00, Weakly_not_taken = 2'b01, Weakly_taken = 2'b11, Strongly_taken = 2'b10;
    parameter PHT_DEPTH = 6;
    parameter BHT_DEPTH = 10;

    reg [5:0] GHT;
    reg [1:0] PHT [(1<<PHT_DEPTH)-1:0];
    
    integer i,j;
    wire [(PHT_DEPTH-1):0] update_PHT_index;
    wire [(PHT_DEPTH-1):0] update_GHR_value;
 
    assign update_GHR_value = pcF[7:2] ^ GHT;  
    assign update_PHT_index = update_GHR_value;
// ---------------------------------------Ԥ���߼�---------------------------------------
    assign pred_takeF = PHT[update_PHT_index][1] & branchF;      // ��ȡָ�׶�Ԥ���Ƿ����ת����������ˮ�ߴ��ݸ�����׶Ρ�


 //---------------------------------------PHT��ʼ���Լ�����---------------------------------------
    
    reg [5:0] GHT_re;
    reg [1:0] PHT_re [(1<<PHT_DEPTH)-1:0];

// ---------------------------------------Ԥ���߼�---------------------------------------
  
// ---------------------------------------Ԥ���߼�---------------------------------------

    wire [(PHT_DEPTH-1):0] update_PHT_index_re;
    wire [(PHT_DEPTH-1):0] update_GHR_value_re;
 
    assign update_GHR_value_re = pcE[7:2] ^ GHT_re;  
    assign update_PHT_index_re = update_GHR_value_re;


    always@(posedge clk) begin
        if(rst) begin
            GHT <= 6'b0;
            end
        else if(branchF) begin
            if(pred_takeF) begin
                GHT <= GHT<<1 + 1'b1;
            end
            else begin
                 GHT <= GHT <<1;
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
        if(branchE && (actual_takeE!=pred_takeE)) begin
            for(i = 0; i < (1<<PHT_DEPTH); i=i+1) begin
                if(i!=update_PHT_index_re) begin
                    PHT[i] <= PHT_re[i] ;
                end
                else begin
                    case(PHT_re[update_PHT_index_re])
	               Strongly_not_taken: PHT[update_PHT_index_re] <=  (actual_takeE?Weakly_not_taken:Strongly_not_taken);
	               Weakly_not_taken:  PHT[update_PHT_index_re] <=  (actual_takeE?Weakly_taken:Strongly_not_taken);
	               Weakly_taken: PHT[update_PHT_index_re] <=  (actual_takeE?Strongly_taken:Weakly_not_taken);
	               Strongly_taken: PHT[update_PHT_index_re] <=  (actual_takeE?Strongly_taken:Weakly_taken);
            endcase 
                end
            end
                        
        end
        else if(branchF) begin
            case(PHT[update_PHT_index])
	Strongly_not_taken: PHT[update_PHT_index] <=  (pred_takeF?Weakly_not_taken:Strongly_not_taken);
	Weakly_not_taken:  PHT[update_PHT_index] <=  (pred_takeF?Weakly_taken:Strongly_not_taken);
	Weakly_taken: PHT[update_PHT_index] <=  (pred_takeF?Strongly_taken:Weakly_not_taken);
	Strongly_taken: PHT[update_PHT_index] <=  (pred_takeF?Strongly_taken:Weakly_taken);
            endcase
        end
        end
      end


    always@(posedge clk) begin
        if(rst) begin
            GHT_re <= 6'b0;
            end
        else if(branchE) begin
            if(actual_takeE) begin
                GHT_re <= GHT_re<<1 + 1'b1;
            end
            else begin
                 GHT_re <= GHT_re<<1;
            end
        end
    end
// ---------------------------------------BHT��ʼ���Լ�����---------------------------------------


// ---------------------------------------PHT��ʼ���Լ�����---------------------------------------
    always @(posedge clk) begin
        if(rst) begin
            for(i = 0; i < (1<<PHT_DEPTH); i=i+1) begin
                PHT_re[i] <= Weakly_taken;
            end
        end
        else begin
            if(branchE) begin
            case(PHT_re[update_PHT_index_re])
	Strongly_not_taken: PHT_re[update_PHT_index_re] <=  (actual_takeE?Weakly_not_taken:Strongly_not_taken);
	Weakly_not_taken:  PHT_re[update_PHT_index_re] <=  (actual_takeE?Weakly_taken:Strongly_not_taken);
	Weakly_taken: PHT_re[update_PHT_index_re] <=  (actual_takeE?Strongly_taken:Weakly_not_taken);
	Strongly_taken: PHT_re[update_PHT_index_re] <=  (actual_takeE?Strongly_taken:Weakly_taken);

            endcase 
        end
    end
    end

endmodule
