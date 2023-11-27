class monitor#(parameter M=3, parameter N=8) extends uvm_monitor;
   `uvm_component_utils(monitor)
   transaction pkts;
   uvm_analysis_port #(transaction) mon_ap;
   virtual interface_if vif;
   
   function new(string name = "monitor", uvm_component parent);
      super.new(name, parent);
   endfunction
  
  function void build_phase(uvm_phase phase);
       `uvm_info(get_full_name(), "MONITOR BUILD PHASE TRIGGERED", UVM_DEBUG)
       super.build_phase(phase);
       mon_ap = new("mon_ap", this);
       `uvm_info(get_full_name(), "MONITOR BUILD PHASE EXIT", UVM_DEBUG)
     endfunction
     
     function void connect_phase(uvm_phase phase);
       `uvm_info(get_full_name(), "MONITOR CONNECT PHASE TRIGGERED", UVM_DEBUG)
       super.connect_phase(phase);
       `uvm_info(get_full_name(), "MONITOR CONNECT PHASE EXIT", UVM_DEBUG)
     endfunction
  
  task capture_pkts(transaction pkts);
     @(vif.clocking_mod.monitor_cb);
	 if(vif.rst == 0 && vif.clocking_mod.monitor_cb.w_en == 1)begin
        pkts = transaction #(M, N) :: type_id :: create("mon_pkts");
        pkts.w_en = vif.clocking_mod.monitor_cb.w_en;
        pkts.waddr = vif.clocking_mod.monitor_cb.waddr;
        pkts.wdata = vif.clocking_mod.monitor_cb.wdata;
        pkts.opcode = WRITE;
       `uvm_info("monitor", "WRITE PACKETS", UVM_MEDIUM)
        pkts.print();
        mon_ap.write(pkts);
	 end
	 if(vif.rst == 0 && vif.clocking_mod.monitor_cb.r_en == 1)begin
        pkts = transaction #(M, N) :: type_id :: create("mon_pkts");
        pkts.r_en = vif.clocking_mod.monitor_cb.r_en;
        pkts.raddr = vif.clocking_mod.monitor_cb.raddr;
        pkts.rdata = vif.clocking_mod.monitor_cb.rdata;
        pkts.opcode = READ;
       `uvm_info("monitor", "READ PACKETS", UVM_MEDIUM)
        pkts.print();
        mon_ap.write(pkts);
	 end    
  endtask
     
     task run_phase(uvm_phase phase);
       `uvm_info(get_full_name(), "MONITOR RUN PHASE TRIGGERED", UVM_DEBUG)
        forever begin
          capture_pkts(pkts);
        end
       `uvm_info(get_full_name(), "MONITOR RUN PHASE EXIT", UVM_DEBUG)
     endtask 
endclass
     
     