`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:17:12 PM
// Design Name: 
// Module Name: dependency_control
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


module dependency_control(
    input [6:0]             opcode,
    input [`R_SIZE-1:0]     src_addr1,
    input [`R_SIZE-1:0]     src_addr2,
    input [`R_SIZE-1:0]     dest_addr_pipeline_reg2,
    input [`R_SIZE-1:0]     dest_writeback,
    input                   writeback_operation,
    input                   ram_read_operation,
    output                  pipeline_stall,
    output reg [1:0]        forward_flag1, // 1 if result should be forwarded on operand1
    output reg [1:0]        forward_flag2 // 1 if result should be forwarded on operand2
);

assign pipeline_stall = ((dest_addr_pipeline_reg2 == src_addr1) | (dest_addr_pipeline_reg2 == src_addr2)) & ram_read_operation & writeback_operation;

always@(*) begin
    forward_flag1 = 0;
    if ((dest_addr_pipeline_reg2 == src_addr1) & (writeback_operation == 1)) begin
        case (opcode[6:5])
            `ARITHMETIC,
            `SHIFT,
            `COND:
                   forward_flag1 = 2'b01; 
            `MEM:
                if (opcode[6:2] != `LOADC) begin
                    forward_flag1 = 2'b01; 
                end
        endcase
    end
    if ((dest_writeback == src_addr1) & (writeback_operation == 1)) begin
        case (opcode[6:5])
            `ARITHMETIC,
            `SHIFT,
            `COND:
                   forward_flag1 = 2'b11; 
            `MEM:
                if (opcode[6:2] != `LOADC) begin
                    forward_flag1 = 2'b11; 
                end
        endcase
    end
end

always@(*) begin
    forward_flag2 = 0;
    if ((dest_addr_pipeline_reg2 == src_addr2) & (writeback_operation == 1)) begin
        case (opcode[6:5])
            `ARITHMETIC,
            `SHIFT,
            `COND:
                   forward_flag2 = 2'b01; 
            `MEM:
                if (opcode[6:2] != `LOADC) begin
                    forward_flag2 = 2'b01; 
                end
        endcase
    end
    if ((dest_writeback == src_addr2) & (writeback_operation == 1)) begin
        case (opcode[6:5])
            `ARITHMETIC,
            `SHIFT,
            `COND:
                   forward_flag2 = 2'b11; 
            `MEM:
                if (opcode[6:2] != `LOADC) begin
                    forward_flag2 = 2'b11; 
                end
        endcase
    end
end
endmodule
