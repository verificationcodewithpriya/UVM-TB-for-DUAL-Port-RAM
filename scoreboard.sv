class scoreboard #(parameter M=3, parameter N=8) extends uvm_component;
 
    uvm_tlm_analysis_fifo #(transaction) scb_af;
    transaction scb_pkts;
    event rst_captured;
  	bit[N-1:0] expected_rdata;
  	int ref_mem[int];
  	virtual interface_if vif;
  
  `uvm_component_utils_begin (scoreboard)
    `uvm_field_int(expected_rdata, UVM_ALL_ON)
    `uvm_field_aa_int_int(ref_mem, UVM_ALL_ON)
  `uvm_component_utils_end

   function new (string name = "scoreboard" , uvm_component parent);
      super.new(name,parent);
   endfunction  

   function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     scb_af = new ("scb_af",this);
     `uvm_info (get_full_name() , phase.get_name() , UVM_MEDIUM)
   endfunction : build_phase

    function void connect_phase (uvm_phase phase);
       super.connect_phase (phase);
       `uvm_info (get_full_name() , phase.get_name() , UVM_MEDIUM)
    endfunction : connect_phase
  
  function void ref_model(transaction scb_pkts);
    if(scb_pkts.w_en == 1)begin
      ref_mem[scb_pkts.waddr] = scb_pkts.wdata;
    end
    else if(scb_pkts.r_en == 1)begin
      if(ref_mem.exists(scb_pkts.raddr))begin
        expected_rdata = ref_mem[scb_pkts.raddr];
      end
      else begin
        expected_rdata = 'h0;
      end
    end
  endfunction
  
  function void write_checker(transaction scb_pkts);
    if(ref_mem[scb_pkts.waddr] == vif.dut_mem[scb_pkts.waddr])
      `uvm_info("WRITE_CHECKER", $sformatf(" WRITE_CHECKER PASS, ref_mem[scb_pkts.waddr] = %0h,  vif.dut_mem[scb_pkts.waddr] = %0h",ref_mem[scb_pkts.waddr],  vif.dut_mem[scb_pkts.waddr]), UVM_MEDIUM)
    else
      `uvm_error("WRITE_CHECKER", " WRITE_CHECKER FAIL")
  endfunction
  
  function void read_checker(transaction scb_pkts);
    if(expected_rdata == scb_pkts.rdata)      
      `uvm_info("READ_CHECKER", $sformatf(" READ_CHECKER PASS expected_rdata = %0h, scb_pkts.rdata = %0h",expected_rdata,scb_pkts.rdata), UVM_MEDIUM)
      else
        `uvm_error("READ_CHECKER", $sformatf(" READ_CHECKER FAIL expected_rdata = %0h, scb_pkts.rdata = %0h",expected_rdata,scb_pkts.rdata))
  endfunction

    task run_phase (uvm_phase phase);
    `uvm_info (get_full_name() , "SCOREBOARD RUN TASK TRIGGERED" , UVM_MEDIUM)
        forever 
          begin
            scb_pkts = transaction#(M,N):: type_id :: create ("scb_pkts");
            scb_af.get (scb_pkts);
            `uvm_info ("SCOREBOARD" , scb_pkts.sprint(), UVM_MEDIUM)
            ref_model(scb_pkts);
            if(scb_pkts.w_en == 1)write_checker(scb_pkts);   
            if(scb_pkts.r_en == 1)read_checker(scb_pkts);
     	  end  
    `uvm_info (get_full_name() , "SCOREBOARD RUN TASK EXIT" , UVM_MEDIUM)
    endtask
endclass 


  
