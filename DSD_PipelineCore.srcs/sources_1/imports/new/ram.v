`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 11:39:21 PM
// Design Name: 
// Module Name: ram
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


module ram_module(
    input                    rst_n,
    input                    clk,
    input                    read_enable, //active 1
    input                    write_enable, //active 1
    input      [`A_SIZE-1:0] address,
    input      [`D_SIZE-1:0] data_in,
    output reg [`D_SIZE-1:0] data_out
    );
    
reg [`D_SIZE-1:0] ram_array [0:`RAM_SIZE-1];
integer idx;

always @(posedge clk) begin
    if (rst_n == 0) begin
        for (idx = 0; idx < `RAM_SIZE; idx = idx + 1) begin
            ram_array[idx] <= 0;
        end
        data_out <= 0;
    end else if (write_enable == 1) begin
        ram_array[address] <= data_in;
    end else if (read_enable == 1) begin
        data_out <= ram_array[address];
    end
end

/*reading is asynchronous*/
// assign data_out = (read_enable == 1'b1)? ram_array[address] : `D_SIZE'd0;

endmodule
