library ieee;
use ieee.std_logic_1164.all;

entity flow_in_hs is
  generic (
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
end flow_in_hs;

architecture moore of flow_in_hs is

  signal current_r : std_logic_vector(1 downto 0);
  signal next_w    : std_logic_vector(1 downto 0);

begin

  process (all)
  begin
    if (rst_i = '1') then
      current_r <= "00";
    elsif (rising_edge(clk_i)) then
      current_r <= next_w;
    end if;
  end process;

  process (all)
  begin
    case current_r is
      when "00" =>
        if (val_i = '1' and wok_i = '1') then
          next_w <= "01";
        else
          next_w <= "00";
        end if;
      when "01" =>
        if (val_i = '0') then
          next_w <= "00";
        else
          next_w <= "10";
        end if;
      when "10" =>
        if (val_i = '0') then
          next_w <= "00";
        else
          next_w <= "10";
        end if;
      when others => next_w <= "00";
    end case;
  end process;

  ack_o  <= '1' when (current_r = "01" or current_r = "10") else '0';
  wr_o   <= '1' when (current_r = "01") else '0';
  data_o <= data_i;

end moore;

architecture mealy of flow_in_hs is

  signal current_r : std_logic;
  signal next_w    : std_logic;

begin

  process (all)
  begin
    if (rst_i = '1') then
      current_r <= '0';
    elsif (rising_edge(clk_i)) then
      current_r <= next_w;
    end if;
  end process;

  process (all)
  begin
    case current_r is
      when '0' =>
        if (val_i = '1' and wok_i = '1') then
          ack_o  <= '0';
          wr_o   <= '0';
          next_w <= '1';
        else
          ack_o  <= '0';
          wr_o   <= '0';
          next_w <= '0';
        end if;
      when '1' =>
        if (val_i = '1') then
          ack_o  <= '1';
          wr_o   <= '1';
          next_w <= '1';
        else
          ack_o  <= '1';
          wr_o   <= '0';
          next_w <= '0';
        end if;
      when others =>
        ack_o  <= '0';
        wr_o   <= '0';
        next_w <= '0';
    end case;
  end process;

  data_o <= data_i;

end mealy;