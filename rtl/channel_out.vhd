library ieee;
use ieee.std_logic_1164.all;

entity channel_out is
  generic (
    -- channel enable
    c_ena_p : natural := 1;
    -- output flow regulation mode
    flow_mode_p : natural := 0;
    -- arbitration mode
    arbitration_mode_p : natural := 0;
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
    -- requests and grants
    req_i : in std_logic_vector(3 downto 0);
    gnt_o : out std_logic_vector(3 downto 0);
    -- intra router signals
    rok_i   : in std_logic_vector(3 downto 0);
    rd_o    : out std_logic;
    data3_i : in std_logic_vector(data_width_p downto 0);
    data2_i : in std_logic_vector(data_width_p downto 0);
    data1_i : in std_logic_vector(data_width_p downto 0);
    data0_i : in std_logic_vector(data_width_p downto 0)
  );
end channel_out;

architecture rtl of channel_out is

  signal rok_w  : std_logic;
  signal data_w : std_logic_vector(data_width_p downto 0);
  signal gnt_w  : std_logic_vector(3 downto 0);

begin

  channel_out :
  if (c_ena_p = 0) generate
    data_o <= (others => '0');
    val_o  <= '0';
    gnt_o  <= (others => '0');
    rd_o   <= '0';
  else generate
      flow_out : entity work.flow_out
        generic map(
          mode_p       => flow_mode_p,
          data_width_p => data_width_p
        )
        port map(
          clk_i  => clk_i,
          rst_i  => rst_i,
          data_o => data_o,
          val_o  => val_o,
          ack_i  => ack_i,
          data_i => data_w,
          rok_i  => rok_w,
          rd_o   => rd_o
        );
      arbitration : entity work.arbitration
        generic map(
          mode_p => arbitration_mode_p
        )
        port map(
          clk_i => clk_i,
          rst_i => rst_i,
          req_i => req_i,
          gnt_o => gnt_w
        );
      data_switch : entity work.switch
        generic map(
          data_width_p => data_width_p + 1
        )
        port map(
          sel_i   => gnt_w,
          data3_i => data3_i,
          data2_i => data2_i,
          data1_i => data1_i,
          data0_i => data0_i,
          data_o  => data_w
        );
      rok_switch : entity work.switch
        generic map(
          data_width_p => 1
        )
        port map(
          sel_i      => gnt_w,
          data3_i(0) => rok_i(3),
          data2_i(0) => rok_i(2),
          data1_i(0) => rok_i(1),
          data0_i(0) => rok_i(0),
          data_o(0)  => rok_w
        );
      gnt_o <= gnt_w;
    end generate;

  end rtl;