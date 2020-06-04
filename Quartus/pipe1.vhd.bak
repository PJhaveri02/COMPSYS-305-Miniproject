LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;


ENTITY pipe1 IS
	PORT
		(SIGNAL  clk, vert_sync : IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		  SIGNAL LFSR_3_bit		: IN std_logic_vector(2 DOWNTO 0);
		  SIGNAL stage : IN integer range 1 to 3;
		SIGNAL Pipe_Out1	: OUT std_logic);		
END pipe1;

architecture behavior of pipe1 is

SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL pipe_y_pos				: std_logic_vector(9 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(0,10);
SIGNAL pipe_x_pos1			: std_logic_vector(10 DOWNTO 0):= conv_std_logic_vector(680,11);
SIGNAL pipe_x_motion			: std_logic_vector(10 DOWNTO 0):= conv_std_logic_vector(4,11);
SIGNAL lfsr						: std_logic_vector(2 DOWNTO 0);
SIGNAL gap 						: integer range 100 to 150 := 150;

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(20,10);
-- pipe_x_pos and pipe_y_pos show the (x,y) for the centre of pipe

pipe_gen : process(pipe_x_pos1, pipe_y_pos, pixel_row, pixel_column, size)
		begin	
			-- x_pos - size <= pixel_column <= x_pos + size
			-- y_pos - size <= pixel_row <= y_pos + size
			
			if( ('0' & pipe_x_pos1 <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & pipe_x_pos1 + size) and ('0' & pipe_y_pos <= '0' & pixel_row ) and ('0' & pixel_row <= '0' & pipe_y_pos + 479)) then 
  				Pipe_Out1<= '1';					
				case lfsr is 
					when "000" =>
						if(pixel_row >= 40 AND pixel_row <= 40 + gap) then
							Pipe_Out1<='0';
						end if;
						
					when "001" =>
						if(pixel_row >= 80 AND pixel_row <= 80 + gap) then
							Pipe_Out1<='0';
						end if;
						
					when "010" =>
						if(pixel_row >= 120 AND pixel_row <= 120 + gap) then
							Pipe_Out1<='0';
						end if;
						
					when "011" =>
						if(pixel_row >= 160 AND pixel_row <= 160 + gap) then
							Red <= '0';
							Pipe_Out1<='0';
						end if;
							
					when "100" =>
						if(pixel_row >= 200 AND pixel_row <= 200 + gap) then
							Red <= '0';
							Pipe_Out1<='0';
						end if;
						
					when "101" =>
						if(pixel_row >= 240 AND pixel_row <= 240 + gap) then
							Red <= '0';
							Pipe_Out1<='0';
						end if;
						
					when "110" =>
						if(pixel_row >= 280 AND pixel_row <= 280 + gap) then
							Red <= '0';
							Pipe_Out1<='0';
						end if;
						
					when "111" =>
						if(pixel_row >= 320 AND pixel_row <= 320 + gap) then
							Pipe_Out1<='0';
						end if;
						
				end case;
						
			else	
				Pipe_Out1<='0';	
			end if;
	end process pipe_gen;
	
	
--process to get a new lfsr number when it is to the right of the screen
new_gap : process(pipe_x_pos1)
begin
	if((pipe_x_pos1>CONV_STD_LOGIC_VECTOR(660,11))AND (pipe_x_pos1<CONV_STD_LOGIC_VECTOR(680,11))) then	
		lfsr<= lfsR_3_bit;
	end if;
end process new_gap;



-- Colours for pixel data on video signal
-- Changing the background and pipe colour by pushbuttons

Green <= '0';
Blue <=  '0';


Move_Pipes: process (vert_sync, pipe_x_pos1)  	
begin
	-- Move pipe once every vertical sync
	if (rising_edge(vert_sync)) then		
		pipe_x_pos1 <= pipe_x_pos1 - pipe_x_motion;
		
		 
		
		if (pipe_x_pos1<=CONV_STD_LOGIC_VECTOR(8,11)) then
				--use LFSR to generate a random number again
				pipe_x_pos1 <= CONV_STD_LOGIC_VECTOR(680,11);
		end if;
			
		
	end if;
	
end process Move_Pipes;

--process to increase motion based on stage
--and to change the gap size depending on the stage
difficulty : process (clk, stage)
begin	
	
	--based on stage
	if(stage = 1) then
		pipe_x_motion <= conv_std_logic_vector(4,11);
		gap<=150;
	elsif(stage = 2) then
		pipe_x_motion <= conv_std_logic_vector(5,11);
		gap<=125;
	else --stage is 3 
		pipe_x_motion <= conv_std_logic_vector(6,11);
		gap<=100;
	end if;
	
end process difficulty;
END behavior;