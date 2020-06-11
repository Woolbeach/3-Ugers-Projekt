----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2020 10:16:44 AM
-- Design Name: 
-- Module Name: switches - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switches is
    generic (
    ADDR:   integer := 65034
    );
    port (
    input:              std_logic_vector(7 downto 0);
    data_to_address:    out std_logic_vector(7 downto 0)
    );
end switches;

architecture Behavioral of switches is

begin

data_to_address <= input;


end Behavioral;
