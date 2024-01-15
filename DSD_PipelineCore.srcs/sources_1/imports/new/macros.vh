/* Address bus size*/
`define A_SIZE 10

/* Data bus size*/
`define D_SIZE 32

/* Instruction size*/
`define I_SIZE 16

/*RAM size*/
`define RAM_SIZE 128

/*CPU Registers*/
`define R_NUM 8
`define R_SIZE 3
`define R0 3'd0
`define R1 3'd1
`define R2 3'd2
`define R3 3'd3
`define R4 3'd4
`define R5 3'd5
`define R6 3'd6
`define R7 3'd7

/*OPCODES*/
`define ARITHMETIC 2'b00
`define SHIFT      2'b01
`define MEM        2'b10
`define COND       2'b11

/*ARITHMETIC*/
`define ADD      7'b000_0001
`define ADDF     7'b000_0010
`define SUB      7'b000_0011
`define SUBF     7'b000_0100
`define AND      7'b000_0101
`define OR       7'b000_0110
`define XOR      7'b000_0111
`define NAND     7'b000_1000
`define NXOR     7'b000_1001

/*SHIFT*/
`define SHIFTR   7'b010_0000
`define SHIFTRA  7'b010_0001
`define SHIFTL   7'b010_0010

/*MEM*/
`define LOAD     5'b1_0000
`define LOADC    5'b1_0001
`define STORE    5'b1_0010

/*COND*/
`define JMP      4'b1100
`define JMPR     4'b1101
`define JMPcond  4'b1110
`define JMPRcond 4'b1111

`define HALT     16'hFFFF
`define NOP      16'h0000

`define HALT_OP  7'b111_1111
`define NOP_OP   7'b000_0000

/*OPCODES*/
`define OP_SIZE 7
`define OP_TYPE 2

/*CONDITIONS*/

`define N   3'b000
`define NN  3'b001
`define Z   3'b010
`define NZ  3'b011