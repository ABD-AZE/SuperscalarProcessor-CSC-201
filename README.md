# Superscalar Processor with Dual Pipelines

link to ppt: https://iitracin-my.sharepoint.com/:p:/g/personal/pradyuman_ss_cs_iitr_ac_in/EUMN85Z1f4lGgEfcnXlgKdsBRtsC8XhoxP2WSJ17jTh4TA?e=zTLUBG

A **superscalar processor** is an advanced microprocessor capable of executing more than one instruction during a single clock cycle. This capability is achieved by incorporating **dual pipelines**, which allows simultaneous execution of multiple instructions, significantly improving the throughput of the processor. In our project, we have developed a superscalar processor that uses **dual pipelining** to support **instruction-level parallelism** and efficient hazard management.

## Approach to Superscalar Pipeline Design

Our superscalar processor consists of two parallel pipelines that handle different stages of instruction execution: **Fetch, Decode, Execute, Memory Access, and Writeback**. The use of dual pipelining introduces challenges such as resource contention and **hazard management**, which we have addressed with a variety of techniques.

The pipeline stages are defined as follows:
- **Fetch Stage**: This stage is responsible for fetching the next instruction(s) from memory. In our design, the **instruction fetch unit** can fetch two instructions simultaneously, which are then dispatched to the respective pipelines.
- **Decode Stage**: During decoding, instructions are parsed to determine their operation and the required operands. We employ a dual instruction decoder that can handle two instructions concurrently, ensuring that both pipelines are supplied with the necessary information.
- **Execute Stage**: The execute stage performs arithmetic and logical operations. We have implemented an **ALU (Arithmetic Logic Unit)** for each pipeline, allowing parallel execution of independent operations.
- **Memory Access Stage**: This stage handles data memory operations such as load and store. Both pipelines share access to a unified memory unit, with arbitration logic to manage simultaneous access requests.
- **Writeback Stage**: In this final stage, the results of computations are written back to the register file. Dual write ports have been implemented to allow both pipelines to perform writeback operations concurrently.

<img width="748" alt="image" src="https://github.com/user-attachments/assets/58e7a89c-6620-4e4d-b0ea-14ad207c8b47">

<img width="612" alt="image" src="https://github.com/user-attachments/assets/f8892b08-c314-4d5e-912a-72d1be562846">


## ISA Design

Our superscalar processor is designed as a **Harvard machine** with dedicated instruction memory. The **instruction set architecture (ISA)** is tailored to support basic arithmetic, logical, and branching operations. The ISA specifications are as follows:
- **16-bit instruction word** (IR size = 16 bits)
- **Number of instructions**: 16
- **Number of Registers**: 8 (with the eighth register being the Flag Register `r7`)
- **Memory size**: 32 words, word-addressable
- **Program counter (PC) size**: 16 bits
- **Opcode size**: 4 bits
- **Immediate bit size**: 1 bit
- **Register size**: 3 bits

### Instruction Format
The instruction format is divided as follows:

<img width="703" alt="image" src="https://github.com/user-attachments/assets/a8b4344b-c5f9-4b7e-9c00-077c640cb979">


The custom processor supports 16 instructions:
1. **NOP** - No operation (Opcode: 0000)
2. **ADD rd, rs1, rs2** - Add (Opcode: 0001)
3. **SUB rd, rs1, rs2** - Subtract (Opcode: 0010)
4. **MUL rd, rs1, rs2** - Multiply (Opcode: 0011)
5. **LOAD rd, [rs1 + imm]** - Load (Opcode: 0100)
6. **STORE rs1, [rs2 + imm]** - Store (Opcode: 0101)
7. **CMP rs1, rs2** - Compare (Opcode: 0110)
8. **MOV rd, rs1** - Move (Opcode: 0111)
9. **OR rd, rs1, rs2** - Logical OR (Opcode: 1000)
10. **AND rd, rs1, rs2** - Logical AND (Opcode: 1001)
11. **NOT rd, rs1** - Logical NOT (Opcode: 1010)
12. **LSL rd, rs1, rs2** - Logical Shift Left (Opcode: 1011)
13. **JUMP target** - Unconditional Jump (Opcode: 1100)
14. **LSR rd, rs1, rs2** - Logical Shift Right (Opcode: 1101)
15. **BEQ target** - Branch if Equal (Opcode: 1110)
16. **BGT target** - Branch if Greater (Opcode: 1111)

## CPI Formula and Instruction-Level Parallelism

The **cycles per instruction (CPI)** is a key metric in assessing processor performance. In an ideal scenario without hazards or stalls, our dual-pipeline processor aims to achieve a CPI of approximately **0.5**, since it can potentially execute two instructions per cycle. However, in practice, achieving this ideal CPI is challenging due to various factors such as pipeline hazards, resource limitations, and data dependencies between instructions.

The **effective CPI** of the processor is calculated using the formula:

**CPI = (Total Cycles) / (Total Instructions Executed)**

In our dual-pipeline design, factors such as pipeline stalls, branch mispredictions, and data hazards increase the total cycle count, resulting in a higher CPI. Our implementation aims to minimize these stalls and maintain a CPI as close to 0.5 as possible by employing effective hazard management techniques.

## Hazard Management: Stalling and Data Forwarding

**Hazard management** in a pipelined processor refers to handling situations where instructions cannot execute simultaneously due to resource conflicts or data dependencies. We handle three primary types of hazards:

1. **Data Hazards**: These occur when instructions depend on the results of previous instructions that are still in the pipeline. To address data hazards, we have implemented **data forwarding** and **stalling** mechanisms.
   - **Data Forwarding**: This technique is used to directly pass results from one pipeline stage to another without waiting for the normal writeback. We use a **relayer unit** to implement forwarding paths, ensuring that data is available for dependent instructions as soon as possible. The relayer unit monitors the pipeline stages and forwards data from the execute or memory stages to the decode stage when necessary, thereby reducing stalls.
   - **Stalling**: If forwarding is not feasible, we introduce **pipeline stalls** to delay instruction execution until the necessary data is ready. Stalls are controlled using dedicated logic, which generates control signals to freeze the relevant pipeline stages while allowing other stages to continue, thereby minimizing the performance impact.

2. **Structural Hazards**: These occur when two instructions require the same hardware resource simultaneously. In our dual-pipeline design, **structural hazards** are minimized through resource duplication (e.g., dual ALUs) and arbitration logic for shared resources such as memory access units. The control unit ensures that resource contention is effectively managed to avoid unnecessary stalls.

3. **Control Hazards**: Control hazards arise due to branch instructions that change the flow of execution. We use a **branch prediction mechanism** to mitigate control hazards. The branch predictor attempts to guess the outcome of branch instructions, allowing the pipeline to continue fetching subsequent instructions without waiting for the branch to be resolved. In case of a misprediction, the pipeline is flushed, and the correct instructions are fetched, which introduces a penalty.

## Hazard Management Implementation (Referencing GitHub Repository)

In our implementation, the **hazard detection** logic is tightly integrated with the pipeline architecture. We have utilized a combination of **buffers** and a **relayer unit** to manage data dependencies and control signal propagation across the two pipelines. Detailed information about the implementation can be found in our GitHub repository [here](https://github.com/ABD-AZE/SuperscalarProcessor-CSC-203/tree/main/src).

- **Buffers Before Pipelining**: To handle the synchronization of instructions between the dual pipelines, we utilize buffers before the decode and execute stages. These buffers act as holding units to manage the flow of instructions and reduce the risk of instruction conflicts. The buffers help in temporarily storing instruction and data values, allowing smoother transitions between stages and better coordination between the pipelines.

- **Relayer Unit**: The **relayer unit** is used to detect data dependencies between the two pipelines and initiate data forwarding when applicable. This unit effectively ensures that dependent instructions do not lead to incorrect execution. The relayer unit also coordinates with the hazard detection logic to determine when stalling is required, providing a unified solution for managing data hazards.

- **Control Unit**: The **control unit** plays a crucial role in managing the dual pipelines. It is responsible for generating control signals for instruction fetch, decode, execution, memory access, and writeback stages. The control unit also manages pipeline flushing in case of branch mispredictions, ensuring that both pipelines operate seamlessly without executing incorrect instructions.

## Managing Dual Pipelines with Limited Resources

Managing **dual pipelines** with limited resources requires careful handling of shared components, such as the **register file** and **memory units**. In our design:
- We ensure that both pipelines access shared resources without conflicts by employing **resource arbitration** techniques. The arbitration logic monitors access requests and grants access in a fair manner to prevent deadlocks or starvation.
- A dedicated **control unit** coordinates the simultaneous execution of instructions across the two pipelines, ensuring that resource contention is minimized while maximizing parallelism. The control unit also handles situations where both pipelines need to access the same memory location, ensuring that memory operations are performed correctly.
- The **register file** has been designed to support dual read and write ports, allowing both pipelines to access the registers concurrently without causing data corruption. The register file includes additional control logic to handle simultaneous read and write requests, ensuring data consistency across both pipelines.
- **Branch Prediction and Flushing**: To manage control hazards effectively, we have implemented a branch prediction unit that predicts the outcome of branch instructions to keep the pipeline full. When a misprediction occurs, the control unit flushes the incorrect instructions from the pipeline, minimizing the performance penalty.

## Instruction Execution Principles

- **Negative Clock Edge Execution**: Instructions are executed during the negative edge of the clock cycle to ensure synchronization across the dual pipelines.
- **Dependency Checking Before Execution**: Before passing two instructions into the dual pipelines, we verify if they can be executed simultaneously by checking for **WAW (Write After Write)**, **RAW (Read After Write)**, and **WAR (Write After Read)** hazards. If any of these hazards exist, the instructions are either executed serially in a single pipeline while inserting a **bubble (NOP)** in the other pipeline.
- **Instruction Fetch and Hazard Resolution**: We fetch two instructions from shared memory at the same time using **two Program Counters (PCs)** to add instructions to both pipelines simultaneously. The instructions are then stored in two **Instruction Registers (IR1 and IR2)** before they proceed into the pipelines. We resolve **RAW hazards** using data forwarding where possible and use **stalling** otherwise to minimize stall cycles.

## Conclusion

Our superscalar processor with dual pipelines aims to enhance processing speed by executing two instructions simultaneously. By leveraging techniques such as data forwarding, stalling, branch prediction, and resource arbitration, we effectively manage the complexities introduced by instruction-level parallelism and limited resource availability. The detailed implementation of these features can be reviewed in our GitHub repository, which contains the Verilog code, testbenches, and documentation outlining the pipeline architecture and hazard management logic.

The **dual pipelining** approach, combined with advanced hazard management techniques, allows our processor to achieve significant improvements in throughput while maintaining correctness and efficiency. Our work demonstrates the potential of superscalar architectures in achieving high performance through parallel instruction execution and effective resource management.

<img width="603" alt="image" src="https://github.com/user-attachments/assets/8e0aa196-6381-4654-a46a-828382646f3b">

The ALU circuit diagram above shows the different functional units (Adder, Multiplier, Shift Unit, Logical Unit, and Mov Unit) and how the control signals (`isAdd`, `isSub`, `isMul`, `isCmp`, etc.) determine the operations performed on the operands `A` and `B`. The output from these units is directed to the `aluResult`, which is then used in subsequent stages of the pipeline.




