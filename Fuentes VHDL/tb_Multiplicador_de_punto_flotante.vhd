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

component Multiplicador_de_punto_flotante is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);   --Factor X
           y : in STD_LOGIC_VECTOR (31 downto 0);   --factor Y 
           z : out STD_LOGIC_VECTOR (31 downto 0)); --Producto Z
end component;


--entradas
signal x : STD_LOGIC_VECTOR (31 downto 0);   --Factor X
signal y : STD_LOGIC_VECTOR (31 downto 0);   --factor Y 

--salida
signal z : STD_LOGIC_VECTOR (31 downto 0); --Producto Z

begin

     uut: Multiplicador_de_punto_flotante PORT MAP (
          x => x,
          y => y,
          z => z
        );
     stim_proc: process
     begin        
              -- hold reset state for 100 ns.
         wait for 100 ns;
                
                   x<="01000000001000000000000000000000"; --2.5
                   y<="11000001001010000000000000000000"; --(-10.5)
            
         wait;
     end process;
end Behavioral;







