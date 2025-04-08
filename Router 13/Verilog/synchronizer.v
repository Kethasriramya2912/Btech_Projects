//synchronizer rtl
module synchronizer(input clk,resetn,detect_add,write_enb_reg,
					input read_enb_0,read_enb_1,read_enb_2,
					input full_0,full_1,full_2,
					input empty_0,empty_1,empty_2,
					input [1:0] data_in,
					output soft_reset_0,soft_reset_1,soft_reset_2,
					output vld_out_0,vld_out_1,vld_out_2,
					output reg fifo_full,
					output reg [2:0] write_enb
					);
					
	reg [1:0] temp_reg;
	reg [4:0] reset_counter_0,reset_counter_1,reset_counter_2;
	assign vld_out_0=~empty_0;
	assign vld_out_1=~empty_1;
	assign vld_out_2=~empty_2;
	assign soft_reset_0=(reset_counter_0>=29)?1'b1:1'b0;
	assign soft_reset_1=(reset_counter_1>=29)?1'b1:1'b0;
	assign soft_reset_2=(reset_counter_2>=29)?1'b1:1'b0;
	always@(posedge clk)
		begin
			if(!resetn)
				temp_reg<=2'bzz;
			else
				if(detect_add)
					temp_reg<=data_in;
		end
	
	always@(*)
		begin
			case(temp_reg)
				2'b00:fifo_full=full_0;
				2'b01:fifo_full=full_1;
				2'b10:fifo_full=full_2;
				default:fifo_full=0;
			endcase
		if(write_enb_reg)
			begin
				case(temp_reg)
					2'b00:write_enb=3'b001;
					2'b01:write_enb=3'b010;
					2'b10:write_enb=3'b100;
				default:write_enb=3'b000;
				endcase
			end
		else
			write_enb=0;
		end
		
	always@(posedge clk)
		begin
			if (!resetn)
				begin
					reset_counter_0<=0; reset_counter_1<=0; reset_counter_2<=0;
				end
			else
				begin
					if(temp_reg==2'b00 && vld_out_0!=0 && read_enb_0==0)
						reset_counter_0<=reset_counter_0+1'b1;
					if(temp_reg==2'b01 && vld_out_1!=0 && read_enb_1==0)
						reset_counter_1<=reset_counter_1+1'b1;
					if(temp_reg==2'b10 && vld_out_2!=0 && read_enb_2==0)
						reset_counter_2<=reset_counter_2+1'b1;
					if(reset_counter_0>=29 || detect_add)
							reset_counter_0<=0;
					if(reset_counter_1>=29 || detect_add)
							reset_counter_1<=0;
					if(reset_counter_2>=29 || detect_add)
							reset_counter_2<=0;
				end
		end
			
endmodule

