`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:11:59 PM
// Design Name: 
// Module Name: seq_core
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


module seq_core(
    // general
    input                   rst_n, // active 0
    input                   clk,
    // program memory
    output [`A_SIZE-1:0]    pc,
    input  [15:0]           instruction,
    // data memory
    output                  read,  // active 1
    output                  write, // active 1
    output [`A_SIZE-1:0]    address,
    input  [`D_SIZE-1:0]    data_in,
    output [`D_SIZE-1:0]    data_out
);

wire                    wire_pipeline_flush;
wire                    wire_pc_halt;
wire                    wire_pc_load;
wire [`A_SIZE-1:0]      wire_pc_jmp_addr;
wire [`A_SIZE-1:0]      wire_pc_jmp_offset;
wire [15:0]             wire_instruction_reg;

wire [`R_SIZE-1:0]      wire_reg_addr1;
wire [`R_SIZE-1:0]      wire_reg_addr2;
wire [`D_SIZE-1:0]      wire_reg_data1;
wire [`D_SIZE-1:0]      wire_reg_data2;

wire [`R_SIZE-1:0]      wire_reg1_dest_addr;
wire [`D_SIZE-1:0]      wire_reg1_operand1;
wire [`D_SIZE-1:0]      wire_reg1_operand2;
wire [6:0]              wire_reg1_opcode;

wire [`R_SIZE-1:0]      wire_exec_dest_addr;
wire [`D_SIZE-1:0]      wire_exec_operand1;
wire [`D_SIZE-1:0]      wire_exec_operand2;
wire [6:0]              wire_exec_opcode;

wire [`D_SIZE-1:0]      wire_reg2_result;
wire [`R_SIZE-1:0]      wire_reg2_dest_addr;
wire                    wire_reg2_writeback_operation; 
wire                    wire_reg2_read_en;
wire                    wire_reg2_write_en;

wire [`D_SIZE-1:0]      wire_result;
wire [`R_SIZE-1:0]      wire_dest_addr;
wire                    wire_writeback_operation; 
wire                    wire_read_en;

wire [`R_SIZE-1:0]      wire_reg_dest_addr;
wire [`D_SIZE-1:0]      wire_reg_result;
// wire                    wire_reg_write_en;

/****************************************************************************************************
*                                                 REG_MODULE                                        *
****************************************************************************************************/

reg_module reg_file(
    .rst_n                      (rst_n),
    .clk                        (clk),
    .write_enable               (wire_reg_write_en),
    .write_addr                 (wire_reg_dest_addr),
    .read1_addr                 (wire_reg_addr1),
    .read2_addr                 (wire_reg_addr2),
    .data_in                    (wire_reg_result),
    .data1_out                  (wire_reg_data1),
    .data2_out                  (wire_reg_data2)
);

/****************************************************************************************************
*                                                 FETCH                                             *
****************************************************************************************************/

stage_fetch fetch_module(
    .rst_n                      (rst_n),
    .clk                        (clk),
    .pipeline_flush             (wire_pipeline_flush),
    .pc_halt                    (wire_pc_halt),
    .pc_load                    (wire_pc_load),
    .pc_jmp_addr                (wire_pc_jmp_addr),
    .pc_jmp_offset              (wire_pc_jmp_offset),
    .pc                         (pc),
    .instruction                (instruction),
    .instruction_reg            (wire_instruction_reg)
);

/****************************************************************************************************
*                                                 READ                                              *
****************************************************************************************************/

stage_read read_module(
    .instruction_reg            (wire_instruction_reg),
    .reg_data1                  (wire_reg_data1),
    .reg_data2                  (wire_reg_data2),
    .reg_addr1                  (wire_reg_addr1),
    .reg_addr2                  (wire_reg_addr2),
    .operand1                   (wire_reg1_operand1),
    .operand2                   (wire_reg1_operand2),
    .dest_addr                  (wire_reg1_dest_addr),
    .opcode                     (wire_reg1_opcode)
);

/****************************************************************************************************
*                                                 PIPELINE REG 1                                    *
****************************************************************************************************/

read_execute_pipeline_reg pipeline_reg1(
    .rst_n                      (rst_n),
    .clk                        (clk),
    .pipeline_flush             (wire_pipeline_flush),
    .pc_halt                    (wire_pc_halt),
    .input_opcode               (wire_reg1_opcode),
    .input_dest_addr            (wire_reg1_dest_addr),
    .input_operand1             (wire_reg1_operand1),
    .input_operand2             (wire_reg1_operand2),
    .output_opcode              (wire_exec_opcode),
    .output_dest_addr           (wire_exec_dest_addr),
    .output_operand1            (wire_exec_operand1),
    .output_operand2            (wire_exec_operand2)
);

/****************************************************************************************************
*                                                 EXECUTE                                           *
****************************************************************************************************/

stage_execute execute_module(
    .opcode                     (wire_exec_opcode),
    .operand1                   (wire_exec_operand1),
    .operand2                   (wire_exec_operand2),
    .input_dest_addr            (wire_exec_dest_addr),
    .ram_addr                   (address),
    .ram_data_out               (data_out),
    .result                     (wire_reg2_result),
    .dest_addr                  (wire_reg2_dest_addr),
    .writeback_operation        (wire_reg2_writeback_operation),
    .write_en                   (write),
    .read_en                    (wire_reg2_read_en),
    .pipeline_flush             (wire_pipeline_flush),
    .pc_halt                    (wire_pc_halt),
    .pc_load                    (wire_pc_load),
    .pc_jmp_addr                (wire_pc_jmp_addr),
    .pc_jmp_offset              (wire_pc_jmp_offset)
);

/****************************************************************************************************
*                                                  PIPELINE REG 2                                   *
****************************************************************************************************/

execute_writeback_pipeline_reg pipeline_reg2(
    .rst_n                      (rst_n),
    .clk                        (clk),
    .pipeline_flush             (wire_pipeline_flush),
    .pc_halt                    (wire_pc_halt),
    .input_result               (wire_reg2_result),
    .input_dest_addr            (wire_reg2_dest_addr),
    .input_writeback_operation  (wire_reg2_writeback_operation), 
    .input_read_en              (wire_reg2_read_en),
    // .input_write_en             (wire_reg2_write_en),
    .output_result              (wire_result),
    .output_dest_addr           (wire_dest_addr),
    .output_writeback_operation (wire_writeback_operation),
    .output_read_en             (read)
    // .output_write_en            (write)
);

/****************************************************************************************************
*                                                  WRITEBACK                                        *
****************************************************************************************************/

stage_writeback writeback_module(
    .input_result               (wire_result),
    .input_dest_addr            (wire_dest_addr),
    .writeback_operation        (wire_writeback_operation),
    .read_en                    (read),
    .ram_data_in                (data_in),
    .output_dest_addr           (wire_reg_dest_addr),
    .output_result              (wire_reg_result),
    .write_en                   (wire_reg_write_en)
);

endmodule
