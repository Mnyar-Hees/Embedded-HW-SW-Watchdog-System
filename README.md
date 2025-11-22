# Embedded HW/SW Watchdog System 

This project implements a hardware/software watchdog demonstrator on the **DE10-Lite (Intel MAX 10)** board. The system shows how a watchdog timer can automatically reset an embedded system when the software hangs.

The design combines:
- A **custom VHDL watchdog timer** (`task_5_wdt.vhd`)
- A **Platform Designer / Qsys CPU system** (`wdt_cpu_sys`)
- A **C program** running on the CPU that periodically “kicks” the watchdog

---

## 🌐 Overview

The CPU application runs a simple loop:

- Updates a **7-segment display** with a counter (0–9)
- Periodically restarts the watchdog through a **WDT_RESTART** register
- Uses a hardware timer to achieve a 1-second period

If the user presses the button (**KEY0**), the software intentionally enters an **infinite loop** and stops restarting the watchdog.  
After the timeout, the **VHDL watchdog** asserts a reset and the whole system restarts automatically.

This demonstrates how a watchdog increases system availability in case of software lock-up.

---

## 🔧 Hardware (VHDL)

Main hardware modules:

- `task_5_wdt_cpu_system.vhd`  
  Top-level that connects:
  - 50 MHz system clock  
  - Switches and push button  
  - LED and 7-seg outputs  
  - CPU system (`wdt_cpu_sys`)  
  - Watchdog module (`task_5_wdt`)

- `task_5_wdt.vhd`  
  Custom watchdog timer:
  - Counts clock cycles up to `g_cnt_max` (default 50e6 ≈ 1 s)
  - Monitors a restart pulse from software
  - Generates an **active-low reset** for at least 2 clock cycles
  - Can be enabled/disabled via a switch

Optional:
- `timer_hw_ip` HDL and TCL files for the custom timer IP used by the software.

---

## 🧠 Software (C)

Main features of the `main.c` application:

- Initializes LEDs and 7-seg display
- Uses a hardware timer to create a **1-second software period**
- Sends a pulse to the `WDT_RESTART` register once per second
- Increments the value shown on the 7-seg display (0→9 loop)
- Monitors **BUTTON_BASE (KEY0)**:
  - When pressed, all LEDs turn on and the code enters an infinite loop  
  - The watchdog then times out and resets the system

This illustrates how a hang in application code can be recovered automatically by a watchdog.

---


