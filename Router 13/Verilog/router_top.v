module router_top(input clk,resetn,
					input read_enb_0,read_enb_1, read_enb_2,
					input pkt_valid,
					input [7:0] data_in,
					output wire [7:0] data_out_0, data_out_1,data_out_2,
					output wire valid_out_0,valid_out_1,valid_out_2,
					output wire error,busy);

	wire soft_reset_0,soft_reset_1,soft_reset_2;
	wire empty_0,empty_1,empty_2;
	wire full_0,full_1,full_2,fifo_full;
	wire [2:0] write_enb;
	wire write_enb_reg,rst_int_reg;
	wire detect_add,lfd_state,ld_state,full_state,laf_state;
	wire low_pkt_valid,parity_done;
	wire [7:0] dout;
	
	FIFO FIFO_0(clk,resetn,soft_reset_0,read_enb_0,write_enb[0],lfd_state,
            dout,
            data_out_0,
            empty_0,full_0);
	
	FIFO FIFO_1(clk,resetn,soft_reset_1,read_enb_1,write_enb[1],lfd_state,
            dout,
            data_out_1,
            empty_1,full_1);
			
	FIFO FIFO_2(clk,resetn,soft_reset_2,read_enb_2,write_enb[2],lfd_state,
            dout,
            data_out_2,
            empty_2,full_2);
			
	synchronizer Synch(clk,resetn,detect_add,write_enb_reg,
					 read_enb_0,read_enb_1,read_enb_2,
					 full_0,full_1,full_2,
					 empty_0,empty_1,empty_2,
					 data_in[1:0],
					 soft_reset_0,soft_reset_1,soft_reset_2,
					 valid_out_0,valid_out_1,valid_out_2,
					 fifo_full,
					 write_enb);
									
					
	router_fsm	FSM(clk,resetn,pkt_valid,
					data_in[1:0],
					fifo_full,empty_0,empty_1,empty_2,
					soft_reset_0,soft_reset_1,soft_reset_2,
					parity_done,low_pkt_valid,
					write_enb_reg,detect_add,ld_state,laf_state,lfd_state,
					full_state,rst_int_reg,busy);
					
	
	router_register Register(clk,resetn,pkt_valid,
						data_in,
						fifo_full,rst_int_reg, detect_add,
						ld_state,laf_state,full_state,lfd_state,
						parity_done,low_pkt_valid,error,
						dout);
endmodule


