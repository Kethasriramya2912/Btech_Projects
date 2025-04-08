/*************************************
Filename:router_wr_sequencer.sv
Version:1.0
Author:Avi

Doubts:
 
Comments:
       Define write_xtn in class router_wr_sequencer
*************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class router_wr_sequencer extends uvm_sequencer #(write_xtn);
   
    `uvm_component_utils(router_wr_sequencer)
     
     extern function new(string name="router_wr_sequencer",uvm_component parent);

endclass

    function router_wr_sequencer::new(string name="router_wr_sequencer",uvm_component parent);
        super.new(name,parent); 
       // `uvm_info("router_wr_sequencer","created",UVM_LOW)
    endfunction
