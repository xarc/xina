library ieee;
use ieee.std_logic_1164.all;

entity switch is
  generic (
    -- data width
    data_width_p : positive := 32
  );
  port (
    -- sel
    sel_i : in std_logic_vector(3 downto 0);
    -- switch
    data3_i : in std_logic_vector(data_width_p - 1 downto 0);
    data2_i : in std_logic_vector(data_width_p - 1 downto 0);
    data1_i : in std_logic_vector(data_width_p - 1 downto 0);
    data0_i : in std_logic_vector(data_width_p - 1 downto 0);
    data_o  : out std_logic_vector(data_width_p - 1 downto 0)
  );
end switch;

architecture rtl of switch is

begin

  data_o <= (data3_i and (data_width_p - 1 downto 0 => sel_i(3))) or
    (data2_i and (data_width_p - 1 downto 0           => sel_i(2))) or
    (data1_i and (data_width_p - 1 downto 0           => sel_i(1))) or
    (data0_i and (data_width_p - 1 downto 0           => sel_i(0)));

end rtl;