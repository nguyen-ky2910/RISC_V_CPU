32-bit Pipelined RISC-V CPU



An educational, synthesizable implementation of a 32-bit pipelined RISC-V processor written in Verilog. The design separates instruction processing into the classic five pipeline stages—Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back—and includes data forwarding for common register dependencies.

The project is organized as a Xilinx Vivado design and includes a self-contained instruction image, stage-level testbenches, and an end-to-end CPU testbench.

Note: This repository is intended for learning, RTL experimentation, and simulation. It should not be treated as a production-ready or fully verified implementation of the complete RV32I specification.

Architecture

flowchart LR
    IF["IF<br/>Instruction Fetch"] --> ID["ID<br/>Decode & Register Read"]
    ID --> EX["EX<br/>ALU & Branch"]
    EX --> MEM["MEM<br/>Data Memory"]
    MEM --> WB["WB<br/>Write Back"]
    MEM -. "forward" .-> EX
    WB -. "forward" .-> EX

Pipeline stages

Stage

Main responsibilities

RTL module

IF

Program-counter update, instruction fetch, and PC + 4 generation

instruction_fetch.v

ID

Instruction decode, register-file access, immediate generation, and ID/EX pipeline registers

instruction_decode.v

EX

Operand forwarding, ALU operation, branch-target calculation, and EX/MEM pipeline registers

instruction_execute.v

MEM

Data-memory access and MEM/WB pipeline registers

instruction_memory.v

WB

Selection of ALU, memory, or PC + 4 result for register write-back

instruction_writeback.v

The primary integration module is RISC_V_CPU.v.

Key Features

32-bit RISC-V datapath based on the RV32I instruction formats

Five-stage pipeline: IF, ID, EX, MEM, and WB

32 × 32-bit register file with register x0 hardwired to zero

Separate 256 × 32-bit instruction and data memories

ALU operations for addition, subtraction, AND, OR, and signed set-less-than

Immediate generation for I-, S-, and B-type formats

Control paths for register-register ALU, immediate ALU, load, store, branch, and jump instruction classes

EX-stage branch decision and target-address calculation

Data forwarding from the MEM and WB stages to both EX-stage ALU operands

Active-low asynchronous reset for pipeline and state registers

Modular and full-CPU Verilog testbenches

Instruction Scope

The current modular datapath contains decoding and control logic for the following instruction groups:

Group

Examples represented in the RTL

Purpose

Register-register

ADD, SUB, AND, OR, SLT

Arithmetic and logical operations

Immediate

ADDI and ALU-immediate formats

Register-immediate operations

Load

LW control path

Read a 32-bit word from data memory

Store

SW control path

Write a 32-bit word to data memory

Branch

BEQ control path

Conditional PC-relative branch

Jump

JAL control path

PC-relative jump and link

Instruction support is still under development. Before relying on an instruction in a larger system, verify its decode, immediate generation, hazard behavior, and write-back path with a dedicated test.

Hazard Handling

hazard_unit.v resolves common read-after-write dependencies by forwarding:

the current MEM-stage ALU result to either EX-stage source operand; or

the WB-stage result to either EX-stage source operand.

MEM-stage forwarding has priority over WB-stage forwarding. The present hazard unit does not implement a general pipeline stall mechanism, load-use interlock, or control-hazard flush logic; programs and future extensions should account for those limitations.

Repository Structure

RISC_V_CPU/
├── RISC-V_CPU.xpr
├── RISC-V_CPU.srcs/
│   ├── sources_1/new/
│   │   ├── RISC_V_CPU.v              # Primary top-level CPU
│   │   ├── instruction_fetch.v       # IF stage
│   │   ├── instruction_decode.v      # ID stage
│   │   ├── instruction_execute.v     # EX stage
│   │   ├── instruction_memory.v      # MEM stage
│   │   ├── instruction_writeback.v   # WB stage
│   │   ├── control_unit_top.v        # Main and ALU decoder integration
│   │   ├── main_decoder.v            # Main control decoder
│   │   ├── ALU_decoder.v             # ALU control decoder
│   │   ├── hazard_unit.v             # EX operand forwarding
│   │   ├── register_file.v
│   │   ├── data_memory.v
│   │   ├── instruction_memmory.v     # Instruction ROM used by IF
│   │   ├── extend.v                  # Immediate generator
│   │   ├── ALU.v
│   │   ├── pc_module.v
│   │   ├── pc_adder.v
│   │   ├── mux_2_1.v
│   │   ├── mux_3_1.v
│   │   └── memfile.mem               # Simulation instruction image
│   └── sim_1/new/
│       ├── tb_RISC_V_CPU.v
│       ├── tb_instruction_fetch.v
│       ├── tb_instruction_decode.v
│       ├── tb_instruction_execute.v
│       ├── tb_instruction_memory.v
│       └── tb_instruction_writeback.v
└── simulation_tb_RISC_V_CPU_behav.wcfg

The repository also contains experimental/alternative RTL files. The module hierarchy instantiated by RISC_V_CPU.v is the reference path documented above.

Requirements

Xilinx Vivado 2018.3 (the version recorded in the project file)

A simulator capable of compiling Verilog-2001 RTL

No RISC-V software toolchain is required for the included test image; instructions are loaded directly from memfile.mem

The Vivado project is configured for the Xilinx xc7k70tfbv676-1 device. You may retarget the RTL to another FPGA by changing the project part and supplying the appropriate timing and pin constraints.

Running the Full-CPU Simulation

Clone the repository:

git clone https://github.com/nguyen-ky2910/RISC_V_CPU.git
cd RISC_V_CPU

Start Vivado 2018.3.

Select Open Project and open RISC-V_CPU.xpr.

In Simulation Sources, set tb_RISC_V_CPU as the simulation top if it is not already selected.

Choose Run Simulation → Run Behavioral Simulation.

Run the simulation for at least 220 ns, or select Run All.

Inspect the program counter, fetched instruction, pipeline control signals, ALU result, memory interface, forwarding selectors, and register write-back signals in the waveform window.

The testbench generates a 10 ns clock period, holds the active-low reset for 20 ns, and then runs the processor for 200 ns.

Running Stage-Level Tests

The sim_1/new directory contains focused testbenches for the five major stages. To run one in Vivado:

Right-click the desired testbench under Simulation Sources.

Select Set as Top.

Launch Behavioral Simulation.

Compare the generated outputs with the stimulus and expected behavior defined in that testbench.

Loading a Different Program

Instruction memory is initialized with:

$readmemh("memfile.mem", mem);

To test another program, replace the contents of RISC-V_CPU.srcs/sources_1/new/memfile.mem with one 32-bit hexadecimal instruction word per line. Keep the file in the Vivado simulation sources so that the simulator can resolve it at runtime.

Project Status

The processor is an educational work in progress. Current development priorities include:

completing and verifying the intended RV32I instruction subset;

adding load-use detection and pipeline stalling;

flushing younger instructions after taken branches and jumps;

expanding self-checking instruction and integration tests;

adding synthesis, timing, and FPGA resource-utilization results; and

documenting or adding board-specific constraints for hardware deployment.

Contributing

Bug reports, verification improvements, and RTL enhancements are welcome. For a substantial change, open an issue first and describe the intended behavior. Please keep changes modular and include a focused testbench or reproducible simulation procedure.

Author

Developed by nguyen-ky2910 as an educational project in RISC-V architecture, pipelined processor design, and Verilog RTL development.

License

No license file is currently included. Unless a license is added, copyright remains with the repository owner and reuse is not automatically granted. If you intend to make the project openly reusable, consider adding a standard open-source license such as MIT, BSD-2-Clause, or Apache-2.0.
