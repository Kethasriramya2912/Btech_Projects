/***********************************
Filename:router_test_pkg.sv
Version:1.0
Author:Avi
***********************************/

package router_test_pkg;
    import uvm_pkg::*;

    `include "uvm_macros.svh"
    `include "write_xtn.sv"
    `include "router_wr_agent_config.sv"
    `include "router_rd_agent_config.sv"
    `include "router_env_config.sv"
    `include "router_wr_driver.sv"
    `include "router_wr_monitor.sv"
    `include "router_wr_sequencer.sv"
    `include "router_wr_agent.sv"
    `include "router_wr_agt_top.sv"
    `include "router_wr_sequence.sv"

    `include "read_xtn.sv"
    `include "router_rd_driver.sv"
    `include "router_rd_monitor.sv"
    `include "router_rd_sequencer.sv"
    `include "router_rd_agent.sv"
    `include "router_rd_agt_top.sv"
    `include "router_rd_sequence.sv"
    
    //`include "router_env_config.sv"
    `include "router_virtual_sequencer.sv"
    `include "router_virtual_sequences.sv"
    `include "router_scoreboard.sv" 
    `include "router_env.sv"

    `include "router_testcases.sv"
   
endpackage
