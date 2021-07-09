library ieee;
use ieee.std_logic_1164.all;

entity routing is
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
end routing;

architecture rtl of routing is

begin

  xy :
  if (mode_p = 1) generate
    mealy : entity work.routing_xy(mealy)
      generic map(
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
        req_l_o => req_l_o,
        req_n_o => req_n_o,
        req_e_o => req_e_o,
        req_s_o => req_s_o,
        req_w_o => req_w_o
      );
  else generate
      moore : entity work.routing_xy(moore)
        generic map(
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
          req_l_o => req_l_o,
          req_n_o => req_n_o,
          req_e_o => req_e_o,
          req_s_o => req_s_o,
          req_w_o => req_w_o
        );
    end generate;

  end rtl;