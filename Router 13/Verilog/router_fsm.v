module router_fsm(input clk,resetn,pkt_valid,
					input [1:0] data_in,
					input fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
					input soft_reset_0,soft_reset_1,soft_reset_2,
					input parity_done,low_pkt_valid,
					output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,
					output full_state,rst_int_reg,busy
					);
		
	parameter DECODE_ADDRESS=8'b00000001,                      //1
				LOAD_FIRST_DATA=8'b00000010,                   //2
				WAIT_TILL_EMPTY=8'b00000100,                   //4
				LOAD_DATA=8'b00001000,                         //8
				LOAD_PARITY=8'b00010000,                       //16
				CHECK_PARITY_ERROR=8'b00100000,                //32
				FIFO_FULL_STATE=8'b01000000,                   //64
				LOAD_AFTER_FULL=8'b10000000;                   //128
				
	reg [7:0] PS,NS;
	wire [2:0]pde,pdne,lfa;
				
	always@(posedge clk)
		begin
			if(!resetn)
				PS<=DECODE_ADDRESS;
			else
				PS<=NS;
		end
			
		assign pde[0]=(pkt_valid==1 && data_in==2'b00 && fifo_empty_0==1);
		assign pde[1]=(pkt_valid==1 && data_in==2'b01 && fifo_empty_1==1);
		assign pde[2]=(pkt_valid==1 && data_in==2'b10 && fifo_empty_2==1);
		assign pdne[0]=(pkt_valid==1 && data_in==2'b00 && fifo_empty_0==0);
		assign pdne[1]=(pkt_valid==1 && data_in==2'b01 && fifo_empty_1==0);
		assign pdne[2]=(pkt_valid==1 && data_in==2'b10 && fifo_empty_2==0);
		assign lfa[0]=(fifo_empty_0==1 && data_in==0);
		assign lfa[1]=(fifo_empty_1==1 && data_in==1);
		assign lfa[2]=(fifo_empty_2==1 && data_in==2);
		assign soft_reset=soft_reset_0|soft_reset_1|soft_reset_2;
		
	always@(*)
		begin
			case(PS)
				DECODE_ADDRESS:NS=pkt_valid?pde?LOAD_FIRST_DATA:pdne?WAIT_TILL_EMPTY:DECODE_ADDRESS:DECODE_ADDRESS;
				LOAD_FIRST_DATA:NS=LOAD_DATA;
				WAIT_TILL_EMPTY:NS=lfa?LOAD_FIRST_DATA:WAIT_TILL_EMPTY;
				LOAD_DATA:begin
							if(fifo_full)
								NS=FIFO_FULL_STATE;
							else if(!fifo_full && !pkt_valid)
								NS=LOAD_PARITY;
							else 
								NS=LOAD_DATA;
						  end
				FIFO_FULL_STATE:NS=fifo_full?FIFO_FULL_STATE:LOAD_AFTER_FULL;
				LOAD_AFTER_FULL:NS=parity_done?DECODE_ADDRESS:low_pkt_valid?LOAD_PARITY:LOAD_DATA;
				LOAD_PARITY:NS=CHECK_PARITY_ERROR;
				CHECK_PARITY_ERROR:NS=fifo_full?FIFO_FULL_STATE:DECODE_ADDRESS;
				default:NS=DECODE_ADDRESS;
			endcase
		end

		
	assign detect_add=(PS==DECODE_ADDRESS)?1'b1:1'b0;
	assign lfd_state=(PS==LOAD_FIRST_DATA)?1'b1:1'b0;
	assign ld_state=(PS==LOAD_DATA)?1'b1:1'b0;
	assign full_state=(PS==FIFO_FULL_STATE)?1'b1:1'b0;
	assign laf_state=(PS==LOAD_AFTER_FULL)?1'b1:1'b0;
	assign rst_int_reg=(PS==CHECK_PARITY_ERROR)?1'b1:1'b0;
	assign write_enb_reg=(PS==LOAD_DATA || PS==LOAD_PARITY || PS==LOAD_AFTER_FULL)?1'b1:1'b0;
	assign busy=(PS==LOAD_FIRST_DATA || PS==LOAD_PARITY || PS==FIFO_FULL_STATE || PS==LOAD_AFTER_FULL || PS==WAIT_TILL_EMPTY || PS==CHECK_PARITY_ERROR)?1'b1:1'b0;
					
endmodule
