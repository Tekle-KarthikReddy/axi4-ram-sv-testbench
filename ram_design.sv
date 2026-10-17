module ram_design #(parameter addr_width =4,data_width=32,depth=16)(
        input clk,rst,wr_en,
        input [addr_width-1:0] addr,
        input [data_width-1:0] wdata,
        output reg [data_width-1:0] rdata);

reg [data_width-1:0] mem[0:depth-1];
integer i;
initial for(i=0;i<depth;i=i+1) mem[i] =0;

always@(posedge clk) begin
        if(rst)
                rdata<=0;
        else if(wr_en)
                mem[addr] <=wdata;
        else
                rdata <= mem[addr];
end
endmodule
