library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity detector_tb is
end detector_tb;

architecture detector_tb_beh of detector_tb is
constant T_CLOCK: time := 25 ms;
signal s1_tb: std_logic := '0';
signal s2_tb: std_logic := '0';
signal clk_cont_tb: std_logic := '0';
signal alarma_tb: std_logic;

begin

    INST_DETECTOR: entity work.detector(detector_beh)
            port map(
                    s1 => s1_tb,
                    s2 => s2_tb,
                    clk_cont => clk_cont_tb,
                    alarma => alarma_tb 
                    );
    clk_cont_tb  <= not clk_cont_tb after T_CLOCK/2;
    s1_tb <= '1' after 1000 ms, '0' after 1400 ms;
    s2_tb <= '1' after 1100 ms, '0' after 1500 ms;
end detector_tb_beh;