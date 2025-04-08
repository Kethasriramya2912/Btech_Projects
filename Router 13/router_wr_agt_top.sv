/*******************************************
Filename:router_wr_agt_top.sv
Version:1.0
Author:Avi
*******************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class router_wr_agt_top extends uvm_env;

    `uvm_component_utils(router_wr_agt_top)
    
    router_wr_agent wr_agent;    

    extern function new(string name="router_wr_agt_top",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task  run_phase(uvm_phase phase);
endclass

    function router_wr_agt_top::new(string name="router_wr_agt_top",uvm_component parent);
          super.new(name,parent);
    endfunction
 
    function void router_wr_agt_top::build_phase(uvm_phase phase);
         wr_agent=router_wr_agent::type_id::create("wr_agent",this);
         super.build_phase(phase);
    endfunction

    task router_wr_agt_top::run_phase(uvm_phase phase);
        // uvm_top.print_topology();
    endtask
