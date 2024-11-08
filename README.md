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

# Completing the ISA
# 16 Instructions for the Custom Processor

1. *ADD rd, rs1, rs2* (Arithmetic add, register-register or register-immediate)
   - *Opcode*: 0000
   - *I*: 0 (register-register)
   - *Example*: ADD R1, R2, R3 (add R2 and R3, store in R1)
   - *Binary*: 0000_0_001_010_00011 → 1 0 1 2 3
   
   - *I*: 1 (register-immediate)
   - *Example*: ADD R1, R2, 5 (add R2 and immediate 5, store in R1)
   - *Binary*: 0000_1_001_010_00101 → 1 1 1 2 5

2. *SUB rd, rs1, rs2* (Arithmetic subtract, register-register or register-immediate)
   - *Opcode*: 0001
   - *I*: 0 (register-register)
   - *Example*: SUB R4, R5, R6 (subtract R6 from R5, store in R4)
   - *Binary*: 0001_0_100_101_00110 → 2 0 4 5 6
   
   - *I*: 1 (register-immediate)
   - *Example*: SUB R4, R5, 7 (subtract immediate 7 from R5, store in R4)
   - *Binary*: 0001_1_100_101_00111 → 2 1 4 5 7

3. *MUL rd, rs1, rs2* (Arithmetic multiply, register-register or register-immediate)
   - *Opcode*: 0010
   - *I*: 0 (register-register)
   - *Example*: MUL R7, R0, R1 (multiply R0 and R1, store in R7)
   - *Binary*: 0010_0_111_000_00001 → 3 0 7 0 1
   
   - *I*: 1 (register-immediate)
   - *Example*: MUL R7, R0, 3 (multiply R0 by immediate 3, store in R7)
   - *Binary*: 0010_1_111_000_00011 → 3 1 7 0 3

4. *LOAD rd, [rs1 + imm]* (Load from memory with immediate offset)
   - *Opcode*: 0011
   - *I*: 1 (Always immediate for LOAD)
   - *Example*: LOAD R2, [R3 + 5] (load value from memory at R3 + 5, store in R2)
   - *Binary*: 0011_1_010_011_00101 → 4 1 2 3 5

5. *STORE rs1, [rs2 + imm]* (Store to memory with immediate offset)
   - *Opcode*: 0100
   - *I*: 1 (Always immediate for STORE)
   - *Example*: STORE R5, [R6 + 10] (store R5 to memory at R6 + 10)
   - *Binary*: 0100_1_101_110_01010 → 5 1 5 6 A

6. *MOV rd, rs1* (Move, register-register)
   - *Opcode*: 0110
   - *I*: 0 (Always register-register for MOV)
   - *Example*: MOV R2, R3 (move R3 into R2)
   - *Binary*: 0110_0_010_011_00000 → 6 0 2 3 0

7. *AND rd, rs1, rs2* (Logical AND, register-register or register-immediate)
   - *Opcode*: 1000
   - *I*: 0 (register-register)
   - *Example*: AND R2, R3, R1 (bitwise AND between R3 and R1, store in R2)
   - *Binary*: 1000_0_010_011_00001 → 7 0 2 3 1
   
   - *I*: 1 (register-immediate)
   - *Example*: AND R2, R3, 15 (bitwise AND between R3 and immediate 15, store in R2)
   - *Binary*: 0111_1_010_011_01111 → 7 1 2 3 F

8. *OR rd, rs1, rs2* (Logical OR, register-register or register-immediate)
   - *Opcode*: 0111
   - *I*: 0 (register-register)
   - *Example*: OR R5, R6, R7 (bitwise OR between R6 and R7, store in R5)
   - *Binary*: 0111_0_101_110_00111 → 8 0 5 6 7
   
   - *I*: 1 (register-immediate)
   - *Example*: OR R5, R6, 7 (bitwise OR between R6 and immediate 7, store in R5)
   - *Binary*: 0111_1_101_110_00111 → 8 1 5 6 7

9. *BGT rs1, rs2, offset* (Branch if Greater Than)
   - *Opcode*: 1110
   - *I*: 0
   - *Example*: BGT R1, R2, -3 (if R1 > R2, branch to PC + offset -3)
   - *Binary*: 1110_0_001_010_11101 → 9 0 1 2 1D

10. *BEQ rs1, rs2, offset* (Branch if Equal)
    - *Opcode*: 1101
    - *I*: 0
    - *Example*: BEQ R4, R5, 8 (if R4 equals R5, branch to PC + offset 8)
    - *Binary*: 1101_0_100_101_01000 → A 0 4 5 8

11. *JUMP target*
    - *Opcode*: 1100
    - *I*: 1 (Always immediate)
    - *Example*: JUMP 15 (Jump to address 15)
    - *Binary*: 1100_1_000_000_01111 → B 1 0 0 F

12. *NOT rd, rs1* (Logical NOT, register-register)
    - *Opcode*: 1001
    - *I*: 0
    - *Example*: NOT R1, R2 (bitwise NOT of R2, store the result in R1)
    - *Binary*: 1001_0_001_010_00000 → C 0 1 2 0

13. *SRL rd, rs1, imm* (Logical Shift Right, immediate)
    - *Opcode*: 1011
    - *I*: 1
    - *Example*: SRL R3, R4, 2 (logical shift R4 right by 2 bits, store in R3)
    - *Binary*: 1011_1_011_100_00010 → D 1 3 4 2

14. *SLL rd, rs1, imm* (Logical Shift Left, immediate)
    - *Opcode*: 1010
    - *I*: 1
    - *Example*: SLL R3, R4, 3 (logical shift R4 left by 3 bits, store in R3)
    - *Binary*: 1010_1_011_100_00011 → E 1 3 4 3
15. *NOP* (No Operation)
    - *Opcode*: 1111
    - *I*: 0 (No operands required)
    - *Example*: NOP (does nothing, used to fill delay slots or align instructions)
    - *Binary*: 1111_0_000_000_00000 → F 0 0 0 0
  
16. *CMP rs1, rs2* (Compare registers)
    - *Opcode*: 0101
    - *I*: 0 (register-register comparison)
    - *Example*: CMP R1, R2 (compares R1 and R2, sets flags)
    - *Binary*: 0101_0_001_010_00000 → B 0 1 2 0
