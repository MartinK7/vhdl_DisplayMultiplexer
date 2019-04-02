--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-03-14 08:51
-- Design: top
-- Description: Implementation of 7-segment display time-multiplexing module.
--------------------------------------------------------------------------------
-- TODO: Verify 7-segment display time-multiplexing module on Coolrunner-II
--       board. Use seven-segment LED display, on-board clock signal with
--       frequency of 10 kHz, and switches on CPLD expansion board as
--       input data.
--
-- NOTE: Copy "hex_to_sseg.vhd", "one_of_four.vhd", and "coolrunner.ucf"
--       files from previous lab(s) to current working folder.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    port (
	     -- Global input signals at Nexys2
		  sw  : std_logic_vector(8-1 downto 0);         -- switches
		  btn : std_logic_vector(4-1 downto 0);         -- buttons
		  
        -- Global input signals at Nexys2
        clk : in std_logic;                           -- 50MHz crystal

        -- Global output signals at Nexys2
        an  : out std_logic_vector(4-1 downto 0);     -- 7-segment
        seg : out std_logic_vector(7-1 downto 0)
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
	 signal data3 : std_logic_vector(4-1 downto 0) := "0000";
	 signal data2 : std_logic_vector(4-1 downto 0) := "0000";
	 signal data1 : std_logic_vector(4-1 downto 0) := "0000";
	 signal data0 : std_logic_vector(4-1 downto 0) := "0000";
begin
	 data3 <= sw(7 downto 4) when btn(0) = '1' else data3;
	 data2 <= sw(3 downto 0) when btn(0) = '1' else data2;
	 data1 <= sw(7 downto 4);
	 data0 <= sw(3 downto 0);

    -- sub-block of display multiplexer
    DISPMULTIPLEX : entity work.disp_mux
        port map (
            data3_i => data3,
            data2_i => data2,
            data1_i => data1,
            data0_i => data0,
				clk_i => clk,
				an_o => an,
				sseg_o => seg
        );
end Behavioral;
