LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		(SIGNAL  clk, vert_sync, left_click	: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		SIGNAL red, green, blue 			: OUT std_logic);		
END bouncy_ball;

architecture behavior of bouncy_ball is

	component char_rom
		PORT(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC);
	end component;
	
	component lives is
	PORT (pipeCollision, groundCollision, giftCollection, newGame : IN std_logic;
		   lives : OUT integer;
			gameOver : OUT std_logic);
	END component;

SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);

SIGNAL pipe_on					: std_logic;
SIGNAL pipe_size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL pipe_y_pos				: std_logic_vector(10 DOWNTO 0);
SiGNAL pipe_x_pos				: std_logic_vector(9 DOWNTO 0):= conv_STD_LOGIC_VECTOR(599,10);
SIGNAL pipe_x_motion			: std_logic_vector(9 DOWNTO 0);

SIGNAL previosClick			: std_logic := '0';
SIGNAL charAddress : std_LOGIC_VECTOR(5 downto 0);
SIGNAL charOn, rom_mux_output : std_logic;

SIGNAL pipe, ground, gift, newGamee, gameOverr : std_logic := '0';
SIGNAL livesGame : integer;
BEGIN      

char: char_rom PORT MAP(clock =>clk, font_row=>pixel_row(4 downto 2), font_col=>pixel_column(4 downto 2), character_address=>charAddress, 
			rom_mux_output => rom_mux_output); 
livess : lives PORT MAP(pipe, ground, gift, newGamee, livesGame, gameOverr);			

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(100,11);

ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
--Red <=  '1';
--Green <= '1' and (not ball_on);
--Blue <=  not ball_on;

addText : process(pixel_row, pixel_column, ball_on)
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
	
	if (charOn = '1') then
		Red <= '0' XOR rom_mux_output;
		Green <= '0' XOR rom_mux_output;
		Blue <= '0' XOR rom_mux_output;
	elsif (ball_on = '1') then
		Red <= '0';
		Green <= '1';
		Blue <= '0';
	elsif (pipe_on = '1') then
		Red <= '1';
		Green <= '0';
		Blue <= '0';
	else 
		Red <= '0';
		Green <= '0';
		Blue <= '0';
	end if;
end process;


pipe_size <= CONV_STD_LOGIC_VECTOR(20,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
pipe_y_pos <= CONV_STD_LOGIC_VECTOR(0,11);

pipe_gen : process(clk, pixel_row, pixel_column, pipe_size, pipe_x_pos, pipe_y_pos)
		begin	
			if( ('0' & pipe_x_pos <= pixel_column + pipe_size) and ('0' & pixel_column <= pipe_x_pos + pipe_size) 	-- x_pos - size <= pixel_column <= x_pos + size
				and ('0' & pipe_y_pos <= pixel_row ) and ('0' & pixel_row <= pipe_y_pos + 479) ) then -- y_pos - size <= pixel_row <= y_pos + size
  				pipe_on <= '1';		
				if(pixel_row >= 250 AND pixel_row <= 350) then	
					pipe_on <='0';	
				end if;
			else	
				pipe_on <='0';	
			end if;
	end process pipe_gen;

Move_Pipe: process (vert_sync)  	
begin
	-- Move ball once every vertical sync
	if (rising_edge(vert_sync)) then			
		-- Bounce off sides of screen
		if ( ('0' & pipe_x_pos >= CONV_STD_LOGIC_VECTOR(639,10) - pipe_size) ) then
			pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(3,10);
		elsif (pipe_x_pos <= size) then 
			pipe_x_motion <= CONV_STD_LOGIC_VECTOR(3,10);
		end if;
		-- Compute next ball X position
		pipe_x_pos <= pipe_x_pos + pipe_x_motion;
	end if;
end process Move_Pipe;



MoveBall: Process(left_click,ball_y_pos, vert_sync)
begin

 if(rising_edge(vert_sync))then
 
	 if (('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size) ) then
			ground <= '1';
	 elsif(ball_y_pos <= size) then 
			ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
    elsif(left_click = '0') then
      ball_y_motion <=  CONV_STD_LOGIC_VECTOR(2,10);
		previosClick <= '0';
    elsif(left_click = '1' AND previosClick = '0') then
      ball_y_motion <= - CONV_STD_LOGIC_VECTOR(40,10);
		previosClick <= '1';
	 else 
		ball_y_motion <=  CONV_STD_LOGIC_VECTOR(2,10);
    end if;
		
		if (ground = '1') then
			ball_y_motion <= 479 - size;
		elsif (ball_y_pos + ball_y_motion <= (0 + size)) then
			ball_y_pos <= (others => '0');
			ball_y_pos <= ball_y_pos + size;
		else
			ball_y_pos <= ball_y_pos + ball_y_motion;
		end if;
	end if;
end process MoveBall;

end architecture behavior;
