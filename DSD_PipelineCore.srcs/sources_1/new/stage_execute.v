`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2024 05:17:12 PM
// Design Name: 
// Module Name: seq_core_execute
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


module stage_execute(
    // input from read_execute_pipeline_reg
    input [`OP_SIZE-1:0]        opcode,
    input [`D_SIZE-1:0]         operand1,
    input [`D_SIZE-1:0]         operand2,
    input [`R_SIZE-1:0]         input_dest_addr,
    //output to ram_module
    output reg [`A_SIZE-1:0]    ram_addr,
    output reg [`D_SIZE-1:0]    ram_data_out,
    //output to execute_writeback_pipeline_reg
    output reg [`D_SIZE-1:0]    result,
    output reg [`R_SIZE-1:0]    dest_addr,
    output reg                  writeback_operation, // if 1, then result has to be stored in reg_module
    output reg                  write_en,
    output reg                  read_en,
    //pipeline signals
    output reg                  pipeline_flush,
    output reg                  pc_halt,
    output reg                  pc_load,
    output reg [`A_SIZE-1:0]    pc_jmp_addr,
    output reg [`A_SIZE-1:0]    pc_jmp_offset
);

always@(*) begin
    ram_addr = 0;
    ram_data_out = 0;
    result = 0;
    dest_addr = 0;
    writeback_operation = 0;
    write_en = 0;
    read_en = 0;
    pipeline_flush = 0;
    pc_halt = 0;
    pc_load = 0;
    pc_jmp_addr = 0;
    pc_jmp_offset = 0;

    if (opcode == `NOP_OP) begin
        /*skip*/
    end else if (opcode == `HALT_OP) begin
        // halt the cpu
        pc_halt = 1;
    end else begin
        case (opcode[6:5])
            `ARITHMETIC: begin
                // set writeback signals
                writeback_operation = 1'b1;
                dest_addr = input_dest_addr;
                case (opcode)
                    `ADD,`ADDF:
                        result = operand1 + operand2;
                    `SUB, `SUBF:
                        result = operand1 - operand2;
                    `AND:
                        result = operand1 & operand2;
                    `OR:
                        result = operand1 || operand2;
                    `XOR:
                        result = operand1 ^ operand2;
                    `NAND:
                        result = ~(operand1 & operand2);
                    `NXOR:
                        result = ~(operand1 || operand2);
                endcase
            end
            `SHIFT: begin
                // set writeback signals
                writeback_operation = 1'b1;
                dest_addr = input_dest_addr;
                case (opcode)
                    `SHIFTR:
                        result = operand1 >> operand2;
                    `SHIFTRA:
                        result = operand1 >>> operand2;
                    `SHIFTL:
                        result = operand1 << operand2;
                endcase
            end
            `MEM: begin
                case (opcode[6:2])
                    `LOAD: begin
                        // set ram signals
                        dest_addr = input_dest_addr;
                        ram_addr = operand1;
                        read_en = 1'b1;
                        writeback_operation = 1'b1;
                    end
                    `LOADC: begin
                        // set ram signals
                        result = {operand1[`D_SIZE-1:8], operand2[7:0]};
                        dest_addr = input_dest_addr;
                        writeback_operation = 1'b1;
                    end
                    `STORE: begin
                        // set ram signals
                        ram_addr = operand1;
                        ram_data_out = operand2;
                        write_en = 1'b1;
                    end
                endcase
             end
             `COND: begin
                case (opcode[6:3])
                    `JMP: begin
                        pc_jmp_addr = operand1[`A_SIZE:0];
                        pc_load = 1'b1;
                        pipeline_flush = 1'b1;
                     end
                    `JMPR: begin
                        pc_jmp_offset = operand1;
                        pc_load = 1'b1;
                        pipeline_flush = 1'b1;
                     end
                     `JMPcond: begin
                        case (opcode[2:0])
                           `N: begin
                                if (operand1[`D_SIZE-1] == 1'b1) begin
                                    pc_jmp_addr = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                            `NN: begin
                                if (operand1[`D_SIZE-1] == 1'b0) begin
                                    pc_jmp_addr = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                            `Z: begin
                                if (operand1 == `D_SIZE'd0) begin
                                    pc_jmp_addr = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                            `NZ: begin
                                if (operand1 != `D_SIZE'd0) begin
                                    pc_jmp_addr = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                        endcase
                     end
                     `JMPRcond: begin
                        case (opcode[2:0])
                           `N: begin
                                if (operand1[`D_SIZE-1] == 1'b1) begin
                                    pc_jmp_offset = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                            `NN: begin
                                if (operand1[`D_SIZE-1] == 1'b0) begin
                                    pc_jmp_offset = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                            `Z: begin
                                if (operand1 == `D_SIZE'd0) begin
                                    pc_jmp_offset = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                            `NZ: begin
                                if (operand1 != `D_SIZE'd0) begin
                                    pc_jmp_offset = operand2[`A_SIZE-1:0];
                                    pc_load = 1'b1;
                                    pipeline_flush = 1'b1;
                                end
                            end
                        endcase
                     end
                endcase
             end
        endcase
    end
end

endmodule
