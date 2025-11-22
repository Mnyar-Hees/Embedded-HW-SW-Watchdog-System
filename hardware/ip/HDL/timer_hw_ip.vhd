library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_hw_ip is
    port (
        clk      : in std_logic;
        reset_n  : in std_logic;
        -- Avalon Buss 
        cs_n     : in std_logic;
        write_n  : in std_logic;
        read_n   : in std_logic;
        addr     : in std_logic_vector(1 downto 0);
        din      : in std_logic_vector(31 downto 0);
        dout     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of timer_hw_ip is

    signal s_ctrl_reg : std_logic_vector(1 downto 0);
    signal data_reg   : std_logic_vector(31 downto 0);

    component timer is
        port (
            clk          : in std_logic;
            reset_n      : in std_logic;
            i_ctrl_reg   : in std_logic_vector(1 downto 0);
            o_timer_data : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -------------------------------------------------
    ------------ Avalon buss control ----------------
    -------------------------------------------------

    -- Write 
    process (clk, reset_n) is
    begin
        if reset_n = '0' then      -- asynchronous reset (active low)
            s_ctrl_reg <= (others => '0');
        elsif rising_edge(clk) then -- rising clock edge
            if cs_n = '0' and write_n = '0' and read_n = '1' and addr = "01" then
                s_ctrl_reg <= din(31 downto 30);
            end if;
        end if;
    end process;

    -- Read 
    process (cs_n, read_n, write_n, addr, data_reg) is
    begin
        if cs_n = '0' and write_n = '1' and read_n = '0' and addr = "00" then
            dout <= data_reg;
        else
            dout <= (others => '0'); -- 'X'
        end if;
    end process;

    --------------------------------------------------
    --------- Timer component instantiation ----------
    --------------------------------------------------

    timer_inst : timer
        port map (
            clk          => clk,
            reset_n      => reset_n,
            i_ctrl_reg   => s_ctrl_reg,
            o_timer_data => data_reg
        );

end rtl;
