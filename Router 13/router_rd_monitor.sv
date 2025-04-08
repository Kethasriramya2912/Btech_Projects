/************************************
Filename:router_rd_monitor.sv
Version:1.0
Author:Avi
Doubts:
Comments:
        Write run_phase and data_from_dut
************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class router_rd_monitor extends uvm_monitor;

    `uvm_component_utils(router_rd_monitor)
    
      uvm_analysis_port#(read_xtn) rm_port;  
    
      router_rd_agent_config rd_agt_cfg;
      virtual router_if.RD_MON rd_if;
         
      int no_read_packets;     

      extern function new(string name="router_rd_monitor",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
      extern task run_phase(uvm_phase phase);
      extern task collect_data();
      extern function void report_phase(uvm_phase phase);
endclass

     function router_rd_monitor::new(string name="router_rd_monitor",uvm_component parent);
         super.new(name,parent);
     endfunction

     function void router_rd_monitor::build_phase(uvm_phase phase);
         if(!uvm_config_db#(router_rd_agent_config)::get(this,"","router_rd_agent_config",rd_agt_cfg))
              `uvm_fatal("router_rd_monitor","unable to get read config, have you set it?")
         rm_port=new("rm_port",this);
         super.build_phase(phase);
     endfunction

     function void router_rd_monitor::connect_phase(uvm_phase phase);
         rd_if=rd_agt_cfg.rd_if;
     endfunction

     task router_rd_monitor::run_phase(uvm_phase phase);
          forever
              begin
                   collect_data();
              end
     endtask

     task router_rd_monitor::collect_data();
         read_xtn xtn;
	begin
         xtn=read_xtn::type_id::create("xtn");
            @(rd_if.rd_cb_mon);
         wait(rd_if.rd_cb_mon.read_enb)
           @(rd_if.rd_cb_mon)
            xtn.header=rd_if.rd_cb_mon.data_out;
            xtn.payload=new[xtn.header[7:2]];
                foreach(xtn.payload[i])
                    begin
            @(rd_if.rd_cb_mon);
                        xtn.payload[i]=rd_if.rd_cb_mon.data_out;
      
                    end
         xtn.parity=rd_if.rd_cb_mon.data_out;
       //  xtn.print();
       //  `uvm_info("router_rd_monitor","value is",UVM_LOW)
         no_read_packets++;
         rm_port.write(xtn);
         xtn.print(uvm_default_table_printer);
      @(rd_if.rd_cb_mon);   
end
     endtask

     function void router_rd_monitor::report_phase(uvm_phase phase);
         `uvm_info("Number of packet received in read monitor:",$sformatf("%0d",no_read_packets),UVM_LOW)
     endfunction
