class func_cvg#(parameter M=3, parameter N=8) extends uvm_component;
  `uvm_component_utils(func_cvg)
  uvm_tlm_analysis_fifo #(transaction) cvg_af;
  transaction cvg_pkts;
  
   bit write_only_random;
   bit write_only_incr;
   bit read_only_random;
   bit read_only_incr;
   bit write_followed_by_read_random;
   bit write_followed_by_read_incr;
   bit write_even_read_odd_loc;
   bit write_odd_read_even_loc;
    
   transaction q1[$];
   transaction q2[$];
   transaction q3[$];
   transaction q4[$];
   transaction q5[$];
   transaction q6[$];
   transaction q7[$];
   transaction q8[$];
    
  covergroup cg;
    WRITE_EN: coverpoint cvg_pkts.w_en{bins w_en_high = {1'b1};
                                       ignore_bins w_en_low = {1'b0};}
    READ_EN:  coverpoint cvg_pkts.r_en{bins r_en_high = {1'b1};
                                       ignore_bins r_en_low = {1'b0};}
    
    WADDR_CP: coverpoint cvg_pkts.waddr{bins write_addr[4] = {[0:$]};}
    RADDR_CP: coverpoint cvg_pkts.raddr{bins read_addr[4] = {[0:$]};}
    
    WDATA_CP: coverpoint cvg_pkts.wdata{wildcard bins wr_data_ones_8 = {8'b1???????};
                                        wildcard bins wr_data_ones_7 = {8'b?1??????};
                                        wildcard bins wr_data_ones_6 = {8'b??1?????};
                                        wildcard bins wr_data_ones_5 = {8'b???1????};
                                        wildcard bins wr_data_ones_4 = {8'b????1???};
                                        wildcard bins wr_data_ones_3 = {8'b?????1??};
                                        wildcard bins wr_data_ones_2 = {8'b??????1?};
                                        wildcard bins wr_data_ones_1 = {8'b???????1};

                                        wildcard bins wr_data_zeros_8 = {8'b0???????};
                                        wildcard bins wr_data_zeros_7 = {8'b?0??????};
                                        wildcard bins wr_data_zeros_6 = {8'b??0?????};
                                        wildcard bins wr_data_zeros_5 = {8'b???0????};
                                        wildcard bins wr_data_zeros_4 = {8'b????0???};
                                        wildcard bins wr_data_zeros_3 = {8'b?????0??};
                                        wildcard bins wr_data_zeros_2 = {8'b??????0?};
                                        wildcard bins wr_data_zeros_1 = {8'b???????0};}
    
    RDATA_CP: coverpoint cvg_pkts.rdata{wildcard bins re_data_ones_8 = {8'b1???????};
                                        wildcard bins re_data_ones_7 = {8'b?1??????};
                                        wildcard bins re_data_ones_6 = {8'b??1?????};
                                        wildcard bins re_data_ones_5 = {8'b???1????};
                                        wildcard bins re_data_ones_4 = {8'b????1???};
                                        wildcard bins re_data_ones_3 = {8'b?????1??};
                                        wildcard bins re_data_ones_2 = {8'b??????1?};
                                        wildcard bins re_data_ones_1 = {8'b???????1};

                                        wildcard bins re_data_zeros_8 = {8'b0???????};
                                        wildcard bins re_data_zeros_7 = {8'b?0??????};
                                        wildcard bins re_data_zeros_6 = {8'b??0?????};
                                        wildcard bins re_data_zeros_5 = {8'b???0????};
                                        wildcard bins re_data_zeros_4 = {8'b????0???};
                                        wildcard bins re_data_zeros_3 = {8'b?????0??};
                                        wildcard bins re_data_zeros_2 = {8'b??????0?};
                                        wildcard bins re_data_zeros_1 = {8'b???????0};}
                                        
    WENXWADDR: cross WRITE_EN,WADDR_CP;
    RENXRADDR: cross READ_EN, RADDR_CP;
    
    
    WRITE_ONLY_RANDOM: coverpoint write_only_random {option.at_least = 6;
                                                     bins write_only_random_high = {1};
                                                     ignore_bins write_only_random_low = {0};
                                                    }
    
    READ_ONLY_RANDOM: coverpoint read_only_random {option.at_least = 6;
                                                   bins read_only_random_high = {1};
                                                   ignore_bins read_only_random_low = {0};
                                                    }
    
    WRITE_ONLY_INCR: coverpoint write_only_incr {option.at_least = 6;
                                                 bins write_only_incr_high = {1};
                                                     ignore_bins write_only_incr_low = {0};
                                                    }
    
    READ_ONLY_INCR: coverpoint read_only_incr {option.at_least = 6;
                                               bins read_only_incr_high = {1};
                                                     ignore_bins read_only_incr_low = {0};
                                                    }
    
    WRITE_FOLLOWED_BY_READ_RANDOM: coverpoint write_followed_by_read_random{ option.at_least = 6;
                                                                             bins write_followed_by_read_random_high = {1};
                                                                             ignore_bins write_followed_by_read_random_low = {0};
                                                                           }
    WRITE_FOLLOWED_BY_READ_INCR: coverpoint write_followed_by_read_incr{ option.at_least = 6;
                                                                         bins write_followed_by_read_incr_high = {1};
                                                                         ignore_bins write_followed_by_read_incr_low = {0};
                                                                           }
    
    WR_EVEN_RD_ODD_LOC: coverpoint write_even_read_odd_loc{option.at_least = 6;
                                                           bins wr_even_rd_odd_high = {1};
                                                           ignore_bins wr_even_rd_odd_low = {0};
                                                          }
    WR_ODD_RD_EVEN_LOC: coverpoint write_odd_read_even_loc{option.at_least = 6;
                                                           bins wr_odd_rd_even_high = {1};
                                                           ignore_bins wr_odd_rd_even_low = {0};
                                                          }
  endgroup
  
   function new(string name = "func_cvg", uvm_component parent);
    super.new(name,parent);
    cg = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name()," [FUNC_CVG]: BUILD_PHASE TRIGGERD", UVM_MEDIUM)
    super.build_phase(phase);
    cvg_af = new("cvg_af", this);
    `uvm_info(get_full_name()," [FUNC_CVG]: BUILD_PHASE EXIT", UVM_MEDIUM)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name()," [FUNC_CVG]: CONNECT_PHASE TRIGGERD", UVM_MEDIUM)
    super.connect_phase(phase);
    `uvm_info(get_full_name()," [FUNC_CVG]: CONNECT_PHASE EXIT", UVM_MEDIUM)
  endfunction
  
  // WRITE ONLY WITH RANDOM ADDRESS
  function void f_write_only_random(transaction cvg_pkts );
    if(((q1[q1.size()-2].waddr - q1[q1.size()-1].waddr) !== 1) && (q1[q1.size()-2].w_en == 1 && q1[q1.size()-1].w_en == 1)) begin
        write_only_random = 1;
      `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE ONLY RANDOM HIT: q1[%0d].wraddr = %0h  q1[%0d].wraddr = %0h", q1.size()-1, q1[q1.size()-1].waddr, q1.size()-2, q1[q1.size()-2].waddr), UVM_LOW)
      end
      else begin
         write_only_random = 0;
        `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE ONLY RANDOM NOTHIT:q1[%0d].wraddr = %0h  q1[%0d].wraddr = %0h", q1.size()-1, q1[q1.size()-1].waddr, q1.size()-2, q1[q1.size()-2].waddr), UVM_LOW)
        end
      cg.sample();
    `uvm_info(get_full_name(), $sformatf("COVERAGE WRITE ONLY RANDOM ADDRESS = %0.2f%%\n", cg.WRITE_ONLY_RANDOM.get_inst_coverage()), UVM_LOW)
        q1.pop_back;
        write_only_random = 0;        
     endfunction
  
  ///READ_ONLY_RANDOM_ADDRESS     
  function void f_read_only_random(transaction cvg_pkts);
    if((q2[q2.size()-2].raddr - q2[q2.size()-1].raddr) !== 1 && (q2[q2.size()-2].r_en ==1 && q2[q2.size()-1].r_en ==1))begin
        read_only_random = 1;
      `uvm_info(get_full_name(), $sformatf("COVERAGE:READ ONLY RANDOM HIT: q2[%0d].raddr = %0h  q2[%0d].raddr = %0h", q2.size()-1, q2[q2.size()-1].raddr, q2.size()-2, q2[q2.size()-2].raddr), UVM_LOW)
      end
      else begin
         read_only_random = 0;
        `uvm_info(get_full_name(), $sformatf("COVERAGE:READ ONLY RANDOM NOTHIT:q2[%0d].raddr = %0h  q2[%0d].raddr = %0h", q2.size()-1, q2[q2.size()-1].raddr, q2.size()-2, q2[q2.size()-2].raddr), UVM_LOW)
        end
      cg.sample();
    `uvm_info(get_full_name(), $sformatf("COVERAGE READ ONLY RANDOM ADDRESS = %0.2f%%\n", cg.READ_ONLY_RANDOM.get_inst_coverage()), UVM_LOW)
        q2.pop_back;
        read_only_random = 0;        
     endfunction 
  
  //WRITE ONLY INCREMENTAL ADDRESS
  function void f_write_only_incr(transaction cvg_pkts);
       if((q3[q3.size()-2].waddr - q3[q3.size()-1].waddr) == 1)begin
           write_only_incr = 1;
         `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE ONLY INCR HIT q3[%0d].wraddr = %0h  q3[%0d].wraddr = %0h", q3.size()-2, q3[q3.size()-2].waddr, q3.size()-1, q3[q3.size()-1].waddr), UVM_LOW)
        end
        else begin
           write_only_incr = 0;
          `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE ONLY INCR NOTHIT: q3[%0d].wraddr = %0h  q3[%0d].wraddr = %0h",q3.size()-2, q3[q3.size()-2].waddr, q3.size()-1, q3[q3.size()-1].waddr), UVM_LOW)
        end
        cg.sample();
    `uvm_info(get_full_name(), $sformatf("COVERAGE WRITE ONLY INCREMENTAL ADDRESS = %0.2f%%\n", cg.WRITE_ONLY_INCR.get_inst_coverage()),UVM_LOW);
        q3.pop_back;
        write_only_incr = 0;
   endfunction
  
  //READ ONLY INCREMENTAL ADDRESS
  function void f_read_only_incr(transaction cvg_pkts);
       if((q4[q4.size()-2].raddr - q4[q4.size()-1].raddr) == 1)begin
           read_only_incr = 1;
         `uvm_info(get_full_name(), $sformatf("COVERAGE:READ ONLY INCR HIT q4[%0d].raddr = %0h  q4[%0d].raddr = %0h",q4.size()-2, q4[q4.size()-2].raddr, q4.size()-1, q4[q4.size()-1].raddr), UVM_LOW)
        end
        else begin
           read_only_incr = 0;
          `uvm_info(get_full_name(), $sformatf("COVERAGE:READ ONLY INCR NOTHIT q4[%0d].raddr = %0h  q4[%0d].raddr = %0h",q4.size()-2, q4[q4.size()-2].raddr, q4.size()-1, q4[q4.size()-1].raddr), UVM_LOW)
        end
        cg.sample();
    `uvm_info(get_full_name(), $sformatf("COVERAGE READ ONLY INCREMENTAL ADDRESS = %0.2f%%\n", cg.READ_ONLY_INCR.get_inst_coverage()),UVM_LOW);
        q4.pop_back;
        read_only_incr = 0;       
     endfunction
  
  ///WRITE FOLLOWED BY READ WITH RANDOM ADDRESS
  function void f_write_followed_by_read_random(transaction cvg_pkts);
    if ((((q5[q5.size() - 2].waddr - q5[q5.size() - 1].waddr) != 1) ) && (((q5[q5.size() - 2].raddr - q5[q5.size() - 1].raddr) != 1))) begin
        write_followed_by_read_random = 1;
      `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE FOLLOWED BY READ RANDOM HIT: q5[%0d].waddr = %0h  q5[%0d].raddr = %0h", q5.size()-2, q5[q5.size()-2].waddr, q5.size()-1, q5[q5.size()-1].raddr), UVM_LOW)
      end
      else begin
        write_followed_by_read_random = 0;
        `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE FOLLOWED BY READ RANDOM NOTHIT: q5[%0d].waddr = %0h  q5[%0d].raddr = %0h", q5.size()-2, q5[q5.size()-2].waddr, q5.size()-1, q5[q5.size()-1].raddr), UVM_LOW)    
      end
       cg.sample();
      `uvm_info(get_full_name(), $sformatf("COVERAGE WRITE FOLLOWED BY READ RANDOM WRITE AND READ ADDRESS = %0.2f%%\n", cg.WRITE_FOLLOWED_BY_READ_RANDOM.get_inst_coverage()),UVM_LOW)                  
      q5.pop_back();
       write_followed_by_read_random = 0;  
  endfunction
  
  ///WRITE FOLLOWED BY READ WITH INCR ADDRESS
  function void f_write_followed_by_read_incr(transaction cvg_pkts);
    if(((q6[q6.size() - 2].waddr - q6[q6.size() - 1].waddr)==1) && ((q6[q6.size() - 2].raddr - q6[q6.size() - 1].raddr)==1)) begin
        write_followed_by_read_incr = 1;
      `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE FOLLOWED BY READ INCR HIT: q6[%0d].waddr = %0h  q6[%0d].waddr=%0h, q6[%0d].raddr = %0h, q6[%0d].raddr = %0h",q6.size()-2, q6[q6.size()-2].waddr, q6.size() - 1, q6[q6.size() - 1].waddr, q6.size() - 2, q6[q6.size() - 2].raddr, q6.size()-1, q6[q6.size()-1].raddr), UVM_LOW)
      end
      else begin
        write_followed_by_read_incr = 0;
        `uvm_info(get_full_name(), $sformatf("COVERAGE: WRITE FOLLOWED BY READ INCR NOTHIT: q6[%0d].waddr = %0h  q6[%0d].waddr=%0h, q6[%0d].raddr = %0h, q6[%0d].raddr = %0h",q6.size()-2, q6[q6.size()-2].waddr, q6.size() - 1, q6[q6.size() - 1].waddr, q6.size() - 2, q6[q6.size() - 2].raddr, q6.size()-1, q6[q6.size()-1].raddr), UVM_LOW)
      end
       cg.sample();
    `uvm_info(get_full_name(), $sformatf("COVERAGE WRITE FOLLOWED BY READ INCR WRITE AND READ ADDRESS = %0.2f%%\n", cg.WRITE_FOLLOWED_BY_READ_INCR.get_inst_coverage()),UVM_LOW)                  
      q6.pop_back();
       write_followed_by_read_incr = 0;  
  endfunction
  
  
  // WRITE EVEN READ ODD LOCATION 
  function void f_wr_even_rd_odd();
    if(((q7[q7.size()-2].raddr%2 != 0) && (q7[q7.size()-2].r_en == 1)) && ((q7[q7.size()-1].waddr%2 == 0) && (q7[q7.size()-1].w_en == 1)))begin
      write_even_read_odd_loc = 1;
      `uvm_info(get_full_name(), $sformatf("Coverage Function WRITE EVEN READ ODD LOCATION HIT:%d q7[%0d].raddr = %0h, q7[%0d].r_en=%0h, q7[%0d].waddr=%0h q7[%0d].w_en=%0h ",write_even_read_odd_loc, q7.size()-2, q7[q7.size()-2].raddr, q7.size()-2, q7[q7.size()-2].r_en, q7.size()-1, q7[q7.size()-1].waddr,q7.size()-1, q7[q7.size()-1].w_en ),UVM_MEDIUM);
    end
    else begin
      write_even_read_odd_loc = 0;
      `uvm_info(get_full_name(), $sformatf("Coverage Function WRITE EVEN READ ODD LOCATION NOTHIT:%d q7[%0d].raddr = %0h, q7[%0d].r_en=%0h, q7[%0d].waddr=%0h q7[%0d].w_en=%0h ",write_even_read_odd_loc, q7.size()-2, q7[q7.size()-2].raddr, q7.size()-2, q7[q7.size()-2].r_en, q7.size()-1, q7[q7.size()-1].waddr,q7.size()-1, q7[q7.size()-1].w_en ),UVM_MEDIUM);
    end
    cg.sample();
    q7.pop_back();
    `uvm_info(get_full_name(), $sformatf("coverage of WRITE EVEN READ ODD LOCATION = %0.2f%%\n",cg.WR_EVEN_RD_ODD_LOC.get_inst_coverage()),UVM_MEDIUM); 
  endfunction
  
  // WRITE ODD READ EVEN LOCATION 
  function void f_wr_odd_rd_even();
    if(((q8[q8.size()-2].raddr%2 == 0) && (q8[q8.size()-2].r_en == 1)) && ((q8[q8.size()-1].waddr%2 != 0) && (q8[q8.size()-1].w_en == 1)))begin
      write_odd_read_even_loc = 1;
      `uvm_info(get_full_name(), $sformatf("Coverage Function WRITE ODD READ EVEN LOCATION HIT:%d q8[%0d].raddr = %0h, q8[%0d].r_en=%0h, q8[%0d].waddr=%0h q8[%0d].w_en=%0h ",write_odd_read_even_loc, q8.size()-2, q8[q8.size()-2].raddr, q8.size()-2, q8[q8.size()-2].r_en, q8.size()-1, q8[q8.size()-1].waddr,q8.size()-1, q8[q8.size()-1].w_en ),UVM_MEDIUM);
    end
    else begin
      write_odd_read_even_loc = 0;
      `uvm_info(get_full_name(), $sformatf("Coverage Function WRITE ODD READ EVEN LOCATION NOTHIT:%d q8[%0d].raddr = %0h, q8[%0d].r_en=%0h, q8[%0d].waddr=%0h q8[%0d].w_en=%0h ",write_odd_read_even_loc, q8.size()-2, q8[q8.size()-2].raddr, q8.size()-2, q8[q8.size()-2].r_en, q8.size()-1, q8[q8.size()-1].waddr,q8.size()-1, q8[q8.size()-1].w_en ),UVM_MEDIUM);
    end
    cg.sample();
    q8.pop_back();
    `uvm_info(get_full_name(), $sformatf("coverage of WRITE ODD READ EVEN LOCATION = %0.2f%%\n",cg.WR_ODD_RD_EVEN_LOC.get_inst_coverage()),UVM_MEDIUM); 
  endfunction
  
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name()," [FUNC_CVG]: RUN_TASK TRIGGERD", UVM_MEDIUM)
    forever begin
      super.run_phase(phase);
      cvg_pkts = transaction#(M,N)::type_id::create("cvg_pkts");
      cvg_af.get (cvg_pkts);
      `uvm_info ("FUNC_CVG" , cvg_pkts.sprint(), UVM_LOW) 
        if(cvg_pkts.w_en == 1) q1.push_front(cvg_pkts);
        q2.push_front(cvg_pkts);
        if(cvg_pkts.w_en == 1)q3.push_front(cvg_pkts);
        q4.push_front(cvg_pkts);
        q5.push_front(cvg_pkts);
        q6.push_front(cvg_pkts);   
        q7.push_front(cvg_pkts);   
        q8.push_front(cvg_pkts);   
      
      if(q1.size() > 1) begin
         f_write_only_random(cvg_pkts);
       end
      
      if(q2.size() > 1) begin
        f_read_only_random(cvg_pkts);
      end
      
      if(q3.size() > 1) begin
        f_write_only_incr(cvg_pkts);
      end
      
      if(q4.size() > 1) begin   
        f_read_only_incr(cvg_pkts);
      end
      
      if(q5.size() > 1) begin   
        f_write_followed_by_read_random(cvg_pkts);
      end
      
      if(q6.size() > 1) begin   
        f_write_followed_by_read_incr(cvg_pkts);
      end
      
      if(q7.size() > 1) begin   
        f_wr_even_rd_odd();
      end
      
      if(q8.size() > 1) begin   
        f_wr_odd_rd_even();
      end
       cg.sample();
      
      `uvm_info("FUNC_CVG",$sformatf("coverage of write enable= %0.2f%%,read enable= %0.2f%%",cg.WRITE_EN.get_coverage(), cg.READ_EN.get_coverage()),UVM_LOW);  
      `uvm_info("FUNC_CVG",$sformatf("coverage of wdata enable= %0.2f%%, rdata= %0.2f%%",cg.WDATA_CP.get_coverage(), cg.RDATA_CP.get_coverage()),UVM_LOW);         `uvm_info("FUNC_CVG",$sformatf("coverage of waddr enable= %0.2f%%, raddr= %0.2f%%",cg.WADDR_CP.get_coverage(), cg.RADDR_CP.get_coverage()),UVM_LOW);         `uvm_info("FUNC_CVG",$sformatf("CROSS WRITEXADDR enable= %0.2f%%, READXADDR= %0.2f%%",cg.WENXWADDR.get_coverage(), cg.RENXRADDR.get_coverage()),UVM_LOW);
      `uvm_info("FUNC_CVG",$sformatf("OVERALL CVG = %0.2f%%", cg.get_coverage()),UVM_LOW);
      `uvm_info(get_full_name()," [FUNC_CVG]: RUN_TASK EXIT", UVM_MEDIUM)
    end
  endtask
endclass