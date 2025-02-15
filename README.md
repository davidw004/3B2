# 3B2 FPGA Programming and Testing Lab

This repository contains VHDL code and Quartus Prime project files for the **3B2: FPGA Programming and Testing Lab**. The experiment involves designing and implementing a traffic light controller on a DE1-SoC FPGA board using Quartus Prime software.

---

## Objective
The objective of this lab is to:
- Become familiar with a typical FPGA device and its features.
- Realize a logic circuit using a CAD flow for FPGAs.
- Configure, test, and understand the capabilities of an FPGA device.

---

## Description
This project implements a **traffic light controller** for a pedestrian crossing. The system:
- Starts with **Vehicle GREEN** and **Pedestrian RED**.
- Changes state on **pedestrian request** or **reset**.
- Follows a 3-state sequence on request:
  1. Vehicle YELLOW for 5 seconds
  2. Vehicle RED and Pedestrian GREEN for 10 seconds
  3. Return to initial state
- Returns to initial state immediately on reset.

### Improved Functionality: Request Wait Time
To prevent continuous pedestrian requests from blocking the vehicle lane (RED light), the controller includes a **wait time** mechanism:
- After completing a pedestrian request, the system enforces a **10-second wait time** during which the vehicle light remains GREEN before accepting another request.
- This ensures vehicles are given a minimum duration to proceed, enhancing traffic flow and safety.

The state machine is implemented using VHDL and follows the state diagram and table provided in the experiment handout.

---

## Hardware
- **DE1-SoC Development Board** with **Cyclone V SoC FPGA**
- Inputs:
  - `clk`: 50 MHz clock from DE1-SoC board
  - `request`: Pedestrian request push-button
  - `reset`: Reset push-button
- Outputs:
  - `output[4:0]`: Controls LEDs for vehicle and pedestrian lights:
    - `LEDR0`: Vehicle GREEN
    - `LEDR2`: Vehicle YELLOW
    - `LEDR4`: Vehicle RED
    - `LEDR7`: Pedestrian GREEN
    - `LEDR9`: Pedestrian RED

---
