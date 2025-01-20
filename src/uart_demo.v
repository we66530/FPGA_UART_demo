`timescale 1ns / 1ps
module uart_demo(
    input clk,
    input rst_n,
    
    input en_sw15,
    output en_sig_ld15,
    
    input get_btn_d,
    input rx_pin_jb1,
    output rx_buf_not_empty,
    output rx_buf_full,
    
    input send_btn_r,
    input [3:0]tx_send_data,  //輸出SW0~Sw3給pc端
    output tx_pin_jb0,
    output tx_buf_not_full,
    
    output [3:0]an,
    output [7:0]seg_code
	output [7:0]seg_data_1
	output [7:0]seg_data_0
    );
    wire rst,rx_pin_in,read_sig,write_sig;
    wire rst_btn_c = ~rst_n;
	
	wire clkout_1kHZ;
	
	//除彈跳模組
    input_signal_processing sig_processing(
        .clk( clk ),
        .rst_btn_c( rst_btn_c ),
        .rst( rst ),
        
        .rx_pin_jb1( rx_pin_jb1 ),
        .rx_pin_in( rx_pin_in ),
        
        .get_btn_d( get_btn_d ),
        .read_sig( read_sig ),
        
        .send_btn_r( send_btn_r ),
        .write_sig( write_sig ),
        
        .en_sw15( en_sw15 ),
        .en_sig_ld15( en_sig_ld15 )       
    );
    //
    wire [7:0]rx_get_data;
    uart_top uart_top(
        .clk( clk ),
        .rst( rst ),
        
        .en( en_sig_ld15 ),
        
        .rx_read( read_sig ),
        .rx_pin_in( rx_pin_in ),
        .rx_get_data( rx_get_data ),
        .rx_buf_not_empty( rx_buf_not_empty ),
        .rx_buf_full( rx_buf_full ),
        
        .tx_write( write_sig ),
        .tx_pin_out( tx_pin_jb0 ),
        .tx_send_data( tx_assic ),
        .tx_buf_not_full( tx_buf_not_full )
    );
    
	wire [3:0] rx_dec, 
	wire [7:0] tx_assic;
	wire [15:0] SegData;
	assign SegData = {4'b0000, tx_send_data, 4'b0000, rx_dec};
	
	dec2assic dec2assic_i (tx_send_data, tx_assic); //transfer to assic for PC
	assic2dec assic2dec_i (rx_get_data, rx_dec); //trabsfer to dec for Seg7
	
	Divider_Clock u_Divider_Clock(
		.clkin(clk),
		.rst_n(rst_n),
		.clkout_1K(clkout_1kHZ)
	);
	
	Seg_Display u_Seg_Display(
		.Scan_clk(clkout_1kHZ),
		.clk(clkout_1kHZ),
		.rts(rst_n),
		.Data(SegData),
		.Seg7_show(seg_cs),  
		.seg_data_0(seg_data_0),
		.seg_data_1(seg_data_1)
	);
	
endmodule
