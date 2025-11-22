library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port (
        clk          : in std_logic;
        reset_n      : in std_logic;
        i_ctrl_reg   : in std_logic_vector(1 downto 0);
        o_timer_data : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of timer is
    signal s_timer_cnt : unsigned(31 downto 0);
begin

    process (clk, reset_n) is
    begin
        if reset_n = '0' then
            s_timer_cnt <= (others => '0');
        elsif rising_edge(clk) then
            case i_ctrl_reg is
                -- start timer
                when "10" =>
                    s_timer_cnt <= s_timer_cnt + 1;

                -- stop timer 
                when "00" =>
                    s_timer_cnt <= s_timer_cnt;

                -- reset timer 
                when "01" =>
                    s_timer_cnt <= (others => '0');

                when others =>
                    s_timer_cnt <= s_timer_cnt;
            end case;
        end if;
    end process;

    o_timer_data <= std_logic_vector(s_timer_cnt);

end architecture rtl;
