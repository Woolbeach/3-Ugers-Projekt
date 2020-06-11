-- This is the component that you'll need to fill in in order to create the LC3 computer.
-- It is FPGA independent. It can be used without any changes between the Zybo and the 
-- Nexys3 boards.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

--Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lc3_computer is
   port (
	  --System clock
      clk              : in  std_logic; 

      --Virtual I/O
      led              : out std_logic_vector(7 downto 0);
      btn              : in  std_logic_vector(4 downto 0);
      sw               : in  std_logic_vector(7 downto 0);
      hex              : out std_logic_vector(15 downto 0); --16 bit hexadecimal value (shown on 7-seg sisplay)

	  --Physical I/0 (IO on the Zybo FPGA)
	  pbtn				  : in  std_logic_vector(3 downto 0);
	  psw				  : in  std_logic_vector(3 downto 0);
	  pled				  : out  std_logic_vector(2 downto 0);

	  --VIO serial
	  rx_data          : in  std_logic_vector(7 downto 0);
      rx_rd            : out std_logic;
      rx_empty         : in  std_logic;
      tx_data          : out std_logic_vector(7 downto 0);
      tx_wr            : out std_logic;
      tx_full          : in  std_logic;
		
		sink             : out std_logic;

      --Debug
      address_dbg      : out std_logic_vector(15 downto 0);
      data_dbg         : out std_logic_vector(15 downto 0);
      RE_dbg           : out std_logic;
      WE_dbg           : out std_logic;
		
	  --LC3 CPU inputs
      cpu_clk_enable   : in  std_logic;
      sys_reset        : in  std_logic;
      sys_program      : in  std_logic
   );
end lc3_computer;

architecture Behavioral of lc3_computer is
   ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>---
   ---<<<<< Pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>---

	--Making	sure	that	our	output	signals	are	not	merged/removed	during	
	-- synthesis. We	achieve	this	by	setting	the keep	attribute for	all	our	outputs
	-- It's good to uncomment the following attributs if you get some errors with multiple 
	-- drivers for a signal.
--attribute	keep:     string;
--attribute	keep	of	led			: signal	is	"true";
--attribute	keep	of	pled		: signal	is	"true";
--attribute	keep	of	hex			: signal	is	"true";
--attribute	keep	of	rx_rd		: signal	is	"true";
--attribute	keep	of	tx_data		: signal	is	"true";
--attribute	keep	of	tx_wr		: signal	is	"true";
--attribute	keep	of	address_dbg	: signal	is	"true";
--attribute	keep	of	data_dbg	: signal	is	"true";
--attribute	keep	of	RE_dbg		: signal	is	"true";
--attribute	keep	of	WE_dbg		: signal	is	"true";
--attribute	keep	of	sink		: signal	is	"true";


   --Creating user friently names for the buttons
    alias btn_u : std_logic is btn(0); --Button UP
    alias btn_l : std_logic is btn(1); --Button LEFT
    alias btn_d : std_logic is btn(2); --Button DOWN
    alias btn_r : std_logic is btn(3); --Button RIGHT
    alias btn_s : std_logic is btn(4); --Button SELECT (center button)
    alias btn_c : std_logic is btn(4); --Button CENTER
   
    signal sink_sw : std_logic;
    signal sink_psw : std_logic;
    signal sink_btn : std_logic;
    signal sink_pbtn : std_logic;
    signal sink_uart : std_logic;
   
	-- Memory interface signals
	signal address: std_logic_vector(15 downto 0);
	signal data, data_in, data_out: std_logic_vector(15 downto 0); -- data inputs
	signal RE, WE:  std_logic;
    

	-- I/O constants for addr from 0xFE00 to 0xFFFF:
    constant STDIN_S    : std_logic_vector(15 downto 0) := X"FE00";  -- Serial IN (terminal keyboard)
    constant STDIN_D    : std_logic_vector(15 downto 0) := X"FE02";
    constant STDOUT_S   : std_logic_vector(15 downto 0) := X"FE04";  -- Serial OUT (terminal  display)
    constant STDOUT_D   : std_logic_vector(15 downto 0) := X"FE06";
    constant IO_SW      : std_logic_vector(15 downto 0) := X"FE0A";  -- Switches
    constant IO_PSW     : std_logic_vector(15 downto 0) := X"FE0B";  -- Physical Switches	
    constant IO_BTN     : std_logic_vector(15 downto 0) := X"FE0e";  -- Buttons
    constant IO_PBTN    : std_logic_vector(15 downto 0) := X"FE0F";  -- Physical Buttons	
    constant IO_SSEG    : std_logic_vector(15 downto 0) := X"FE12";  -- 7 segment
	constant IO_LED     : std_logic_vector(15 downto 0) := X"FE16";  -- Leds
	constant IO_PLED    : std_logic_vector(15 downto 0) := X"FE17";  -- Physical Leds
   
	---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ---<<<<< End of pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---

	
begin
  ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>---
   ---<<<<< Pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<>>>>>>>>>>>>>>>--- 
   
   --In order to avoid warnings or errors all outputs should be assigned a value. 
   --The VHDL lines below assign a value to each otput signal. An otput signal can have
   --only one driver, so each otput signal that you plan to use in your own VHDL code
   --should be commented out in the lines below 

   
   --Virtual Leds on Zybo VIO (active high)
   led(0) <= '0';
   led(1) <= '0';
   led(2) <= '0'; 
   led(3) <= '0'; 
   led(4) <= '0'; 
   led(5) <= '0'; 
   led(6) <= '0'; 
   led(7) <= '0'; 

   --Physical leds on the Zybo board (active high)
   pled(0) <= '0';
   pled(1) <= '0';
   pled(2) <= '0';

   --Virtual hexadecimal display on Zybo VIO
   hex <= X"1234"; 

	--Virtual I/O UART
	rx_rd <= '0';
	tx_wr <= '0';
	tx_data <= X"00";
	
	--Input data for the LC3 CPU
	--data_in <= X"0000";

   --All the input signals comming to the FPGA should be used at least once otherwise we get 
   --synthesis warnings. The following lines of VHDL code are meant to remove those warnings. 
   --Sink is just an output signal that that has the only purpose to allow all the inputs to 
   --be used at least once, by orring them and assigning the resulting the value to sink.
   --You are not suppoosed to modify the following lines of VHDL code, where inputs are orred and
   --assigned to the sink. 
   sink_psw <= psw(0) or psw(1) or psw(2) or psw(3);
   sink_pbtn <= pbtn(0) or pbtn(1) or pbtn(2) or pbtn(3);
   sink_sw <= sw(0) or sw(1) or sw(2) or sw(3) or sw(4) or sw(5) or sw(6) or sw(7); 
   sink_btn <= btn(0) or btn(1) or btn(2) or btn(3) or btn(4);
	sink_uart <= rx_data(0) or rx_data(1) or rx_data(2) or rx_data(3) or rx_data(4) or 
					 rx_data(5) or rx_data(6) or rx_data(7)or rx_empty or tx_full; 
   sink <= sink_sw or sink_psw or sink_btn or sink_pbtn or sink_uart;

   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
   ---<<<<< End of pregenerated code >>>>>---
   ---<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>---
	
	--You'll have to decide which type of data bus you need to use for the
	--  LC3 processor. Here are the options:
	-- 1. Bidirectional data bus (to which you write using tristates).
	-- 2. Two unidirctional busses data_in and data_out where you use
	--    multiplexors to dicide where the data for data_in is comming for.
	--The VHDL code that instantiate either one of these options for the LC3
	--  processor are provided below. Just uncomment the one you prefer
	
	-- <<< LC3 CPU using multiplexers for the data bus>>>	
	lc3_m: entity work.lc3_wrapper_multiplexers
	port map (
		 clk        => clk,
		 clk_enable => cpu_clk_enable,
		 reset      => sys_reset,
		 program    => sys_program,
		 addr       => address,
		 data_in    => data_in,
		 data_out   => data_out,
		 WE         => WE,
		 RE         => RE 
		 );   
   data_dbg <= data_in when RE='1' else data_out;
	-- <<< LC3 CPU using multiplexers end of instantiation>>>	
	
--	lc3_t: entity work.CustomTimer
--        port map(
--        clk                 => clk,
--        --second              => X"FE12"  
--        );
	
	memory_data: entity work.xilinx_one_port_ram_sync
        generic map (
            ADDR_WIDTH      => 16,-- Address width 
            DATA_WIDTH      => 16,-- decimal Data size
            ARRAY_SIZE      => 12 -- 2^ARRAY_SIZE
        )
        port map (
             clk                => clk,
             addr               => address,
             din                => data_out,
             dout               => data_in,
             WE                 => WE,
             din_vio_switch     => sw,
             dout_vio_led       => led
             );
  
	--Information that is sent to the debugging module
   address_dbg <= address;
   RE_dbg <= RE;
   WE_dbg <= WE;
   
	-------------------------------------------------------------------------------
	-- <<< Write your VHDL code starting from here >>>
	-------------------------------------------------------------------------------

end behavioral;



