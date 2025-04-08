/***********************************
Filename:router_wr_agent.sv
Version:1.0
Author:Avi
***********************************/
`include "uvm_macros.svh"
import uvm_pkg::*;


class router_wr_agent extends uvm_agent;

     `uvm_component_utils(router_wr_agent)
      
      router_wr_agent_config wr_agt_cfg_h; 
    
      router_wr_driver wr_drv;
      router_wr_monitor wr_mon;
      router_wr_sequencer wr_seqrh;

      extern function new(string name="router_wr_agent",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
endclass


    function router_wr_agent::new(string name="router_wr_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void router_wr_agent::build_phase(uvm_phase phase);
        if(!uvm_config_db#(router_wr_agent_config)::get(this,"","router_wr_agent_config",wr_agt_cfg_h))
            `uvm_fatal("router_wr_agent","unable to get write agent config, have you set it?")
        wr_mon=router_wr_monitor::type_id::create("wr_mon",this);
        if(wr_agt_cfg_h.is_active==UVM_ACTIVE)
            begin
                wr_seqrh=router_wr_sequencer::type_id::create("wr_seqrh",this);
                wr_drv=router_wr_driver::type_id::create("wr_drv",this);
            end
    endfunction

    function void router_wr_agent::connect_phase(uvm_phase phase);
       if(wr_agt_cfg_h.is_active==UVM_ACTIVE)
           wr_drv.seq_item_port.connect(wr_seqrh.seq_item_export);
    endfunction
