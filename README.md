# Keypoints
1) instructions to be executed during negative edge of the clock
2) If instructions depend on one another then do not execute them in parallel simply insert a bubble for one of them
3) Resolve RAW hazards and control hazards (incase we go for branch prediction also)
4) Can implement forwarding for RAW hazards to minimise stall cycles
5) the problem is: we have to fetch two instructins from shared memory at the same time, this problem must be resolved through:
   a. We have to put 2 PC's in order to add instructions in both pipelines simultaneously.
   b. At once we can fetch 2 instructions and store them in IR1 and IR2 (2 instruction registers)
6) The basic principle we are following is that before passing the two instructions into the two pipelines, we check whether the two instructions can be executed at the same time or not, i.e., we check for WAW, RAW, WAR all three hazards. If they are non-existent, we pass them in the two pipelines, or pass the instructions one by one in one pipeline and pass bubble(NOP) in the other.
7) We first are trying only for structural and data hazard. If time permits, also for control hazard.

## Harvard machine (dedicated instruction memory).
There is a dedicated structure in the processor called the register file that contains all the 8 registers

ISA DEGIGN.<,br>
16 bit instruction => IR size =16 bits. <br>
No. of instructions = 16. <br>
No. of Registers = 8.<br>
memory size = 32 words<br>
pc size = 16 bit<br>
So, size of opcode = 4 bits.<br>
Immediate bit size = 1 bit.<br>
Size of register = 3 bits.<br>
Memory Addressing: Word-addressable.<br>
<br>
The instruction format is divided as follows: <br>
Opcode (4 bits)	|      I (1 bit)  	|      rd (3 bits)	|    rs1 (3 bits)      |     	rs2/imm (5 bits)

# ISA
# 16 Instructions for the Custom Processor

## 1. NOP
- **Opcode**: `0000`
- **Example**: `NOP` (does nothing)
- **Binary**: `0000_0_000_000_00000 → 0 0 0 0 0`

## 2. ADD rd, rs1, rs2
- **Opcode**: `0001`
- **I**: 0 (register-register)
- **Example**: `ADD R1, R2, R3`
- **Binary**: `0001_0_001_010_00011 → 1 0 1 2 3`
- **I**: 1 (register-immediate)
- **Example**: `ADD R1, R2, 5`
- **Binary**: `0001_1_001_010_00101 → 1 1 1 2 5`

## 3. SUB rd, rs1, rs2
- **Opcode**: `0010`
- **I**: 0 (register-register)
- **Example**: `SUB R4, R5, R6`
- **Binary**: `0010_0_100_101_00110 → 2 0 4 5 6`

- **I**: 1 (register-immediate)
- **Example**: `SUB R4, R5, 7`
- **Binary**: `0010_1_100_101_00111 → 2 1 4 5 7`

## 4. MUL rd, rs1, rs2
- **Opcode**: `0011`
- **I**: 0 (register-register)
- **Example**: `MUL R7, R0, R1`
- **Binary**: `0011_0_111_000_00001 → 3 0 7 0 1`

- **I**: 1 (register-immediate)
- **Example**: `MUL R7, R0, 3`
- **Binary**: `0011_1_111_000_00011 → 3 1 7 0 3`

## 5. LOAD rd, [rs1 + imm]
- **Opcode**: `0100`
- **I**: 1
- **Example**: `LOAD R2, [R3 + 5]`
- **Binary**: `0100_1_010_011_00101 → 4 1 2 3 5`

## 6. STORE rs1, [rs2 + imm]
- **Opcode**: `0101`
- **I**: 1
- **Example**: `STORE R5, [R6 + 10]`
- **Binary**: `0101_1_101_110_01010 → 5 1 5 6 A`

## 7. CMP rs1, rs2
- **Opcode**: `0110`
- **I**: 0
- **Example**: `CMP R1, R2`
- **Binary**: `0110_0_001_010_00000 → B 0 1 2 0`

## 8. MOV rd, rs1
- **Opcode**: `0111`
- **I**: 0
- **Example**: `MOV R2, R3`
- **Binary**: `0111_0_010_011_00000 → 7 0 2 3 0`

## 9. OR rd, rs1, rs2
- **Opcode**: `1000`
- **I**: 0 (register-register)
- **Example**: `OR R5, R6, R7`
- **Binary**: `1000_0_101_110_00111 → 8 0 5 6 7`

- **I**: 1 (register-immediate)
- **Example**: `OR R5, R6, 7`
- **Binary**: `1000_1_101_110_00111 → 8 1 5 6 7`

## 10. AND rd, rs1, rs2
- **Opcode**: `1001`
- **I**: 0 (register-register)
- **Example**: `AND R2, R3, R1`
- **Binary**: `1001_0_010_011_00001 → 9 0 2 3 1`

- **I**: 1 (register-immediate)
- **Example**: `AND R2, R3, 15`
- **Binary**: `1001_1_010_011_01111 → 9 1 2 3 F`

## 11. NOT rd, rs1
- **Opcode**: `1010`
- **I**: 0
- **Example**: `NOT R1, R2`
- **Binary**: `1010_0_001_010_00000 → C 0 1 2 0`

## 12. LSL rd, rs1, rs2
- **Opcode**: `1011`
- **I**: 1
- **Example**: `LSL R3, R4, 3`
- **Binary**: `1011_1_011_100_00011 → D 1 3 4 3`

## 13. LSR rd, rs1, rs2
- **Opcode**: `1101`
- **I**: 1
- **Example**: `LSR R3, R4, 2`
- **Binary**: `1101_1_011_100_00010 → D 1 3 4 2`

## 14. BEQ rs1, rs2, offset
- **Opcode**: `1110`
- **I**: 0
- **Example**: `BEQ R4, R5, 8`
- **Binary**: `1110_0_100_101_01000 → A 0 4 5 8`

## 15. BGT rs1, rs2, offset
- **Opcode**: `1111`
- **I**: 0
- **Example**: `BGT R1, R2, -3`
- **Binary**: `1111_0_001_010_11101 → 9 0 1 2 1D`

## 16. JUMP target
- **Opcode**: `1100`
- **I**: 1
- **Example**: `JUMP 15`
- **Binary**: `1100_1_000_000_01111 → B 1 0 0 F`

---
<img width="958" alt="image" src="https://github.com/user-attachments/assets/8f5587b9-af28-47ba-9f41-c63ecfe9faa2">
