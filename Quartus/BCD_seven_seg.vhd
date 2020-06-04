library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;  


entity BCD_seven_seg is
  port (digit : in integer;
		  LED_out : out std_logic_vector(7 downto 0));
end entity BCD_seven_seg;

architecture arc2 of BCD_seven_seg is
begin
  process (digit)
  begin

    case digit is
      when 0 => LED_out <= "00000011"; -- 0
      when 1 => LED_out <= "10011111"; -- 1
      when 2 => LED_out <= "00100101"; -- 2
      when 3 => LED_out <= "00001101"; -- 3
      when 4 => LED_out <= "10011001"; -- 4
      when 5 => LED_out <= "01001001"; -- 5
      when 6 => LED_out <= "01000001"; -- 6
      when 7 => LED_out <= "00011111"; -- 7
      when 8 => LED_out <= "00000001"; -- 8
      when 9 => LED_out <= "00001001"; -- 9
      when others => LED_out <= "11111111";
    end case;

  end process;
end architecture arc2;