library ieee;
use ieee.std_logic_1164.all;

package hamming_pkg is

  type par_set_t is array (natural range <>, natural range <>) of integer;
  type par_err_t is array (natural range <>) of std_logic_vector(6 downto 0);

  constant par_set_c : par_set_t := (
  0 => (0, 1, 3, 4, 6, 8, 10, 11, 13, 15, 17, 19, 21, 23, 25, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 57, 59, 61, 63),
  1 => (0, 2, 3, 5, 6, 9, 10, 12, 13, 16, 17, 20, 21, 24, 25, 27, 28, 31, 32, 35, 36, 39, 40, 43, 44, 47, 48, 51, 52, 55, 56, 58, 59, 62, 63),
  2 => (1, 2, 3, 7, 8, 9, 10, 14, 15, 16, 17, 22, 23, 24, 25, 29, 30, 31, 32, 37, 38, 39, 40, 45, 46, 47, 48, 53, 54, 55, 56, 60, 61, 62, 63),
  3 => (4, 5, 6, 7, 8, 9, 10, 18, 19, 20, 21, 22, 23, 24, 25, 33, 34, 35, 36, 37, 38, 39, 40, 49, 50, 51, 52, 53, 54, 55, 56, 64, -1, -1, -1),
  4 => (11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, -1, -1, -1, -1),
  5 => (26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, -1, -1, -1, -1),
  6 => (57, 58, 59, 60, 61, 62, 63, 64, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1)
  );

  constant par_err_c : par_err_t := (
  0  => "0000011",
  1  => "0000101",
  2  => "0000110",
  3  => "0000111",
  4  => "0001001",
  5  => "0001010",
  6  => "0001011",
  7  => "0001100",
  8  => "0001101",
  9  => "0001110",
  10 => "0001111",
  11 => "0010001",
  12 => "0010010",
  13 => "0010011",
  14 => "0010100",
  15 => "0010101",
  16 => "0010110",
  17 => "0010111",
  18 => "0011000",
  19 => "0011001",
  20 => "0011010",
  21 => "0011011",
  22 => "0011100",
  23 => "0011101",
  24 => "0011110",
  25 => "0011111",
  26 => "0100001",
  27 => "0100010",
  28 => "0100011",
  29 => "0100100",
  30 => "0100101",
  31 => "0100110",
  32 => "0100111",
  33 => "0101000",
  34 => "0101001",
  35 => "0101010",
  36 => "0101011",
  37 => "0101100",
  38 => "0101101",
  39 => "0101110",
  40 => "0101111",
  41 => "0110000",
  42 => "0110001",
  43 => "0110010",
  44 => "0110011",
  45 => "0110100",
  46 => "0110101",
  47 => "0110110",
  48 => "0110111",
  49 => "0111000",
  50 => "0111001",
  51 => "0111010",
  52 => "0111011",
  53 => "0111100",
  54 => "0111101",
  55 => "0111110",
  56 => "0111111",
  57 => "1000001",
  58 => "1000010",
  59 => "1000011",
  60 => "1000100",
  61 => "1000101",
  62 => "1000110",
  63 => "1000111",
  64 => "1001000"
  );

  function par_width_f (width_p : in positive) return positive;
  function par_subset_f (width_p : in positive; pos_p : in natural) return positive;
  function par_data_f (data_p   : in std_logic_vector) return std_logic_vector;

  component hamming_enc
    generic (
      width_p : positive
    );
    port (
      data_i : in std_logic_vector(width_p - 1 downto 0);
      data_o : out std_logic_vector(width_p + par_width_f(width_p) - 1 downto 0)
    );
  end component;

  component hamming_dec
    generic (
      width_p : positive
    );
    port (
      data_i : in std_logic_vector(width_p + par_width_f(width_p) - 1 downto 0);
      data_o : out std_logic_vector(width_p - 1 downto 0)
    );
  end component;

end package;

package body hamming_pkg is

  function par_width_f (width_p : in positive) return positive is
  begin
    for i in 0 to par_set_c'length(1) - 1 loop
      if width_p <= par_set_c(i, 0) then
        return i;
      end if;
    end loop;
    return par_set_c'length(1);
  end function;

  function par_subset_f (width_p : in positive; pos_p : in natural) return positive is
  begin
    for i in 0 to par_set_c'length(2) - 1 loop
      if par_set_c(pos_p, i) >= width_p or par_set_c(pos_p, i) =- 1 then
        return i;
      end if;
    end loop;
    return par_set_c'length(2);
  end function;

  function par_data_f (data_p : in std_logic_vector) return std_logic_vector is
    constant par_width_c        : integer                                    := par_width_f(data_p'length);
    variable par_data_v         : std_logic_vector(par_width_c - 1 downto 0) := (others => '0');
  begin
    for i in 0 to par_width_c loop
      for j in 0 to par_subset_f(data_p'length, i) loop
        if par_set_c(i, j) < data_p'length and par_set_c(i, j) /= - 1 then
          par_data_v(i) := par_data_v(i) xor data_p(par_set_c(i, j));
        end if;
      end loop;
    end loop;
    return par_data_v;
  end function;

end hamming_pkg;