`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 19:56:08
// Design Name: 
// Module Name: uplus_ten_gig_channel
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


module uplus_ten_gig_channel#(
    parameter       P_MIN_LENGTH = 8'd64      ,
    parameter       P_MAX_LENGTH = 15'd9600
)(
    input           i_sys_reset         ,
    input           i_dclk              ,
    output          o_gt_txp            ,
    output          o_gt_txn            ,
    input           i_gt_rxp            ,
    input           i_gt_rxn            ,

    output          o_tx_clk_out        ,
    output          o_rx_clk_out        ,
    output          o_user_tx_reset     ,
    output          o_user_rx_reset     ,
    output          o_stat_rx_status    ,

    output [0:0]    o_qpll0reset        ,
    input  [0:0]    i_qpll0lock         ,
    input  [0:0]    i_qpll0outclk       ,
    input  [0:0]    i_qpll0outrefclk    ,
    output [0:0]    o_qpll1reset        ,
    input  [0:0]    i_qpll1lock         ,
    input  [0:0]    i_qpll1outclk       ,
    input  [0:0]    i_qpll1outrefclk    ,

    output          tx_axis_tready      ,
    input           tx_axis_tvalid      ,
    input  [63 :0]  tx_axis_tdata       ,
    input           tx_axis_tlast       ,
    input  [7  :0]  tx_axis_tkeep       ,
    input           tx_axis_tuser       ,

    output          rx_axis_tvalid      ,
    output [63 :0]  rx_axis_tdata       ,
    output          rx_axis_tlast       ,
    output [7  :0]  rx_axis_tkeep       ,
    output          rx_axis_tuser       

);

wire w_rxrecclkout              ;
wire w_rx_core_clk              ;
wire w_gt_reset_tx_done         ;
wire w_gt_reset_rx_done         ;
wire w_gtwiz_reset_all          ;
wire w_gtwiz_reset_tx_datapath  ;
wire w_gtwiz_reset_rx_datapath  ;
wire w_tx_core_reset            ;
wire w_rx_core_reset            ;
wire w_rx_serdes_reset          ;

/*----ctrl rx----*/         
wire        ctl_rx_enable_0                     ;
wire        ctl_rx_check_preamble_0             ;
wire        ctl_rx_check_sfd_0                  ;
wire        ctl_rx_force_resync_0               ;
wire        ctl_rx_delete_fcs_0                 ;
wire        ctl_rx_ignore_fcs_0                 ;
wire [14:0] ctl_rx_max_packet_len_0             ;
wire [7 :0] ctl_rx_min_packet_len_0             ;
wire        ctl_rx_process_lfi_0                ;
wire        ctl_rx_test_pattern_0               ;
wire        ctl_rx_data_pattern_select_0        ;
wire        ctl_rx_test_pattern_enable_0        ;
wire        ctl_rx_custom_preamble_enable_0     ;
/*----RX Stats Signals----*/  
wire        stat_rx_framing_err_0           ;
wire        stat_rx_framing_err_valid_0     ;
wire        stat_rx_local_fault_0           ;
wire        stat_rx_block_lock_0            ;
wire        stat_rx_valid_ctrl_code_0       ;
//wire        o_stat_rx_status                ;
wire        stat_rx_remote_fault_0          ;
wire [1 :0] stat_rx_bad_fcs_0               ;
wire [1 :0] stat_rx_stomped_fcs_0           ;
wire        stat_rx_truncated_0             ;
wire        stat_rx_internal_local_fault_0  ;
wire        stat_rx_received_local_fault_0  ;
wire        stat_rx_hi_ber_0                ;
wire        stat_rx_got_signal_os_0         ;
wire        stat_rx_test_pattern_mismatch_0 ;
wire [3 :0] stat_rx_total_bytes_0           ;
wire [1 :0] stat_rx_total_packets_0         ;
wire [13:0] stat_rx_total_good_bytes_0      ;
wire        stat_rx_total_good_packets_0    ;
wire        stat_rx_packet_bad_fcs_0        ;
wire        stat_rx_packet_64_bytes_0       ;
wire        stat_rx_packet_65_127_bytes_0   ;
wire        stat_rx_packet_128_255_bytes_0  ;
wire        stat_rx_packet_256_511_bytes_0  ;
wire        stat_rx_packet_512_1023_bytes_0 ;
wire        stat_rx_packet_1024_1518_bytes_0;
wire        stat_rx_packet_1519_1522_bytes_0;
wire        stat_rx_packet_1523_1548_bytes_0;
wire        stat_rx_packet_1549_2047_bytes_0;
wire        stat_rx_packet_2048_4095_bytes_0;
wire        stat_rx_packet_4096_8191_bytes_0;
wire        stat_rx_packet_8192_9215_bytes_0;
wire        stat_rx_packet_small_0          ;
wire        stat_rx_packet_large_0          ;
wire        stat_rx_unicast_0               ;
wire        stat_rx_multicast_0             ;
wire        stat_rx_broadcast_0             ;
wire        stat_rx_oversize_0              ;
wire        stat_rx_toolong_0               ;
wire        stat_rx_undersize_0             ;
wire        stat_rx_fragment_0              ;
wire        stat_rx_vlan_0                  ;
wire        stat_rx_inrangeerr_0            ;
wire        stat_rx_jabber_0                ;
wire        stat_rx_bad_code_0              ;
wire        stat_rx_bad_sfd_0               ;
wire        stat_rx_bad_preamble_0          ;
/*----tx single----*/
wire        tx_reset_0                      ;
wire        user_tx_reset_0                 ;
wire        tx_unfout_0                     ;
wire [55:0] tx_preamblein_0                 ;
wire [55:0] rx_preambleout_0                ;
wire        ctl_tx_enable_0                 ;
wire        ctl_tx_send_rfi_0               ;
wire        ctl_tx_send_lfi_0               ;
wire        ctl_tx_send_idle_0              ;
wire        ctl_tx_fcs_ins_enable_0         ;
wire        ctl_tx_ignore_fcs_0             ;
wire        ctl_tx_test_pattern_0           ;
wire        ctl_tx_test_pattern_enable_0    ;
wire        ctl_tx_test_pattern_select_0    ;
wire        ctl_tx_data_pattern_select_0    ;
wire [57:0] ctl_tx_test_pattern_seed_a_0    ;
wire [57:0] ctl_tx_test_pattern_seed_b_0    ;
wire [3 :0] ctl_tx_ipg_value_0              ;
wire        ctl_tx_custom_preamble_enable_0 ;

wire        stat_tx_local_fault_0            ;
wire [3 :0] stat_tx_total_bytes_0            ;
wire        stat_tx_total_packets_0          ;
wire [13:0] stat_tx_total_good_bytes_0       ;
wire        stat_tx_total_good_packets_0     ;
wire        stat_tx_bad_fcs_0                ;
wire        stat_tx_packet_64_bytes_0        ;
wire        stat_tx_packet_65_127_bytes_0    ;
wire        stat_tx_packet_128_255_bytes_0   ;
wire        stat_tx_packet_256_511_bytes_0   ;
wire        stat_tx_packet_512_1023_bytes_0  ;
wire        stat_tx_packet_1024_1518_bytes_0 ;
wire        stat_tx_packet_1519_1522_bytes_0 ;
wire        stat_tx_packet_1523_1548_bytes_0 ;
wire        stat_tx_packet_1549_2047_bytes_0 ;
wire        stat_tx_packet_2048_4095_bytes_0 ;
wire        stat_tx_packet_4096_8191_bytes_0 ;
wire        stat_tx_packet_8192_9215_bytes_0 ;
wire        stat_tx_packet_small_0           ;
wire        stat_tx_packet_large_0           ;
wire        stat_tx_unicast_0                ;
wire        stat_tx_multicast_0              ;
wire        stat_tx_broadcast_0              ;
wire        stat_tx_vlan_0                   ;
wire        stat_tx_frame_error_0            ;

xxv_ethernet_0_sharedlogic_wrapper i_xxv_ethernet_0_sharedlogic_wrapper
(
    .gt_txusrclk2_0                     (o_tx_clk_out               ),
    .gt_rxusrclk2_0                     (o_rx_clk_out               ),
    .rx_core_clk_0                      (w_rx_core_clk              ),
    .gt_tx_reset_in_0                   (w_gt_reset_tx_done         ),
    .gt_rx_reset_in_0                   (w_gt_reset_rx_done         ),
    .tx_core_reset_in_0                 (0                          ),
    .rx_core_reset_in_0                 (0                          ),
    .tx_core_reset_out_0                (w_tx_core_reset            ),
    .rx_core_reset_out_0                (w_rx_core_reset            ),
    .rx_serdes_reset_out_0              (w_rx_serdes_reset          ),
    .usr_tx_reset_0                     (o_user_tx_reset            ),
    .usr_rx_reset_0                     (o_user_rx_reset            ),
    .gtwiz_reset_all_0                  (w_gtwiz_reset_all          ),
    .gtwiz_reset_tx_datapath_out_0      (w_gtwiz_reset_tx_datapath  ),
    .gtwiz_reset_rx_datapath_out_0      (w_gtwiz_reset_rx_datapath  ),
    .sys_reset                          (i_sys_reset                ),
    .dclk                               (i_dlk                      )
);

xxv_ethernet_0 xxv_ethernet_u0 (
    .gt_txp_out                         (o_gt_txp                           ),  // output wire [0 : 0] gt_txp_out
    .gt_txn_out                         (o_gt_txn                           ),  // output wire [0 : 0] gt_txn_out
    .gt_rxp_in                          (i_gt_rxp                           ),  // input wire [0 : 0] gt_rxp_in
    .gt_rxn_in                          (i_gt_rxn                           ),  // input wire [0 : 0] gt_rxn_in
    .rx_core_clk_0                      (w_rx_core_clk                      ),  // input wire rx_core_clk_0
    .rx_serdes_reset_0                  (w_rx_serdes_reset                  ),  // input wire rx_serdes_reset_0
    .txoutclksel_in_0                   (3'b101                             ),  // input wire [2 : 0] txoutclksel_in_0
    .rxoutclksel_in_0                   (3'b101                             ),  // input wire [2 : 0] rxoutclksel_in_0
    .rxrecclkout_0                      (w_rxrecclkout                      ),  // output wire rxrecclkout_0
    .sys_reset                          (i_sys_reset                        ),  // input wire sys_reset
    .dclk                               (i_dclk                             ),  // input wire dclk
    .tx_clk_out_0                       (o_tx_clk_out                       ),  // output wire tx_clk_out_0
    .rx_clk_out_0                       (o_rx_clk_out                       ),  // output wire rx_clk_out_0
    .gtpowergood_out_0                  (),                                     // output wire gtpowergood_out_0
    .qpll0clk_in                        (i_qpll0outclk                      ),  // input wire [0 : 0] qpll0clk_in
    .qpll0refclk_in                     (i_qpll0outrefclk                   ),  // input wire [0 : 0] qpll0refclk_in
    .qpll1clk_in                        (i_qpll1outclk                      ),  // input wire [0 : 0] qpll1clk_in
    .qpll1refclk_in                     (i_qpll1outrefclk                   ),  // input wire [0 : 0] qpll1refclk_in
    .gtwiz_reset_qpll0lock_in           (i_qpll0lock                        ),  // input wire gtwiz_reset_qpll0lock_in
    .gtwiz_reset_qpll0reset_out         (o_qpll0reset                       ),  // output wire gtwiz_reset_qpll0reset_out
    .gtwiz_reset_qpll1lock_in           (i_qpll1lock                        ),  // input wire gtwiz_reset_qpll1lock_in
    .gtwiz_reset_qpll1reset_out         (o_qpll1reset                       ),  // output wire gtwiz_reset_qpll1reset_out
    .gt_reset_tx_done_out_0             (w_gt_reset_tx_done                 ),  // output wire gt_reset_tx_done_out_0
    .gt_reset_rx_done_out_0             (w_gt_reset_rx_done                 ),  // output wire gt_reset_rx_done_out_0
    .gt_reset_all_in_0                  (w_gtwiz_reset_all                  ),  // input wire gt_reset_all_in_0
    .gt_tx_reset_in_0                   (w_gtwiz_reset_tx_datapath          ),  // input wire gt_tx_reset_in_0
    .gt_rx_reset_in_0                   (w_gtwiz_reset_rx_datapath          ),  // input wire gt_rx_reset_in_0
    .rx_reset_0                         (w_rx_core_reset                    ),  // input wire rx_reset_0
    .rx_axis_tvalid_0                   (rx_axis_tvalid                     ),  // output wire rx_axis_tvalid_0
    .rx_axis_tdata_0                    (rx_axis_tdata                      ),  // output wire [63 : 0] rx_axis_tdata_0
    .rx_axis_tlast_0                    (rx_axis_tlast                      ),  // output wire rx_axis_tlast_0
    .rx_axis_tkeep_0                    (rx_axis_tkeep                      ),  // output wire [7 : 0] rx_axis_tkeep_0
    .rx_axis_tuser_0                    (rx_axis_tuser                      ),  // output wire rx_axis_tuser_0
    .ctl_rx_enable_0                    (ctl_rx_enable_0                    ),  // input wire ctl_rx_enable_0
    .ctl_rx_check_preamble_0            (ctl_rx_check_preamble_0            ),  // input wire ctl_rx_check_preamble_0
    .ctl_rx_check_sfd_0                 (ctl_rx_check_sfd_0                 ),  // input wire ctl_rx_check_sfd_0
    .ctl_rx_force_resync_0              (ctl_rx_force_resync_0              ),  // input wire ctl_rx_force_resync_0
    .ctl_rx_delete_fcs_0                (ctl_rx_delete_fcs_0                ),  // input wire ctl_rx_delete_fcs_0
    .ctl_rx_ignore_fcs_0                (ctl_rx_ignore_fcs_0                ),  // input wire ctl_rx_ignore_fcs_0
    .ctl_rx_max_packet_len_0            (ctl_rx_max_packet_len_0            ),  // input wire [14 : 0] ctl_rx_max_packet_len_0
    .ctl_rx_min_packet_len_0            (ctl_rx_min_packet_len_0            ),  // input wire [7 : 0] ctl_rx_min_packet_len_0
    .ctl_rx_process_lfi_0               (ctl_rx_process_lfi_0               ),  // input wire ctl_rx_process_lfi_0
    .ctl_rx_test_pattern_0              (ctl_rx_test_pattern_0              ),  // input wire ctl_rx_test_pattern_0
    .ctl_rx_data_pattern_select_0       (ctl_rx_data_pattern_select_0       ),  // input wire ctl_rx_data_pattern_select_0
    .ctl_rx_test_pattern_enable_0       (ctl_rx_test_pattern_enable_0       ),  // input wire ctl_rx_test_pattern_enable_0
    .ctl_rx_custom_preamble_enable_0    (ctl_rx_custom_preamble_enable_0    ),  // input wire ctl_rx_custom_preamble_enable_0
    .stat_rx_framing_err_0              (stat_rx_framing_err_0              ),  // output wire stat_rx_framing_err_0
    .stat_rx_framing_err_valid_0        (stat_rx_framing_err_valid_0        ),  // output wire stat_rx_framing_err_valid_0
    .stat_rx_local_fault_0              (stat_rx_local_fault_0              ),  // output wire stat_rx_local_fault_0
    .stat_rx_block_lock_0               (stat_rx_block_lock_0               ),  // output wire stat_rx_block_lock_0
    .stat_rx_valid_ctrl_code_0          (stat_rx_valid_ctrl_code_0          ),  // output wire stat_rx_valid_ctrl_code_0
    .stat_rx_status_0                   (o_stat_rx_status                   ),  // output wire stat_rx_status_0
    .stat_rx_remote_fault_0             (stat_rx_remote_fault_0             ),  // output wire stat_rx_remote_fault_0
    .stat_rx_bad_fcs_0                  (stat_rx_bad_fcs_0                  ),  // output wire [1 : 0] stat_rx_bad_fcs_0_0
    .stat_rx_stomped_fcs_0              (stat_rx_stomped_fcs_0              ),  // output wire [1 : 0] stat_rx_stomped_fcs_0
    .stat_rx_truncated_0                (stat_rx_truncated_0                ),  // output wire stat_rx_truncated_0
    .stat_rx_internal_local_fault_0     (stat_rx_internal_local_fault_0     ),  // output wire stat_rx_internal_local_fault_0
    .stat_rx_received_local_fault_0     (stat_rx_received_local_fault_0     ),  // output wire stat_rx_received_local_fault_0
    .stat_rx_hi_ber_0                   (stat_rx_hi_ber_0                   ),  // output wire stat_rx_hi_ber_0
    .stat_rx_got_signal_os_0            (stat_rx_got_signal_os_0            ),  // output wire stat_rx_got_signal_os_0
    .stat_rx_test_pattern_mismatch_0    (stat_rx_test_pattern_mismatch_0    ),  // output wire stat_rx_test_pattern_mismatch_0
    .stat_rx_total_bytes_0              (stat_rx_total_bytes_0              ),  // output wire [3 : 0] stat_rx_total_bytes_0
    .stat_rx_total_packets_0            (stat_rx_total_packets_0            ),  // output wire [1 : 0] stat_rx_total_packets_0
    .stat_rx_total_good_bytes_0         (stat_rx_total_good_bytes_0         ),  // output wire [13 : 0] stat_rx_total_good_bytes_0
    .stat_rx_total_good_packets_0       (stat_rx_total_good_packets_0       ),  // output wire stat_rx_total_good_packets_0
    .stat_rx_packet_bad_fcs_0           (stat_rx_packet_bad_fcs_0           ),  // output wire stat_rx_packet_bad_fcs_0
    .stat_rx_packet_64_bytes_0          (stat_rx_packet_64_bytes_0          ),  // output wire stat_rx_packet_64_bytes_0
    .stat_rx_packet_65_127_bytes_0      (stat_rx_packet_65_127_bytes_0      ),  // output wire stat_rx_packet_65_127_bytes_0
    .stat_rx_packet_128_255_bytes_0     (stat_rx_packet_128_255_bytes_0     ),  // output wire stat_rx_packet_128_255_bytes_0
    .stat_rx_packet_256_511_bytes_0     (stat_rx_packet_256_511_bytes_0     ),  // output wire stat_rx_packet_256_511_bytes_0
    .stat_rx_packet_512_1023_bytes_0    (stat_rx_packet_512_1023_bytes_0    ),  // output wire stat_rx_packet_512_1023_bytes_0
    .stat_rx_packet_1024_1518_bytes_0   (stat_rx_packet_1024_1518_bytes_0   ),  // output wire stat_rx_packet_1024_1518_bytes_0
    .stat_rx_packet_1519_1522_bytes_0   (stat_rx_packet_1519_1522_bytes_0   ),  // output wire stat_rx_packet_1519_1522_bytes_0
    .stat_rx_packet_1523_1548_bytes_0   (stat_rx_packet_1523_1548_bytes_0   ),  // output wire stat_rx_packet_1523_1548_bytes_0
    .stat_rx_packet_1549_2047_bytes_0   (stat_rx_packet_1549_2047_bytes_0   ),  // output wire stat_rx_packet_1549_2047_bytes_0
    .stat_rx_packet_2048_4095_bytes_0   (stat_rx_packet_2048_4095_bytes_0   ),  // output wire stat_rx_packet_2048_4095_bytes_0
    .stat_rx_packet_4096_8191_bytes_0   (stat_rx_packet_4096_8191_bytes_0   ),  // output wire stat_rx_packet_4096_8191_bytes_0
    .stat_rx_packet_8192_9215_bytes_0   (stat_rx_packet_8192_9215_bytes_0   ),  // output wire stat_rx_packet_8192_9215_bytes_0
    .stat_rx_packet_small_0             (stat_rx_packet_small_0             ),  // output wire stat_rx_packet_small_0
    .stat_rx_packet_large_0             (stat_rx_packet_large_0             ),  // output wire stat_rx_packet_large_0
    .stat_rx_unicast_0                  (stat_rx_unicast_0                  ),  // output wire stat_rx_unicast_0
    .stat_rx_multicast_0                (stat_rx_multicast_0                ),  // output wire stat_rx_multicast_0
    .stat_rx_broadcast_0                (stat_rx_broadcast_0                ),  // output wire stat_rx_broadcast_0
    .stat_rx_oversize_0                 (stat_rx_oversize_0                 ),  // output wire stat_rx_oversize_0
    .stat_rx_toolong_0                  (stat_rx_toolong_0                  ),  // output wire stat_rx_toolong_0
    .stat_rx_undersize_0                (stat_rx_undersize_0                ),  // output wire stat_rx_undersize_0
    .stat_rx_fragment_0                 (stat_rx_fragment_0                 ),  // output wire stat_rx_fragment_0
    .stat_rx_vlan_0                     (stat_rx_vlan_0                     ),  // output wire stat_rx_vlan_0
    .stat_rx_inrangeerr_0               (stat_rx_inrangeerr_0               ),  // output wire stat_rx_inrangeerr_0
    .stat_rx_jabber_0                   (stat_rx_jabber_0                   ),  // output wire stat_rx_jabber_0
    .stat_rx_bad_code_0                 (stat_rx_bad_code_0                 ),  // output wire stat_rx_bad_code_0
    .stat_rx_bad_sfd_0                  (stat_rx_bad_sfd_0                  ),  // output wire stat_rx_bad_sfd_0
    .stat_rx_bad_preamble_0             (stat_rx_bad_preamble_0             ),  // output wire stat_rx_bad_preamble_0

    .tx_reset_0                         (w_tx_core_reset                    ),      // input wire tx_reset_0
    .tx_axis_tready_0                   (tx_axis_tready                     ),      // output wire tx_axis_tready_0
    .tx_axis_tvalid_0                   (tx_axis_tvalid                     ),      // input wire tx_axis_tvalid_0
    .tx_axis_tdata_0                    (tx_axis_tdata                      ),      // input wire [63 : 0] tx_axis_tdata_0
    .tx_axis_tlast_0                    (tx_axis_tlast                      ),      // input wire tx_axis_tlast_0
    .tx_axis_tkeep_0                    (tx_axis_tkeep                      ),      // input wire [7 : 0] tx_axis_tkeep_0
    .tx_axis_tuser_0                    (tx_axis_tuser                      ),      // input wire tx_axis_tuser_0
    .tx_unfout_0                        (tx_unfout_0                        ),      // output wire tx_unfout_0
    .tx_preamblein_0                    (tx_preamblein_0                    ),      // input wire [55 : 0] tx_preamblein_0
    .rx_preambleout_0                   (rx_preambleout_0                   ),      // output wire [55 : 0] rx_preambleout_0  

    .stat_tx_local_fault_0              (stat_tx_local_fault_0              ),      // output wire stat_tx_local_fault_0
    .stat_tx_total_bytes_0              (stat_tx_total_bytes_0              ),      // output wire [3 : 0] stat_tx_total_bytes_0_0
    .stat_tx_total_packets_0            (stat_tx_total_packets_0            ),      // output wire stat_tx_total_packets_0
    .stat_tx_total_good_bytes_0         (stat_tx_total_good_bytes_0         ),      // output wire [13 : 0] stat_tx_total_good_bytes_0
    .stat_tx_total_good_packets_0       (stat_tx_total_good_packets_0       ),      // output wire stat_tx_total_good_packets_0
    .stat_tx_bad_fcs_0                  (stat_tx_bad_fcs_0                  ),      // output wire stat_tx_bad_fcs_0
    .stat_tx_packet_64_bytes_0          (stat_tx_packet_64_bytes_0          ),      // output wire stat_tx_packet_64_bytes_0
    .stat_tx_packet_65_127_bytes_0      (stat_tx_packet_65_127_bytes_0      ),      // output wire stat_tx_packet_65_127_bytes_0
    .stat_tx_packet_128_255_bytes_0     (stat_tx_packet_128_255_bytes_0     ),      // output wire stat_tx_packet_128_255_bytes_0
    .stat_tx_packet_256_511_bytes_0     (stat_tx_packet_256_511_bytes_0     ),      // output wire stat_tx_packet_256_511_bytes_0
    .stat_tx_packet_512_1023_bytes_0    (stat_tx_packet_512_1023_bytes_0    ),      // output wire stat_tx_packet_512_1023_bytes_0
    .stat_tx_packet_1024_1518_bytes_0   (stat_tx_packet_1024_1518_bytes_0   ),      // output wire stat_tx_packet_1024_1518_bytes_0
    .stat_tx_packet_1519_1522_bytes_0   (stat_tx_packet_1519_1522_bytes_0   ),      // output wire stat_tx_packet_1519_1522_bytes_0
    .stat_tx_packet_1523_1548_bytes_0   (stat_tx_packet_1523_1548_bytes_0   ),      // output wire stat_tx_packet_1523_1548_bytes_0
    .stat_tx_packet_1549_2047_bytes_0   (stat_tx_packet_1549_2047_bytes_0   ),      // output wire stat_tx_packet_1549_2047_bytes_0
    .stat_tx_packet_2048_4095_bytes_0   (stat_tx_packet_2048_4095_bytes_0   ),      // output wire stat_tx_packet_2048_4095_bytes_0
    .stat_tx_packet_4096_8191_bytes_0   (stat_tx_packet_4096_8191_bytes_0   ),      // output wire stat_tx_packet_4096_8191_bytes_0
    .stat_tx_packet_8192_9215_bytes_0   (stat_tx_packet_8192_9215_bytes_0   ),      // output wire stat_tx_packet_8192_9215_bytes_0
    .stat_tx_packet_small_0             (stat_tx_packet_small_0             ),      // output wire stat_tx_packet_small_0
    .stat_tx_packet_large_0             (stat_tx_packet_large_0             ),      // output wire stat_tx_packet_large_0
    .stat_tx_unicast_0                  (stat_tx_unicast_0                  ),      // output wire stat_tx_unicast_0
    .stat_tx_multicast_0                (stat_tx_multicast_0                ),      // output wire stat_tx_multicast_0
    .stat_tx_broadcast_0                (stat_tx_broadcast_0                ),      // output wire stat_tx_broadcast_0
    .stat_tx_vlan_0                     (stat_tx_vlan_0                     ),      // output wire stat_tx_vlan_00
    .stat_tx_frame_error_0              (stat_tx_frame_error_0              ),      // output wire stat_tx_frame_error_0

    .ctl_tx_enable_0                    (ctl_tx_enable_0                    ),      // input wire ctl_tx_enable_0
    .ctl_tx_send_rfi_0                  (ctl_tx_send_rfi_0                  ),      // input wire ctl_tx_send_rfi_0
    .ctl_tx_send_lfi_0                  (ctl_tx_send_lfi_0                  ),      // input wire ctl_tx_send_lfi_0
    .ctl_tx_send_idle_0                 (ctl_tx_send_idle_0                 ),      // input wire ctl_tx_send_idle_0
    .ctl_tx_fcs_ins_enable_0            (ctl_tx_fcs_ins_enable_0            ),      // input wire ctl_tx_fcs_ins_enable_0
    .ctl_tx_ignore_fcs_0                (ctl_tx_ignore_fcs_0                ),      // input wire ctl_tx_ignore_fcs_0
    .ctl_tx_test_pattern_0              (ctl_tx_test_pattern_0              ),      // input wire ctl_tx_test_pattern_0
    .ctl_tx_test_pattern_enable_0       (ctl_tx_test_pattern_enable_0       ),      // input wire ctl_tx_test_pattern_enable_0
    .ctl_tx_test_pattern_select_0       (ctl_tx_test_pattern_select_0       ),      // input wire ctl_tx_test_pattern_select_0
    .ctl_tx_data_pattern_select_0       (ctl_tx_data_pattern_select_0       ),      // input wire ctl_tx_data_pattern_select_0
    .ctl_tx_test_pattern_seed_a_0       (ctl_tx_test_pattern_seed_a_0       ),      // input wire [57 : 0] ctl_tx_test_pattern_seed_a_0
    .ctl_tx_test_pattern_seed_b_0       (ctl_tx_test_pattern_seed_b_0       ),      // input wire [57 : 0] ctl_tx_test_pattern_seed_b_0
    .ctl_tx_ipg_value_0                 (ctl_tx_ipg_value_0                 ),      // input wire [3 : 0] ctl_tx_ipg_value_0
    .ctl_tx_custom_preamble_enable_0    (ctl_tx_custom_preamble_enable_0    ),      // input wire ctl_tx_custom_preamble_enable_0
    .gt_loopback_in_0                   (3'b000                   )      // input wire [2 : 0] gt_loopback_in_0
);

/*======================= sfp0 =========================*/
assign w_rx_core_clk = o_tx_clk_out;
/*----ctrl rx----*/ 
assign ctl_rx_enable_0                  = 1'b1          ;
assign ctl_rx_check_preamble_0          = 1'b1          ;
assign ctl_rx_check_sfd_0               = 1'b1          ;
assign ctl_rx_force_resync_0            = 1'b0          ;
assign ctl_rx_delete_fcs_0              = 1'b1          ;
assign ctl_rx_ignore_fcs_0              = 1'b0          ;
assign ctl_rx_max_packet_len_0          = P_MAX_LENGTH  ;
assign ctl_rx_min_packet_len_0          = P_MIN_LENGTH  ;
assign ctl_rx_process_lfi_0             = 1'b0          ;
assign ctl_rx_test_pattern_0            = 1'b0          ;
assign ctl_rx_test_pattern_enable_0     = 1'b0          ;
assign ctl_rx_data_pattern_select_0     = 1'b0          ;
assign ctl_rx_custom_preamble_enable_0  = 1'b0          ;
/*----tx single----*/
assign tx_preamblein_0                  = 55'h55_55_55_55_55_55_55;
assign tx_reset_0                       = 1'b0          ;
assign ctl_tx_enable_0                  = 1'b1          ;
assign ctl_tx_send_rfi_0                = 1'b0          ;
assign ctl_tx_send_lfi_0                = 1'b0          ;
assign ctl_tx_send_idle_0               = 1'b0          ;
assign ctl_tx_fcs_ins_enable_0          = 1'b1          ;
assign ctl_tx_ignore_fcs_0              = 1'b0          ;
assign ctl_tx_test_pattern_0            = 'd0           ;
assign ctl_tx_test_pattern_enable_0     = 'd0           ;
assign ctl_tx_test_pattern_select_0     = 'd0           ;
assign ctl_tx_data_pattern_select_0     = 'd0           ;
assign ctl_tx_test_pattern_seed_a_0     = 'd0           ;
assign ctl_tx_test_pattern_seed_b_0     = 'd0           ;
assign ctl_tx_ipg_value_0               = 4'd12         ;
assign ctl_tx_custom_preamble_enable_0  = 1'b0          ;


endmodule
