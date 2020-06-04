library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity Debouncer is
		GENERIC (
			clk_frequency	:	INTEGER := 25000000;
			stable_time		:	INTEGER := 250);		-- Time button must remain stable (in ms);
		PORT (clk, pushButton : IN std_logic;
				outputSignal	 : OUT std_logic);
end entity;

architecture behaviour of Debouncer is
begin 
	process(clk, pushButton)
		variable count : INTEGER RANGE 0 TO clk_frequency * stable_time / 1000;
		variable tempOut : std_logic := '1';
	begin
		if (pushButton = '1') then
			tempOut := '1';
			count := 0;
		else
			if (falling_edge(clk)) then 
				if (count < (clk_frequency * stable_time / 1000) AND pushButton = '0') then
					count := count + 1; 
				else 
					tempOut := '0';
					count := 0;
				end if;
			end if;
		end if;
		outputSignal <= tempOut;
	end process;
end architecture behaviour;