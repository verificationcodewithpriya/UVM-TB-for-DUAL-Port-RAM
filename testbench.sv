interface interface_if #(parameter M=3, parameter N=8)(input clk, rst);
   logic w_en, r_en;
   logic [M-1:0]waddr, raddr;
   logic [N-1:0]wdata;
   logic [N-1:0]rdata;
  
  reg[N-1:0]dut_mem[(2**M)-1:0];
  assign dut_mem = top.dut.mem;
  
   clocking driver_cb @(posedge clk);
      default input #0 output #2;
      output w_en, r_en;
      output waddr, raddr;
      output wdata;
      input rdata;
   endclocking
  
   clocking monitor_cb @(posedge clk);
      default input #0 output #0;
      input w_en, r_en;
      input waddr, raddr;
      input wdata;
      input rdata;
   endclocking
  
  modport clocking_mod(clocking driver_cb, clocking monitor_cb, input rst);
  modport dut_mod(input clk, rst, w_en, r_en, waddr, raddr, wdata, output rdata);
endinterface
    
     
`include "env_pkg.sv"
module top;
  
  import  uvm_pkg :: *;
  `include "uvm_macros.svh"
  import env_pkg :: *;
  
  bit clk, rst;
  int total_tx;
  
  interface_if intf(clk, rst);
  
  DUAL_PORT_RAM dut(.clk(intf.clk),
                   .reset(intf.rst),
                   .wr_en(intf.w_en),
                   .r_en(intf.r_en),
                   .waddr(intf.waddr),
                   .wdata(intf.wdata),
                   .raddr(intf.raddr),
                   .rdata(intf.rdata)
                   );
  
  initial begin
     $dumpfile("dump.vcd"); $dumpvars;
     clk = 0;
     forever #5 clk = ~clk;
   end
  
  task reset_mode();
    rst = 1;
    repeat(3)@(posedge clk);
    rst = 0;
    repeat(3)@(posedge clk);
  endtask
  
  config_obj cfg;
  initial begin
    fork
      begin
        reset_mode();
      end
      begin
        cfg = config_obj::type_id::create ("cfg");
        cfg.is_active = UVM_ACTIVE;
        cfg.vif = intf;
        total_tx = 7;
        uvm_config_db#(config_obj)::set(null,"*","config_obj",cfg);
        uvm_config_db #(int) :: set (null , "*" , "str" , total_tx);
        run_test("base_test");
      end
    join
  end
endmodule      