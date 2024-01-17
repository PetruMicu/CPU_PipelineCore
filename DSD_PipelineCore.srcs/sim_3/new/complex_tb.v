`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2023 05:58:30 PM
// Design Name: 
// Module Name: seq_core_tb
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


module complex_tb(

    );

integer idx;
reg clk;
reg rst_n;

wire [`D_SIZE-1:0] data_in;
wire [`D_SIZE-1:0] data_out;
wire write_enable;
wire read_enable;
reg [15:0] instruction;
wire [`A_SIZE-1:0] instruction_addr;
wire [`A_SIZE-1:0] memory_addr;

reg [15:0] prog_mem[0:64];

seq_core cpu(
    .rst_n(rst_n),
    .clk(clk),
    .pc(instruction_addr),
    .instruction(instruction),
    .read(read_enable),
    .write(write_enable),
    .address(memory_addr),
    .data_in(data_in),
    .data_out(data_out)
);

ram_module ram (
    .clk (clk),
    .read_enable(read_enable),
    .write_enable(write_enable),
    .address(memory_addr),
    .data_in(data_out),
    .data_out(data_in)
);

integer i;

// Initialize clock and reset
  initial begin
    clk = 0;
    rst_n = 0;
    #6 rst_n = 1; // Release reset after 6 time units
  end

  // Generate a clock signal
  always begin
    #5 clk = ~clk; // Toggle the clock every 5 time units
  end
  
task pc_wait();
   @(instruction_addr);
endtask

  // Populate program memory
  initial begin
    for (idx = 0; idx < 18; idx = idx + 1) begin
        ram.ram_array[idx] = idx;
    end
    
    prog_mem[0] = {`NOP};
    prog_mem[1] = {`LOADC, `R0, 8'h9};
    prog_mem[2] = {`LOADC, `R1, 8'h1};
    prog_mem[3] = {`LOADC, `R2, 8'h0};
    prog_mem[4] = {`LOADC, `R3, 8'h9};
    prog_mem[5] = {`LOADC, `R4, 8'h18};
    prog_mem[6] = {`LOAD, `R5, 5'd0, `R2};
    prog_mem[7] = {`LOAD, `R6, 5'd0, `R3};
    prog_mem[8] = {`ADD, `R7, `R5, `R6};
    prog_mem[9] = {`NOP};
    prog_mem[10] = {`STORE, `R4, 5'd0, `R7};;
    prog_mem[11] = {`ADD, `R2, `R2, `R1};
    prog_mem[12] = {`ADD, `R3, `R3, `R1};
    prog_mem[13] = {`ADD, `R4, `R4, `R1};
    prog_mem[14] = {`SUB, `R0, `R0, `R1};
    prog_mem[15] = {`NOP};
    prog_mem[16] = {`NOP};
    prog_mem[17] = {`NOP};
    prog_mem[18] = {`JMPRcond, `NZ, `R0, -6'd11};
    prog_mem[19] = {`NOP};
    prog_mem[20] = {`NOP};
    prog_mem[21] = {`NOP};
    prog_mem[22] = {`NOP};
    prog_mem[23] = {`NOP};
    prog_mem[24] = {`HALT};
    instruction = prog_mem[0];
    
  end

  // Simulate program execution
  initial begin
    @(rst_n);
    // Loop to read and execute instructions
    while(instruction != `HALT) begin
      instruction = prog_mem[instruction_addr]; // Read an instruction from program memory
      if (instruction != `HALT)
        pc_wait();
    end

    $finish; // Finish the simulation when all instructions are executed
  end


endmodule
