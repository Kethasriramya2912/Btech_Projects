/************************************
Filename:router_wr_agent_config.sv
Version:1.0
Author:Avi
************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class router_wr_agent_config extends uvm_object;

    virtual router_if wr_if;
    uvm_active_passive_enum is_active;
    static int wr_drv_cnt=0;
    static int wr_mon_cnt=0;
    
    
    `uvm_object_utils(router_wr_agent_config)

   function new(string name="router_wr_agent_config");
       super.new(name);
   endfunction

endclass
