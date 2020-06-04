LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		(SIGNAL  clk, vert_sync, left_click, startGame, SW_1	: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  SIGNAL stage								: IN integer range 1 to 3;
		SIGNAL red, green, blue, gameOver			: OUT std_logic);		
END bouncy_ball;

architecture behavior of bouncy_ball is
	
	component lives is
	PORT (pipeCollision, groundCollision, giftCollection, newGame : IN std_logic;
		   lives : OUT integer;
			gameOver : OUT std_logic);
	END component;
	
	component pipes IS
	PORT
		(SIGNAL  clk, vert_sync, startGame, endGame, SW_1					: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  SIGNAL stage								: IN integer range 1 to 3;
		SIGNAL Pipe_Out2							: OUT std_logic);		
	END component;
	
		
	component pipes1 IS
	PORT
		(SIGNAL  clk, vert_sync, startGame, endGame, SW_1					: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  SIGNAL stage								: IN integer range 1 to 3;
		SIGNAL Pipe_Out2							: OUT std_logic);		
	END component;
	
	component displayLives IS
		PORT
			(SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
			 SIGNAL livesGame 						: IN integer;
			 SIGNAL charAddress 						: OUT std_logic_vector(5 downto 0);
			 SIGNAL charOn								: OUT std_logic);
	END component;

SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);

SIGNAL pipe_on, pipe_on1					: std_logic;

SIGNAL previosClick			: std_logic := '0';

SIGNAL pipe, ground, gift, newGamee, gameOverrr : std_logic := '0';
SIGNAL livesGame : integer;

BEGIN       
livess : lives PORT MAP(pipe, ground, gift, startGame, livesGame, gameOverrr);
pipeGen : pipes PORT MAP (clk, vert_sync, startGame, gameOverrr, SW_1, pixel_row, pixel_column, stage, pipe_on);
pipeGen1 : pipes1 PORT MAP (clk, vert_sync, startGame, gameOverrr, SW_1, pixel_row, pixel_column, stage, pipe_on1);


gameOver <= gameOverrr;		

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(100,11);

ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';

Red <= '0' when (ball_on = '1') else
		 '1' when (pipe_on = '1' OR pipe_on1 = '1') else
		 '0';

Green <= '1' when (ball_on = '1') else
			'0' when (pipe_on = '1' OR pipe_on1 = '1') else
			'0';
		 
Blue <= '0';
		 
pipe <= '1' when ((ball_on = '1') AND (pipe_on = '1' OR pipe_on1 = '1')) else
		  '0';

MoveBall: Process(vert_sync)
begin

 if(rising_edge(vert_sync))then
 
	 if (SW_1 = '1') then
		ball_y_motion <= CONV_STD_LOGIC_VECTOR(0,10);
	 elsif (('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479,10) - size) ) then
			ground <= '1';
	 elsif(ball_y_pos <= size) then 
			ball_y_motion <= CONV_STD_LOGIC_VECTOR(4,10);
    elsif(left_click = '0') then
      ball_y_motion <=  CONV_STD_LOGIC_VECTOR(4,10);
		previosClick <= '0';
    elsif(left_click = '1' AND previosClick = '0') then
      ball_y_motion <= - CONV_STD_LOGIC_VECTOR(50,10);
		previosClick <= '1';
	 else 
		ball_y_motion <=  CONV_STD_LOGIC_VECTOR(4,10);
    end if;
		
		if (startGame = '0') then
			ball_y_pos <= CONV_STD_LOGIC_VECTOR(200, 10);
			ground <= '0';
		elsif (ground = '1') then
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
