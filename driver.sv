class driver extends uvm_driver#(transaction, transaction);
  `uvm_component_utils(driver)
  virtual interface_if vif;
  transaction pkts;
  
  //uvm_blocking_put_port d_put_port;
  
  function new(string name= "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    `uvm_info (get_full_name(), $sformatf(" [DRIVER]: BUILD PHASE TRIGGERED"), UVM_DEBUG)
    super.build_phase(phase);
    `uvm_info (get_full_name(), $sformatf(" [DRIVER]: BUILD PHASE EXIT"), UVM_DEBUG)
  endfunction
  
  task initialization();
    @(vif.clocking_mod.driver_cb)begin
      vif.clocking_mod.driver_cb.w_en <= 'h0;    
      vif.clocking_mod.driver_cb.r_en <= 'h0; 
      vif.clocking_mod.driver_cb.waddr<='h0;  
      vif.clocking_mod.driver_cb.raddr<='h0;  
      vif.clocking_mod.driver_cb.wdata<='h0;
    @(vif.clocking_mod.driver_cb);
    end
    wait(vif.rst == 0);
  endtask
  
  task driver_done(transaction pkts);
    begin
      wait(vif.rst == 0);  
      @(vif.clocking_mod.driver_cb);
      vif.clocking_mod.driver_cb.w_en <= pkts.w_en;    
      vif.clocking_mod.driver_cb.r_en <= pkts.r_en;  
      vif.clocking_mod.driver_cb.waddr <= pkts.waddr;  
      vif.clocking_mod.driver_cb.raddr <= pkts.raddr;  
      vif.clocking_mod.driver_cb.wdata <= pkts.wdata;
      @(vif.clocking_mod.driver_cb);
      vif.clocking_mod.driver_cb.w_en <= 'h0;    
      vif.clocking_mod.driver_cb.r_en <= 'h0;
      repeat(pkts.random_delay)@(vif.driver_cb);
    end
  endtask
  
  task run_phase(uvm_phase phase); 
    `uvm_info (get_full_name()," [DRIVER]: RUN TASK TRIGGERED", UVM_MEDIUM)
    super.run_phase(phase);
    forever begin
      if(vif.rst == 1)begin
        initialization();
      end
      else begin
        `uvm_info(get_full_name()," [DRIVER]: WAITING FOR PACKET FROM SEQUENCER", UVM_LOW)
        seq_item_port.get_next_item(pkts);     
        `uvm_info("driver", pkts.sprint(), UVM_LOW)  
        driver_done(pkts);
        seq_item_port.item_done(pkts);    
        `uvm_info(get_full_name(), $sformatf(" [DRIVER]: ITEM DONE"), UVM_LOW)
      end
    end  
    `uvm_info (get_full_name(), " [DRIVER]: RUN TASK EXIT", UVM_MEDIUM)
  endtask
endclass
