LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

-- The chooseScreen component/block determines which screen should be shown to the user
-- as per the user's choice. This file has a characteristics of an FSM as is determines
-- the current state of the game.
entity ChooseScreen is
	PORT 
		(SIGNAL  clk, pushButton, left_click1, switch, vert_sync	: IN std_logic;
       SIGNAL pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		 SIGNAL stage 							: IN integer range 1 to 3;
		 SIGNAL red, green, blue, outputGameOver, outputStartGame, trainModeOut			: OUT std_logic;
		 SIGNAL SW_1							: IN std_logic);
end entity;

architecture behaviour of ChooseScreen is
	-- Main Menu Component (Displaying main menu to the user)
	component DisplayText
	PORT(clock, switch : in std_logic;
		  pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		  red, green, blue : out std_logic);
	end component;
	
	-- Ball Component that represents the bird
	component bouncy_ball
	PORT
		(SIGNAL  clk, vert_sync, left_click, startGame, SW_1	: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  SIGNAL stage								: IN integer range 1 to 3;
		SIGNAL red, green, blue, gameOver 			: OUT std_logic);
	END component;
	
	
	-- RGB Signals 
	signal redBallStatic, greenBallStatic, blueBallStatic : std_logic;
	signal redBall, greenBall, blueBall : std_logic;
	signal redMenu, greenMenu, blueMenu : std_logic;
	
	-- Game Over & Start Signals 
	signal gameOverTrain, gameOver : std_logic;
	signal startGameTrain, startGame : std_logic;
	
	-- States of the game:
	-- "00" --> Main Menu
	-- "01" --> Training (static ball)
	-- "10" --> Game (moving ball)
	signal currentState : std_logic_vector(1 downto 0) := "00";
begin
	GAME_MODE : bouncy_ball port map (clk, vert_sync, left_click1, startGame, SW_1, pixel_row, pixel_column, stage, redBall, greenBall, blueBall, gameOver);
	MENU : DisplayText port map (clk, switch, pixel_row, pixel_column, redMenu, greenMenu, blueMenu);
	TRAIN_MODE : bouncy_ball port map (clk, vert_sync, left_click1, startGameTrain, SW_1, pixel_row, pixel_column, stage, redBallStatic, greenBallStatic, blueBallStatic, gameOverTrain);

	red <= redMenu when (currentState = "00") else
			 redBallStatic when (currentState = "01") else
			 redBall when (currentState = "10");
	blue <= blueMenu when (currentState = "00") else
			  blueBallStatic when (currentState = "01") else
			  blueBall when (currentState = "10");
	green <= greenMenu when (currentState = "00") else
				greenBallStatic when (currentState = "01") else
				greenBall when (currentState = "10");
	
	outputGameOver <= gameOverTrain when (currentState = "01") else
							gameOver;
	outputStartGame <= startGameTrain when (currentState = "01") else
							 startGame;
	
	-- The following process determines 
	showScreen : process (pushButton)
	begin
		if (pushButton = '0') then
			-- User has chosen TRAINING mode
			if (currentState = "00" AND switch = '1') then
				currentState <= "01";
				startGame <= '0';
				startGameTrain <= '1';
				trainModeOut <= '1';
			-- User has chosen GAME mode
			elsif (currentState = "00" AND switch = '0') then
				currentState <= "10";
				startGame <= '1';
				startGameTrain <= '0';
				trainModeOut <= '0';
			elsif (gameOver = '1' OR gameOverTrain = '1') then
				currentState <= "00";
				startGame <= '0';
				startGameTrain <= '0';
				trainModeOut <= '0';
			end if;
		end if;
	end process;
	
end architecture behaviour;