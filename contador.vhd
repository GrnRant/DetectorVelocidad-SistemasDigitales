library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic(N: natural := 4);

    port (ena: in std_logic;
          clk: in std_logic;  
          rst: in std_logic;
          count: out std_logic_vector(N-1 downto 0)
          );
end counter;

architecture counter_beh of counter is
    signal aux: unsigned(N-1 downto 0);
    signal max: integer := 15;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            aux <= (others => '0');
        end if;
        if rising_edge(clk) then
            --Si está habilitado
            if ena = '1' and to_integer(unsigned(aux)) /= max then
                --Sumar
                aux <= aux + 1;
            end if;
            count <= std_logic_vector(aux); 
        end if;
    end process;
end counter_beh;