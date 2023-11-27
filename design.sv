module DUAL_PORT_RAM #(parameter M=3, parameter N=8)(clk, reset, wr_en, r_en, waddr, raddr, wdata, rdata);
	input clk, reset, wr_en, r_en;
	input [M-1:0] waddr, raddr;
	input [N-1:0] wdata;
	output reg [N-1:0] rdata;
  
	reg [N-1:0]mem[(2**M)-1:0];
	
	always @(posedge clk) begin
      if(reset) 
        begin
           for(int i=0; i<2**M; i=i+1)
              mem[i]<='h00;
              rdata<='h00;
           end
	  else 
        if(reset==0)begin
			if(wr_en==1)
              mem[waddr] <= wdata;
			if(r_en==1)
              rdata<= mem[raddr];
	  end
	  else begin
	     rdata <= rdata;
	  end
    end
endmodule