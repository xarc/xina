library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

use work.hamming_pkg.all;

entity hamming_dec is
  generic (
    width_p : positive := 8
  );
  port (
    data_i : in std_logic_vector(width_p + par_width_f(width_p) - 1 downto 0);
    data_o : out std_logic_vector(width_p - 1 downto 0)
  );
end entity;

architecture rtl of hamming_dec is

  constant par_width_c : integer := par_width_f(width_p);
  signal par_data_w    : std_logic_vector(par_width_c - 1 downto 0);
  signal par_diff_w    : std_logic_vector(par_width_c - 1 downto 0);
  signal par_err_w     : std_logic_vector(width_p - 1 downto 0);

begin

  dec : for i in par_width_c - 1 downto 0 generate
    constant subset_c : integer := par_subset_f(width_p, i);
    signal par_part_w : std_logic_vector(subset_c - 1 downto 0);
  begin
    par : for j in par_part_w'range generate
      par_part_w(j) <= data_i(par_set_c(i, j));
    end generate;
    par_data_w(i) <= xor_reduce(par_part_w);
  end generate;

  par_diff_w <= par_data_w xor data_i(width_p + par_width_c - 1 downto width_p);

  err : for i in par_err_w'range generate
    par_err_w(i) <= nor_reduce(par_err_c(i)(par_width_c - 1 downto 0) xor par_diff_w);
  end generate;

  data_o <= data_i(width_p - 1 downto 0) xor par_err_w;

end architecture;