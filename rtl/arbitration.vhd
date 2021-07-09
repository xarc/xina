library ieee;
use ieee.std_logic_1164.all;

entity arbitration is
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
end arbitration;

architecture rtl of arbitration is

begin

  rr :
  if (mode_p = 1) generate
    mealy : entity work.arbitration_rr(mealy)
      port map(
        clk_i => clk_i,
        rst_i => rst_i,
        req_i => req_i,
        gnt_o => gnt_o
      );
  else generate
      moore : entity work.arbitration_rr(moore)
        port map(
          clk_i => clk_i,
          rst_i => rst_i,
          req_i => req_i,
          gnt_o => gnt_o
        );
    end generate;

  end rtl;