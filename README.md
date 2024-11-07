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


# Architecture for single pipeline
 ![237593769-4caaeee5-e804-42ae-b0f0-264a62f2d385](https://github.com/user-attachments/assets/9f952f2e-13fe-4d1d-a737-a4bc5f6c04a1)

# sample: six-issue dynamic superscaler microprocessor
<img width="637" alt="image" src="https://github.com/user-attachments/assets/2a7a091b-d332-415b-a44b-11c396d6124a">

In a superscalar processor, multiple instructions can be fetched, decoded, and executed in parallel during a single clock cycle. This improves performance by allowing the processor to complete more instructions at once, rather than processing them one at a time.

**Six-Issue**: This means that the processor can issue (or start executing) up to six instructions in parallel per clock cycle. Each cycle, it attempts to issue six instructions to different execution units (such as the integer unit, floating-point unit, etc.), depending on whether there are enough independent instructions available and whether the execution units are free.
**Dynamic**: This refers to dynamic instruction scheduling, where the processor decides the order of instruction execution at runtime, based on instruction dependencies and resource availability. This approach, combined with the ability to issue multiple instructions, allows for more efficient handling of workloads and can improve overall performance.


# 1. Virtual Memory
In most modern computers, programs don’t access physical memory (the actual RAM chips) directly. Instead, they use virtual memory. Here’s why and how this works:

## Why Use Virtual Memory?
It gives each program the illusion of having its own large, contiguous block of memory, regardless of how much physical memory (RAM) is available. This helps prevent programs from interfering with each other’s memory and makes memory management more flexible.

## How Virtual Memory Works:
The operating system and the CPU work together to map a program’s virtual memory addresses to actual locations in physical memory (RAM). Each program’s memory is divided into small chunks called pages, which are mapped to physical memory pages as needed.


# 2. Pages and Page Table
To manage virtual memory, the system divides memory into fixed-size chunks:

Pages: Virtual memory is divided into pages (usually 4KB each), and physical memory (RAM) is also divided into similar-sized page frames.
Page Table: The operating system uses a page table to keep track of which virtual pages map to which physical page frames. Every program has its own page table, which tells the CPU where to find each piece of the program’s data in physical memory.

# 3. Address Translation
When a program accesses memory, it uses a virtual address. However, this virtual address needs to be translated to a physical address in RAM, where the data actually resides.

Virtual Address: The address the program uses, which doesn’t correspond directly to an actual location in RAM.
Physical Address: The actual location in RAM where the data is stored.
Address Translation Process: The CPU uses the page table to convert (or translate) virtual addresses to physical addresses. For every memory access, it needs to check the page table to see where the virtual address maps in physical memory.

# 4. Translation Lookaside Buffer (TLB)
Now that we understand pages, page tables, and address translation, we can explain the Translation Lookaside Buffer (TLB) and why it’s important.

## Why TLB Is Needed: 
Checking the page table for every memory access would be slow, as it could involve multiple steps. Since programs access memory frequently, this would significantly reduce performance.
## What the TLB Does: 
The TLB is a special cache that stores recent translations from virtual addresses to physical addresses. When the CPU needs to translate a virtual address, it first checks the TLB to see if the translation is already there. If it is, the CPU can skip the slower process of looking up the page table.

## Cache: 
In computing, a cache is a small, fast memory that stores frequently accessed data to speed up future access. The TLB is a type of cache specifically for storing recent address translations.

# 5. How the TLB Works
TLB Hit: If the TLB contains the virtual-to-physical address translation that the CPU needs, it’s called a TLB hit. The CPU can directly use the physical address from the TLB, avoiding the slower page table lookup.
TLB Miss: If the TLB doesn’t contain the needed translation, it’s called a TLB miss. In this case, the CPU has to look up the page table to find the physical address, then load this translation into the TLB for future use.
Why the TLB Improves Performance
Faster Memory Access: By storing recently used address translations, the TLB allows the CPU to skip the time-consuming page table lookup most of the time, which speeds up memory access.
**Locality of Reference**: Programs tend to access the same memory locations repeatedly or access nearby locations. This principle, known as "locality of reference," means that translations in the TLB are often reused, making it very effective.


