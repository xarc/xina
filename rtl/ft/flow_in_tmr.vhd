library ieee;
use ieee.std_logic_1164.all;

entity flow_in_tmr is
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
end flow_in_tmr;

architecture rtl of flow_in_tmr is

  type bit_t is array (2 downto 0) of std_logic;
  signal ack_w : bit_t;
  signal wr_w  : bit_t;

  type bit_vector_t is array (2 downto 0) of std_logic_vector(data_width_p downto 0);
  signal data_w : bit_vector_t;

begin

  tmr :
  for i in 2 downto 0 generate
    flow_in : entity work.flow_in
      generic map(
        data_width_p => data_width_p
      )
      port map(
        clk_i  => clk_i,
        rst_i  => rst_i,
        data_i => data_i,
        val_i  => val_i,
        ack_o  => ack_w(i),
        data_o => data_w(i),
        wok_i  => wok_i,
        wr_o   => wr_w(i)
      );
  end generate;

  tmr_vector :
  for i in data_width_p downto 0 generate
    data_o(i) <= (data_w(0)(i) and data_w(1)(i)) or (data_w(0)(i) and data_w(2)(i)) or (data_w(1)(i) and data_w(2)(i));
  end generate;

  ack_o <= (ack_w(0) and ack_w(1)) or (ack_w(0) and ack_w(2)) or (ack_w(1) and ack_w(2));
  wr_o  <= (wr_w(0) and wr_w(1)) or (wr_w(0) and wr_w(2)) or (wr_w(1) and wr_w(2));

end rtl;