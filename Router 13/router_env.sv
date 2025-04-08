/**********************************
Filename:router_env.sv
Version:1.0
Author:Avi
**********************************/

class router_env extends uvm_env;
                                                                                                                                                                     router_env_config env_cfg_h;  
   router_scoreboard sb;
   router_virtual_sequencer v_sequencer;
   router_wr_agt_top wr_agt_top[];
   router_rd_agt_top rd_agt_top[];

   
   extern function new(string name="router_env",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
  // extern task run_phase(uvm_phase phase);  

   `uvm_component_utils(router_env)

endclass

  function router_env::new(string name="router_env",uvm_component parent);
      super.new(name,parent);
  endfunction

  function void router_env::build_phase(uvm_phase phase);
    if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",env_cfg_h))
        `uvm_fatal("Router_Env_Config","Not able to get router config object, have you set it?")
      if(env_cfg_h.has_wagent==1)
          begin
              wr_agt_top=new[env_cfg_h.no_of_wagents];
              foreach(wr_agt_top[i])
                  begin
                      uvm_config_db#(router_wr_agent_config)::set(this,$sformatf("wr_agt_top[%0d]*",i),"router_wr_agent_config",env_cfg_h.wr_agt_cfg_h[i]);
                      wr_agt_top[i]=router_wr_agt_top::type_id::create($sformatf("wr_agt_top[%0d]",i),this);
                  end
          end
      if(env_cfg_h.has_ragent==1)
          begin
              rd_agt_top=new[env_cfg_h.no_of_ragents];
              foreach(rd_agt_top[i])
                  begin
                      uvm_config_db#(router_rd_agent_config)::set(this,$sformatf("rd_agt_top[%0d]*",i),"router_rd_agent_config",env_cfg_h.rd_agt_cfg_h[i]); 
                     // `uvm_info("1212",$sformatf("rd_agt_top[%0d]",i),UVM_LOW)
                     // uvm_config_db#(int)::dump();
                      rd_agt_top[i]=router_rd_agt_top::type_id::create($sformatf("rd_agt_top[%0d]",i),this);
                  end
          end
     
      super.build_phase(phase);

      if(env_cfg_h.has_virtual_sequencer)
          v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);

      if(env_cfg_h.has_scoreboard)
          begin
              sb=router_scoreboard::type_id::create("sb",this);
          end      
  endfunction

  function void router_env::connect_phase(uvm_phase phase);
      if(env_cfg_h.has_virtual_sequencer)
          begin
              if(env_cfg_h.has_wagent)
                  begin
                      //`uvm_info("router_env","this is executed too",UVM_LOW)
                      foreach(wr_agt_top[i])
                          v_sequencer.wr_seqrh[i]=wr_agt_top[i].wr_agent.wr_seqrh;
                  end
              if(env_cfg_h.has_ragent)
                  begin
                      foreach(rd_agt_top[i])
                         v_sequencer.rd_seqrh[i]=rd_agt_top[i].rd_agent.rd_seqrh;
                  end  
          end
     
      if(env_cfg_h.has_scoreboard==1)
          begin
              foreach(wr_agt_top[i])
                  wr_agt_top[i].wr_agent.wr_mon.wm_port.connect(sb.fifo_wrh[i].analysis_export);
              foreach(rd_agt_top[i])
                  rd_agt_top[i].rd_agent.rd_mon.rm_port.connect(sb.fifo_rdh[i].analysis_export);
          end
  endfunction
