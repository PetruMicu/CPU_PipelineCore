`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 09:17:23 PM
// Design Name: 
// Module Name: Mux
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


module mux(
    input [1:0]                 sel,
    input [`D_SIZE-1:0]         input1,
    input [`D_SIZE-1:0]         input2,
    input [`D_SIZE-1:0]         input3,
    output [`D_SIZE-1:0]        selected_output
);


assign selected_output = (sel[0] == 0) ? input1 : ((sel[1] == 0) ? input2 : input3);
    
endmodule
