/*************************************
Filename:router_rd_sequence.sv
Version:1.0
Author:Avi
*************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class base_rd_sequence extends uvm_sequence #(read_xtn);
    
    `uvm_object_utils(base_rd_sequence)
   
     extern function new(string name="base_rd_sequence"); 
endclass
    
    function base_rd_sequence::new(string name="base_rd_sequence");
        super.new(name);
    endfunction


class rd_cycle_30 extends base_rd_sequence;
    `uvm_object_utils(rd_cycle_30)
   
    extern function new(string name="rd_cycle_30");
    extern task body();
endclass

    function rd_cycle_30::new(string name="rd_cycle_30");
        super.new(name);
    endfunction

    task rd_cycle_30::body();
   //  repeat(3)
          begin
         req=read_xtn::type_id::create("req");
         start_item(req);
         assert(req.randomize() with {cycle==29;});
         finish_item(req);
          end
    endtask

    
class rd_sequence0 extends base_rd_sequence;
    `uvm_object_utils(rd_sequence0)
   
    extern function new(string name="rd_sequence0");
    extern task body();
endclass

    function rd_sequence0::new(string name="rd_sequence0");
        super.new(name);
    endfunction

    task rd_sequence0::body();
     repeat(10)
          begin
         req=read_xtn::type_id::create("req");
         start_item(req);
         assert(req.randomize() with {cycle==1;});
         finish_item(req);
          end
    endtask
