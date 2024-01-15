`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 08:35:27 PM
// Design Name: 
// Module Name: reg_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_module(
    input rst_n,
    input clk,
    input write_enable, //active 1
    input [`R_SIZE-1:0] write_addr,
    input [`R_SIZE-1:0] read1_addr,
    input [`R_SIZE-1:0] read2_addr,
    input [`D_SIZE-1:0] data_in,
    output [`D_SIZE-1:0] data1_out,
    output [`D_SIZE-1:0] data2_out
    );
    
reg [`D_SIZE-1:0] registers [0:`R_NUM-1]; // 8 internal registers R0 to R7
integer idx;


/*synchronous writing and resetting on positive edge of the clk*/
always@(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        for (idx = 0; idx < `R_NUM; idx = idx + 1) begin
            registers[idx] <= 0;
        end
    end else if (write_enable == 1'b1) begin
        registers[write_addr] = data_in;
    end
end

/*asynhronous reading*/
assign data1_out = (rst_n == 1'b0) ? 0 : registers[read1_addr];
assign data2_out = (rst_n == 1'b0) ? 0 : registers[read2_addr];

endmodule