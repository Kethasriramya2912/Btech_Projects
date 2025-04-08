/********************************
Filename:router_virtual_sequencer.sv
Version:1.0
Author:Avi
********************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    
     router_wr_sequencer wr_seqrh[];
     router_rd_sequencer rd_seqrh[];
    
     router_env_config env_cfg_h;    
    
     `uvm_component_utils(router_virtual_sequencer)
    
     function new(string name="router_virtual_sequencer",uvm_component parent);
         super.new(name,parent);
        // `uvm_info("www","virtual sequencer",UVM_LOW)
     endfunction

     function void build_phase(uvm_phase phase);
          if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",env_cfg_h))
              `uvm_fatal("router_virtual_sequencer","unable to get router_env_config, have you set it?")
          super.build_phase(phase);
          wr_seqrh=new[env_cfg_h.no_of_wagents];
          rd_seqrh=new[env_cfg_h.no_of_ragents];
     endfunction
endclass

