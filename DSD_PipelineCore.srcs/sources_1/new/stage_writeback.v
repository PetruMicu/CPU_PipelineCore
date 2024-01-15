`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:44:56 PM
// Design Name: 
// Module Name: stage_writeback
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


module stage_writeback(
    // input from execute_writeback_pipeline_reg
    input [`D_SIZE-1:0]         input_result,
    input [`R_SIZE-1:0]         input_dest_addr,
    input                       writeback_operation, // if 1, then result has to be stored in reg_module
    input                       read_en,
    // input from ram_module
    input [`D_SIZE-1:0]         ram_data_in,
    //output to reg_module
    output reg [`R_SIZE-1:0]    output_dest_addr,
    output reg [`D_SIZE-1:0]    output_result,
    output reg                  write_en
);

always@(*) begin
    output_dest_addr = 0;
    output_result = 0;
    write_en = 0;
    if (read_en == 1 && writeback_operation == 1) begin
        output_result = ram_data_in;
        output_dest_addr = input_dest_addr;
        write_en = 1;
    end else if (writeback_operation == 1) begin
        output_result = input_result;
        output_dest_addr = input_dest_addr;
        write_en = 1;
    end
end

endmodule
