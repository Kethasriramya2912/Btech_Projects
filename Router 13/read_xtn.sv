/**********************************
Filename:read_xtn.sv
Version:1.0
Author:Avi
**********************************/
`include "uvm_macros.svh"
import uvm_pkg::*;

class read_xtn extends uvm_sequence_item;
    
     bit [7:0] header;
     bit [7:0] payload[];
     bit [7:0] parity;

     rand logic[4:0] cycle;
 
     `uvm_object_utils(read_xtn)

     constraint c1{cycle inside {[1:29]};}

     extern function new(string name="read_xtn");
     extern function void do_print(uvm_printer printer);
endclass
 
     function read_xtn::new(string name="read_xtn");
         super.new(name);
     endfunction

    function void read_xtn::do_print(uvm_printer printer);
       super.do_print(printer);
       //                        name,             value,              size,    radix
           printer.print_field("header",           this.header,         8  ,     UVM_DEC);
           printer.print_field("header_address",   this.header[1:0],    2  ,     UVM_DEC);
       foreach(this.payload[i])
           printer.print_field("payload",          this.payload[i],     8  ,     UVM_DEC);
           printer.print_field("parity",           this.parity,         8  ,     UVM_DEC);
    endfunction
