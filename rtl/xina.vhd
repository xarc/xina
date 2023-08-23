library ieee;
use ieee.std_logic_1164.all;

package xina_pkg is

  constant rows_c             : positive := 2;
  constant cols_c             : positive := 2;
  constant flow_mode_c        : natural  := 0; -- 0 for HS Moore, 1 for HS Mealy
  constant routing_mode_c     : natural  := 0; -- 0 for XY Moore, 1 for XY Mealy
  constant arbitration_mode_c : natural  := 0; -- 0 for RR Moore, 1 for RR Mealy
  constant buffer_mode_c      : natural  := 0; -- 0 for FIFO Ring, 1 for FIFO Shift
  constant buffer_depth_c     : positive := 4;
  constant data_width_c       : positive := 32;

  type data_link_l_t is array (cols_c - 1 downto 0, rows_c - 1 downto 0) of std_logic_vector(data_width_c downto 0);
  type data_link_x_t is array (cols_c downto 0, rows_c - 1 downto 0) of std_logic_vector(data_width_c downto 0);
  type data_link_y_t is array (cols_c - 1 downto 0, rows_c downto 0) of std_logic_vector(data_width_c downto 0);
  type ctrl_link_l_t is array (cols_c - 1 downto 0, rows_c - 1 downto 0) of std_logic;
  type ctrl_link_x_t is array (cols_c downto 0, rows_c - 1 downto 0) of std_logic;
  type ctrl_link_y_t is array (cols_c - 1 downto 0, rows_c downto 0) of std_logic;

end xina_pkg;

library ieee;
use ieee.std_logic_1164.all;

use work.xina_pkg.all;

entity xina is
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

  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- local channel interface
    l_in_data_i  : in data_link_l_t;
    l_in_val_i   : in ctrl_link_l_t;
    l_in_ack_o   : out ctrl_link_l_t;
    l_out_data_o : out data_link_l_t;
    l_out_val_o  : out ctrl_link_l_t;
    l_out_ack_i  : in ctrl_link_l_t
  );
end xina;

architecture rtl of xina is

  -- link signals for x channels
  signal x_in_data_w  : data_link_x_t;
  signal x_in_val_w   : ctrl_link_x_t;
  signal x_in_ack_w   : ctrl_link_x_t;
  signal x_out_data_w : data_link_x_t;
  signal x_out_val_w  : ctrl_link_x_t;
  signal x_out_ack_w  : ctrl_link_x_t;
  -- link signals for y channels
  signal y_in_data_w  : data_link_y_t;
  signal y_in_val_w   : ctrl_link_y_t;
  signal y_in_ack_w   : ctrl_link_y_t;
  signal y_out_data_w : data_link_y_t;
  signal y_out_val_w  : ctrl_link_y_t;
  signal y_out_ack_w  : ctrl_link_y_t;

begin

  y0 :
  for i in cols_p - 1 downto 0 generate
    y_in_data_w(i, rows_p) <= (others => '0');
    y_in_val_w(i, rows_p)  <= '0';
    y_out_ack_w(i, rows_p) <= '0';
    y_out_data_w(i, 0)     <= (others => '0');
    y_out_val_w(i, 0)      <= '0';
    y_in_ack_w(i, 0)       <= '0';
  end generate;

  x0 :
  for j in rows_p - 1 downto 0 generate
    x_in_data_w(0, j)       <= (others => '0');
    x_in_val_w(0, j)        <= '0';
    x_out_ack_w(0, j)       <= '0';
    x_out_data_w(cols_p, j) <= (others => '0');
    x_out_val_w(cols_p, j)  <= '0';
    x_in_ack_w(cols_p, j)   <= '0';
  end generate;

  col :
  for i in cols_p - 1 downto 0 generate
    row :
    for j in rows_p - 1 downto 0 generate
      router : entity work.router
        generic map(
          x_id_p             => i,
          y_id_p             => j,
          l_ena_p            => 1,
          n_ena_p            => ((j + 1) mod rows_p),
          e_ena_p            => ((i + 1) mod cols_p),
          s_ena_p            => j,
          w_ena_p            => i,
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
          l_in_data_i  => l_in_data_i(i, j),
          l_in_val_i   => l_in_val_i(i, j),
          l_in_ack_o   => l_in_ack_o(i, j),
          l_out_data_o => l_out_data_o(i, j),
          l_out_val_o  => l_out_val_o(i, j),
          l_out_ack_i  => l_out_ack_i(i, j),
          n_in_data_i  => y_in_data_w(i, j + 1),
          n_in_val_i   => y_in_val_w(i, j + 1),
          n_in_ack_o   => y_in_ack_w(i, j + 1),
          n_out_data_o => y_out_data_w(i, j + 1),
          n_out_val_o  => y_out_val_w(i, j + 1),
          n_out_ack_i  => y_out_ack_w(i, j + 1),
          e_in_data_i  => x_out_data_w(i + 1, j),
          e_in_val_i   => x_out_val_w(i + 1, j),
          e_in_ack_o   => x_out_ack_w(i + 1, j),
          e_out_data_o => x_in_data_w(i + 1, j),
          e_out_val_o  => x_in_val_w(i + 1, j),
          e_out_ack_i  => x_in_ack_w(i + 1, j),
          s_in_data_i  => y_out_data_w(i, j),
          s_in_val_i   => y_out_val_w(i, j),
          s_in_ack_o   => y_out_ack_w(i, j),
          s_out_data_o => y_in_data_w(i, j),
          s_out_val_o  => y_in_val_w(i, j),
          s_out_ack_i  => y_in_ack_w(i, j),
          w_in_data_i  => x_in_data_w(i, j),
          w_in_val_i   => x_in_val_w(i, j),
          w_in_ack_o   => x_in_ack_w(i, j),
          w_out_data_o => x_out_data_w(i, j),
          w_out_val_o  => x_out_val_w(i, j),
          w_out_ack_i  => x_out_ack_w(i, j)
        );
    end generate;
  end generate;

end rtl;