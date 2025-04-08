/***************************************
Filename:router_rd_agent.sv
Version:1.0
Author:Avi
Doubts:
Comments:
      Write connect phase
***************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class router_rd_agent extends uvm_agent;

    `uvm_component_utils(router_rd_agent)

     router_rd_agent_config rd_agt_cfg_h;
     
     router_rd_driver rd_drv;
     router_rd_monitor rd_mon;
     router_rd_sequencer rd_seqrh;

     extern function new(string name="router_rd_agent",uvm_component parent);
     extern function void build_phase(uvm_phase phase);
     extern function void connect_phase(uvm_phase phase);
endclass

    function router_rd_agent::new(string name="router_rd_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void router_rd_agent::build_phase(uvm_phase phase);
       // uvm_config_db#(int)::dump();
        if(!uvm_config_db#(router_rd_agent_config)::get(this,"","router_rd_agent_config",rd_agt_cfg_h))
           `uvm_fatal("router_rd_agent","unable to get read config object, have you set it?")
       
        rd_mon=router_rd_monitor::type_id::create("rd_mon",this);
        if(rd_agt_cfg_h.is_active==UVM_ACTIVE)
            begin
                rd_drv=router_rd_driver::type_id::create("rd_drv",this);
                rd_seqrh=router_rd_sequencer::type_id::create("rd_seqrh",this);
            end
    endfunction

    function void router_rd_agent::connect_phase(uvm_phase phase);
        if(rd_agt_cfg_h.is_active==UVM_ACTIVE)
            rd_drv.seq_item_port.connect(rd_seqrh.seq_item_export);
    endfunction
