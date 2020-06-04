LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY pipes IS
	PORT
		(SIGNAL  clk, vert_sync, startGame, endGame, SW_1	: IN std_logic;
        SIGNAL pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
--		  SIGNAL LFSR_3_bit		: IN std_logic_vector(2 DOWNTO 0);
		  SIGNAL stage : IN integer range 1 to 3;
		SIGNAL Pipe_Out2 	: OUT std_logic);		
END pipes;

architecture behavior of pipes is

component LFSR is
  port(Clk, Reset : in std_logic;
      Rand_Bits_Out : out std_logic_vector(7 downto 0));
end component;


SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL pipe_y_pos				: std_logic_vector(9 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(0,10);
SIGNAL pipe_x_pos2			: std_logic_vector(10 DOWNTO 0):= conv_std_logic_vector(1000,11);
SIGNAL pipe_x_motion			: std_logic_vector(10 DOWNTO 0):= conv_std_logic_vector(4,11);
SIGNAL lfsr1						: std_logic_vector(7 DOWNTO 0);
SIGNAL lfsR_8_bit 			: std_logic_vector(7 DOWNTO 0);
SIGNAL reset					: std_logic := '1';
SIGNAL gap 						: integer range 100 to 150 := 150;
SIGNAL upper_gap 				: integer range 0 to 479;
SIGNAL lower_gap 				: integer range 0 to 479;

BEGIN           

LFSR_GEN : LFSR PORT MAP(clk, reset, lfsR_8_bit);

size <= CONV_STD_LOGIC_VECTOR(20,10);
-- pipe_x_pos and pipe_y_pos show the (x,y) for the centre of pipe

pipe_gen : process(pipe_x_pos2, pipe_y_pos, pixel_row, pixel_column, size)
		begin	
			-- x_pos - size <= pixel_column <= x_pos + size
			-- y_pos - size <= pixel_row <= y_pos + size
			upper_gap <= conv_integer(unsigned(lfsr1)) + 37;
			lower_gap <= upper_gap + gap;
			
			if( ('0' & pipe_x_pos2 <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & pipe_x_pos2 + size) and ('0' & pipe_y_pos <= '0' & pixel_row ) and ('0' & pixel_row <= '0' & pipe_y_pos + 479)) then 
  				Pipe_Out2 <= '1';		
				
				
				if(pixel_row >= upper_gap AND pixel_row <= lower_gap) then
					Pipe_Out2 <='0';
				end if;
				
			else			
				Pipe_Out2<='0';	
			end if;
	end process pipe_gen;
	
	
--process to get a new lfsr number when it is to the right of the screen
new_gap : process(pipe_x_pos2)
begin
	if((pipe_x_pos2>CONV_STD_LOGIC_VECTOR(660,11))AND (pipe_x_pos2<CONV_STD_LOGIC_VECTOR(680,11))) then	
		lfsr1<= lfsR_8_bit;
		
		
		if(stage = 1) then
			gap <= 150;
		elsif(stage = 2) then 
			gap <= 125;
		else --stage 3
			gap <= 100;
		end if;
	end if;
end process new_gap;


Move_Pipes: process (vert_sync, startGame, endGame, SW_1)  	
begin

	if (startGame = '0') then
		pipe_x_pos2 <= conv_std_logic_vector(1000,11);
	elsif (endGame = '1' OR SW_1 = '1') then
		pipe_x_pos2 <= pipe_x_pos2;
	-- Move pipe once every vertical sync
	elsif (rising_edge(vert_sync)) then		
		pipe_x_pos2 <= pipe_x_pos2 - pipe_x_motion;
		
		if ((pipe_x_pos2 + size) <=CONV_STD_LOGIC_VECTOR(8,11)) then
				--use LFSR to generate a random number again
				pipe_x_pos2 <= CONV_STD_LOGIC_VECTOR(680,11);
		end if;
			
	end if;
	
end process Move_Pipes;

--process to increase motion based on stage
--and to change the gap size depending on the stage
difficulty : process (stage)
begin	
	
	--based on stage
	if(stage = 1) then
		pipe_x_motion <= conv_std_logic_vector(4,11);
	elsif(stage = 2) then
		pipe_x_motion <= conv_std_logic_vector(5,11);
	else --stage is 3 
		pipe_x_motion <= conv_std_logic_vector(6,11);
	end if;
	
end process difficulty;

END behavior;