library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Multiplicador_de_punto_flotante is
--  Port ( );
end tb_Multiplicador_de_punto_flotante;

architecture Behavioral of tb_Multiplicador_de_punto_flotante is

component Multiplicador_de_punto_flotante_clk is
    Port ( clk_i 	: in STD_LOGIC;
		   x 		: in STD_LOGIC_VECTOR (31 downto 0);   --Factor X
           y        : in STD_LOGIC_VECTOR (31 downto 0);   --factor Y 
           z        : out STD_LOGIC_VECTOR (31 downto 0)); --Producto Z
end component;

--entradas
signal clk_tb : STD_LOGIC := '0';                    --clk
signal x_tb : STD_LOGIC_VECTOR (31 downto 0);   --Factor X2
signal y_tb : STD_LOGIC_VECTOR (31 downto 0);   --factor Y2 

--salida
signal z_tb : STD_LOGIC_VECTOR (31 downto 0); --Producto Z2

begin
    clk_tb <= not clk_tb after 10 ns;
    
    uut: Multiplicador_de_punto_flotante_clk PORT MAP (
          clk_i => clk_tb,
          x => x_tb,
          y => y_tb,
          z => z_tb
        );
     stim_proc: process
     begin        
              -- hold reset state for 100 ns.
        --/wait for 100 ns;               
                   x_tb<="01000000001000000000000000000000"; --2.5
                   y_tb<="11000001001010000000000000000000"; --(-10.5)
            
         wait;
     end process;
end Behavioral;







