`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 16:27:15
// Design Name: 
// Module Name: VCU128_top_tn
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


module VCU128_top_tn();

reg sys_clk,gt_clk;

wire [1:0]w_gt_txp;
wire [1:0]w_gt_txn;

always begin
    gt_clk = 0;
    #1.6;
    gt_clk = 1;
    #1.6;
end

always begin
    sys_clk = 0;
    #5;
    sys_clk = 1;
    #5;
end


VCU128_10g_eth_top#(
    .P_CHANNEL_NUM      (2        ) ,
    .P_MIN_LENGTH       (8'd64    ) ,
    .P_MAX_LENGTH       (15'd9600 )
)VCU128_10g_eth_top_u0(
    .i_gt_refclk_p      (gt_clk     ),
    .i_gt_refclk_n      (~gt_clk    ),
    .i_sys_clk_p        (sys_clk    ),
    .i_sys_clk_n        (~sys_clk   ),
    .o_gt_txp           (w_gt_txp   ),
    .o_gt_txn           (w_gt_txn   ),
    .i_gt_rxp           (w_gt_txp   ),
    .i_gt_rxn           (w_gt_txn   ),
    .o_sfp_dis          () 
);


endmodule
