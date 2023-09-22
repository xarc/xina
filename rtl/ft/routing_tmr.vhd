library ieee;
use ieee.std_logic_1164.all;

entity routing_tmr is
  generic (
    mode_p : natural := 0;
    -- router identification
    x_id_p : natural := 1;
    y_id_p : natural := 1;
    -- network data width
    data_width_p : positive := 32
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- frame and data
    frame_i : in std_logic;
    data_i  : in std_logic_vector(data_width_p - 1 downto 0);
    -- buffer read
    rok_i : in std_logic;
    rd_i  : in std_logic;
    -- requests
    req_l_o : out std_logic;
    req_n_o : out std_logic;
    req_e_o : out std_logic;
    req_s_o : out std_logic;
    req_w_o : out std_logic
  );
end routing_tmr;

architecture rtl of routing_tmr is

  type bit_t is array (2 downto 0) of std_logic;
  signal req_l_w : bit_t;
  signal req_n_w : bit_t;
  signal req_e_w : bit_t;
  signal req_s_w : bit_t;
  signal req_w_w : bit_t;

begin

  tmr :
  for i in 2 downto 0 generate
    routing : entity work.routing
      generic map(
        mode_p       => mode_p,
        x_id_p       => x_id_p,
        y_id_p       => y_id_p,
        data_width_p => data_width_p
      )
      port map(
        clk_i   => clk_i,
        rst_i   => rst_i,
        frame_i => frame_i,
        data_i  => data_i,
        rok_i   => rok_i,
        rd_i    => rd_i,
        req_l_o => req_l_w(i),
        req_n_o => req_n_w(i),
        req_e_o => req_e_w(i),
        req_s_o => req_s_w(i),
        req_w_o => req_w_w(i)
      );
  end generate;

  req_l_o <= (req_l_w(0) and req_l_w(1)) or (req_l_w(0) and req_l_w(2)) or (req_l_w(1) and req_l_w(2));
  req_n_o <= (req_n_w(0) and req_n_w(1)) or (req_n_w(0) and req_n_w(2)) or (req_n_w(1) and req_n_w(2));
  req_e_o <= (req_e_w(0) and req_e_w(1)) or (req_e_w(0) and req_e_w(2)) or (req_e_w(1) and req_e_w(2));
  req_s_o <= (req_s_w(0) and req_s_w(1)) or (req_s_w(0) and req_s_w(2)) or (req_s_w(1) and req_s_w(2));
  req_w_o <= (req_w_w(0) and req_w_w(1)) or (req_w_w(0) and req_w_w(2)) or (req_w_w(1) and req_w_w(2));

end rtl;