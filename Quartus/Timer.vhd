library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

entity Timer is 
	port (clock_25MHz, Pause, reset_timer, game_over: in std_logic;
		  Time_Out : out integer range 0 to 999
		  );
end entity Timer;

architecture behaviour of Timer is
begin
  
  
  --Process to start counting the time once the start bit is high.
  process(reset_timer, clock_25MHz, Pause, game_over)
    --variable to pass timer out, save logic elements
    variable time1 : integer := 0;
    --variable to keep the count
    variable counter : integer range 0 to 24999999:= 0;
    
    begin
      if(rising_edge(clock_25MHz) AND game_over = '0') then --switches is down
        --check for reset with higher priority
        --should this be asynchronous???
        if(reset_timer = '0') then
        
          counter:=0;
          time1:=0;
        
        elsif (Pause = '0') then --pauses the game
          
          --start counting the clock every 1 thousand
          if(counter = 24999999) then --check for 1 less since we increment after the check
            time1:= time1 + 1;
            counter:= 0;
          else 
            counter:= counter +1;
          
          end if; 
        end if;
      end if;
      Time_Out<=time1;
      
  end process;
  
end architecture behaviour;