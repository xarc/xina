library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity buffering_fifo is
  generic (
    -- data width and buffer depth
    data_width_p   : positive := 32;
    buffer_depth_p : positive := 4
  );
  port (
    clk_i : in std_logic;
    rst_i : in std_logic;
    -- read from buffer
    rok_o  : out std_logic;
    rd_i   : in std_logic;
    data_o : out std_logic_vector(data_width_p - 1 downto 0);
    -- write to buffer
    wok_o  : out std_logic;
    wr_i   : in std_logic;
    data_i : in std_logic_vector(data_width_p - 1 downto 0)
  );
end buffering_fifo;

architecture ring of buffering_fifo is

  type fifo_t is array (buffer_depth_p - 1 downto 0) of std_logic_vector(data_width_p - 1 downto 0);
  signal fifo_r   : fifo_t;
  signal rd_ptr_r : unsigned(integer(ceil(log2(real(buffer_depth_p)))) - 1 downto 0) := (others => '0');
  signal wr_ptr_r : unsigned(integer(ceil(log2(real(buffer_depth_p)))) - 1 downto 0) := (others => '0');
  signal n_pos_r  : unsigned(integer(ceil(log2(real(buffer_depth_p)))) downto 0)     := (others => '0');

begin

  process (all)
  begin
    if (rst_i = '1') then
      rd_ptr_r <= (others => '0');
      wr_ptr_r <= (others => '0');
      n_pos_r  <= (others => '0');
    elsif (rising_edge(clk_i)) then
      if (wr_i = '1' and n_pos_r /= buffer_depth_p) then
        wr_ptr_r                     <= wr_ptr_r + 1;
        fifo_r(to_integer(wr_ptr_r)) <= data_i;
        if (rd_i = '1' and n_pos_r /= 0) then
          rd_ptr_r <= rd_ptr_r + 1;
        else
          n_pos_r <= n_pos_r + 1;
        end if;
      elsif (rd_i = '1' and n_pos_r /= 0) then
        rd_ptr_r <= rd_ptr_r + 1;
        n_pos_r  <= n_pos_r - 1;
      end if;
    end if;
  end process;
  rok_o  <= '1' when (n_pos_r /= 0) else '0';
  wok_o  <= '1' when (n_pos_r /= buffer_depth_p) else '0';
  data_o <= fifo_r(to_integer(rd_ptr_r));

end ring;

architecture shift of buffering_fifo is

  type fifo_t is array (buffer_depth_p - 1 downto 0) of std_logic_vector(data_width_p - 1 downto 0);
  signal fifo_r   : fifo_t;
  signal rd_ptr_r : unsigned(integer(ceil(log2(real(buffer_depth_p)))) downto 0) := (others => '0');

begin

  process (all)
  begin
    if (rst_i = '1') then
      rd_ptr_r <= (others => '0');
    elsif (rising_edge(clk_i)) then
      if (wr_i = '1' and rd_ptr_r /= buffer_depth_p) then
        fifo_r(0) <= data_i;
        for i in 1 to buffer_depth_p - 1 loop
          fifo_r(i) <= fifo_r(i - 1);
        end loop;
        if not (rd_i = '1' and rd_ptr_r /= 0) then
          rd_ptr_r <= rd_ptr_r + 1;
        end if;
      elsif (rd_i = '1' and rd_ptr_r /= 0) then
        rd_ptr_r <= rd_ptr_r - 1;
      end if;
    end if;
  end process;
  rok_o  <= '1' when (rd_ptr_r /= 0) else '0';
  wok_o  <= '1' when (rd_ptr_r /= buffer_depth_p) else '0';
  data_o <= fifo_r(to_integer(rd_ptr_r)) when (to_integer(rd_ptr_r) = 0) else fifo_r(to_integer(rd_ptr_r - 1));

end shift;