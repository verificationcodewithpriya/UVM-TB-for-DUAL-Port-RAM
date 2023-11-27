class seq#(parameter M=3, parameter N=8)  extends uvm_sequence #(transaction);
  `uvm_object_utils(seq)
  transaction pkts, pkts2;
  int number_tx =2;
 
  function new(string name = "seq");
    super.new(name);
  endfunction
 
  virtual task body();   
    `uvm_info (get_full_name(), $sformatf("[SEQ]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    pkts = transaction#(M,N)::type_id::create ("seq_pkts");
    pkts2 = transaction#(M,N)::type_id::create ("pkts2");
     for(int i=0; i<number_tx; i++)begin
      start_item(pkts);
      assert(pkts.randomize());
       pkts.print();
     `uvm_info(get_full_name(), "copying pkts to pkts2", UVM_MEDIUM)
      pkts2.copy(pkts);
      finish_item(pkts);
      get_response(pkts);
       //`uvm_do(pkts);
      //`uvm_info("seq", pkts2.sprint(), UVM_MEDIUM)
    end
    `uvm_info (get_full_name(), $sformatf("[SEQ]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////// WRITE ONLY /////////////////////
class write extends seq;
  `uvm_object_utils(write)
  transaction_child1 child_pkt;
  
  function new(string name = "write");
    super.new(name);
  endfunction
 
 virtual task body();   
    `uvm_info (get_full_name(), $sformatf("[write]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    child_pkt = transaction_child1#(M,N)::type_id::create ("child_pkt");
     for(int i=0; i<number_tx; i++)begin
      start_item(child_pkt);
       assert(child_pkt.randomize() with {opcode == WRITE;});
       child_pkt.print();
      finish_item(child_pkt);
       get_response(pkts);
    end
    `uvm_info (get_full_name(), $sformatf("[write]: BODY PHASE EXIT"), UVM_MEDIUM)

  endtask
endclass

///////////// READ ONLY //////////////////////
class read extends seq;
  `uvm_object_utils(read)
  
  function new(string name = "read");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[read]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
     `uvm_do_with(pkts, {opcode == READ;});
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[read]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

////////////// WRITE FOLLOWED BY WITH READ RANDOM ADDRESS ////////////
class write_followed_read extends seq;
  `uvm_object_utils(write_followed_read)
  
  function new(string name = "write_followed_read");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[write_followed_read]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
      `uvm_do_with(pkts, {opcode == WRITE;});
      get_response(pkts);
      
      `uvm_do_with(pkts, {opcode == READ;});
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[write_followed_read]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////// WRITE ONLY INCREMENTAL ADDRESS /////////////////////
class write_incr_addr extends seq;
  `uvm_object_utils(write_incr_addr)
  
  function new(string name = "write_incr_addr");
    super.new(name);
  endfunction
 
 virtual task body();   
    `uvm_info (get_full_name(), $sformatf("[write_incr_addr]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
     for(int i=0; i<number_tx; i++)begin
       `uvm_do_with(pkts, {waddr == i[2:0]; opcode == WRITE;});
       get_response(pkts);
     end
    `uvm_info (get_full_name(), $sformatf("[write_incr_addr]: BODY PHASE EXIT"), UVM_MEDIUM)

  endtask
endclass

/////////////// READ ONLY INCREMENTAL ADDRESS /////////////////////
class read_incr_addr extends seq;
  `uvm_object_utils(read_incr_addr)

  function new(string name = "read_incr_addr");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[read_incr_addr]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
     for(int i=0; i<number_tx; i++)begin
       `uvm_do_with(pkts, {raddr == i[2:0]; opcode == READ;});
       get_response(pkts);
     end
   `uvm_info (get_full_name(), $sformatf("[read_incr_addr]: BODY PHASE EXIT"), UVM_MEDIUM)

  endtask
endclass

////////////// WRITE FOLLOWED BY READ WITH INCREMENTAL ADDRESS ////////////
class write_followed_read_incr_addr extends seq;
  `uvm_object_utils(write_followed_read_incr_addr)
  
  function new(string name = "write_followed_read_incr_addr");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[write_followed_read_incr_addr]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
      `uvm_do_with(pkts, {waddr == i[2:0]; opcode == WRITE;});
      get_response(pkts);
      
      `uvm_do_with(pkts, {raddr == i[2:0]; opcode == READ;});
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[write_followed_read_incr_addr]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

///////////// WRITE FIRST READ NEXT WITH RANDOM ADDRESS //////////////////////////
class write_first_read_next_rand_addr extends seq;
  `uvm_object_utils(write_first_read_next_rand_addr)
  
  function new(string name = "write_first_read_next_rand_addr");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[write_first_read_next_rand_addr]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
      `uvm_do_with(pkts, {if(i<number_tx/2)opcode == WRITE;
                          else opcode == READ;});
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[write_first_read_next_rand_addr]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

///////////// WRITE FIRST READ NEXT WITH INCREMENTAL ADDRESS //////////////////////////
class write_first_read_next_incr_addr extends seq;
  `uvm_object_utils(write_first_read_next_incr_addr)
  
  function new(string name = "write_first_read_next_incr_addr");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[write_first_read_next_incr_addr]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
      `uvm_do_with(pkts, {waddr == i[2:0]; raddr == i[2:0];
                          if(i<number_tx/2)opcode == WRITE;
                          else opcode == READ;});
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[write_first_read_next_incr_addr]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

////////// WRITE TO ODD READ EVEN LOCATION ///////////////////////////////////////////
class write_to_odd_read_even_location extends seq;
  `uvm_object_utils(write_to_odd_read_even_location)
  
  function new(string name = "write_to_odd_read_even_location");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[write_to_odd_read_even_location]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
      `uvm_do_with(pkts, {
         				  waddr%2 != 0;
        				  opcode == WRITE;
                         });
      get_response(pkts);
      
      `uvm_do_with(pkts, {
         				  raddr%2 == 0;
        				  opcode == READ;
                         });
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[write_to_odd_read_even_location]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

////////// WRITE TO EVEN READ ODD LOCATION ///////////////////////////////////////////
class write_to_even_read_odd_location extends seq;
  `uvm_object_utils(write_to_even_read_odd_location)
  
  function new(string name = "write_to_even_read_odd_location");
    super.new(name);
  endfunction
 
 virtual task body();   
   `uvm_info (get_full_name(), $sformatf("[write_to_even_read_odd_location]: BODY PHASE TRIGGERED"), UVM_MEDIUM)
    for(int i=0; i<number_tx; i++)begin
      `uvm_do_with(pkts, {
                           waddr%2 == 0; 
        				   opcode == WRITE;
                         });
      get_response(pkts);
      
      `uvm_do_with(pkts, {
                           raddr%2 != 0; 
        				   opcode == READ;
                         });
      get_response(pkts);
    end
   `uvm_info (get_full_name(), $sformatf("[write_to_even_read_odd_location]: BODY PHASE EXIT"), UVM_MEDIUM)
  endtask
endclass

