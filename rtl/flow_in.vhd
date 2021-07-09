library ieee;
use ieee.std_logic_1164.all;

entity flow_in is
  generic (
    mode_p : natural := 0;
    -- network data width
    data_width_p : positive := 32
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- link interface
    data_i : in std_logic_vector(data_width_p downto 0);
    val_i  : in std_logic;
    ack_o  : out std_logic;
    -- write to buffer
    data_o : out std_logic_vector(data_width_p downto 0);
    wok_i  : in std_logic;
    wr_o   : out std_logic
  );
end flow_in;

architecture rtl of flow_in is

begin

  hs :
  if (mode_p = 1) generate
    mealy : entity work.flow_in_hs(mealy)
      generic map(
        data_width_p => data_width_p
      )
      port map(
        clk_i  => clk_i,
        rst_i  => rst_i,
        data_i => data_i,
        val_i  => val_i,
        ack_o  => ack_o,
        data_o => data_o,
        wok_i  => wok_i,
        wr_o   => wr_o
      );
  else generate
      moore : entity work.flow_in_hs(moore)
        generic map(
          data_width_p => data_width_p
        )
        port map(
          clk_i  => clk_i,
          rst_i  => rst_i,
          data_i => data_i,
          val_i  => val_i,
          ack_o  => ack_o,
          data_o => data_o,
          wok_i  => wok_i,
          wr_o   => wr_o
        );
    end generate;

  end rtl;