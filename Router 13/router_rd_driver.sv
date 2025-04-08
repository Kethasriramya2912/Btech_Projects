/**************************************
Filename:router_rd_driver.sv
Version:1.0
Author:Avi
Doubts:
Comments:
       Read_xtn in router_rd_driver class def.
       Write run_phase and data2dut.
       repeat(xtn.cycle)
**************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class router_rd_driver extends uvm_driver#(read_xtn);
 
    `uvm_component_utils(router_rd_driver)
 
     router_rd_agent_config rd_agt_cfg;
     virtual router_if.RD_DRV rd_if;
 
     extern function new(string name="router_rd_driver",uvm_component parent);
     extern function void build_phase(uvm_phase phase);
     extern function void connect_phase(uvm_phase phase);
     extern task run_phase(uvm_phase phase);
     extern task send2dut(read_xtn xtn);
endclass

    function router_rd_driver::new(string name="router_rd_driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void router_rd_driver::build_phase(uvm_phase phase);
        if(!uvm_config_db#(router_rd_agent_config)::get(this,"","router_rd_agent_config",rd_agt_cfg))
            `uvm_fatal("router_rd_driver","unable to get read agent config, have you set it?")
    endfunction

    function void router_rd_driver::connect_phase(uvm_phase phase);
        rd_if=rd_agt_cfg.rd_if;
    endfunction

    task router_rd_driver::run_phase(uvm_phase phase);
        forever
            begin
                seq_item_port.get_next_item(req);
                send2dut(req);
                seq_item_port.item_done();
            end
    endtask
 
    task router_rd_driver::send2dut(read_xtn xtn);
         wait(rd_if.rd_cb_drv.valid_out)
             repeat(xtn.cycle)
                 @(rd_if.rd_cb_drv);
                 rd_if.rd_cb_drv.read_enb<=1;
         wait(!rd_if.rd_cb_drv.valid_out)
                 rd_if.rd_cb_drv.read_enb<=0;
    endtask
        
