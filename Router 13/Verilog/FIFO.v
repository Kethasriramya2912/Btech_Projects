module FIFO(input clk,reset_n,soft_reset,read_enb,write_enb,lfd_state,
            input [7:0] data_in,
            output reg [7:0] data_out,
            output empty,full);

    reg [8:0] mem [0:15]; integer i;
    reg [5:0] payload_length;
    reg [4:0] wr_ptr,rd_ptr;
    reg temp_lfd;
    
    assign empty=((rd_ptr==wr_ptr)|| !reset_n)?1'b1:1'b0;
    assign full=(rd_ptr=={~wr_ptr[4],wr_ptr[3:0]})?1'b1:1'b0;
   
   always@(posedge clk)
	begin
	temp_lfd<=lfd_state;
	end
	
   always@(posedge clk)
        begin
            if(!reset_n)
                begin
					for(i=0;i<16;i=i+1)
                        mem[i]<=0;
                   data_out<=0;
                   wr_ptr<=0;
                   rd_ptr<=0;
				   payload_length<=0;
                end
            else if(soft_reset)                   //timeout condition???
                begin
					data_out<=8'bzzzzzzzz;
					 for(i=0;i<16;i=i+1)
                        mem[i]<=0;
				end
			
            else
				begin
					if(read_enb==1 && empty!=1)
						begin
						//payload_length<=(mem[rd_ptr][8]==1)?mem[rd_ptr][7:2]:payload_length-1;
							if(mem[rd_ptr][8]!=0)
								payload_length<=mem[rd_ptr][7:2]+1'b1;
							else if(payload_length!=0)
									payload_length<=payload_length-1;
							data_out<=mem[rd_ptr[3:0]];
							rd_ptr<=rd_ptr+1; 
							end
					if(payload_length==0 && empty==1)
						data_out<=8'bzzzzzzzz;
					
					if(write_enb==1 && full!=1 && data_in>=0)
						begin
							mem[wr_ptr[3:0]]<={temp_lfd,data_in};
							wr_ptr<=wr_ptr+1;  
						end
					
				end	
		end       
endmodule
