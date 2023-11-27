class agent#(parameter M=3, parameter N=8)  extends uvm_agent;
  `uvm_component_utils(agent)
  
  config_obj cfg;
  driver d0;
  monitor m0;
  uvm_sequencer#(transaction) sqr;

  virtual interface_if vif;
  
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(), $sformatf(" [AGENT]: BUILD_PHASE TRIGGERED"), UVM_MEDIUM)
    if(!uvm_config_db #(config_obj)::get(this,"", "config_obj", cfg))begin
      `uvm_fatal(get_full_name(), " [AGENT]: could not get cfg")
    end
    
    super.build_phase(phase);
    m0 = monitor#(M,N)::type_id::create("m0",this);
    if(cfg.is_active == UVM_ACTIVE)begin
      sqr =  uvm_sequencer#(transaction)::type_id::create("sqr",this); 
      d0 = driver :: type_id :: create ("d0",this);
    end
    `uvm_info(get_full_name(), $sformatf(" [AGENT]: BUILD_PHASE EXIT"), UVM_MEDIUM)
  endfunction
  
  function void connect_phase(uvm_phase phase);   
    `uvm_info(get_full_name(), $sformatf(" [AGENT]: CONNECT_PHASE TRIGGERED"), UVM_MEDIUM)
    super.connect_phase(phase); 
    m0.vif = cfg.vif;
    if(cfg.is_active == UVM_ACTIVE)begin
      d0.vif = cfg.vif;
      d0.seq_item_port.connect(sqr.seq_item_export);
      d0.rsp_port.connect(sqr.rsp_export);
    end   
    `uvm_info(get_full_name(), $sformatf(" [AGENT]: CONNECT_PHASE EXIT"), UVM_MEDIUM)
  endfunction
  
  task run_phase(uvm_phase phase); 
    `uvm_info(get_full_name(), $sformatf(" [AGENT]: RUN_TASK TRIGGERED"), UVM_MEDIUM) 
    super.run_phase(phase);
    `uvm_info(get_full_name(), $sformatf(" [AGENT]: RUN_TASK EXIT"), UVM_MEDIUM)
  endtask
endclass

