/*****************************************
Filename:top.sv
Description:top module
Version:1.0
Author:Avi
*****************************************/



module top;


 import router_test_pkg::*;

 import uvm_pkg::*;
//Don't forget to include the package file later


//Generating Clock
    bit clk;
    always #10 clk=~clk;

//Instantiating interfaces
    router_if wr_if0(clk);
    router_if rd_if0(clk),rd_if1(clk),rd_if2(clk);

//Instantiating Router top
    router_top DUV(.clk(clk),.resetn(wr_if0.resetn),
                   .read_enb_0(rd_if0.read_enb),.read_enb_1(rd_if1.read_enb),.read_enb_2(rd_if2.read_enb),
                   .pkt_valid(wr_if0.pkt_valid),.data_in(wr_if0.data_in),
                   .data_out_0(rd_if0.data_out),.data_out_1(rd_if1.data_out),.data_out_2(rd_if2.data_out),
                   .valid_out_0(rd_if0.valid_out),.valid_out_1(rd_if1.valid_out),.valid_out_2(rd_if2.valid_out),
                   .error(wr_if0.error),.busy(wr_if0.busy));

   initial
       begin
//Setting virtual interfaces which will point to static interface.
           uvm_config_db #(virtual router_if)::set(null,"*","wr_if0",wr_if0);
           uvm_config_db #(virtual router_if)::set(null,"*","rd_if0",rd_if0);
           uvm_config_db #(virtual router_if)::set(null,"*","rd_if1",rd_if1);
           uvm_config_db #(virtual router_if)::set(null,"*","rd_if2",rd_if2);

           run_test();
       end
endmodule
