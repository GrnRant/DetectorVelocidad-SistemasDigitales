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
    signal delay_rst: std_logic;
    --Salida del comparador (entrada es "count")
    signal comp_out: std_logic;
    --Salida del asincrónico
    signal asinc_out: std_logic;
    --Entrada al bloque del delay
    signal delay_in: std_logic;
    --Señal auxiliar para manejar tiempo de matenido 
    --(cuatro ciclos de clks)
    signal delay_reg: std_logic_vector(DELAY_CICLOS-1 downto 0) := (others => '0');
    constant cero: std_logic_vector(DELAY_CICLOS-1 downto 0) := (others => '0'); 
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
            --COMPARADOR
            --Salida del comparador es el bit más significativo
            -- del contador
            if rst_cont = '0' then
                comp_out <= count(BITS_CONTADOR-1);
            else
                comp_out <= '1';
            end if;
            if (comp_out = '0' and s1 = '1' and s2 = '1') then
                delay_in <= '1';
            else
                delay_in <= '0';
            end if;
            
            
            if rising_edge(clk_cont) then
                --RESET CONTADOR
                --Tiene delay de un ciclo
                if delay_rst = '1' then
                    rst_cont <= not asinc_out;
                    delay_rst <= '0';
                end if;
                delay_rst <= '1';

                --DELAY ALARMA
                --Manejo del delay en la alarma (se mantiene 
                --durante DELAY_CICLOS)
                delay_reg(DELAY_CICLOS-1 downto 1) 
                <= delay_reg(DELAY_CICLOS-2 downto 0);
                delay_reg(0) <= delay_in;
            end if;

    end process P_DETECTOR;

    --Salida del delay
    alarma <= '1' when delay_reg /= cero else '0';
    
end detector_beh;