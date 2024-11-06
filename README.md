1) instructions to be executed during negative edge of the clock
2) If instructions depend on one another then do not execute them in parallel simply insert a bubble for one of them
3) Resolve RAW hazards and control hazards (incase we go for branch prediction also)
4) Can implement forwarding for RAW hazards to minimise stall cycles
 