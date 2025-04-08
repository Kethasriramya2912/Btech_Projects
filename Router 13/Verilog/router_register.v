module router_register(input clk,resetn,pkt_valid,
						input [7:0] data_in,
						input fifo_full,rst_int_reg, detect_add,
						input ld_state,laf_state,full_state,lfd_state,
						output reg parity_done,low_pkt_valid,err,
						output reg [7:0] dout);
						
		reg [7:0] header_reg,fifo_full_reg,internal_parity_reg,packet_parity_reg;
		
		
		//header_reg calculation
		always@(posedge clk)
			begin
			if(!resetn)
				header_reg<=0;
			else
				if(detect_add && pkt_valid)
					header_reg<=data_in;
			end
		
		//fifo_full_reg calculation
		always@(posedge clk)
			begin
			if(!resetn)
					fifo_full_reg<=0;
			else 
				if(ld_state && fifo_full)
					fifo_full_reg<=data_in;
		   	end
		
		//packet_parity calculation
		always@(posedge clk)
			begin
			if(!resetn)
				packet_parity_reg<=0;
			else
				if((ld_state && !fifo_full && !pkt_valid) || (laf_state && !pkt_valid && !parity_done))
					packet_parity_reg<=data_in;
				//else if(!pkt_valid && full_state)
				//	packet_parity_reg<=fifo_full_reg;
			end
			
		//internal parity calculation
		always@(posedge clk)
			begin
				if(!resetn)
					internal_parity_reg<=0;
				else if(detect_add)
					internal_parity_reg<=0;
				else if(lfd_state)
					internal_parity_reg<=internal_parity_reg^header_reg;
				else if(ld_state && pkt_valid && !full_state || (laf_state && pkt_valid))
					internal_parity_reg<=internal_parity_reg^data_in;
				else
					internal_parity_reg<=internal_parity_reg;
			end
			
			//dout calculation
			always@(posedge clk)
				begin
					if(!resetn)
						dout<=0;
					else if(rst_int_reg)
						dout<=8'bzzzzzzzz;
					else
						begin
							if(laf_state && (pkt_valid || low_pkt_valid))
									dout<=fifo_full_reg;
							if(lfd_state)
									dout<=header_reg;
									//dout<=data_in;
							if(ld_state && !fifo_full )
									dout<=data_in;
						end
				end
			
			//low_pkt_valid calculation
			always@(posedge clk)
				begin
					if(!resetn)
						begin
						low_pkt_valid<=0;
						end
					else
						begin
							if(rst_int_reg)
								low_pkt_valid<=0;
							else if(ld_state && !pkt_valid)
									low_pkt_valid<=1;
						end
				end
			
		
			//parity done
			always@(posedge clk)
				begin
				if(!resetn)
					parity_done<=0;
				else
					if((ld_state && !pkt_valid && !fifo_full) || (laf_state && low_pkt_valid && !parity_done))
						parity_done<=1;
					else if(detect_add)
						parity_done<=0;
				end
				
			//error calculation		
			always@(posedge clk)
			begin
			if(!resetn)
					err<=0;
			else
				if(parity_done && !full_state)
					begin
						if(packet_parity_reg!=internal_parity_reg)
							err<=1;
						else
							err<=0;
					end
			end
endmodule

