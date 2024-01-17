`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:17:12 PM
// Design Name: 
// Module Name: writeback_dest_register
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


module writeback_dest_register(
    input                            clk,
    input                            rst_n,
    input                            pc_halt,
    input                            pipeline_flush,
    input                            pipeline_stall,
    input [`R_SIZE-1:0]              dest_addr,
    input [`D_SIZE-1:0]              result,
    output reg  [`R_SIZE-1:0]        clocked_dest_addr,
    output reg  [`D_SIZE-1:0]        clocked_result
);

always@(posedge clk or negedge rst_n) begin
    if (rst_n == 0 || pipeline_flush == 1) begin
        clocked_dest_addr <= 0;
        clocked_result <= 0;
    end else if (pc_halt == 1 || pipeline_stall == 1)begin
        clocked_dest_addr <= clocked_dest_addr;
        clocked_result <= clocked_result;
    end else begin
        clocked_dest_addr <= dest_addr;
        clocked_result <= result;
    end
end
endmodule
