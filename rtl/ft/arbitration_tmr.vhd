library ieee;
use ieee.std_logic_1164.all;

entity arbitration_tmr is
  generic (
    mode_p : natural := 0
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- requests and grants
    req_i : in std_logic_vector(3 downto 0);
    gnt_o : out std_logic_vector(3 downto 0)
  );
end arbitration_tmr;

architecture rtl of arbitration_tmr is

  type bit_vector_t is array (2 downto 0) of std_logic_vector(3 downto 0);
  signal gnt_w : bit_vector_t;

begin

  tmr :
  for i in 2 downto 0 generate
    arbitration : entity work.arbitration
      generic map(
        mode_p => mode_p
      )
      port map(
        clk_i => clk_i,
        rst_i => rst_i,
        req_i => req_i,
        gnt_o => gnt_w(i)
      );
  end generate;

  tmr_vector :
  for i in 3 downto 0 generate
    gnt_o(i) <= (gnt_w(0)(i) and gnt_w(1)(i)) or (gnt_w(0)(i) and gnt_w(2)(i)) or (gnt_w(1)(i) and gnt_w(2)(i));
  end generate;

end rtl;