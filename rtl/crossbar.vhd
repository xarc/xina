library ieee;
use ieee.std_logic_1164.all;

entity crossbar is
  port (
    -- local channel requests
    l_req_n_i : in std_logic;
    l_req_e_i : in std_logic;
    l_req_s_i : in std_logic;
    l_req_w_i : in std_logic;
    l_req_n_o : out std_logic;
    l_req_e_o : out std_logic;
    l_req_s_o : out std_logic;
    l_req_w_o : out std_logic;
    -- north channel requests
    n_req_l_i : in std_logic;
    n_req_e_i : in std_logic;
    n_req_s_i : in std_logic;
    n_req_w_i : in std_logic;
    n_req_l_o : out std_logic;
    n_req_e_o : out std_logic;
    n_req_s_o : out std_logic;
    n_req_w_o : out std_logic;
    -- east channel requests
    e_req_l_i : in std_logic;
    e_req_n_i : in std_logic;
    e_req_s_i : in std_logic;
    e_req_w_i : in std_logic;
    e_req_l_o : out std_logic;
    e_req_n_o : out std_logic;
    e_req_s_o : out std_logic;
    e_req_w_o : out std_logic;
    -- south channel requests
    s_req_l_i : in std_logic;
    s_req_n_i : in std_logic;
    s_req_e_i : in std_logic;
    s_req_w_i : in std_logic;
    s_req_l_o : out std_logic;
    s_req_n_o : out std_logic;
    s_req_e_o : out std_logic;
    s_req_w_o : out std_logic;
    -- west channel requests
    w_req_l_i : in std_logic;
    w_req_n_i : in std_logic;
    w_req_e_i : in std_logic;
    w_req_s_i : in std_logic;
    w_req_l_o : out std_logic;
    w_req_n_o : out std_logic;
    w_req_e_o : out std_logic;
    w_req_s_o : out std_logic;
    -- local channel grants
    l_gnt_n_i : in std_logic;
    l_gnt_e_i : in std_logic;
    l_gnt_s_i : in std_logic;
    l_gnt_w_i : in std_logic;
    l_gnt_n_o : out std_logic;
    l_gnt_e_o : out std_logic;
    l_gnt_s_o : out std_logic;
    l_gnt_w_o : out std_logic;
    -- north channel grants
    n_gnt_l_i : in std_logic;
    n_gnt_e_i : in std_logic;
    n_gnt_s_i : in std_logic;
    n_gnt_w_i : in std_logic;
    n_gnt_l_o : out std_logic;
    n_gnt_e_o : out std_logic;
    n_gnt_s_o : out std_logic;
    n_gnt_w_o : out std_logic;
    -- east channel grants
    e_gnt_l_i : in std_logic;
    e_gnt_n_i : in std_logic;
    e_gnt_s_i : in std_logic;
    e_gnt_w_i : in std_logic;
    e_gnt_l_o : out std_logic;
    e_gnt_n_o : out std_logic;
    e_gnt_s_o : out std_logic;
    e_gnt_w_o : out std_logic;
    -- south channel grants
    s_gnt_l_i : in std_logic;
    s_gnt_n_i : in std_logic;
    s_gnt_e_i : in std_logic;
    s_gnt_w_i : in std_logic;
    s_gnt_l_o : out std_logic;
    s_gnt_n_o : out std_logic;
    s_gnt_e_o : out std_logic;
    s_gnt_w_o : out std_logic;
    -- west channel grants
    w_gnt_l_i : in std_logic;
    w_gnt_n_i : in std_logic;
    w_gnt_e_i : in std_logic;
    w_gnt_s_i : in std_logic;
    w_gnt_l_o : out std_logic;
    w_gnt_n_o : out std_logic;
    w_gnt_e_o : out std_logic;
    w_gnt_s_o : out std_logic
  );
end crossbar;

architecture rtl of crossbar is

begin

  -- reqs
  l_req_n_o <= l_req_n_i;
  l_req_e_o <= l_req_e_i;
  l_req_s_o <= l_req_s_i;
  l_req_w_o <= l_req_w_i;
  n_req_l_o <= n_req_l_i;
  n_req_e_o <= '0';
  n_req_s_o <= n_req_s_i;
  n_req_w_o <= '0';
  e_req_l_o <= e_req_l_i;
  e_req_n_o <= e_req_n_i;
  e_req_s_o <= e_req_s_i;
  e_req_w_o <= e_req_w_i;
  s_req_l_o <= s_req_l_i;
  s_req_n_o <= s_req_n_i;
  s_req_e_o <= '0';
  s_req_w_o <= '0';
  w_req_l_o <= w_req_l_i;
  w_req_n_o <= w_req_n_i;
  w_req_e_o <= w_req_e_i;
  w_req_s_o <= w_req_s_i;
  -- grants
  l_gnt_n_o <= l_gnt_n_i;
  l_gnt_e_o <= l_gnt_e_i;
  l_gnt_s_o <= l_gnt_s_i;
  l_gnt_w_o <= l_gnt_w_i;
  n_gnt_l_o <= n_gnt_l_i;
  n_gnt_e_o <= n_gnt_e_i;
  n_gnt_s_o <= n_gnt_s_i;
  n_gnt_w_o <= n_gnt_w_i;
  e_gnt_l_o <= e_gnt_l_i;
  e_gnt_n_o <= '0';
  e_gnt_s_o <= '0';
  e_gnt_w_o <= e_gnt_w_i;
  s_gnt_l_o <= s_gnt_l_i;
  s_gnt_n_o <= s_gnt_n_i;
  s_gnt_e_o <= s_gnt_e_i;
  s_gnt_w_o <= s_gnt_w_i;
  w_gnt_l_o <= w_gnt_l_i;
  w_gnt_n_o <= '0';
  w_gnt_e_o <= w_gnt_e_i;
  w_gnt_s_o <= '0';

end rtl;