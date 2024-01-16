`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:41:39 PM
// Design Name: 
// Module Name: decode_execute_pipeline_reg
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


module read_execute_pipeline_reg(
    // general
    input                       rst_n,   // active 0
    input                       clk,
    // pipeline signals (active 1)
    input                       pipeline_flush,
    input                       pc_halt,
    // input from stage_read
    input [`OP_SIZE-1:0]        input_opcode,
    input[`R_SIZE-1:0]          input_src_addr1,
    input[`R_SIZE-1:0]          input_src_addr2,
    input [`R_SIZE-1:0]         input_dest_addr,
    input [`D_SIZE-1:0]         input_operand1,
    input [`D_SIZE-1:0]         input_operand2,
    //output to stage_execute
    output reg [`OP_SIZE-1:0]   output_opcode,
    output reg [`R_SIZE-1:0]    output_src_addr1,
    output reg [`R_SIZE-1:0]    output_src_addr2,
    output reg [`R_SIZE-1:0]    output_dest_addr,
    output reg [`D_SIZE-1:0]    output_operand1,
    output reg [`D_SIZE-1:0]    output_operand2
);

always@(posedge clk or negedge rst_n) begin
    if ((rst_n == 0) || (pipeline_flush == 1)) begin
        //reset pipeline register
        output_opcode <= 0;
        output_dest_addr <= 0;
        output_operand1 <= 0;
        output_operand2 <= 0;
        output_src_addr1 <= 0;
        output_src_addr2 <= 0;
    end else if (pc_halt == 1) begin
        //keep current values, processor has been halted
        output_opcode <= output_opcode;
        output_dest_addr <= output_dest_addr;
        output_operand1 <= output_operand1;
        output_operand2 <= output_operand2;
        output_src_addr1 <= output_src_addr1;
        output_src_addr2 <= output_src_addr2;
    end else begin
        //store next instruction parameters
        output_opcode <= input_opcode;
        output_dest_addr <= input_dest_addr;
        output_operand1 <= input_operand1;
        output_operand2 <= input_operand2;
        output_src_addr1 <= input_src_addr1;
        output_src_addr2 <= input_src_addr2;
    end
end

endmodule
