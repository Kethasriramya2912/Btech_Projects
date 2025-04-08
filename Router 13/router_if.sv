/*******************************************************
Filename:router_if.sv
Description:Router Interface
Version:1.0
Author:Avi
*******************************************************/

`define DATA_WIDTH 8

interface router_if(input bit clk);
    
    logic resetn;
    logic read_enb;
    logic pkt_valid;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic valid_out;
    logic error, busy;

//Write Driver Clocking Block
    clocking wr_cb_drv@(posedge clk);
        default input #1 output #1;
        input busy,error;
        output data_in,pkt_valid,resetn;   
    endclocking 

//Write Monitor Clocking Block:w
    clocking wr_cb_mon@(posedge clk);
       default input #1 output #1;
       input resetn,data_in,pkt_valid,error,busy;
    endclocking

//Read Driver Clocking Block
   clocking rd_cb_drv@(posedge clk);
     default input #1 output #1;
     output read_enb;
     input valid_out;
   endclocking

//Read Monitor Clocking Block
   clocking rd_cb_mon@(posedge clk);
     default input #1 output #1;
     input read_enb,valid_out,data_out;
   endclocking

//MODPORT Declarations
   modport WR_DRV(clocking wr_cb_drv);
   modport WR_MON(clocking wr_cb_mon);
   modport RD_DRV(clocking rd_cb_drv);
   modport RD_MON(clocking rd_cb_mon);

endinterface


