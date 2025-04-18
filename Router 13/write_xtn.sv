/*************************************
Filename:write_xtn.sv
Version:1.0
Author:Avi
*************************************/
`include "uvm_macros.svh"
import uvm_pkg::*;
class write_xtn extends uvm_sequence_item;
    
      rand bit[7:0] header;
      rand bit[7:0] payload[];
      bit [7:0] parity;
bit err; 
     `uvm_object_utils(write_xtn)
      constraint wr_pkt{
                        payload.size == header[7:2];
                        header[1:0]!=3;
                        header[7:2]!=0;
                        }
     extern function new(string name="write_xtn");
     extern function void post_randomize();
     extern function void do_print(uvm_printer printer);
endclass
      
      function write_xtn::new(string name="write_xtn");
          super.new(name);
      endfunction

      function void  write_xtn::post_randomize();
          parity=0^header;
          foreach(payload[i])
              parity=parity^payload[i];
      endfunction

      function void write_xtn::do_print(uvm_printer printer);
          super.do_print(printer);
          //                 string name,        value,              size,     radix
          printer.print_field("header",           this.header,       8,         UVM_DEC); 
          printer.print_field("header_address",           this.header[1:0],       2,         UVM_DEC);
          foreach(this.payload[i])
          printer.print_field("payload",          this.payload[i],   8,         UVM_DEC);
          printer.print_field("parity",           this.parity,       8,         UVM_DEC);
      endfunction
