library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity routing_xy is
  generic (
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
end routing_xy;

architecture moore of routing_xy is

  signal current_r : std_logic_vector(3 downto 0);
  signal next_w    : std_logic_vector(3 downto 0);

begin

  process (all)
  begin
    if (rst_i = '1') then
      current_r <= "0000";
    elsif (rising_edge(clk_i)) then
      current_r <= next_w;
    end if;
  end process;

  process (all)
    variable x_dst_v : integer;
    variable y_dst_v : integer;
  begin
    case current_r is
      when "0000" =>
        if (frame_i = '1' and rok_i = '1') then
          x_dst_v := to_integer(unsigned(data_i(data_width_p - 1 downto (data_width_p/2))));
          y_dst_v := to_integer(unsigned(data_i((data_width_p/2) - 1 downto 0)));
          if (x_dst_v /= x_id_p) then
            if (x_dst_v > x_id_p) then
              next_w      <= "0001";
            else next_w <= "0010";
            end if;
          elsif (y_dst_v /= y_id_p) then
            if (y_dst_v > y_id_p) then
              next_w      <= "0011";
            else next_w <= "0100";
            end if;
          else next_w <= "0101";
          end if;
        else next_w <= "0000";
        end if;
        -- x_dst_v > x_id_p
      when "0001" =>
        if (frame_i = '0' and rd_i = '1' and rok_i = '1') then
          next_w      <= "1001";
        else next_w <= "0001";
        end if;
      when "1001" =>
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "0000";
        else next_w <= "1001";
        end if;
        -- x_dst_v < x_id_p
      when "0010" =>
        if (frame_i = '0' and rd_i = '1' and rok_i = '1') then
          next_w      <= "1010";
        else next_w <= "0010";
        end if;
      when "1010" =>
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "0000";
        else next_w <= "1010";
        end if;
        -- y_dst_v > y_id_p
      when "0011" =>
        if (frame_i = '0' and rd_i = '1' and rok_i = '1') then
          next_w      <= "1011";
        else next_w <= "0011";
        end if;
      when "1011" =>
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "0000";
        else next_w <= "1011";
        end if;
        -- y_dst_v < y_id_p
      when "0100" =>
        if (frame_i = '0' and rd_i = '1' and rok_i = '1') then
          next_w      <= "1100";
        else next_w <= "0100";
        end if;
      when "1100" =>
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "0000";
        else next_w <= "1100";
        end if;
        -- x_dst_v = x_id_p and y_dst_v = y_id_p
      when "0101" =>
        if (frame_i = '0' and rd_i = '1' and rok_i = '1') then
          next_w      <= "1101";
        else next_w <= "0101";
        end if;
      when "1101" =>
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "0000";
        else next_w <= "1101";
        end if;
        -- others
      when others => next_w <= "0000";
    end case;
  end process;

  req_l_o <= '1' when (current_r = "0101" or current_r = "1101") else '0';
  req_n_o <= '1' when (current_r = "0011" or current_r = "1011") else '0';
  req_e_o <= '1' when (current_r = "0001" or current_r = "1001") else '0';
  req_s_o <= '1' when (current_r = "0100" or current_r = "1100") else '0';
  req_w_o <= '1' when (current_r = "0010" or current_r = "1010") else '0';

end moore;

architecture mealy of routing_xy is

  signal current_r : std_logic_vector(2 downto 0);
  signal next_w    : std_logic_vector(2 downto 0);

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
    variable x_dst_v : integer;
    variable y_dst_v : integer;
  begin
    case current_r is
      when "000" =>
        if (frame_i = '1' and rok_i = '1') then
          x_dst_v := to_integer(unsigned(data_i(data_width_p - 1 downto (data_width_p/2))));
          y_dst_v := to_integer(unsigned(data_i((data_width_p/2) - 1 downto 0)));
          if (x_dst_v /= x_id_p) then
            if (x_dst_v > x_id_p) then
              req_l_o <= '0';
              req_n_o <= '0';
              req_e_o <= '1';
              req_s_o <= '0';
              req_w_o <= '0';
              if (rd_i = '1') then
                next_w      <= "001";
              else next_w <= "000";
              end if;
            else req_l_o <= '0';
              req_n_o      <= '0';
              req_e_o      <= '0';
              req_s_o      <= '0';
              req_w_o      <= '1';
              if (rd_i = '1') then
                next_w      <= "010";
              else next_w <= "000";
              end if;
            end if;
          elsif (y_dst_v /= y_id_p) then
            if (y_dst_v > y_id_p) then
              req_l_o <= '0';
              req_n_o <= '1';
              req_e_o <= '0';
              req_s_o <= '0';
              req_w_o <= '0';
              if (rd_i = '1') then
                next_w      <= "011";
              else next_w <= "000";
              end if;
            else req_l_o <= '0';
              req_n_o      <= '0';
              req_e_o      <= '0';
              req_s_o      <= '1';
              req_w_o      <= '0';
              if (rd_i = '1') then
                next_w      <= "100";
              else next_w <= "000";
              end if;
            end if;
          else req_l_o <= '1';
            req_n_o      <= '0';
            req_e_o      <= '0';
            req_s_o      <= '0';
            req_w_o      <= '0';
            if (rd_i = '1') then
              next_w      <= "101";
            else next_w <= "000";
            end if;
          end if;
        else req_l_o <= '0';
          req_n_o      <= '0';
          req_e_o      <= '0';
          req_s_o      <= '0';
          req_w_o      <= '0';
          next_w       <= "000";
        end if;
        -- x_dst_v > x_id_p
      when "001" =>
        req_l_o <= '0';
        req_n_o <= '0';
        req_e_o <= '1';
        req_s_o <= '0';
        req_w_o <= '0';
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "111";
        else next_w <= "001";
        end if;
        -- x_dst_v < x_id_p
      when "010" =>
        req_l_o <= '0';
        req_n_o <= '0';
        req_e_o <= '0';
        req_s_o <= '0';
        req_w_o <= '1';
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "111";
        else next_w <= "010";
        end if;
        -- y_dst_v > y_id_p
      when "011" =>
        req_l_o <= '0';
        req_n_o <= '1';
        req_e_o <= '0';
        req_s_o <= '0';
        req_w_o <= '0';
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "111";
        else next_w <= "011";
        end if;
        -- y_dst_v < y_id_p
      when "100" =>
        req_l_o <= '0';
        req_n_o <= '0';
        req_e_o <= '0';
        req_s_o <= '1';
        req_w_o <= '0';
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "111";
        else next_w <= "100";
        end if;
        -- x_dst_v = x_id_p and y_dst_v = y_id_p
      when "101" =>
        req_l_o <= '1';
        req_n_o <= '0';
        req_e_o <= '0';
        req_s_o <= '0';
        req_w_o <= '0';
        if (frame_i = '1' and rd_i = '1' and rok_i = '1') then
          next_w      <= "111";
        else next_w <= "101";
        end if;
        -- others
      when "111" =>
        req_l_o <= '0';
        req_n_o <= '0';
        req_e_o <= '0';
        req_s_o <= '0';
        req_w_o <= '0';
        next_w  <= "000";
      when others =>
        req_l_o <= '0';
        req_n_o <= '0';
        req_e_o <= '0';
        req_s_o <= '0';
        req_w_o <= '0';
        next_w  <= "000";
    end case;
  end process;
end mealy;