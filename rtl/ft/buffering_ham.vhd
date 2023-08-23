library ieee;
use ieee.std_logic_1164.all;

use work.hamming_pkg.all;

entity buffering_ham is
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
end buffering_ham;

architecture rtl of buffering_ham is

  constant par_width_p : integer := par_width_f(data_width_p);
  signal data_enc_w    : std_logic_vector(data_width_p + par_width_p - 1 downto 0);
  signal data_dec_w    : std_logic_vector(data_width_p + par_width_p - 1 downto 0);

begin

  buffering : entity work.buffering
    generic map(
      mode_p         => mode_p,
      data_width_p   => data_width_p + par_width_p,
      buffer_depth_p => buffer_depth_p
    )
    port map(
      clk_i  => clk_i,
      rst_i  => rst_i,
      rok_o  => rok_o,
      rd_i   => rd_i,
      data_o => data_dec_w,
      wok_o  => wok_o,
      wr_i   => wr_i,
      data_i => data_enc_w
    );

  hamming_enc : entity work.hamming_enc
    generic map(
      width_p => data_width_p
    )
    port map(
      data_i => data_i,
      data_o => data_enc_w
    );

  hamming_dec : entity work.hamming_dec
    generic map(
      width_p => data_width_p
    )
    port map(
      data_i => data_dec_w,
      data_o => data_o
    );

end rtl;