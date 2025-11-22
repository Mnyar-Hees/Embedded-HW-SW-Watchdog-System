library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity task_5_wdt is

	generic
	(
		g_cnt_max : natural := 50e6
	);

	port 
	(
      clk        : in  std_logic;
      rst_n      : in  std_logic;
      i_enable   : in  std_logic;
      i_restart  : in  std_logic;
      o_reset_n  : out std_logic
	);

end entity;

architecture rtl of task_5_wdt is

    signal s_cnt     : integer range 0 to 2**26-1;
    signal s_restart : std_logic;

begin

    process (clk, rst_n) is
begin
    -- process
    if rst_n = '0' then   -- asynchronous reset (active low)
        o_reset_n <= '0';
        s_cnt <= 0;
        s_restart <= '0';
    elsif rising_edge(clk) then  -- rising clock edge
        s_restart <= i_restart;
        -- check for enable
        if i_enable = '1' then
            -- clear reset out
            o_reset_n <= '1';
            -- increment counter
            s_cnt <= s_cnt + 1;
            -- reset counter when restart input is triggered
            if s_restart = '1' xor i_restart = '1' then

                    -- 0  0 0
                    -- 0  1 1
                    -- 1  0 1
                    -- 1  1 0
                    s_cnt <= 0;
                end if;

                -- reset the output if max cnt reached
                if s_cnt = g_cnt_max then
                    o_reset_n <= '0';
                end if;

                -- make sure reset is active for 2 clk
                if s_cnt > g_cnt_max + 1 then
                    o_reset_n <= '0';
                    s_cnt     <= 0;
                end if;

            else
                -- if wdt is disabled, dont reset system
                s_cnt     <= 0;
                o_reset_n <= '1';
            end if;
        end if;
    end process;

end rtl;
