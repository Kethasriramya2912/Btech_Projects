/*************************************
Filename:router_virtual_sequences.sv
Version:1.0
Author:Avi
**************************************/


class base_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(base_virtual_sequence)

     function new(string name="base_virtual_sequence");
          super.new(name);
     endfunction

     router_env_config env_cfg_h;
     router_virtual_sequencer v_sequencer;
     
     router_wr_sequencer wr_seqrh[];
     router_rd_sequencer rd_seqrh[];
   
   //  wr_sequence0 wr_seq0;
     extern task body();

endclass

    task base_virtual_sequence::body();
        if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",env_cfg_h))
             `uvm_fatal("base_virtual_sequence","unable to get router_env_config, have you set it?")
       
        assert($cast(v_sequencer,m_sequencer))
            else
             `uvm_error("base_virtual_sequence","datatypes of sequencers are different")
        wr_seqrh=new[env_cfg_h.no_of_wagents];
        rd_seqrh=new[env_cfg_h.no_of_ragents];
     
      //  `uvm_info("virtual_sequence",$sformatf("no_of_agents %0d",env_cfg_h.no_of_wagents),UVM_LOW)        
        foreach(wr_seqrh[i])
           wr_seqrh[i]=v_sequencer.wr_seqrh[i];
                
        foreach(rd_seqrh[i])
           rd_seqrh[i]=v_sequencer.rd_seqrh[i];
    endtask

class virtual_sequence0 extends base_virtual_sequence;
    wr_sequence0 wr_seq0;
    rd_sequence0 rd_seq0;
    bit [1:0] address;
    `uvm_object_utils(virtual_sequence0)
    
    function new(string name="virtual_sequence0");
        super.new(name);
    endfunction
    
    task body();
       super.body();
       wr_seq0=wr_sequence0::type_id::create("wr_seq0");
       rd_seq0=rd_sequence0::type_id::create("rd_seq0");
       if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
           `uvm_fatal("virtual sequence","unable to get address, have you set it?")  
      // `uvm_info("virtual_sequence","virtual sequence body is executed",UVM_LOW)
      //  foreach(wr_seqrh[i])
      fork
           begin
              wr_seq0.start(wr_seqrh[0]);
            //  `uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
           end
           begin
              // `uvm_info("address is",$sformatf("address %d",address), UVM_LOW)
               if(address==2'b00)
                   rd_seq0.start(rd_seqrh[0]);
               if(address==2'b01)
                   rd_seq0.start(rd_seqrh[1]);
               if(address==2'b10)
                   rd_seq0.start(rd_seqrh[2]);
           end
      join
    endtask
endclass


class large_packet_vs extends base_virtual_sequence;
    large_packet_sequence wr_seq0;
    rd_sequence0 rd_seq0;
    bit [1:0] address;
    `uvm_object_utils(large_packet_vs)
    
    function new(string name="large_packet_vs");
        super.new(name);
    endfunction
    
    task body();
       super.body();
       wr_seq0=large_packet_sequence::type_id::create("wr_seq0");
       rd_seq0=rd_sequence0::type_id::create("rd_seq0");
       if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
           `uvm_fatal("virtual sequence","unable to get address, have you set it?")  
      // `uvm_info("virtual_sequence","virtual sequence body is executed",UVM_LOW)
      //  foreach(wr_seqrh[i])
      fork
           begin
              wr_seq0.start(wr_seqrh[0]);
            //  `uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
           end
           begin
              // `uvm_info("address is",$sformatf("address %d",address), UVM_LOW)
               if(address==2'b00)
                   rd_seq0.start(rd_seqrh[0]);
               if(address==2'b01)
                   rd_seq0.start(rd_seqrh[1]);
               if(address==2'b10)
                   rd_seq0.start(rd_seqrh[2]);
           end
      join
    endtask
endclass


class small_packet_vs extends base_virtual_sequence;
    small_packet_sequence wr_seq0;
    rd_sequence0 rd_seq0;
    bit [1:0] address;
    `uvm_object_utils(small_packet_vs)
    
    function new(string name="small_packet_vs");
        super.new(name);
    endfunction
    
    task body();
       super.body();
       wr_seq0=small_packet_sequence::type_id::create("wr_seq0");
       rd_seq0=rd_sequence0::type_id::create("rd_seq0");
       if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
           `uvm_fatal("virtual sequence","unable to get address, have you set it?")  
      // `uvm_info("virtual_sequence","virtual sequence body is executed",UVM_LOW)
      //  foreach(wr_seqrh[i])
      fork
           begin
              wr_seq0.start(wr_seqrh[0]);
            //  `uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
           end
           begin
              // `uvm_info("address is",$sformatf("address %d",address), UVM_LOW)
               if(address==2'b00)
                   rd_seq0.start(rd_seqrh[0]);
               if(address==2'b01)
                   rd_seq0.start(rd_seqrh[1]);
               if(address==2'b10)
                   rd_seq0.start(rd_seqrh[2]);
           end
      join
    endtask
endclass


class packet_14_vs extends base_virtual_sequence;
    packet_14_sequence wr_seq0;
    rd_sequence0 rd_seq0;
    bit [1:0] address;
    `uvm_object_utils(packet_14_vs)
    
    function new(string name="packet_14_vs");
        super.new(name);
    endfunction
    
    task body();
       super.body();
       wr_seq0=packet_14_sequence::type_id::create("wr_seq0");
       rd_seq0=rd_sequence0::type_id::create("rd_seq0");
       if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
           `uvm_fatal("virtual sequence","unable to get address, have you set it?")  
      // `uvm_info("virtual_sequence","virtual sequence body is executed",UVM_LOW)
      //  foreach(wr_seqrh[i])
      fork
           begin
              wr_seq0.start(wr_seqrh[0]);
            //  `uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
           end
           begin
              // `uvm_info("address is",$sformatf("address %d",address), UVM_LOW)
               if(address==2'b00)
                   rd_seq0.start(rd_seqrh[0]);
               if(address==2'b01)
                   rd_seq0.start(rd_seqrh[1]);
               if(address==2'b10)
                   rd_seq0.start(rd_seqrh[2]);
           end
      join
    endtask
endclass


class soft_reset_vs extends base_virtual_sequence;
    wr_sequence0 wr_seq0;
    rd_cycle_30 rd_seq0;
    bit [1:0] address;
    `uvm_object_utils(soft_reset_vs)
    
    function new(string name="soft_reset_vs");
        super.new(name);
    endfunction
    
    task body();
       super.body();
       wr_seq0=wr_sequence0::type_id::create("wr_seq0");
       rd_seq0=rd_cycle_30::type_id::create("rd_seq0");
       if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
           `uvm_fatal("virtual sequence","unable to get address, have you set it?")  
      // `uvm_info("virtual_sequence","virtual sequence body is executed",UVM_LOW)
      //  foreach(wr_seqrh[i])
      fork
           begin
              wr_seq0.start(wr_seqrh[0]);
            //  `uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
           end
           begin
              // `uvm_info("address is",$sformatf("address %d",address), UVM_LOW)
               if(address==2'b00)
                   rd_seq0.start(rd_seqrh[0]);
               if(address==2'b01)
                   rd_seq0.start(rd_seqrh[1]);
               if(address==2'b10)
                   rd_seq0.start(rd_seqrh[2]);
           end
      join
    endtask
endclass
