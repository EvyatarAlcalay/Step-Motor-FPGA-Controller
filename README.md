# Stepper Motor Controller on FPGA

This project implements a control system for a **bipolar stepper motor** on an FPGA using Verilog HDL. It supports multiple speed modes (full/half steps) and direction control, with a user interface via buttons and switches, and displays output on two 7-segment HEX displays.

## Target Platform

- **Board:** DE10-Nano (Cyclone V: 5CSXFC6D6F31C6)
- **Language:** Verilog HDL
- **Tools:** Intel Quartus Prime (20.1 or compatible)

---

## Requirements

To run this project on hardware, you will need:

- **DE10-Nano FPGA board** (or compatible Cyclone V board)
- **Bipolar stepper motor**
- **H-Bridge driver module** (e.g., L298N) to interface between FPGA and motor
- **12V power supply** (or as required by your motor)
- Intel Quartus software (for compilation and programming)

---

## Project Structure

- `step_motor_top.v` — Top-level module
- `clk_divider.v` — Clock divider for generating timing signals
- `motor_sm.v` — Motor state machine (step logic)
- `speed_controller_sm.v` — State machine to manage speed control modes
- `speed_selector.v` — Selects and controls the pulse frequency
- `quarter_count.v` — Counts and displays number of quarter-steps taken
- `seven_segment.v` — 7-segment display encoder (for HEX displays)
- `negedge_detector.v` — Detects falling edges on control signals

---

## How it Works

1. The user controls the stepper motor using switches (`SW1`, `SW2`, `SW3`) and buttons (`KEY0`, `KEY1`, `KEY3`).
2. The motor supports direction change, start/stop, and speed ramping (via `KEY3`).
3. The system tracks quarter-step counts and displays them on HEX0 and HEX1.
4. The clock is divided down to generate appropriate timing signals for the selected speed mode.

---

## FPGA Pin Mapping

| Signal             | FPGA Pin Resource |
|--------------------|-------------------|
| `clk`              | PIN_AB12          |
| `reset_n`          | PIN_Y16           |
| `sw[3:0]`          | PIN_W16, W15, AB17, AB16 |
| `key[3:0]`         | PIN_AA14, AA15, AB13, AB14 |
| `hex0[6:0]`        | PIN_AC23, AD24, AE24, AC24, AD23, AE23, AF23 |
| `hex1[6:0]`        | PIN_AF22, AE22, AE21, AD22, AD21, AC22, AC21 |
| `motor_out[3:0]`   | PIN_AG17, AH17, AG18, AH18 |

> If using DE10-Nano or similar boards, you can use the default constraints file (.qsf) to assign pins accordingly.

---

## Build and Flash Instructions

1. Open the project in **Intel Quartus** (v20.1 or compatible).
2. Ensure that all `.v` files are added to the project.
3. Assign pins according to your FPGA board and motor wiring using a `.qsf` file (sample mapping in table above).
4. Compile the project:
   - Click **"Start Compilation"** or run `quartus_sh --flow compile <project_name>`.
5. Flash the design to your board:
   - Connect the DE10-Nano via USB-Blaster.
   - Open **Programmer** in Quartus.
   - Add the `.sof` file generated after compilation.
   - Click **Start** to program the FPGA.

---

## Running on Hardware

1. Power the DE10-Nano and connect the **bipolar stepper motor** to GPIO pins via **H-Bridge module** (e.g., L298N).
2. Set the direction and speed mode using the onboard switches:
   - `SW1` – direction
   - `SW2` – run/stop
   - `SW3` – full-step or half-step
3. Use push buttons to trigger actions:
   - `KEY3` – speed ramp-up/ramp-down
   - `KEY1` – manual quarter-cycle pulse
   - `KEY0` – reset system
4. View current step count on HEX0 (units) and HEX1 (tens).
5. Observe motor movement based on input control logic.

> ⚠️ **Important**: Do **not** connect the stepper motor directly to the FPGA!  
> Always use a suitable **H-Bridge driver** (such as L298N or A4988) to protect the board and ensure proper current handling.

---

## Future Work

- Add feedback via rotary encoder to track actual position
- Add UART interface for PC control
- Improve ramp-up/down granularity
