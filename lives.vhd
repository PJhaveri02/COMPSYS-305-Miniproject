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
SIGNAL livesTemp : integer := 3;

begin
	updateLives : process (pipeCollision, groundCollision, giftCollection, newGame)
	begin
		if (newGame = '1') then 
			livesTemp <= 3;
		elsif (pipeCollision = '1') then
			livesTemp <= livesTemp - 1;
		elsif (groundCollision = '1') then
			livesTemp <= 0;
		elsif (giftCollection = '1') then
			livesTemp <= livesTemp + 1;
		else 
			livesTemp <= 3;
		end if;
		
		if (livesTemp = 0) then 
			gameOver <= '1';
		else
			gameOver <= '0';
		end if;
		
		lives <= livesTemp;
	end process;
end architecture behaviour;