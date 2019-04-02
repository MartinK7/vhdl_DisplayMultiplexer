--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-03-14 08:04
-- Design: disp_mux
-- Description: 7-segment display time-multiplexing module.
--------------------------------------------------------------------------------
-- TODO: Complete internal stucture of display multiplexer.
--
-- NOTE: Copy "bin_cnt.vhd", "four_to_one_mux.vhd", "hex_to_sseg.vhd",
--       and "one_of_four.vhd" files from previous lab(s) to current
--       working folder.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------------------------------
-- Entity declaration for display multiplexer
--------------------------------------------------------------------------------
entity disp_mux is
    port (
        -- Entity input signals
        data3_i : in std_logic_vector(4-1 downto 0);
        data2_i : in std_logic_vector(4-1 downto 0);
        data1_i : in std_logic_vector(4-1 downto 0);
        data0_i : in std_logic_vector(4-1 downto 0);
        clk_i   : in std_logic;

        -- Entity output signals
        an_o   : out std_logic_vector(4-1 downto 0);    -- 1-of-4 decoder
        sseg_o : out std_logic_vector(7-1 downto 0)     -- 7-segment display
    );
end disp_mux;

--------------------------------------------------------------------------------
-- Architecture declaration for display multiplexer
--------------------------------------------------------------------------------
architecture Behavioral of disp_mux is
    constant N_BIT : integer := 19;  -- number of bits for clock multiplexer
    signal s_clk_mux : std_logic_vector(N_BIT-1 downto 0);
    signal s_hex : std_logic_vector(4-1 downto 0);  -- internal 4-bit data
begin
    -- sub-block of binary counter (display multiplexing)
	 process(clk_i)
	 begin
			if rising_edge(clk_i) then
				s_clk_mux <= s_clk_mux + 1;
			end if;
	 end process;

    -- sub-block of 4-bit 4-to-1 multiplexer
	 s_hex <= data0_i when s_clk_mux(N_BIT-1 downto N_BIT-2) = "00" else
			    		data1_i when s_clk_mux(N_BIT-1 downto N_BIT-2) = "01" else
			    		data2_i when s_clk_mux(N_BIT-1 downto N_BIT-2) = "10" else
			    		data3_i;


    -- sub-block of hex_to_sseg entity
    HEX2SSEG : entity work.hex_to_sseg
        port map (
            hex_i => s_hex,     -- 4-bit data to decode
            sseg_o => sseg_o    -- 7-bit signal for 7-segment display
        );

    -- sub-block of one_of_four entity
    ONEOFFOUR : entity work.one_of_four
        port map (
            a_i => s_clk_mux(N_BIT-1 downto N_BIT-2),
            y_o => an_o     -- display select signals
        );

end Behavioral;
