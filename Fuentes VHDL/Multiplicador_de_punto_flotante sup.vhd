library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplicador_de_punto_flotante_clk is
    Port ( clk_i : in STD_LOGIC;
		   x 	 : in STD_LOGIC_VECTOR (31 downto 0);   --Factor X
           y 	 : in STD_LOGIC_VECTOR (31 downto 0);   --factor Y
           z 	 : out STD_LOGIC_VECTOR (31 downto 0)); --Producto Z
end Multiplicador_de_punto_flotante_clk;

architecture arch_Multiplicador_de_punto_flotante_clk of Multiplicador_de_punto_flotante_clk is

	component Multiplicador_de_punto_flotante is
		Port ( x 	 : in STD_LOGIC_VECTOR (31 downto 0);   --Factor X
			   y 	 : in STD_LOGIC_VECTOR (31 downto 0);   --factor Y 
			   z 	 : out STD_LOGIC_VECTOR (31 downto 0)); --Producto Z
	end component Multiplicador_de_punto_flotante;

	signal x2: STD_LOGIC_VECTOR (31 downto 0);
	signal y2: STD_LOGIC_VECTOR (31 downto 0);
	signal z2: STD_LOGIC_VECTOR (31 downto 0);

begin
	mul_pf_inst: Multiplicador_de_punto_flotante
	port map (
		x => x2,
		y => y2,
		z => z2
	);
	
    process (clk_i)
        begin 
			if rising_edge(clk_i) then
				x2 <= x;
				y2 <= y;
				z  <= z2;
			end if;
    end process;
end arch_Multiplicador_de_punto_flotante_clk;


