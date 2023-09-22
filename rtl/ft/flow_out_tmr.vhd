library ieee;
use ieee.std_logic_1164.all;

entity flow_out_tmr is
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
end flow_out_tmr;

architecture rtl of flow_out_tmr is

  type bit_t is array (2 downto 0) of std_logic;
  signal val_w : bit_t;
  signal rd_w  : bit_t;

begin

  tmr :
  for i in 2 downto 0 generate
    flow_out : entity work.flow_out
      generic map(
        mode_p       => mode_p,
        data_width_p => data_width_p
      )
      port map(
        clk_i  => clk_i,
        rst_i  => rst_i,
        data_o => open,
        val_o  => val_w(i),
        ack_i  => ack_i,
        data_i => (others => '0'),
        rok_i  => rok_i,
        rd_o   => rd_w(i)
      );
  end generate;

  val_o  <= (val_w(0) and val_w(1)) or (val_w(0) and val_w(2)) or (val_w(1) and val_w(2));
  rd_o   <= (rd_w(0) and rd_w(1)) or (rd_w(0) and rd_w(2)) or (rd_w(1) and rd_w(2));
  data_o <= data_i;

end rtl;