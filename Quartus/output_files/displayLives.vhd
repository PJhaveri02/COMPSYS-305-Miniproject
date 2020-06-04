LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY displayLives IS
	PORT
		(SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		 SIGNAL livesGame 						: IN integer;
		 SIGNAL charAddress 						: OUT std_logic_vector(5 downto 0);
		 SIGNAL charOn								: OUT std_logic);
END displayLives;

architecture beh of displayLives is
begin
	addText : process(pixel_row, pixel_column)
	variable BEGIN_POINT  : INTEGER  := 192;
begin
	if (pixel_row >= CONV_STD_LOGIC_VECTOR(0,10)) AND (pixel_row <= CONV_STD_LOGIC_VECTOR(31,10)) then
			-- L
			if (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 31,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(12,6);
					charOn <= '1';
			-- I
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 32,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 63,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(9,6);
					charOn <= '1';
			-- V
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 64,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 95,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(22,6);
					charOn <= '1';
			-- E
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 96,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 127,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(5,6);
					charOn <= '1';
			-- S
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 128,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 159,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(19,6);
					charOn <= '1';
			-- -
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 160,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 191,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(45,6);
					charOn <= '1';
			-- Lives
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 192,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 223,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(48 + livesGame,6);
					charOn <= '1';
			else 
				charOn <= '0';
		end if;
	else 
	end if;
end process;
end architecture beh;