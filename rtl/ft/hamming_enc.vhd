library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

use work.hamming_pkg.all;

entity hamming_enc is
  generic (
    width_p : positive := 8
  );
  port (
    data_i : in std_logic_vector(width_p - 1 downto 0);
    data_o : out std_logic_vector(width_p + par_width_f(width_p) - 1 downto 0)
  );
end entity;

architecture rtl of hamming_enc is

  constant par_width_c : integer := par_width_f(width_p);
  signal par_data_w    : std_logic_vector(par_width_c - 1 downto 0);

begin

  enc : for i in par_width_c - 1 downto 0 generate
    constant subset_c : integer := par_subset_f(width_p, i);
    signal par_part_w : std_logic_vector(subset_c - 1 downto 0);
  begin
    par : for j in par_part_w'range generate
      par_part_w(j) <= data_i(par_set_c(i, j));
    end generate;
    par_data_w(i) <= xor_reduce(par_part_w);
  end generate;

  data_o <= par_data_w & data_i;

end architecture;