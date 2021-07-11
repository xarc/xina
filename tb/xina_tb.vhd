library ieee;
use ieee.std_logic_1164.all;

use work.xina_pkg.all;

entity xina_tb is
  generic (
    -- # of routers in x and y
    rows_p : positive := rows_c;
    cols_p : positive := cols_c;
    -- input and output flow regulation mode
    flow_mode_p : natural := flow_mode_c; -- 0 for HS Moore, 1 for HS Mealy
    -- routing mode
    routing_mode_p : natural := routing_mode_c; -- 0 for XY Moore, 1 for XY Mealy
    -- arbitration mode
    arbitration_mode_p : natural := arbitration_mode_c; -- 0 for RR Moore, 1 for RR Mealy
    -- input buffer mode and depth
    buffer_mode_p  : natural  := buffer_mode_c; -- 0 for FIFO Ring, 1 for FIFO Shift
    buffer_depth_p : positive := buffer_depth_c;
    -- network data width
    data_width_p : positive := data_width_c
  );
end xina_tb;

architecture tb of xina_tb is

  constant period_c : time := 10 ns;

  signal clk_i        : std_logic := '0';
  signal rst_i        : std_logic := '0';
  signal l_in_data_i  : data_link_l_t;
  signal l_in_val_i   : ctrl_link_l_t;
  signal l_in_ack_o   : ctrl_link_l_t;
  signal l_out_data_o : data_link_l_t;
  signal l_out_val_o  : ctrl_link_l_t;
  signal l_out_ack_i  : ctrl_link_l_t;

begin

  xina : entity work.xina
    generic map(
      rows_p             => rows_p,
      cols_p             => cols_p,
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
      l_out_ack_i  => l_out_ack_i
    );

  clk_i <= not clk_i after period_c/2;
  rst_i <= '1', '0' after period_c;

end tb;