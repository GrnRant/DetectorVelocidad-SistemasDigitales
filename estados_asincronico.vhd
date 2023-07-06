library IEEE;
use IEEE.std_logic_1164.all;

package estados_asincronico is
    --E1->00 E2->01 E3->10 E4->11 Siendo Ei=(S1,S2)
    type asinc_states is (E1, E2, E3, E4);
end package estados_asincronico;
