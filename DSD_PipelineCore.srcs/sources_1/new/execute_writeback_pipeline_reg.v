`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:41:39 PM
// Design Name: 
// Module Name: execute_writeback_pipeline_reg
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


module execute_writeback_pipeline_reg(
    // general
    input                       rst_n,   // active 0
    input                       clk,
    // input pipeline signals (active 1)
    input                       pipeline_flush,
    input                       pc_halt,
    // input from stage_execute
    input [`D_SIZE-1:0]         input_result,
    input [`R_SIZE-1:0]         input_dest_addr,
    input                       input_writeback_operation, // if 1, then result has to be stored in reg_module
    input                       input_read_en,
    // input                       input_write_en,
    // output to stage_writeback
    output reg [`D_SIZE-1:0]    output_result,
    output reg [`R_SIZE-1:0]    output_dest_addr,
    output reg                  output_writeback_operation, // if 1, then result has to be stored in reg_module
    output reg                  output_read_en
    // output reg                  output_write_en
);

always@(posedge clk or negedge rst_n) begin
    if ((rst_n == 0) || (pipeline_flush == 1)) begin
        //reset pipeline register
        output_result               <= 0;
        output_dest_addr            <= 0;
        output_writeback_operation  <= 0;
        output_read_en              <= 0;
        // output_write_en             <= 0;
    end else if (pc_halt == 1) begin
        //keep current values, processor has been halted
        output_result               <= output_result;
        output_dest_addr            <= output_dest_addr;
        output_writeback_operation  <= output_writeback_operation;
        output_read_en              <= output_read_en;
        // output_write_en             <= output_write_en;
    end else begin
        //store next instruction parameters
        output_result               <= input_result;
        output_dest_addr            <= input_dest_addr;
        output_writeback_operation  <= input_writeback_operation;
        output_read_en              <= input_read_en;
        // output_write_en             <= input_write_en;
    end
end
endmodule
