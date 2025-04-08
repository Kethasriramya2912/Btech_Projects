/************************************
Filename:router_wr_driver.sv
Version:1.0
Author:Avi

Doubts:
       

Comments:
       Define write packet in parameter in class_router_wr_driver
       Write run_phase and send2dut
************************************/

class router_wr_driver extends uvm_driver#(write_xtn);
    
    `uvm_component_utils(router_wr_driver)
   
     virtual router_if.WR_DRV wr_if;
     router_wr_agent_config wr_agt_cfg_h;

     int write_xtns_count; 
  
     extern function new(string name="router_wr_driver",uvm_component parent);
     extern function void build_phase(uvm_phase phase);
     extern function void connect_phase(uvm_phase phase);
     extern task run_phase(uvm_phase phase);
     extern task send2dut(write_xtn xtn);
     extern function void report_phase(uvm_phase phase);
endclass

    function router_wr_driver::new(string name="router_wr_driver",uvm_component parent);
         super.new(name,parent);
    endfunction
 
   function void router_wr_driver::build_phase(uvm_phase phase);
       if(!uvm_config_db#(router_wr_agent_config)::get(this,"","router_wr_agent_config",wr_agt_cfg_h))
           `uvm_fatal("router_wr_driver","unable to get write agent config, have you set it?")
   endfunction

   function void router_wr_driver::connect_phase(uvm_phase phase);
       wr_if=wr_agt_cfg_h.wr_if; 
   endfunction
   
   task router_wr_driver::run_phase(uvm_phase phase);
       @(wr_if.wr_cb_drv);
          wr_if.wr_cb_drv.resetn<=0;
       @(wr_if.wr_cb_drv);
          wr_if.wr_cb_drv.resetn<=1;
       forever
           begin
               seq_item_port.get_next_item(req); 
             //  req.print(uvm_default_table_printer);
             // `uvm_fatal("yeah","i am here")
               send2dut(req);
               seq_item_port.item_done();
           end
   endtask

   task router_wr_driver::send2dut(write_xtn xtn);
       write_xtns_count++;
       @(wr_if.wr_cb_drv);
           wait(!wr_if.wr_cb_drv.busy)
           wr_if.wr_cb_drv.pkt_valid<=1;
           wr_if.wr_cb_drv.data_in<=xtn.header;
           @(wr_if.wr_cb_drv);
           foreach(xtn.payload[i])
               begin
                   wait(!wr_if.wr_cb_drv.busy)
                       wr_if.wr_cb_drv.data_in<=xtn.payload[i];
                 @(wr_if.wr_cb_drv);
               end
           wait(!wr_if.wr_cb_drv.busy)
               wr_if.wr_cb_drv.pkt_valid<=0;
               wr_if.wr_cb_drv.data_in<=xtn.parity;
           repeat(2)
               @(wr_if.wr_cb_drv);
        xtn.err=wr_if.wr_cb_drv.error;
        wr_agt_cfg_h.wr_drv_cnt++;
   endtask
  
   function void router_wr_driver::report_phase(uvm_phase phase);
       `uvm_info("No of write xtns sent by driver",$sformatf("%0d",write_xtns_count),UVM_LOW)
   endfunction
