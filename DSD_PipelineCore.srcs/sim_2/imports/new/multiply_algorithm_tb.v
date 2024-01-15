`timescale 1ns / 1ps
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


module multiply_algorithm_tb(

    );
    
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
  
    prog_mem[0] = {`NOP};
    prog_mem[1] = {`LOADC, `R0, 8'd7}; // i - number to be multiplied
    prog_mem[2] = {`LOADC, `R1, 8'd3}; // n - numberrs of multiplies
    prog_mem[3] = {`LOADC, `R3, 8'd0}; // result - initial value is 0
    prog_mem[4] = {`LOADC, `R4, 8'd1}; // decrement value
    
    prog_mem[5] = {`JMPRcond, `Z, `R1, 6'd4}; // jumps to prog_mem[9] if R1 reaches 0
    // multiply loop
    prog_mem[6] = {`ADD, `R3, `R3, `R0}; // result = result + i
   
    prog_mem[7] = {`SUB, `R1, `R1, `R4}; // n = n - 1 
    prog_mem[8] = {`JMPR, 6'd0, 6'b11_1101}; // jumps to prog_mem[5]
    prog_mem[9] = {`STORE, `R1, 5'b0, `R3};
    prog_mem[10] = {`NOP};
    prog_mem[10] = {`NOP};
    prog_mem[10] = {`NOP};
    prog_mem[10] = {`NOP};
    prog_mem[10] = {`NOP};
    prog_mem[10] = {`NOP};
    prog_mem[10] = {`NOP};
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
