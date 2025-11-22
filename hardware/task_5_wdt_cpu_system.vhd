-------------------------------------------------------------------------------

-- Engineer     : Menyar Hees
--
-- File Name    : task_5_wdt_cpu_system.vhd
-- Project      : Embedded HW/SW Watchdog System (Task 5)
--
-- Description  :
--   Top-level integration file connecting:
--     - The Nios II–based CPU system generated in Platform Designer
--       (wdt_cpu_sys), which includes:
--           * Software running on the CPU
--           * LED output register
--           * 7-segment display output
--           * Watchdog "restart" signal generated from C code
--
--     - The custom VHDL Watchdog Timer (task_5_wdt), which:
--           * Measures time between software restart pulses
--           * Generates an active-low reset pulse (2 cycles) when timeout occurs
--           * Can be enabled/disabled using SW(0)
--           * Uses SW(9) as external asynchronous reset
--
--   The purpose of the system is to demonstrate how a watchdog timer can
--   automatically reset a system if the CPU software becomes unresponsive.
--
-- Inputs:
--   MAX10_CLK1_50 : 50 MHz system clock
--   SW(9)         : Global reset (active low)
--   SW(0)         : Enable/disable watchdog
--   KEY(0)        : Button input to software (used to simulate hang)
--
-- Outputs:
--   LEDR          : CPU-driven LED output (status indication)
--   HEX0          : 7-segment display driven by CPU software
--
-- Toolchain     : Intel Quartus + Platform Designer + Nios II + VHDL
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity task_5_wdt_cpu_system is
    port (
        MAX10_CLK1_50 : in  std_logic;                     -- System clock (50 MHz)
        SW            : in  std_logic_vector(9 downto 0);  -- Switches: SW(9)=reset, SW(0)=WDT enable
        KEY           : in  std_logic_vector(1 downto 0);  -- Push buttons (KEY0 used by software)
        LEDR          : out std_logic_vector(7 downto 0);  -- LED output from CPU
        HEX0          : out std_logic_vector(6 downto 0)   -- 7-segment output from CPU
    );
end entity;

architecture rtl of task_5_wdt_cpu_system is

    ---------------------------------------------------------------------------
    -- Component: CPU System generated in Platform Designer (Qsys)
    -- This block contains:
    --   - Nios II CPU
    --   - Software-driven restart signal for the watchdog
    --   - LED and 7-segment output logic
    ---------------------------------------------------------------------------
    component wdt_cpu_sys
        port (
            clk_clk            : in  std_logic := 'X';
            reset_reset_n      : in  std_logic := 'X';
            ledr_export        : out std_logic_vector(7 downto 0);
            sevenseg_export    : out std_logic_vector(6 downto 0);
            wdt_restart_export : out std_logic;
            button_export      : in  std_logic
        );
    end component;

    ---------------------------------------------------------------------------
    -- Component: Custom VHDL Watchdog Timer
    -- Generates reset when software fails to send periodic restart pulses.
    ---------------------------------------------------------------------------
    component task_5_wdt
        generic (
            g_cnt_max : integer    -- Timeout value in clock cycles
        );
        port (
            clk       : in  std_logic;
            rst_n     : in  std_logic;
            i_enable  : in  std_logic;            -- Watchdog ON/OFF
            i_restart : in  std_logic;            -- Software heartbeat pulse
            o_reset_n : out std_logic             -- Reset output to CPU system
        );
    end component;

    -- Internal signals
    signal s_wdt_reset_n : std_logic;   -- Reset from watchdog to CPU
    signal s_wdt_restart : std_logic;   -- Restart pulses from software

begin

    ---------------------------------------------------------------------------
    -- Instantiate CPU System (Platform Designer / Qsys)
    ---------------------------------------------------------------------------
    u0 : wdt_cpu_sys
        port map (
            clk_clk            => MAX10_CLK1_50,
            reset_reset_n      => s_wdt_reset_n,
            ledr_export        => LEDR,
            sevenseg_export    => HEX0,
            wdt_restart_export => s_wdt_restart,
            button_export      => KEY(0)
        );

    ---------------------------------------------------------------------------
    -- Instantiate Watchdog Timer
    -- Timeout = g_cnt_max = 50e6 → 1 second timeout at 50 MHz
    ---------------------------------------------------------------------------
    task_5_wdt_i0 : task_5_wdt
        generic map (
            g_cnt_max => 50e6
        )
        port map (
            clk       => MAX10_CLK1_50,
            rst_n     => SW(9),        -- External reset
            i_enable  => SW(0),        -- Enable/disable watchdog
            i_restart => s_wdt_restart, -- Restart pulses from software
            o_reset_n => s_wdt_reset_n  -- Reset output to CPU
        );

end architecture;
