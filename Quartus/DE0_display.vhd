library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 



entity DE0_display is 
	port (Time_In : in integer range 0 to 999;
			Game_over, clock_25MHz, Train_Mode: in std_logic; --game ovr input is simulated by a switch
			Unit_Sec_OUT, Tens_Sec_OUT, Unit_Min_OUT: out std_logic_vector(7 downto 0);
			Stage : out integer range 1 to 3;
			LEDS_OUT : out std_logic_vector(9 downto 0)
		  );
end entity DE0_display;

architecture behaviour of DE0_display is
	
	--signals for output of the seven segment displays
	signal unit_sec_seg : std_logic_vector(7 downto 0);
	signal tens_sec_seg : std_logic_vector(7 downto 0);
	signal unit_min_seg : std_logic_vector(7 downto 0);
	
	--signals for input of the seven segment displays
	signal unit_sec_in : integer;
	signal tens_sec_in : integer;
	signal unit_min_in : integer;
	
	--signal for counter 
	
	--signal count : integer range 0 to 500;
	
	
	--add seven segment display components
	component BCD_seven_seg is
		port (digit : in integer;
		  LED_out : out std_logic_vector(7 downto 0));
	end component;
	
begin
	
	
	flash : process(clock_25MHz, Game_over) 
	
	begin
		--flash on and off for half a second
--		if(Game_over = '1' and rising_edge(clock_1KHz)) then 
--			if(count = 499) then
--				--reverse the state of all the LED's
--				unit_sec_off<= not(unit_sec_off);
--				tens_sec_off<= not(tens_sec_off);
--				unit_min_off<= not(unit_min_off);
--				
--				-- reset the count back down to 0
--				count <= 0;
--			else
--				--increment the counter
--				count <= count + 1;		
--			end if;
--		end if;
--		
--		if(Game_over = '0' and rising_edge(clock_1KHz)) then 
--		
--			unit_sec_off<= '0';
--			tens_sec_off<= '0';
--			unit_min_off<= '0';
--					
--		end if;
		
	end process flash;
	
	
	
	--inputs for counter will be based on the place value digit from the timer
	unit_sec_in <= ((Time_In MOD 60) MOD 10);
	tens_sec_in <= ((Time_In MOD 60) / 10);
	unit_min_in <= ((Time_In / 60) MOD 10);
	
	
	--component declarations for the seven segment display
	unit_sec : BCD_seven_seg port map (unit_sec_in, unit_sec_seg);
	tens_sec : BCD_seven_seg port map (tens_sec_in, tens_sec_seg);
	unit_min : BCD_seven_seg port map (unit_min_in, unit_min_seg);
	
	
	-- process to assign stage output and LEDS
	stage_set : process(Time_In, Train_Mode)
	begin 
		if (((Time_In>=0) AND (Time_In<30)) OR (Train_Mode = '1')) then
			Stage <= 1;
			--turn on just one LED starting from the left
			LEDS_OUT(9)<= '1';
			LEDS_OUT(8 downto 0) <= "000000000";
		elsif ((Time_In>=30) AND (Time_In<60)) then	
			Stage <=2;
			--turn on two LED's from the left
			LEDS_OUT(9 downto 8)<= "11";
			LEDS_OUT(7 downto 0) <= "00000000";
		else --(Time_In>=60) 
			Stage <= 3;
			--turn on three LED's from the left
			LEDS_OUT(9 downto 7) <= "111";
			LEDS_OUT(6 downto 0) <= "0000000";
		end if;
	end process stage_set;
	
	
	
	--outputs of the components
	Unit_Sec_OUT <= unit_sec_seg;
	Tens_Sec_OUT <= tens_sec_seg;
	Unit_Min_OUT <= unit_min_seg;
	
end architecture behaviour;