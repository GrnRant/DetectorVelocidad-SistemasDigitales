library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.estados_asincronico.all;

entity detector is
    generic(BITS_CONTADOR: natural := 4; 
            DELAY_CICLOS: natural := 4);
    port (s1: in std_logic;
          s2: in std_logic;
          clk_cont: in std_logic;
          alarma: out std_logic
          );
end detector;

architecture detector_beh of detector is
    --Entradas y salidas del contador (sincrónico)
    signal count: std_logic_vector(BITS_CONTADOR-1 downto 0);
    signal rst_cont: std_logic;
    --Salida del comparador (entrada es "count")
    signal comp_out: std_logic;
    --Salida del asincrónico
    signal asinc_out: std_logic;
    --Entrada al bloque del delay
    signal delay_in: std_logic;
    --Señal auxiliar para manejar tiempo de matenido 
    --(cuatro ciclos de clks)
    signal delay_count: std_logic_vector(DELAY_CICLOS-1 downto 0);
begin
    --Sincrónico (contador 4 bits)
    COUNTER_INST : entity work.counter(counter_beh)
        generic map(N => BITS_CONTADOR)
        port map(
            ena => asinc_out,
            clk => clk_cont,
            rst => rst_cont,
            count => count
        );
    --Asincrónico
    ASINC_INST :  entity work.asinc(asinc_beh)
        port map(
            s1 => s1,
            s2 => s2,  
            qo => asinc_out
        );

    P_DETECTOR: process(clk_cont, s1, s2)
        begin
            --Reset contador
            rst_cont <= not asinc_out;

            --COMPARADOR
            --Salida del comparador es el bit más significativo
            -- del contador 
            comp_out <= count(BITS_CONTADOR-1);
            if (comp_out = '1' and asinc_out = '0') then
                delay_in <= '1';
            else
                delay_in <= '0';
            end if;
            
            --DELAY
            --Manejo del delay en la alarma (se mantiene 
            --durante DELAY_CICLOS)
            if rising_edge(clk_cont) then
                delay_count(DELAY_CICLOS-1 downto 1) 
                <= delay_count(DELAY_CICLOS-2 downto 0);
                delay_count(0) <= delay_in;
            end if;
            --Salida del delay
            for i in 0 to (DELAY_CICLOS-1) loop
                if delay_count(i) = '1' then
                    alarma <= '1';
                end if;
            end loop;

    end process P_DETECTOR;
end detector_beh;