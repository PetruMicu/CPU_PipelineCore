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
    output reg              forward_flag1, // 1 if result should be forwarded on operand1
    output reg              forward_flag2 // 1 if result should be forwarded on operand2
);

always@(*) begin
    forward_flag1 = 0;
    if ((dest_addr_pipeline_reg2 == src_addr1) & (writeback_operation == 1)) begin
        case (opcode)
            `ARITHMETIC,
            `SHIFT:
                begin
                   forward_flag1 = 1; 
                end
        endcase
    end
end

always@(*) begin
    forward_flag2 = 0;
    if ((dest_addr_pipeline_reg2 == src_addr2) & (writeback_operation == 1)) begin
        case (opcode)
            `ARITHMETIC,
            `SHIFT:
                begin
                   forward_flag2 = 1; 
                end
        endcase
    end
end
endmodule
