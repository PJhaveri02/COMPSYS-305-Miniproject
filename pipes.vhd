LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY pipes IS
	PORT
		(SIGNAL  clk, vert_sync					: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
		SIGNAL pipe_on 							: OUT std_logic);		
END pipes;

architecture behaviour of pipes is
	SIGNAL pipe_size 					: std_logic_vector(9 DOWNTO 0);  
	SIGNAL pipe_y_pos				: std_logic_vector(10 DOWNTO 0);
	SiGNAL pipe_x_pos				: std_logic_vector(9 DOWNTO 0):= conv_STD_LOGIC_VECTOR(599,10);
	SIGNAL pipe_x_motion			: std_logic_vector(9 DOWNTO 0);
begin
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
			elsif (pipe_x_pos <= pipe_size) then 
				pipe_x_motion <= CONV_STD_LOGIC_VECTOR(3,10);
			end if;
			-- Compute next ball X position
			pipe_x_pos <= pipe_x_pos + pipe_x_motion;
		end if;
	end process Move_Pipe;
end architecture behaviour;