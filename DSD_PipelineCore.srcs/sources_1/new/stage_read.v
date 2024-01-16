`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:17:12 PM
// Design Name: 
// Module Name: seq_core_decode
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


module stage_read(
    //input from intruction register
    input  [15:0]               instruction_reg,
    // interface with reg_module
    input  [`D_SIZE-1:0]        reg_data1,
    input  [`D_SIZE-1:0]        reg_data2,
    output reg [`R_SIZE-1:0]    reg_addr1,
    output reg [`R_SIZE-1:0]    reg_addr2,
    // output to decode_execute_pipeline_reg
    output reg [`D_SIZE-1:0]    operand1,
    output reg [`D_SIZE-1:0]    operand2,
    output reg [`R_SIZE-1:0]    dest_addr,
    output reg [`OP_SIZE-1:0]   opcode
    );
    
    
always@(*) begin
    reg_addr1 = 0;
    reg_addr2 = 0;
    operand1 = 0;
    operand2 = 0;
    dest_addr = 0;
    // store opcode to feed into decode_execute_pipeline_reg
    opcode = instruction_reg[15:9];
    
    // check first 2 bits for op type
    case(instruction_reg[15:14])
        `ARITHMETIC: begin
            // set register addresses contained in the instruction
            dest_addr = instruction_reg[8:6];
            reg_addr1 = instruction_reg[5:3];
            reg_addr2 = instruction_reg[2:0];
            
            // read operands from the outputs of reg_module
            operand1 = reg_data1;
            operand2 = reg_data2;
         end
        `SHIFT: begin
            // set register addresses contained in the instruction
            dest_addr = instruction_reg[8:6];
            reg_addr1 = instruction_reg[8:6];
            
            // read operand from the outputs of reg_module
            operand1 = reg_data1;
            // read operand contained in the instruction
            operand2 = instruction_reg[5:0];
         end
        `MEM: begin
            if (instruction_reg[15:11] == `LOAD) begin
                // set register addresses contained in the instruction
                dest_addr = instruction_reg[10:8];
                reg_addr1 = instruction_reg[2:0];
                
                // read operand from the outputs of reg_module
                operand1 = reg_data1;
            end else if (instruction_reg[15:11] == `LOADC) begin
                // set register addresses contained in the instruction
                dest_addr = instruction_reg[10:8];
                reg_addr1 = instruction_reg[10:8];
                
                // read operand from the outputs of reg_module
                operand1 = reg_data1;
                // read operand contained in the instruction
                operand2 = instruction_reg[7:0];
            end else if (instruction_reg[15:11] == `STORE) begin
                // set register addresses contained in the instruction
                reg_addr1 = instruction_reg[10:8];
                reg_addr2 = instruction_reg[2:0];
                
                // read operand from the outputs of reg_module
                operand1 = reg_data1;
                operand2 = reg_data2;
            end
         end
         `COND: begin
            case (instruction_reg[15:12])
                `JMP: begin
                    // set register address contained in the instruction
                    reg_addr1 = instruction_reg[2:0];
                    
                    // read operand from the outputs of reg_module
                    operand1 = reg_data1;
                 end
                `JMPR: begin
                    operand1 = {{`A_SIZE-6{instruction_reg[5]}},instruction_reg[5:0]};
                 end
                 `JMPcond: begin
                     // set register address contained in the instruction
                     reg_addr1 = instruction_reg[8:6];
                     reg_addr2 = instruction_reg[2:0];
                     
                     // read operand from the outputs of reg_module
                     operand1 = reg_data1;
                     operand2 = reg_data2;
                 end
                 `JMPRcond: begin
                    // set register address contained in the instruction
                    reg_addr1    = instruction_reg[8:6];
                    
                    // read operand from the outputs of reg_module
                    operand1 = reg_data1;
                    operand2 = {{`A_SIZE-6{instruction_reg[5]}},instruction_reg[5:0]};
                 end
            endcase
        end
    endcase
end
    
endmodule
