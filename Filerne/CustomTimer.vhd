------------------------------------------------------------------------------------
---- Company: 
---- Engineer: Den bedste gruppe ever <3
---- 
---- Create Date: 06/10/2020 01:23:57 PM
---- Design Name: Den vildeste timer
---- Module Name: CustomTimer - Behavioral
---- Project Name: Det vildeste projekt
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;




entity CustomTimer is
    port(
    clk:    in std_logic;
    second:    out std_logic
    );
    
end CustomTimer;

architecture Behavioral of CustomTimer is
signal counter: UNSIGNED (25 downto 0) := (others => '0');
constant MAX : POSITIVE:=50*1000*1000;

begin
    process(clk)
begin
  if rising_edge(clk) then
      counter <= counter + 1;
        if counter = MAX then
        second <= '1';
        end if;
  end if;

end process;
     
end Behavioral;

