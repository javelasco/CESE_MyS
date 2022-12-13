library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity Multiplicador_de_punto_flotante is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);   --Factor X
           y : in STD_LOGIC_VECTOR (31 downto 0);   --factor Y 
           z : out STD_LOGIC_VECTOR (31 downto 0)); --Producto Z
end Multiplicador_de_punto_flotante;

architecture Behavioral of Multiplicador_de_punto_flotante is

begin
        process (x,y)
                -- 
                variable x_bit_signo : STD_LOGIC;
                variable x_exponente : STD_LOGIC_VECTOR (8 downto 0);   --exponente  
                variable x_mantissa  : STD_LOGIC_VECTOR (23 downto 0);  --mantisa
                -- 
                variable y_bit_signo : STD_LOGIC;
                variable y_exponente : STD_LOGIC_VECTOR (8 downto 0);
                variable y_mantissa  : STD_LOGIC_VECTOR (23 downto 0);
                --
                variable z_bit_signo : STD_LOGIC;
                variable z_exponente : STD_LOGIC_VECTOR (7 downto 0);
                variable z_mantissa : STD_LOGIC_VECTOR (22 downto 0);
                --
                variable suma_exponente : STD_LOGIC_VECTOR (8 downto 0);
                variable carry1 : STD_LOGIC:='0';
                variable carry2 : STD_LOGIC:='0';
                variable temporal1 : STD_LOGIC_VECTOR (8 downto 0);
                variable temporal2 : STD_LOGIC_VECTOR (8 downto 0);
                variable multiplicacion_temporal : STD_LOGIC_VECTOR (47 downto 0);
                variable multiply_store : STD_LOGIC_VECTOR (47 downto 0);
                variable multiply_store_temp : STD_LOGIC_VECTOR(47 downto 0);
                variable multiply_rounder : STD_LOGIC_VECTOR (22 downto 0);
        
        begin 
                x_bit_signo := x(31);
                x_exponente(7 downto 0) := x(30 downto 23);
                x_exponente(8) := '0';
                x_mantissa(22 downto 0) := x(22 downto 0);
                x_mantissa(23) := '0';
                
                y_bit_signo := y(31);
                y_exponente(7 downto 0) := y(30 downto 23);
                y_exponente(8) := '0';
                y_mantissa(22 downto 0) := y(22 downto 0);
                y_mantissa(23) := '0';
                        
                if (x_exponente = 255 or y_exponente = 255) then
                        z_bit_signo := x_bit_signo xor y_bit_signo;
                        z_exponente := "11111111";
                        z_mantissa  := (others => '0');
                elsif (x_exponente = 0 or y_exponente = 0 ) then
                        z_bit_signo :='0';
                        z_exponente := (others => '0');
                        z_mantissa  := (others => '0');
                        
                else
                        temporal1 := "001111111";
                        temporal2 := "000000001";
                        multiplicacion_temporal := (others=>'0');
                        multiply_store := (others => '0');
                        multiply_store_temp := (others => '0');
                        
                        
                        multiply_rounder := (others =>'0');
                        multiply_rounder(0) :='1';
                        




                        --adicion de 1 al bit mas significativo 
                        --para realizar la multiplicacion
                        x_mantissa(23) := '1';
                        y_mantissa(23) := '1';
                        
                        --multiplicacion y sumatoria de las mantisas
                        for j in 0 to 23 loop
                            multiplicacion_temporal := (others => '0');
                            if (y_mantissa(j)='1')then
                            --se asigna el valor de X_mantisa a multiplicacion temporal 
                            -- y no se no afecta al valor original 
                                    multiplicacion_temporal(23+j downto j) := x_mantissa;
                            end if;
                            -- el valor multiplicado se almacena en un valor temporal
                            --para no afectar de manera directa a la resultante
                            multiply_store_temp := multiply_store;
                            
                            --sumador completo de las operaciones de multiplicacion en 48 bits
                            for i in 0 to 47 loop 
                                    multiply_store(i) := multiply_store_temp(i) xor multiplicacion_temporal(i) xor carry1;
                                    carry1  := ( multiply_store_temp(i) and multiplicacion_temporal(i) ) or ( multiply_store_temp(i) and carry1 ) or ( multiplicacion_temporal(i) and carry1 );
                            end loop;
                    end loop;
                    
                    carry1 := '0';
                    carry2 := '0';
                    --agregado simple del x_exponente e y_exponente
                    for i in 0 to 8 loop
                            suma_exponente(i) := x_exponente(i) xor y_exponente(i) xor carry1;
                            carry1 := (x_exponente(i) and y_exponente(i)) or (x_exponente(i) and carry1) or (y_exponente(i) and carry1);
                    end loop;
                    
                    carry1 := '0';--reasignacion a cero 
                    carry2 := '0';--reasignacion a cero
                    
                    if (multiply_store(47)='1')then
                            --asignando valor a la mantisa de Z
                            --incremento de exponente por desplasamiento de coma
                            for i in 0 to 8 loop
                                    carry1 := suma_exponente(i) ;
                                    suma_exponente(i) := carry1 xor temporal2(i) xor carry2 ;
                                    carry2 := (temporal2(i) and carry1) or (carry1 and carry2) or (temporal2(i) and carry2 ) ;                    
                            end loop;
                            
                            
                            z_mantissa := multiply_store(46 downto 24);
                            carry1 := '0';--reasignacion a cero 
                            carry2 := '0';--reasignacion a cero 
                            multiply_rounder(0) := multiply_store(23);
                            
                            --operacion de redondeo de la mantisa
                            for i in 0 to 22 loop
                                    carry1 := z_mantissa(i);
                                    z_mantissa(i) := carry1 xor multiply_rounder(i) xor carry2;
                                    carry2 := (multiply_rounder(i) and carry1) or (multiply_rounder(i) and carry2) or (carry1 and carry2);
                                    
                            end loop;
                    else 
                            z_mantissa := multiply_store(45 downto 23);
                            
                            carry1 := '0';--reasignacion a cero
                            carry2 := '0';--reasignacion a cero
                            
                            multiply_rounder(0) := multiply_store(22);
                            
                            
                            for i in 0to 22 loop
                                    carry1 := z_mantissa(I) ;
                                    z_mantissa(I) :=  carry1 xor multiply_rounder(I) xor carry2 ;
                                    carry2 := (multiply_rounder(I) and carry1 ) or ( multiply_rounder(I) and carry2 ) or ( carry1 and carry2 ) ;
                             end loop;
                    end if;
                    --resta de z_exponente -127
                    for i in 0 to 8 loop
                            carry1 := suma_exponente(i) ;
                            suma_exponente(i) :=  carry1 xor temporal1(I) xor carry2 ;
                            carry2 := ( carry2 and Not carry1 ) or ( temporal1(i) and Not carry1 ) or (temporal1(i) and carry2) ;
                    end loop;
                    
                    if (suma_exponente (8) = '1') then
                                --desbordamiento
                            if(suma_exponente(7) = '0')then
                                
                                    z_bit_signo := x_bit_signo xor y_bit_signo; 
                                    z_exponente := "11111111";
                                    z_mantissa :=(others => '0');
                            --representación negativa de subdesbordamiento
                            else
                            
                                    z_bit_signo := '0';
                                    z_exponente := (others => '0');
                                    z_mantissa := (others => '0');
                                 
                            end if;
                    else
                            
                            z_exponente := suma_exponente(7 downto 0);
                            z_bit_signo := x_bit_signo xor y_bit_signo;
                            
                    end if; 
                           
                    z_bit_signo := x_bit_signo xor y_bit_signo; 
                    
                    
             end if;
             
             z(31)<= z_bit_signo;
             z(30 downto 23) <= z_exponente;
             z(22 downto 0) <= z_mantissa;
        end process;
end Behavioral;
