library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 


entity LFSR is
  port(Clk, Reset : in std_logic;
      Rand_Bits_Out : out std_logic_vector(7 downto 0));
end entity LFSR;

architecture behaviour of LFSR is
  signal temp_bits : std_logic_vector(7 downto 0) := "01011001";
begin
  
  rand : process(reset, clk) 
    begin
      if(Reset = '0') then --active low
        temp_bits <= "01011001";--initialise bits 
      elsif(rising_edge(Clk)) then 
			
        temp_bits(7) <= temp_bits(0);
        temp_bits(6) <= temp_bits(7) XOR temp_bits(0);
        temp_bits(5) <= temp_bits(6);
		  temp_bits(4) <= temp_bits(5);
		  temp_bits(3) <= temp_bits(4);
		  temp_bits(2) <= temp_bits(3);
		  temp_bits(1) <= temp_bits(2);
		  temp_bits(0) <= temp_bits(1);	  
      end if;
      Rand_Bits_Out <= temp_bits; -- assign temporary signal to the output
  end process rand;
end architecture behaviour;