library ieee;
use ieee.std_logic_1164.all;

entity buffering is
  generic (
    mode_p : natural := 0;
    -- network data width and buffer depth
    data_width_p   : positive := 32;
    buffer_depth_p : positive := 4
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- read from buffer
    rok_o  : out std_logic;
    rd_i   : in std_logic;
    data_o : out std_logic_vector(data_width_p - 1 downto 0);
    -- write to buffer
    wok_o  : out std_logic;
    wr_i   : in std_logic;
    data_i : in std_logic_vector(data_width_p - 1 downto 0)
  );
end buffering;

architecture rtl of buffering is

begin

  fifo :
  if (mode_p = 1) generate
    shift : entity work.buffering_fifo(shift)
      generic map(
        data_width_p   => data_width_p,
        buffer_depth_p => buffer_depth_p
      )
      port map(
        clk_i  => clk_i,
        rst_i  => rst_i,
        rok_o  => rok_o,
        rd_i   => rd_i,
        data_o => data_o,
        wok_o  => wok_o,
        wr_i   => wr_i,
        data_i => data_i
      );
  else generate
      ring : entity work.buffering_fifo(ring)
        generic map(
          data_width_p   => data_width_p,
          buffer_depth_p => buffer_depth_p
        )
        port map(
          clk_i  => clk_i,
          rst_i  => rst_i,
          rok_o  => rok_o,
          rd_i   => rd_i,
          data_o => data_o,
          wok_o  => wok_o,
          wr_i   => wr_i,
          data_i => data_i
        );
    end generate;

  end rtl;