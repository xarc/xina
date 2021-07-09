library ieee;
use ieee.std_logic_1164.all;

entity router_tb is
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
end router_tb;

architecture tb of router_tb is

  constant period_c : time := 10 ns;

  signal clk_i        : std_logic := '0';
  signal rst_i        : std_logic := '0';
  signal l_in_data_i  : std_logic_vector(data_width_p downto 0);
  signal l_in_val_i   : std_logic;
  signal l_in_ack_o   : std_logic;
  signal l_out_data_o : std_logic_vector(data_width_p downto 0);
  signal l_out_val_o  : std_logic;
  signal l_out_ack_i  : std_logic;
  signal n_in_data_i  : std_logic_vector(data_width_p downto 0);
  signal n_in_val_i   : std_logic;
  signal n_in_ack_o   : std_logic;
  signal n_out_data_o : std_logic_vector(data_width_p downto 0);
  signal n_out_val_o  : std_logic;
  signal n_out_ack_i  : std_logic;
  signal e_in_data_i  : std_logic_vector(data_width_p downto 0);
  signal e_in_val_i   : std_logic;
  signal e_in_ack_o   : std_logic;
  signal e_out_data_o : std_logic_vector(data_width_p downto 0);
  signal e_out_val_o  : std_logic;
  signal e_out_ack_i  : std_logic;
  signal s_in_data_i  : std_logic_vector(data_width_p downto 0);
  signal s_in_val_i   : std_logic;
  signal s_in_ack_o   : std_logic;
  signal s_out_data_o : std_logic_vector(data_width_p downto 0);
  signal s_out_val_o  : std_logic;
  signal s_out_ack_i  : std_logic;
  signal w_in_data_i  : std_logic_vector(data_width_p downto 0);
  signal w_in_val_i   : std_logic;
  signal w_in_ack_o   : std_logic;
  signal w_out_data_o : std_logic_vector(data_width_p downto 0);
  signal w_out_val_o  : std_logic;
  signal w_out_ack_i  : std_logic;

begin

  router : entity work.router
    generic map(
      x_id_p             => x_id_p,
      y_id_p             => y_id_p,
      l_ena_p            => l_ena_p,
      n_ena_p            => n_ena_p,
      e_ena_p            => e_ena_p,
      s_ena_p            => s_ena_p,
      w_ena_p            => w_ena_p,
      flow_mode_p        => flow_mode_p,
      routing_mode_p     => routing_mode_p,
      arbitration_mode_p => arbitration_mode_p,
      buffer_mode_p      => buffer_mode_p,
      buffer_depth_p     => buffer_depth_p,
      data_width_p       => data_width_p
    )
    port map(
      clk_i        => clk_i,
      rst_i        => rst_i,
      l_in_data_i  => l_in_data_i,
      l_in_val_i   => l_in_val_i,
      l_in_ack_o   => l_in_ack_o,
      l_out_data_o => l_out_data_o,
      l_out_val_o  => l_out_val_o,
      l_out_ack_i  => l_out_ack_i,
      n_in_data_i  => n_in_data_i,
      n_in_val_i   => n_in_val_i,
      n_in_ack_o   => n_in_ack_o,
      n_out_data_o => n_out_data_o,
      n_out_val_o  => n_out_val_o,
      n_out_ack_i  => n_out_ack_i,
      e_in_data_i  => e_in_data_i,
      e_in_val_i   => e_in_val_i,
      e_in_ack_o   => e_in_ack_o,
      e_out_data_o => e_out_data_o,
      e_out_val_o  => e_out_val_o,
      e_out_ack_i  => e_out_ack_i,
      s_in_data_i  => s_in_data_i,
      s_in_val_i   => s_in_val_i,
      s_in_ack_o   => s_in_ack_o,
      s_out_data_o => s_out_data_o,
      s_out_val_o  => s_out_val_o,
      s_out_ack_i  => s_out_ack_i,
      w_in_data_i  => w_in_data_i,
      w_in_val_i   => w_in_val_i,
      w_in_ack_o   => w_in_ack_o,
      w_out_data_o => w_out_data_o,
      w_out_val_o  => w_out_val_o,
      w_out_ack_i  => w_out_ack_i
    );

  clk_i <= not clk_i after period_c/2;
  rst_i <= '1', '0' after period_c;

end tb;