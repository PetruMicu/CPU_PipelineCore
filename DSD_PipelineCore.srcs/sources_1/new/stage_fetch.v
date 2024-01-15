`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:17:12 PM
// Design Name: 
// Module Name: seq_core_fetch
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


module stage_fetch(
    // general
    input                    rst_n,   // active 0
    input                    clk,
    // pipeline signals (active 1)
    input                    pipeline_flush,
    input                    pc_halt,
    input                    pc_load,
    input [`A_SIZE-1:0]      pc_jmp_addr,
    input [`A_SIZE-1:0]      pc_jmp_offset,
    // program memory
    output reg [`A_SIZE-1:0] pc,
    input      [15:0]        instruction,
    // instruction register
    output reg [15:0] instruction_reg
 );
 
 // PC
 always@(posedge clk or negedge rst_n) begin
    if (rst_n == 0)
        pc <= 0;
    else if (pc_halt == 1)
        pc <= pc;
    else if (pc_load)
        if (pc_jmp_offset == 0)
            pc <= pc_jmp_addr;
        else
            pc <= pc - 2 + pc_jmp_offset; // pipeline correction
    else
        pc <= pc + 1;
 end
 
 //instruction register
  always@(posedge clk or negedge rst_n) begin
    if ((rst_n == 0) || (pipeline_flush == 1))
        instruction_reg <= 0;
    else if (pc_halt)
        instruction_reg <= instruction_reg;
    else
        instruction_reg <= instruction;
  end

endmodule
