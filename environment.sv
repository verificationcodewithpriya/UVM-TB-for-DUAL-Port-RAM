class environment extends uvm_env;
  `uvm_component_utils(environment)
  agent a0;
  scoreboard scb;
  func_cvg cvg;
  config_obj cfg;
  virtual interface_if vif;
  
  function new(string name = "environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);  
    `uvm_info(get_full_name(), $sformatf(" [ENV]: BUILD_PHASE TRIGGERED"), UVM_MEDIUM)
    if(!uvm_config_db #(config_obj)::get(this,"", "config_obj", cfg))begin
      `uvm_fatal(get_full_name(), " [ENV]: could not get cfg")
    end
    super.build_phase(phase);
    a0 = agent::type_id::create ("a0", this); 
    scb = scoreboard::type_id::create ("scb", this); 
    cvg = func_cvg::type_id::create ("cvg", this); 
    `uvm_info(get_full_name(), $sformatf(" [ENV]: BUILD_PHASE EXIT"), UVM_MEDIUM)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [ENV]: CONNECT_PHASE TRIGGERED"), UVM_MEDIUM) 
    super.connect_phase(phase);  
    scb.vif = cfg.vif;
    a0.m0.mon_ap.connect(scb.scb_af.analysis_export);
    a0.m0.mon_ap.connect(cvg.cvg_af.analysis_export);
    `uvm_info(get_full_name(), $sformatf(" [ENV]: CONNECT_PHASE EXIT"), UVM_MEDIUM)
  endfunction
  
  task run_phase(uvm_phase phase);  
    `uvm_info(get_full_name(), $sformatf(" [ENV]: RUN_TASK TRIGGERED"), UVM_MEDIUM)  
    super.run_phase(phase);
    `uvm_info(get_full_name(), $sformatf(" [ENV]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
  
endclass