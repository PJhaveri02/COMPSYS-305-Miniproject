LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity DisplayText is
	PORT(clock, switch : in std_logic;
		  pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		  red, green, blue : out std_logic);
end entity;

architecture behaviour of DisplayText is
	component char_rom
		PORT(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC);
	end component;
	
	signal rom_mux_output : std_logic;
	signal charAddress	: std_logic_vector(5 downto 0);
	signal charOn	: std_logic; 
begin
	char: char_rom PORT MAP(clock =>clock, font_row=>pixel_row(4 downto 2), font_col=>pixel_column(4 downto 2), character_address=>charAddress, 
			rom_mux_output => rom_mux_output);

	-- Currently the text is being displayed 3 times the original size due to the shift of pixel_row & pixel_column
	-- The original size is 8X8
	textDisplay : Process(pixel_row, pixel_column)
		-- This variable says where the text should begin
		variable BEGIN_POINT 			  : INTEGER  := 128;
		variable BEGIN_POINT_MODE_TITLE : INTEGER  := 128;
		variable BEGIN_POINT_MODE 	     : INTEGER	 := 96;
	begin           
		if (pixel_row >= CONV_STD_LOGIC_VECTOR(0,10)) AND (pixel_row <= CONV_STD_LOGIC_VECTOR(31,10)) then
			-- F
			if (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 31,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(6,6);
					charOn <= '1';
			-- L
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 32,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 63,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(12,6);
					charOn <= '1';
			-- A
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 64,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 95,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(1,6);
					charOn <= '1';
			-- P
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 96,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 159,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(16,6);
					charOn <= '1';
			-- Y
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 160,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 191,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(25,6);
					charOn <= '1';
			-- SPACE
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 192,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 223,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(32,6);
					charOn <= '1';
			-- B
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 224,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 255,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(2,6);
					charOn <= '1';
			-- I
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 256,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 287,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(9,6);
					charOn <= '1';
			-- R
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 288,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 319,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(18,6);
					charOn <= '1';
			-- D
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 320,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 351,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(4,6);
					charOn <= '1';
			-- !
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 352,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT + 383,10)) then 
					charAddress <= CONV_STD_LOGIC_VECTOR(33,6);
					charOn <= '1';
			else
				charOn <= '0';
			end if;
		-- SELECT MODE
		elsif (pixel_row >= CONV_STD_LOGIC_VECTOR(128,10)) AND (pixel_row <= CONV_STD_LOGIC_VECTOR(159,10)) then
			-- S
			if (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 31,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(19,6);
					charOn <= '1';
			-- E
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 32,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 63,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(5,6);
					charOn <= '1';
			-- L
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 64,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 95,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(12,6);
					charOn <= '1';
			-- E
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 96,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 127,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(5,6);
					charOn <= '1';
			-- C
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 128,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 159,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(3,6);
					charOn <= '1';
			-- T
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 160,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 191,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(20,6);
					charOn <= '1';
			-- SPACE
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 192,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 223,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(32,6);
					charOn <= '1';
			-- M
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 224,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 255,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(13,6);
					charOn <= '1';
			-- O
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 256,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 287,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(15,6);
					charOn <= '1';
			-- D
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 288,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 319,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(4,6);
					charOn <= '1';
			-- E
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 320,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE_TITLE + 351,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(5,6);
					charOn <= '1';
			else 
				charOn <= '0';
			end if;
		-- TRAINING MODE
		elsif (pixel_row >= CONV_STD_LOGIC_VECTOR(192,10)) AND (pixel_row <= CONV_STD_LOGIC_VECTOR(223,10)) then
			-- 1
			if (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 31,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(49,6);
					charOn <= '1';
			-- .
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 32,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 63,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(46,6);
					charOn <= '1';
			-- T
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 64,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 95,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(20,6);
					charOn <= '1';
			-- R
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 96,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 127,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(18,6);
					charOn <= '1';
			-- A
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 128,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 159,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(1,6);
					charOn <= '1';
			-- I
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 160,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 191,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(9,6);
					charOn <= '1';
			-- N
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 192,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 223,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(14,6);
					charOn <= '1';
			-- I
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 224,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 255,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(9,6);
					charOn <= '1';
			-- N
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 256,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 287,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(14,6);
					charOn <= '1';
			-- G
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 288,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 319,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(7,6);
					charOn <= '1';
						-- SPACE
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 320,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 383,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(32,6);
					charOn <= '1';
			-- <-- WHEN MODE IS 1
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 384,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 415,10) AND switch = '1') then
					charAddress <= CONV_STD_LOGIC_VECTOR(31,6);
					charOn <= '1';
			else 
				charOn <= '0';
			end if;
		-- GAME MODE
		elsif (pixel_row >= CONV_STD_LOGIC_VECTOR(224,10)) AND (pixel_row <= CONV_STD_LOGIC_VECTOR(255,10)) then
			-- 2
			if (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 31,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(50,6);
					charOn <= '1';
			-- .
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 32,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 63,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(46,6);
					charOn <= '1';
			-- G
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 64,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 95,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(7,6);
					charOn <= '1';
			-- A
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 96,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 127,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(1,6);
					charOn <= '1';
			-- M
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 128,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 159,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(13,6);
					charOn <= '1';
			-- E
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 160,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 191,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(5,6);
					charOn <= '1';
			-- SPACE
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 192,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 383,10)) then
					charAddress <= CONV_STD_LOGIC_VECTOR(32,6);
					charOn <= '1';
			-- <-- WHEN MODE IS 0
			elsif (pixel_column >= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 384,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(BEGIN_POINT_MODE + 415,10) AND switch = '0') then
					charAddress <= CONV_STD_LOGIC_VECTOR(31,6);
					charOn <= '1';
			else 
				charOn <= '0';
			end if;
		else 
			charOn <= '0';
		end if;
	end process;

	red <= '0';
	green <=	(charOn AND rom_mux_output);
	blue <= '1';

end architecture behaviour;