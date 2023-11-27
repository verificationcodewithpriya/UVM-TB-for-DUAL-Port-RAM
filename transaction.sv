typedef enum {WRITE, READ}T_type;
class transaction#(parameter M=3, parameter N=8) extends uvm_sequence_item;
  rand bit w_en, r_en;
  rand bit[M-1:0] waddr, raddr;
  rand bit[N-1:0] wdata;
  rand T_type opcode;
  rand bit[2:0] random_delay;
  bit[N-1:0] rdata;
  
  `uvm_object_utils_begin(transaction)
  	`uvm_field_int(w_en, UVM_ALL_ON)
    `uvm_field_int(r_en, UVM_ALL_ON)
    `uvm_field_int(waddr, UVM_ALL_ON)
    `uvm_field_int(raddr, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)    
    `uvm_field_int(rdata, UVM_ALL_ON)
  	`uvm_field_enum(T_type,opcode, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "transaction");
    super.new(name);
  endfunction
  
  constraint write_read{ if(opcode == WRITE) {w_en ==1; r_en == 0;}
              else {w_en ==0; r_en == 1;}}
                
                constraint waddr_c{soft waddr>0;}
endclass
                
class transaction_child1#(parameter M=3, parameter N=8) extends transaction;
  `uvm_object_utils(transaction_child1)
  
  function new(string name = "transaction_child1");
    super.new(name);
  endfunction
endclass
                        
