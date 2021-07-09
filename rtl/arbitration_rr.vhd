library ieee;
use ieee.std_logic_1164.all;

entity arbitration_rr is
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- requests and grants
    req_i : in std_logic_vector(3 downto 0);
    gnt_o : out std_logic_vector(3 downto 0)
  );
end arbitration_rr;

architecture moore of arbitration_rr is

  signal current_r : std_logic_vector(2 downto 0);
  signal next_w    : std_logic_vector(2 downto 0);
  signal gnt_w     : std_logic_vector(3 downto 0);

begin

  process (all)
  begin
    if (rst_i = '1') then
      current_r <= "000";
    elsif (rising_edge(clk_i)) then
      current_r <= next_w;
    end if;
  end process;

  process (all)
  begin
    case current_r is
      when "000" =>
        if (req_i(3) = '1') then
          next_w <= "001";
        elsif (req_i(2) = '1') then
          next_w <= "011";
        elsif (req_i(1) = '1') then
          next_w <= "101";
        elsif (req_i(0) = '1') then
          next_w <= "111";
        else
          next_w <= "000";
        end if;
      when "001" =>
        if (req_i(3) = '1') then
          next_w <= "001";
        elsif (req_i(2) = '1') then
          next_w <= "011";
        elsif (req_i(1) = '1') then
          next_w <= "101";
        elsif (req_i(0) = '1') then
          next_w <= "111";
        else
          next_w <= "010";
        end if;
      when "010" =>
        if (req_i(2) = '1') then
          next_w <= "011";
        elsif (req_i(1) = '1') then
          next_w <= "101";
        elsif (req_i(0) = '1') then
          next_w <= "111";
        elsif (req_i(3) = '1') then
          next_w <= "001";
        else
          next_w <= "010";
        end if;
      when "011" =>
        if (req_i(2) = '1') then
          next_w <= "011";
        elsif (req_i(1) = '1') then
          next_w <= "101";
        elsif (req_i(0) = '1') then
          next_w <= "111";
        elsif (req_i(3) = '1') then
          next_w <= "001";
        else
          next_w <= "100";
        end if;
      when "100" =>
        if (req_i(1) = '1') then
          next_w <= "101";
        elsif (req_i(0) = '1') then
          next_w <= "111";
        elsif (req_i(3) = '1') then
          next_w <= "001";
        elsif (req_i(2) = '1') then
          next_w <= "011";
        else
          next_w <= "100";
        end if;
      when "101" =>
        if (req_i(1) = '1') then
          next_w <= "101";
        elsif (req_i(0) = '1') then
          next_w <= "111";
        elsif (req_i(3) = '1') then
          next_w <= "001";
        elsif (req_i(2) = '1') then
          next_w <= "011";
        else
          next_w <= "110";
        end if;
      when "110" =>
        if (req_i(0) = '1') then
          next_w <= "111";
        elsif (req_i(3) = '1') then
          next_w <= "001";
        elsif (req_i(2) = '1') then
          next_w <= "011";
        elsif (req_i(1) = '1') then
          next_w <= "101";
        else
          next_w <= "110";
        end if;
      when "111" =>
        if (req_i(0) = '1') then
          next_w <= "111";
        elsif (req_i(3) = '1') then
          next_w <= "001";
        elsif (req_i(2) = '1') then
          next_w <= "011";
        elsif (req_i(1) = '1') then
          next_w <= "101";
        else
          next_w <= "000";
        end if;
        -- others
      when others =>
        next_w <= "000";
    end case;
  end process;

  gnt_w <= "1000" when current_r = "001" else
    "0100" when current_r = "011" else
    "0010" when current_r = "101" else
    "0001" when current_r = "111" else
    (others => '0');
  gnt_o <= req_i and gnt_w;

end moore;

architecture mealy of arbitration_rr is

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
        if (req_i(3) = '1') then
          gnt_o  <= "1000";
          next_w <= "00";
        elsif (req_i(2) = '1') then
          gnt_o  <= "0100";
          next_w <= "01";
        elsif (req_i(1) = '1') then
          gnt_o  <= "0010";
          next_w <= "10";
        elsif (req_i(0) = '1') then
          gnt_o  <= "0001";
          next_w <= "11";
        else
          gnt_o  <= "0000";
          next_w <= "00";
        end if;
      when "01" =>
        if (req_i(2) = '1') then
          gnt_o  <= "0100";
          next_w <= "01";
        elsif (req_i(1) = '1') then
          gnt_o  <= "0010";
          next_w <= "10";
        elsif (req_i(0) = '1') then
          gnt_o  <= "0001";
          next_w <= "11";
        elsif (req_i(3) = '1') then
          gnt_o  <= "1000";
          next_w <= "00";
        else
          gnt_o  <= "0000";
          next_w <= "01";
        end if;
      when "10" =>
        if (req_i(1) = '1') then
          gnt_o  <= "0010";
          next_w <= "10";
        elsif (req_i(0) = '1') then
          gnt_o  <= "0001";
          next_w <= "11";
        elsif (req_i(3) = '1') then
          gnt_o  <= "1000";
          next_w <= "00";
        elsif (req_i(2) = '1') then
          gnt_o  <= "0100";
          next_w <= "01";
        else
          gnt_o  <= "0000";
          next_w <= "10";
        end if;
      when "11" =>
        if (req_i(0) = '1') then
          gnt_o  <= "0001";
          next_w <= "11";
        elsif (req_i(3) = '1') then
          gnt_o  <= "1000";
          next_w <= "00";
        elsif (req_i(2) = '1') then
          gnt_o  <= "0100";
          next_w <= "01";
        elsif (req_i(1) = '1') then
          gnt_o  <= "0010";
          next_w <= "10";
        else
          gnt_o  <= "0000";
          next_w <= "11";
        end if;
        -- others
      when others =>
        gnt_o  <= "0000";
        next_w <= "00";
    end case;
  end process;

end mealy;