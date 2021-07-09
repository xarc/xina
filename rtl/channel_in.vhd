library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity channel_in is
  generic (
    -- channel enable
    c_ena_p : natural := 1;
    -- router identification
    x_id_p : natural := 1;
    y_id_p : natural := 1;
    -- input flow regulation mode
    flow_mode_p : natural := 0;
    -- routing mode
    routing_mode_p : natural := 0;
    -- input buffer mode and depth
    buffer_mode_p  : natural  := 0;
    buffer_depth_p : positive := 4;
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
    -- requests and grants
    req_l_o : out std_logic;
    req_n_o : out std_logic;
    req_e_o : out std_logic;
    req_s_o : out std_logic;
    req_w_o : out std_logic;
    gnt_i   : in std_logic_vector(3 downto 0);
    -- intra router signals
    rok_o  : out std_logic;
    rd_i   : in std_logic_vector(3 downto 0);
    data_o : out std_logic_vector(data_width_p downto 0)
  );
end channel_in;

architecture rtl of channel_in is

  signal rok_w      : std_logic;
  signal rd_w       : std_logic;
  signal wok_w      : std_logic;
  signal wr_w       : std_logic;
  signal data_in_w  : std_logic_vector(data_width_p downto 0);
  signal data_out_w : std_logic_vector(data_width_p downto 0);

begin

  channel_in :
  if (c_ena_p = 0) generate
    ack_o   <= '0';
    req_l_o <= '0';
    req_n_o <= '0';
    req_e_o <= '0';
    req_s_o <= '0';
    req_w_o <= '0';
    rok_o   <= '0';
    data_o  <= (others => '0');
  else generate
      flow_in : entity work.flow_in
        generic map(
          mode_p       => flow_mode_p,
          data_width_p => data_width_p
        )
        port map(
          clk_i  => clk_i,
          rst_i  => rst_i,
          data_i => data_i,
          val_i  => val_i,
          ack_o  => ack_o,
          data_o => data_in_w,
          wok_i  => wok_w,
          wr_o   => wr_w
        );
      buffering : entity work.buffering
        generic map(
          mode_p         => buffer_mode_p,
          data_width_p   => data_width_p + 1,
          buffer_depth_p => buffer_depth_p
        )
        port map(
          clk_i  => clk_i,
          rst_i  => rst_i,
          rok_o  => rok_w,
          rd_i   => rd_w,
          data_o => data_out_w,
          wok_o  => wok_w,
          wr_i   => wr_w,
          data_i => data_in_w
        );
      routing : entity work.routing
        generic map(
          mode_p       => routing_mode_p,
          x_id_p       => x_id_p,
          y_id_p       => y_id_p,
          data_width_p => data_width_p
        )
        port map(
          clk_i   => clk_i,
          rst_i   => rst_i,
          frame_i => data_out_w(data_width_p),
          data_i  => data_out_w(data_width_p - 1 downto 0),
          rok_i   => rok_w,
          rd_i    => rd_w,
          req_l_o => req_l_o,
          req_n_o => req_n_o,
          req_e_o => req_e_o,
          req_s_o => req_s_o,
          req_w_o => req_w_o
        );
      rd_switch : entity work.switch
        generic map(
          data_width_p => 1
        )
        port map(
          sel_i      => gnt_i,
          data3_i(0) => rd_i(3),
          data2_i(0) => rd_i(2),
          data1_i(0) => rd_i(1),
          data0_i(0) => rd_i(0),
          data_o(0)  => rd_w
        );
      rok_o  <= rok_w;
      data_o <= data_out_w;
    end generate;

  end rtl;