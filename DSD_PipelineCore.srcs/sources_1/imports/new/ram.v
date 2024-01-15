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
    input                    clk,
    input                    read_enable, //active 1
    input                    write_enable, //active 1
    input      [`A_SIZE-1:0] address,
    input      [`D_SIZE-1:0] data_in,
    output reg [`D_SIZE-1:0] data_out
    );
    
reg [`D_SIZE-1:0] ram_array [0:`RAM_SIZE-1];
reg [`A_SIZE-1:0] read_address;
/*writing is synchronous*/
always @(posedge clk) begin
    if (write_enable) begin
        ram_array[address] <= data_in;
        read_address <= 0;
    end else begin
        read_address <= address;
    end
end

always @(posedge clk) begin
    if (read_enable) begin
        data_out <= ram_array[read_address];
    end else begin
        data_out <= 0;
    end
end
/*reading is asynchronous*/
// assign data_out = (read_enable == 1'b1)? ram_array[address] : `D_SIZE'd0;

endmodule
