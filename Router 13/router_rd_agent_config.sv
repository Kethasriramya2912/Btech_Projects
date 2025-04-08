/********************************
Filename:router_rd_agent_config.sv
Version:1.0
Author:Avi
********************************/

class router_rd_agent_config extends uvm_object;
    
    virtual router_if rd_if;
    uvm_active_passive_enum is_active;
    static int rd_drv_cnt=0;
    static int rd_mon_cnt=0; 
   // static int count=0;  
    `uvm_object_utils(router_rd_agent_config)

    function new(string name="router_rd_agent_config");
        super.new(name);
     //   `uvm_info("router_rd_config",$sformatf("called count %0d",count),UVM_LOW)
     //   count++;
    endfunction

endclass
