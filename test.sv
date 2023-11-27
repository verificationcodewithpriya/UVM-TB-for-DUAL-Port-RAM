class base_test#(parameter M=3, parameter N=8)  extends uvm_test;
  `uvm_component_utils (base_test)
  environment e0;
  seq s0;
  write wr_seq;
  read rd_seq;
  write_followed_read w_f_r;
  write_incr_addr wr_incr_seq;
  read_incr_addr rd_incr_seq;
  write_followed_read_incr_addr w_f_r_incr_addr;
  write_first_read_next_rand_addr w_first_r_next_rand_addr;
  write_first_read_next_incr_addr w_first_r_next_incr_addr;
  write_to_odd_read_even_location  wr_odd_rd_even_loc;
  write_to_even_read_odd_location  wr_even_rd_odd_loc;
  int number_tx;
  
  function new (string name = "base_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  virtual function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [BASE_TEST]: BUILD_PHASE TRIGGERED"), UVM_MEDIUM)
    if(!uvm_config_db #(int)::get(this,"","str",number_tx))
       `uvm_fatal("base_test","transaction");
    super.build_phase(phase);
    e0 = environment::type_id::create ("e0", this); 
    `uvm_info(get_full_name(), $sformatf(" [BASE_TEST]: BUILD_PHASE EXIT"), UVM_MEDIUM)
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [BASE_TEST]: CONNECT_PHASE TRIGGERED"), UVM_MEDIUM)  
    super.connect_phase(phase);
    `uvm_info(get_full_name(), $sformatf(" [BASE_TEST]: CONNECT_PHASE EXIT"), UVM_MEDIUM)
  endfunction
  
  function void end_of_elaboration_phase (uvm_phase phase);
     super.end_of_elaboration_phase (phase);
     `uvm_info (get_full_name() , phase.get_name() , UVM_MEDIUM)
     uvm_top.print_topology();
  endfunction  
  
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [BASE_TEST]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    super.run_phase(phase);
    phase.raise_objection(this);
    s0 = seq#(M,N)::type_id::create ("s0");
    s0.number_tx = number_tx;
    s0.start(e0.a0.sqr);
    
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [BASE_TEST]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

////////////// WRITE ONLY ///////////////////////////
class write_only extends base_test;
  `uvm_component_utils (write_only)
  
  function new (string name = "write_only" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [write_only]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    wr_seq = write::type_id::create ("wr_seq");
    wr_seq.number_tx = number_tx;
    wr_seq.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [write_only]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////////// READ ONLY /////////////////
class read_only extends base_test;
  `uvm_component_utils (read_only)
  
  function new (string name = "read_only" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [read_only]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    rd_seq = read::type_id::create ("rd_seq");
    rd_seq.number_tx = number_tx;
    rd_seq.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [read_only]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////////// WRITE FOLLOWED BY READ /////////////////
class write_followed_read_test  extends base_test;
  `uvm_component_utils (write_followed_read_test)
  
  function new (string name = "write_followed_read_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [write_followed_read_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    w_f_r = write_followed_read ::type_id::create ("w_f_r");
    w_f_r.number_tx = number_tx;
    w_f_r.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [write_followed_read_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

////////////// WRITE ONLY WITH INCREMENTAL ADDRESS ///////////////////////////
class write_incr_addr_test extends base_test;
  `uvm_component_utils (write_incr_addr_test)
  
  function new (string name = "write_incr_addr_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [write_incr_addr_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    wr_incr_seq = write_incr_addr::type_id::create ("wr_incr_seq");
    wr_incr_seq.number_tx = number_tx;
    wr_incr_seq.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [write_incr_addr_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

////////////// READ ONLY WITH INCREMENTAL ADDRESS ///////////////////////////
class read_incr_addr_test extends base_test;
  `uvm_component_utils (read_incr_addr_test)
  
  function new (string name = "read_incr_addr_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [read_incr_addr_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    rd_incr_seq = read_incr_addr::type_id::create ("rd_incr_seq");
    rd_incr_seq.number_tx = number_tx;
    rd_incr_seq.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [read_incr_addr_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////////// WRITE FOLLOWED BY READ WITH INCREMENTAL ADDR /////////////////
class write_followed_read_incr_addr_test  extends base_test;
  `uvm_component_utils (write_followed_read_incr_addr_test)
  
  function new (string name = "write_followed_read_incr_addr_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [write_followed_read_incr_addr_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    w_f_r_incr_addr = write_followed_read_incr_addr ::type_id::create ("w_f_r_incr_addr");
    w_f_r_incr_addr.number_tx = number_tx;
    w_f_r_incr_addr.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [write_followed_read_incr_addr_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////////// WRITE FIRST READ NEXT WITH RANDOM ADDRESS /////////////////////
class write_first_read_next_rand_addr_test  extends base_test;
  `uvm_component_utils (write_first_read_next_rand_addr_test)
  
  function new (string name = "write_first_read_next_rand_addr_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [write_first_read_next_rand_addr_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    w_first_r_next_rand_addr = write_first_read_next_rand_addr ::type_id::create ("write_first_read_next_rand_addr_test");
    w_first_r_next_rand_addr.number_tx = number_tx;
    w_first_r_next_rand_addr.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [write_first_read_next_rand_addr_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////////// WRITE FIRST READ NEXT WITH INCREMENTAL ADDRESS /////////////////////
class write_first_read_next_incr_addr_test  extends base_test;
  `uvm_component_utils (write_first_read_next_incr_addr_test)
  
  function new (string name = "write_first_read_next_incr_addr_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [write_first_read_next_incr_addr_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    w_first_r_next_incr_addr = write_first_read_next_incr_addr ::type_id::create ("write_first_read_next_incr_addr_test");
    w_first_r_next_incr_addr.number_tx = number_tx;
    w_first_r_next_incr_addr.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [write_first_read_next_incr_addr_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass


/////////////////// WRITE ODD READ EVEN LOCATION /////////////////////
class wr_odd_rd_even_location_seq_test  extends base_test;
  `uvm_component_utils (wr_odd_rd_even_location_seq_test)
  
  function new (string name = "wr_odd_rd_even_location_seq_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [wr_odd_rd_even_location_seq_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    wr_odd_rd_even_loc = write_to_odd_read_even_location ::type_id::create ("wr_odd_rd_even_loc");
    wr_odd_rd_even_loc.number_tx = number_tx;
    wr_odd_rd_even_loc.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [wr_odd_rd_even_location_seq_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

/////////////////// WRITE EVEN READ ODD LOCATION /////////////////////
class wr_even_rd_odd_location_test extends base_test;
  `uvm_component_utils (wr_even_rd_odd_location_test)
  
  function new (string name = "wr_even_rd_odd_location_test" , uvm_component parent);
      super.new(name,parent);
   endfunction  

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [wr_even_rd_odd_location_test]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    phase.raise_objection(this);
    wr_even_rd_odd_loc = write_to_even_read_odd_location ::type_id::create ("wr_even_rd_odd_loc");
    wr_even_rd_odd_loc.number_tx = number_tx;
    wr_even_rd_odd_loc.start(e0.a0.sqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(), $sformatf(" [wr_even_rd_odd_location_test]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass