library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY lives is
	PORT (pipeCollision, groundCollision, giftCollection, newGame : IN std_logic;
		   lives : OUT integer;
			gameOver : OUT std_logic);
END ENTITY lives;

architecture behaviour of lives is
begin

	updateLives : process (pipeCollision, groundCollision, giftCollection, newGame)
		variable livesTemp : INTEGER range 0 to 1 := 1;
		variable gameOverTemp : std_logic := '0';
	begin
		if (newGame = '0') then 
			livesTemp := 1;
		elsif (groundCollision = '1' OR pipeCollision = '1') then
			livesTemp := 0;
		elsif (giftCollection = '1') then
			livesTemp := livesTemp + 1;
		end if;
		
		if (livesTemp = 0) then 
			gameOverTemp := '1';
		else
			gameOverTemp := '0';
		end if;
		
		lives <= livesTemp;
		gameOver <= gameOverTemp;
	end process;
end architecture behaviour;