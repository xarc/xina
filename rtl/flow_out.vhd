library ieee;
use ieee.std_logic_1164.all;

entity flow_out is
  generic (
    mode_p : natural := 0;
    -- network data width
    data_width_p : positive := 32
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- link interface
    data_o : out std_logic_vector(data_width_p downto 0);
    val_o  : out std_logic;
    ack_i  : in std_logic;
    -- read from buffer
    data_i : in std_logic_vector(data_width_p downto 0);
    rok_i  : in std_logic;
    rd_o   : out std_logic
  );
end flow_out;

architecture rtl of flow_out is

begin

  hs :
  if (mode_p = 1) generate
    mealy : entity work.flow_out_hs(mealy)
      generic map(
        data_width_p => data_width_p
      )
      port map(
        clk_i  => clk_i,
        rst_i  => rst_i,
        data_o => data_o,
        val_o  => val_o,
        ack_i  => ack_i,
        data_i => data_i,
        rok_i  => rok_i,
        rd_o   => rd_o
      );
  else generate
      moore : entity work.flow_out_hs(moore)
        generic map(
          data_width_p => data_width_p
        )
        port map(
          clk_i  => clk_i,
          rst_i  => rst_i,
          data_o => data_o,
          val_o  => val_o,
          ack_i  => ack_i,
          data_i => data_i,
          rok_i  => rok_i,
          rd_o   => rd_o
        );
    end generate;

  end rtl;