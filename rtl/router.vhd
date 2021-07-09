library ieee;
use ieee.std_logic_1164.all;

entity router is
  generic (
    -- router identification
    x_id_p : natural := 1;
    y_id_p : natural := 1;
    -- local, north, east, south, and west channels enable
    l_ena_p : natural := 1;
    n_ena_p : natural := 1;
    e_ena_p : natural := 1;
    s_ena_p : natural := 1;
    w_ena_p : natural := 1;
    -- input and output flow regulation mode
    flow_mode_p : natural := 0; -- 0 for HS Moore, 1 for HS Mealy
    -- routing mode
    routing_mode_p : natural := 0; -- 0 for XY Moore, 1 for XY Mealy
    -- arbitration mode
    arbitration_mode_p : natural := 0; -- 0 for RR Moore, 1 for RR Mealy
    -- input buffer mode and depth
    buffer_mode_p  : natural  := 0; -- 0 for FIFO Ring, 1 for FIFO Shift
    buffer_depth_p : positive := 4;
    -- network data width
    data_width_p : positive := 32
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- local channel interface
    l_in_data_i  : in std_logic_vector(data_width_p downto 0);
    l_in_val_i   : in std_logic;
    l_in_ack_o   : out std_logic;
    l_out_data_o : out std_logic_vector(data_width_p downto 0);
    l_out_val_o  : out std_logic;
    l_out_ack_i  : in std_logic;
    -- north channel interface
    n_in_data_i  : in std_logic_vector(data_width_p downto 0);
    n_in_val_i   : in std_logic;
    n_in_ack_o   : out std_logic;
    n_out_data_o : out std_logic_vector(data_width_p downto 0);
    n_out_val_o  : out std_logic;
    n_out_ack_i  : in std_logic;
    -- east channel interface
    e_in_data_i  : in std_logic_vector(data_width_p downto 0);
    e_in_val_i   : in std_logic;
    e_in_ack_o   : out std_logic;
    e_out_data_o : out std_logic_vector(data_width_p downto 0);
    e_out_val_o  : out std_logic;
    e_out_ack_i  : in std_logic;
    -- south channel interface
    s_in_data_i  : in std_logic_vector(data_width_p downto 0);
    s_in_val_i   : in std_logic;
    s_in_ack_o   : out std_logic;
    s_out_data_o : out std_logic_vector(data_width_p downto 0);
    s_out_val_o  : out std_logic;
    s_out_ack_i  : in std_logic;
    -- west port interface
    w_in_data_i  : in std_logic_vector(data_width_p downto 0);
    w_in_val_i   : in std_logic;
    w_in_ack_o   : out std_logic;
    w_out_data_o : out std_logic_vector(data_width_p downto 0);
    w_out_val_o  : out std_logic;
    w_out_ack_i  : in std_logic
  );
end router;

architecture rtl of router is

  -- channel l wires
  signal l_req_n_xin_w  : std_logic;
  signal l_req_e_xin_w  : std_logic;
  signal l_req_s_xin_w  : std_logic;
  signal l_req_w_xin_w  : std_logic;
  signal l_gnt_n_xin_w  : std_logic;
  signal l_gnt_e_xin_w  : std_logic;
  signal l_gnt_s_xin_w  : std_logic;
  signal l_gnt_w_xin_w  : std_logic;
  signal l_req_n_xout_w : std_logic;
  signal l_req_e_xout_w : std_logic;
  signal l_req_s_xout_w : std_logic;
  signal l_req_w_xout_w : std_logic;
  signal l_gnt_n_xout_w : std_logic;
  signal l_gnt_e_xout_w : std_logic;
  signal l_gnt_s_xout_w : std_logic;
  signal l_gnt_w_xout_w : std_logic;
  signal l_rok_w        : std_logic;
  signal l_rd_w         : std_logic;
  signal l_data_w       : std_logic_vector(data_width_p downto 0);
  -- channel n wires
  signal n_req_l_xin_w  : std_logic;
  signal n_req_e_xin_w  : std_logic;
  signal n_req_s_xin_w  : std_logic;
  signal n_req_w_xin_w  : std_logic;
  signal n_gnt_l_xin_w  : std_logic;
  signal n_gnt_e_xin_w  : std_logic;
  signal n_gnt_s_xin_w  : std_logic;
  signal n_gnt_w_xin_w  : std_logic;
  signal n_req_l_xout_w : std_logic;
  signal n_req_e_xout_w : std_logic;
  signal n_req_s_xout_w : std_logic;
  signal n_req_w_xout_w : std_logic;
  signal n_gnt_l_xout_w : std_logic;
  signal n_gnt_e_xout_w : std_logic;
  signal n_gnt_s_xout_w : std_logic;
  signal n_gnt_w_xout_w : std_logic;
  signal n_rok_w        : std_logic;
  signal n_rd_w         : std_logic;
  signal n_data_w       : std_logic_vector(data_width_p downto 0);
  -- channel e wires
  signal e_req_l_xin_w  : std_logic;
  signal e_req_n_xin_w  : std_logic;
  signal e_req_s_xin_w  : std_logic;
  signal e_req_w_xin_w  : std_logic;
  signal e_gnt_l_xin_w  : std_logic;
  signal e_gnt_n_xin_w  : std_logic;
  signal e_gnt_s_xin_w  : std_logic;
  signal e_gnt_w_xin_w  : std_logic;
  signal e_req_l_xout_w : std_logic;
  signal e_req_n_xout_w : std_logic;
  signal e_req_s_xout_w : std_logic;
  signal e_req_w_xout_w : std_logic;
  signal e_gnt_l_xout_w : std_logic;
  signal e_gnt_n_xout_w : std_logic;
  signal e_gnt_s_xout_w : std_logic;
  signal e_gnt_w_xout_w : std_logic;
  signal e_rok_w        : std_logic;
  signal e_rd_w         : std_logic;
  signal e_data_w       : std_logic_vector(data_width_p downto 0);
  -- channel s wires
  signal s_req_l_xin_w  : std_logic;
  signal s_req_n_xin_w  : std_logic;
  signal s_req_e_xin_w  : std_logic;
  signal s_req_w_xin_w  : std_logic;
  signal s_gnt_l_xin_w  : std_logic;
  signal s_gnt_n_xin_w  : std_logic;
  signal s_gnt_e_xin_w  : std_logic;
  signal s_gnt_w_xin_w  : std_logic;
  signal s_req_l_xout_w : std_logic;
  signal s_req_n_xout_w : std_logic;
  signal s_req_e_xout_w : std_logic;
  signal s_req_w_xout_w : std_logic;
  signal s_gnt_l_xout_w : std_logic;
  signal s_gnt_n_xout_w : std_logic;
  signal s_gnt_e_xout_w : std_logic;
  signal s_gnt_w_xout_w : std_logic;
  signal s_rok_w        : std_logic;
  signal s_rd_w         : std_logic;
  signal s_data_w       : std_logic_vector(data_width_p downto 0);
  -- channel w wires
  signal w_req_l_xin_w  : std_logic;
  signal w_req_n_xin_w  : std_logic;
  signal w_req_e_xin_w  : std_logic;
  signal w_req_s_xin_w  : std_logic;
  signal w_gnt_l_xin_w  : std_logic;
  signal w_gnt_n_xin_w  : std_logic;
  signal w_gnt_e_xin_w  : std_logic;
  signal w_gnt_s_xin_w  : std_logic;
  signal w_req_l_xout_w : std_logic;
  signal w_req_n_xout_w : std_logic;
  signal w_req_e_xout_w : std_logic;
  signal w_req_s_xout_w : std_logic;
  signal w_gnt_l_xout_w : std_logic;
  signal w_gnt_n_xout_w : std_logic;
  signal w_gnt_e_xout_w : std_logic;
  signal w_gnt_s_xout_w : std_logic;
  signal w_rok_w        : std_logic;
  signal w_rd_w         : std_logic;
  signal w_data_w       : std_logic_vector(data_width_p downto 0);

begin

  lin : entity work.channel_in
    generic map(
      c_ena_p        => l_ena_p,
      x_id_p         => x_id_p,
      y_id_p         => y_id_p,
      flow_mode_p    => flow_mode_p,
      routing_mode_p => routing_mode_p,
      buffer_mode_p  => buffer_mode_p,
      buffer_depth_p => buffer_depth_p,
      data_width_p   => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_i   => l_in_data_i,
      val_i    => l_in_val_i,
      ack_o    => l_in_ack_o,
      req_l_o  => open,
      req_n_o  => l_req_n_xin_w,
      req_e_o  => l_req_e_xin_w,
      req_s_o  => l_req_s_xin_w,
      req_w_o  => l_req_w_xin_w,
      gnt_i(3) => n_gnt_l_xin_w,
      gnt_i(2) => e_gnt_l_xin_w,
      gnt_i(1) => s_gnt_l_xin_w,
      gnt_i(0) => w_gnt_l_xin_w,
      rok_o    => l_rok_w,
      rd_i(3)  => n_rd_w,
      rd_i(2)  => e_rd_w,
      rd_i(1)  => s_rd_w,
      rd_i(0)  => w_rd_w,
      data_o   => l_data_w
    );

  nin : entity work.channel_in
    generic map(
      c_ena_p        => n_ena_p,
      x_id_p         => x_id_p,
      y_id_p         => y_id_p,
      flow_mode_p    => flow_mode_p,
      routing_mode_p => routing_mode_p,
      buffer_mode_p  => buffer_mode_p,
      buffer_depth_p => buffer_depth_p,
      data_width_p   => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_i   => n_in_data_i,
      val_i    => n_in_val_i,
      ack_o    => n_in_ack_o,
      req_l_o  => n_req_l_xin_w,
      req_n_o  => open,
      req_e_o  => n_req_e_xin_w,
      req_s_o  => n_req_s_xin_w,
      req_w_o  => n_req_w_xin_w,
      gnt_i(3) => l_gnt_n_xin_w,
      gnt_i(2) => e_gnt_n_xin_w,
      gnt_i(1) => s_gnt_n_xin_w,
      gnt_i(0) => w_gnt_n_xin_w,
      rok_o    => n_rok_w,
      rd_i(3)  => l_rd_w,
      rd_i(2)  => e_rd_w,
      rd_i(1)  => s_rd_w,
      rd_i(0)  => w_rd_w,
      data_o   => n_data_w
    );

  ein : entity work.channel_in
    generic map(
      c_ena_p        => e_ena_p,
      x_id_p         => x_id_p,
      y_id_p         => y_id_p,
      flow_mode_p    => flow_mode_p,
      routing_mode_p => routing_mode_p,
      buffer_mode_p  => buffer_mode_p,
      buffer_depth_p => buffer_depth_p,
      data_width_p   => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_i   => e_in_data_i,
      val_i    => e_in_val_i,
      ack_o    => e_in_ack_o,
      req_l_o  => e_req_l_xin_w,
      req_n_o  => e_req_n_xin_w,
      req_e_o  => open,
      req_s_o  => e_req_s_xin_w,
      req_w_o  => e_req_w_xin_w,
      gnt_i(3) => l_gnt_e_xin_w,
      gnt_i(2) => n_gnt_e_xin_w,
      gnt_i(1) => s_gnt_e_xin_w,
      gnt_i(0) => w_gnt_e_xin_w,
      rok_o    => e_rok_w,
      rd_i(3)  => l_rd_w,
      rd_i(2)  => n_rd_w,
      rd_i(1)  => s_rd_w,
      rd_i(0)  => w_rd_w,
      data_o   => e_data_w
    );

  sin : entity work.channel_in
    generic map(
      c_ena_p        => s_ena_p,
      x_id_p         => x_id_p,
      y_id_p         => y_id_p,
      flow_mode_p    => flow_mode_p,
      routing_mode_p => routing_mode_p,
      buffer_mode_p  => buffer_mode_p,
      buffer_depth_p => buffer_depth_p,
      data_width_p   => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_i   => s_in_data_i,
      val_i    => s_in_val_i,
      ack_o    => s_in_ack_o,
      req_l_o  => s_req_l_xin_w,
      req_n_o  => s_req_n_xin_w,
      req_e_o  => s_req_e_xin_w,
      req_s_o  => open,
      req_w_o  => s_req_w_xin_w,
      gnt_i(3) => l_gnt_s_xin_w,
      gnt_i(2) => n_gnt_s_xin_w,
      gnt_i(1) => e_gnt_s_xin_w,
      gnt_i(0) => w_gnt_s_xin_w,
      rok_o    => s_rok_w,
      rd_i(3)  => l_rd_w,
      rd_i(2)  => n_rd_w,
      rd_i(1)  => e_rd_w,
      rd_i(0)  => w_rd_w,
      data_o   => s_data_w
    );

  win : entity work.channel_in
    generic map(
      c_ena_p        => w_ena_p,
      x_id_p         => x_id_p,
      y_id_p         => y_id_p,
      flow_mode_p    => flow_mode_p,
      routing_mode_p => routing_mode_p,
      buffer_mode_p  => buffer_mode_p,
      buffer_depth_p => buffer_depth_p,
      data_width_p   => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_i   => w_in_data_i,
      val_i    => w_in_val_i,
      ack_o    => w_in_ack_o,
      req_l_o  => w_req_l_xin_w,
      req_n_o  => w_req_n_xin_w,
      req_e_o  => w_req_e_xin_w,
      req_s_o  => w_req_s_xin_w,
      req_w_o  => open,
      gnt_i(3) => l_gnt_w_xin_w,
      gnt_i(2) => n_gnt_w_xin_w,
      gnt_i(1) => e_gnt_w_xin_w,
      gnt_i(0) => s_gnt_w_xin_w,
      rok_o    => w_rok_w,
      rd_i(3)  => l_rd_w,
      rd_i(2)  => n_rd_w,
      rd_i(1)  => e_rd_w,
      rd_i(0)  => s_rd_w,
      data_o   => w_data_w
    );

  lout : entity work.channel_out
    generic map(
      c_ena_p            => l_ena_p,
      flow_mode_p        => flow_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_o   => l_out_data_o,
      val_o    => l_out_val_o,
      ack_i    => l_out_ack_i,
      req_i(3) => n_req_l_xout_w,
      req_i(2) => e_req_l_xout_w,
      req_i(1) => s_req_l_xout_w,
      req_i(0) => w_req_l_xout_w,
      gnt_o(3) => l_gnt_n_xout_w,
      gnt_o(2) => l_gnt_e_xout_w,
      gnt_o(1) => l_gnt_s_xout_w,
      gnt_o(0) => l_gnt_w_xout_w,
      rok_i(3) => n_rok_w,
      rok_i(2) => e_rok_w,
      rok_i(1) => s_rok_w,
      rok_i(0) => w_rok_w,
      rd_o     => l_rd_w,
      data3_i  => n_data_w,
      data2_i  => e_data_w,
      data1_i  => s_data_w,
      data0_i  => w_data_w
    );

  nout : entity work.channel_out
    generic map(
      c_ena_p            => n_ena_p,
      flow_mode_p        => flow_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_o   => n_out_data_o,
      val_o    => n_out_val_o,
      ack_i    => n_out_ack_i,
      req_i(3) => l_req_n_xout_w,
      req_i(2) => e_req_n_xout_w,
      req_i(1) => s_req_n_xout_w,
      req_i(0) => w_req_n_xout_w,
      gnt_o(3) => n_gnt_l_xout_w,
      gnt_o(2) => n_gnt_e_xout_w,
      gnt_o(1) => n_gnt_s_xout_w,
      gnt_o(0) => n_gnt_w_xout_w,
      rok_i(3) => l_rok_w,
      rok_i(2) => e_rok_w,
      rok_i(1) => s_rok_w,
      rok_i(0) => w_rok_w,
      rd_o     => n_rd_w,
      data3_i  => l_data_w,
      data2_i  => e_data_w,
      data1_i  => s_data_w,
      data0_i  => w_data_w
    );

  eout : entity work.channel_out
    generic map(
      c_ena_p            => e_ena_p,
      flow_mode_p        => flow_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_o   => e_out_data_o,
      val_o    => e_out_val_o,
      ack_i    => e_out_ack_i,
      req_i(3) => l_req_e_xout_w,
      req_i(2) => n_req_e_xout_w,
      req_i(1) => s_req_e_xout_w,
      req_i(0) => w_req_e_xout_w,
      gnt_o(3) => e_gnt_l_xout_w,
      gnt_o(2) => e_gnt_n_xout_w,
      gnt_o(1) => e_gnt_s_xout_w,
      gnt_o(0) => e_gnt_w_xout_w,
      rok_i(3) => l_rok_w,
      rok_i(2) => n_rok_w,
      rok_i(1) => s_rok_w,
      rok_i(0) => w_rok_w,
      rd_o     => e_rd_w,
      data3_i  => l_data_w,
      data2_i  => n_data_w,
      data1_i  => s_data_w,
      data0_i  => w_data_w
    );

  sout : entity work.channel_out
    generic map(
      c_ena_p            => s_ena_p,
      flow_mode_p        => flow_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_o   => s_out_data_o,
      val_o    => s_out_val_o,
      ack_i    => s_out_ack_i,
      req_i(3) => l_req_s_xout_w,
      req_i(2) => n_req_s_xout_w,
      req_i(1) => e_req_s_xout_w,
      req_i(0) => w_req_s_xout_w,
      gnt_o(3) => s_gnt_l_xout_w,
      gnt_o(2) => s_gnt_n_xout_w,
      gnt_o(1) => s_gnt_e_xout_w,
      gnt_o(0) => s_gnt_w_xout_w,
      rok_i(3) => l_rok_w,
      rok_i(2) => n_rok_w,
      rok_i(1) => e_rok_w,
      rok_i(0) => w_rok_w,
      rd_o     => s_rd_w,
      data3_i  => l_data_w,
      data2_i  => n_data_w,
      data1_i  => e_data_w,
      data0_i  => w_data_w
    );

  wout : entity work.channel_out
    generic map(
      c_ena_p            => w_ena_p,
      flow_mode_p        => flow_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i    => clk_i,
      rst_i    => rst_i,
      data_o   => w_out_data_o,
      val_o    => w_out_val_o,
      ack_i    => w_out_ack_i,
      req_i(3) => l_req_w_xout_w,
      req_i(2) => n_req_w_xout_w,
      req_i(1) => e_req_w_xout_w,
      req_i(0) => s_req_w_xout_w,
      gnt_o(3) => w_gnt_l_xout_w,
      gnt_o(2) => w_gnt_n_xout_w,
      gnt_o(1) => w_gnt_e_xout_w,
      gnt_o(0) => w_gnt_s_xout_w,
      rok_i(3) => l_rok_w,
      rok_i(2) => n_rok_w,
      rok_i(1) => e_rok_w,
      rok_i(0) => s_rok_w,
      rd_o     => w_rd_w,
      data3_i  => l_data_w,
      data2_i  => n_data_w,
      data1_i  => e_data_w,
      data0_i  => s_data_w
    );

  crossbar : entity work.crossbar
    port map(
      l_req_n_i => l_req_n_xin_w,
      l_req_e_i => l_req_e_xin_w,
      l_req_s_i => l_req_s_xin_w,
      l_req_w_i => l_req_w_xin_w,
      l_req_n_o => l_req_n_xout_w,
      l_req_e_o => l_req_e_xout_w,
      l_req_s_o => l_req_s_xout_w,
      l_req_w_o => l_req_w_xout_w,
      n_req_l_i => n_req_l_xin_w,
      n_req_e_i => n_req_e_xin_w,
      n_req_s_i => n_req_s_xin_w,
      n_req_w_i => n_req_w_xin_w,
      n_req_l_o => n_req_l_xout_w,
      n_req_e_o => n_req_e_xout_w,
      n_req_s_o => n_req_s_xout_w,
      n_req_w_o => n_req_w_xout_w,
      e_req_l_i => e_req_l_xin_w,
      e_req_n_i => e_req_n_xin_w,
      e_req_s_i => e_req_s_xin_w,
      e_req_w_i => e_req_w_xin_w,
      e_req_l_o => e_req_l_xout_w,
      e_req_n_o => e_req_n_xout_w,
      e_req_s_o => e_req_s_xout_w,
      e_req_w_o => e_req_w_xout_w,
      s_req_l_i => s_req_l_xin_w,
      s_req_n_i => s_req_n_xin_w,
      s_req_e_i => s_req_e_xin_w,
      s_req_w_i => s_req_w_xin_w,
      s_req_l_o => s_req_l_xout_w,
      s_req_n_o => s_req_n_xout_w,
      s_req_e_o => s_req_e_xout_w,
      s_req_w_o => s_req_w_xout_w,
      w_req_l_i => w_req_l_xin_w,
      w_req_n_i => w_req_n_xin_w,
      w_req_e_i => w_req_e_xin_w,
      w_req_s_i => w_req_s_xin_w,
      w_req_l_o => w_req_l_xout_w,
      w_req_n_o => w_req_n_xout_w,
      w_req_e_o => w_req_e_xout_w,
      w_req_s_o => w_req_s_xout_w,
      l_gnt_n_i => l_gnt_n_xout_w,
      l_gnt_e_i => l_gnt_e_xout_w,
      l_gnt_s_i => l_gnt_s_xout_w,
      l_gnt_w_i => l_gnt_w_xout_w,
      l_gnt_n_o => l_gnt_n_xin_w,
      l_gnt_e_o => l_gnt_e_xin_w,
      l_gnt_s_o => l_gnt_s_xin_w,
      l_gnt_w_o => l_gnt_w_xin_w,
      n_gnt_l_i => n_gnt_l_xout_w,
      n_gnt_e_i => n_gnt_e_xout_w,
      n_gnt_s_i => n_gnt_s_xout_w,
      n_gnt_w_i => n_gnt_w_xout_w,
      n_gnt_l_o => n_gnt_l_xin_w,
      n_gnt_e_o => n_gnt_e_xin_w,
      n_gnt_s_o => n_gnt_s_xin_w,
      n_gnt_w_o => n_gnt_w_xin_w,
      e_gnt_l_i => e_gnt_l_xout_w,
      e_gnt_n_i => e_gnt_n_xout_w,
      e_gnt_s_i => e_gnt_s_xout_w,
      e_gnt_w_i => e_gnt_w_xout_w,
      e_gnt_l_o => e_gnt_l_xin_w,
      e_gnt_n_o => e_gnt_n_xin_w,
      e_gnt_s_o => e_gnt_s_xin_w,
      e_gnt_w_o => e_gnt_w_xin_w,
      s_gnt_l_i => s_gnt_l_xout_w,
      s_gnt_n_i => s_gnt_n_xout_w,
      s_gnt_e_i => s_gnt_e_xout_w,
      s_gnt_w_i => s_gnt_w_xout_w,
      s_gnt_l_o => s_gnt_l_xin_w,
      s_gnt_n_o => s_gnt_n_xin_w,
      s_gnt_e_o => s_gnt_e_xin_w,
      s_gnt_w_o => s_gnt_w_xin_w,
      w_gnt_l_i => w_gnt_l_xout_w,
      w_gnt_n_i => w_gnt_n_xout_w,
      w_gnt_e_i => w_gnt_e_xout_w,
      w_gnt_s_i => w_gnt_s_xout_w,
      w_gnt_l_o => w_gnt_l_xin_w,
      w_gnt_n_o => w_gnt_n_xin_w,
      w_gnt_e_o => w_gnt_e_xin_w,
      w_gnt_s_o => w_gnt_s_xin_w
    );

end rtl;