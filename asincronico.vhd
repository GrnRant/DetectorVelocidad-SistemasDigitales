library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.estados_asincronico.all;

entity asinc is
    port (s1: in std_logic;
          s2: in std_logic;  
          qo: out std_logic
          );
end asinc;

architecture asinc_beh of asinc is
    signal current_state: asinc_states := E1;
begin
    P_ASINC: process(s1, s2)
    begin
        if (s1 = '0' and s2 = '0') then
            current_state <= E1;
            qo <= '0';
        elsif (s1 = '0' and s2 = '1') then
            current_state <= E3;
        elsif (s1 = '1' and s2 = '1') then
            current_state <= E4;
        elsif (s1 = '1' and s2 = '0') then
            if current_state = E1 then
                qo <= '1';
            else
                qo <= '0';
            end if;        
            current_state <= E2;   
        end if;
    end process P_ASINC;
end asinc_beh;