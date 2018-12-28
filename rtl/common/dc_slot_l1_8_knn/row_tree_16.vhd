-- Copyright (c) 2015-2018 in2H2 inc.
-- System developed for in2H2 inc. by Intermotion Technology, Inc.
--
-- Full system RTL, C sources and board design files available at https://github.com/nearist
--
-- in2H2 inc. Team Members:
-- - Chris McCormick - Algorithm Research and Design
-- - Matt McCormick - Board Production, System Q/A
--
-- Intermotion Technology Inc. Team Members:
-- - Mick Fandrich - Project Lead
-- - Dr. Ludovico Minati - Board Architecture and Design, FPGA Technology Advisor
-- - Vardan Movsisyan - RTL Team Lead
-- - Khachatur Gyozalyan - RTL Design
-- - Tigran Papazyan - RTL Design
-- - Taron Harutyunyan - RTL Design
-- - Hayk Ghaltaghchyan - System Software
--
-- Tecno77 S.r.l. Team Members:
-- - Stefano Aldrigo, Board Layout Design
--
-- We dedicate this project to the memory of Bruce McCormick, an AI pioneer
-- and advocate, a good friend and father.
--
-- The system, device and methods implemented in this code are covered
-- by US patents #9,747,547 and #9,269,041. Unlimited license for use
-- of this code under the terms of the GPL license is hereby granted.
--
-- These materials are provided free of charge: you can redistribute them and/or modify
-- them under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3.
--
-- These materials are distributed in the hope that they will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <http://www.gnu.org/licenses/>.

------------------------------------------------
-- Sorts 16 results received from dc engines, --
-- sends to row best results module           --
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dc_slot_def.all;

entity row_tree_16 is
port (
  clk          : in  std_logic;
  reset_n      : in  std_logic;
  tree_reset_i : in  std_logic;

  m_rd_i       : in  std_logic;
  m_valid_o    : out std_logic;
  m_data_o     : out std_logic_vector((DISTANCE_SIZE - 1 + 4) downto 0);

  rd_00_o      : out std_logic;
  rd_01_o      : out std_logic;
  rd_02_o      : out std_logic;
  rd_03_o      : out std_logic;
  rd_04_o      : out std_logic;
  rd_05_o      : out std_logic;
  rd_06_o      : out std_logic;
  rd_07_o      : out std_logic;
  rd_08_o      : out std_logic;
  rd_09_o      : out std_logic;
  rd_10_o      : out std_logic;
  rd_11_o      : out std_logic;
  rd_12_o      : out std_logic;
  rd_13_o      : out std_logic;
  rd_14_o      : out std_logic;
  rd_15_o      : out std_logic;

  valid_00_i   : in  std_logic;
  valid_01_i   : in  std_logic;
  valid_02_i   : in  std_logic;
  valid_03_i   : in  std_logic;
  valid_04_i   : in  std_logic;
  valid_05_i   : in  std_logic;
  valid_06_i   : in  std_logic;
  valid_07_i   : in  std_logic;
  valid_08_i   : in  std_logic;
  valid_09_i   : in  std_logic;
  valid_10_i   : in  std_logic;
  valid_11_i   : in  std_logic;
  valid_12_i   : in  std_logic;
  valid_13_i   : in  std_logic;
  valid_14_i   : in  std_logic;
  valid_15_i   : in  std_logic;

  data_00_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_01_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_02_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_03_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_04_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_05_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_06_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_07_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_08_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_09_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_10_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_11_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_12_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_13_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_14_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  data_15_i    : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0)
);
end row_tree_16;

architecture rtl of row_tree_16 is

  component row_node_l0
  port (

    clk          : in  std_logic;
    reset_n      : in  std_logic;
    tree_reset_i : in  std_logic;
    -- Port M signals
    m_rd_i       : in  std_logic;
    m_valid_o    : out std_logic;
    m_data_o     : out std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
    -- Port A signals
    a_rd_o       : out std_logic;
    a_valid_i    : in  std_logic;
    a_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0);
    -- Port B signals
    b_rd_o       : out std_logic;
    b_valid_i    : in  std_logic;
    b_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1) downto 0)
  );
  end component;

  component row_node_l1
  port (

    clk          : in  std_logic;
    reset_n      : in  std_logic;
    tree_reset_i : in  std_logic;
    -- Port M signals
    m_rd_i       : in  std_logic;
    m_valid_o    : out std_logic;
    m_data_o     : out std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0);
    -- Port A signals
    a_rd_o       : out std_logic;
    a_valid_i    : in  std_logic;
    a_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
    -- Port B signals
    b_rd_o       : out std_logic;
    b_valid_i    : in  std_logic;
    b_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0)
  );
  end component;

  component row_node_l2
  port (

    clk          : in  std_logic;
    reset_n      : in  std_logic;
    tree_reset_i : in  std_logic;
    -- Port M signals
    m_rd_i       : in  std_logic;
    m_valid_o    : out std_logic;
    m_data_o     : out std_logic_vector((DISTANCE_SIZE - 1 + 3) downto 0);
    -- Port A signals
    a_rd_o       : out std_logic;
    a_valid_i    : in  std_logic;
    a_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0);
    -- Port B signals
    b_rd_o       : out std_logic;
    b_valid_i    : in  std_logic;
    b_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0)
  );
  end component;

  component row_node_l3
  port (

    clk          : in  std_logic;
    reset_n      : in  std_logic;
    tree_reset_i : in  std_logic;
    -- Port M signals
    m_rd_i       : in  std_logic;
    m_valid_o    : out std_logic;
    m_data_o     : out std_logic_vector((DISTANCE_SIZE - 1 + 4) downto 0);
    -- Port A signals
    a_rd_o       : out std_logic;
    a_valid_i    : in  std_logic;
    a_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1 + 3) downto 0);
    -- Port B signals
    b_rd_o       : out std_logic;
    b_valid_i    : in  std_logic;
    b_data_i     : in  std_logic_vector((DISTANCE_SIZE - 1 + 3) downto 0)
  );
  end component;

  signal tree_reset   : std_logic;

  signal a_rd_0_00    : std_logic;
  signal a_rd_0_01    : std_logic;
  signal a_rd_0_02    : std_logic;
  signal a_rd_0_03    : std_logic;
  signal a_rd_0_04    : std_logic;
  signal a_rd_0_05    : std_logic;
  signal a_rd_0_06    : std_logic;
  signal a_rd_0_07    : std_logic;
  signal a_valid_0_00 : std_logic;
  signal a_valid_0_01 : std_logic;
  signal a_valid_0_02 : std_logic;
  signal a_valid_0_03 : std_logic;
  signal a_valid_0_04 : std_logic;
  signal a_valid_0_05 : std_logic;
  signal a_valid_0_06 : std_logic;
  signal a_valid_0_07 : std_logic;
  signal a_data_0_00  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_01  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_02  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_03  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_04  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_05  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_06  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal a_data_0_07  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);

  signal b_rd_0_00    : std_logic;
  signal b_rd_0_01    : std_logic;
  signal b_rd_0_02    : std_logic;
  signal b_rd_0_03    : std_logic;
  signal b_rd_0_04    : std_logic;
  signal b_rd_0_05    : std_logic;
  signal b_rd_0_06    : std_logic;
  signal b_rd_0_07    : std_logic;
  signal b_valid_0_00 : std_logic;
  signal b_valid_0_01 : std_logic;
  signal b_valid_0_02 : std_logic;
  signal b_valid_0_03 : std_logic;
  signal b_valid_0_04 : std_logic;
  signal b_valid_0_05 : std_logic;
  signal b_valid_0_06 : std_logic;
  signal b_valid_0_07 : std_logic;
  signal b_data_0_00  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_01  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_02  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_03  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_04  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_05  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_06  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);
  signal b_data_0_07  : std_logic_vector((DISTANCE_SIZE - 1) downto 0);

  signal a_rd_1_0     : std_logic;
  signal a_rd_1_1     : std_logic;
  signal a_rd_1_2     : std_logic;
  signal a_rd_1_3     : std_logic;
  signal a_valid_1_0  : std_logic;
  signal a_valid_1_1  : std_logic;
  signal a_valid_1_2  : std_logic;
  signal a_valid_1_3  : std_logic;
  signal a_data_1_0   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
  signal a_data_1_1   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
  signal a_data_1_2   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
  signal a_data_1_3   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);

  signal b_rd_1_0     : std_logic;
  signal b_rd_1_1     : std_logic;
  signal b_rd_1_2     : std_logic;
  signal b_rd_1_3     : std_logic;
  signal b_valid_1_0  : std_logic;
  signal b_valid_1_1  : std_logic;
  signal b_valid_1_2  : std_logic;
  signal b_valid_1_3  : std_logic;
  signal b_data_1_0   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
  signal b_data_1_1   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
  signal b_data_1_2   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);
  signal b_data_1_3   : std_logic_vector((DISTANCE_SIZE - 1 + 1) downto 0);

  signal a_rd_2_0     : std_logic;
  signal a_rd_2_1     : std_logic;
  signal a_valid_2_0  : std_logic;
  signal a_valid_2_1  : std_logic;
  signal a_data_2_0   : std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0);
  signal a_data_2_1   : std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0);

  signal b_rd_2_0     : std_logic;
  signal b_rd_2_1     : std_logic;
  signal b_valid_2_0  : std_logic;
  signal b_valid_2_1  : std_logic;
  signal b_data_2_0   : std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0);
  signal b_data_2_1   : std_logic_vector((DISTANCE_SIZE - 1 + 2) downto 0);

  signal a_rd_3_0     : std_logic;
  signal a_valid_3_0  : std_logic;
  signal a_data_3_0   : std_logic_vector((DISTANCE_SIZE - 1 + 3) downto 0);

  signal b_rd_3_0     : std_logic;
  signal b_valid_3_0  : std_logic;
  signal b_data_3_0   : std_logic_vector((DISTANCE_SIZE - 1 + 3) downto 0);

  signal a_rd_4_0     : std_logic;
  signal a_valid_4_0  : std_logic;
  signal a_data_4_0   : std_logic_vector((DISTANCE_SIZE - 1 + 4) downto 0);

begin

  tree_reset <= tree_reset_i;

  rd_00_o <= a_rd_0_00;
  rd_01_o <= b_rd_0_00;
  rd_02_o <= a_rd_0_01;
  rd_03_o <= b_rd_0_01;
  rd_04_o <= a_rd_0_02;
  rd_05_o <= b_rd_0_02;
  rd_06_o <= a_rd_0_03;
  rd_07_o <= b_rd_0_03;
  rd_08_o <= a_rd_0_04;
  rd_09_o <= b_rd_0_04;
  rd_10_o <= a_rd_0_05;
  rd_11_o <= b_rd_0_05;
  rd_12_o <= a_rd_0_06;
  rd_13_o <= b_rd_0_06;
  rd_14_o <= a_rd_0_07;
  rd_15_o <= b_rd_0_07;

  a_valid_0_00 <= valid_00_i;
  b_valid_0_00 <= valid_01_i;
  a_valid_0_01 <= valid_02_i;
  b_valid_0_01 <= valid_03_i;
  a_valid_0_02 <= valid_04_i;
  b_valid_0_02 <= valid_05_i;
  a_valid_0_03 <= valid_06_i;
  b_valid_0_03 <= valid_07_i;
  a_valid_0_04 <= valid_08_i;
  b_valid_0_04 <= valid_09_i;
  a_valid_0_05 <= valid_10_i;
  b_valid_0_05 <= valid_11_i;
  a_valid_0_06 <= valid_12_i;
  b_valid_0_06 <= valid_13_i;
  a_valid_0_07 <= valid_14_i;
  b_valid_0_07 <= valid_15_i;

  a_data_0_00 <= data_00_i;
  b_data_0_00 <= data_01_i;
  a_data_0_01 <= data_02_i;
  b_data_0_01 <= data_03_i;
  a_data_0_02 <= data_04_i;
  b_data_0_02 <= data_05_i;
  a_data_0_03 <= data_06_i;
  b_data_0_03 <= data_07_i;
  a_data_0_04 <= data_08_i;
  b_data_0_04 <= data_09_i;
  a_data_0_05 <= data_10_i;
  b_data_0_05 <= data_11_i;
  a_data_0_06 <= data_12_i;
  b_data_0_06 <= data_13_i;
  a_data_0_07 <= data_14_i;
  b_data_0_07 <= data_15_i;

  a_rd_4_0    <= m_rd_i;
  m_valid_o   <= a_valid_4_0;
  m_data_o    <= a_data_4_0;

  ----------Layer 0------------
  row_node_l0_0 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_1_0    ,
    m_valid_o    => a_valid_1_0 ,
    m_data_o     => a_data_1_0  ,
    a_rd_o       => a_rd_0_00   ,
    a_valid_i    => a_valid_0_00,
    a_data_i     => a_data_0_00 ,
    b_rd_o       => b_rd_0_00   ,
    b_valid_i    => b_valid_0_00,
    b_data_i     => b_data_0_00
  );

  row_node_l0_1 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_1_0    ,
    m_valid_o    => b_valid_1_0 ,
    m_data_o     => b_data_1_0  ,
    a_rd_o       => a_rd_0_01   ,
    a_valid_i    => a_valid_0_01,
    a_data_i     => a_data_0_01 ,
    b_rd_o       => b_rd_0_01   ,
    b_valid_i    => b_valid_0_01,
    b_data_i     => b_data_0_01
  );

  row_node_l0_2 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_1_1    ,
    m_valid_o    => a_valid_1_1 ,
    m_data_o     => a_data_1_1  ,
    a_rd_o       => a_rd_0_02   ,
    a_valid_i    => a_valid_0_02,
    a_data_i     => a_data_0_02 ,
    b_rd_o       => b_rd_0_02   ,
    b_valid_i    => b_valid_0_02,
    b_data_i     => b_data_0_02
  );

  row_node_l0_3 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_1_1    ,
    m_valid_o    => b_valid_1_1 ,
    m_data_o     => b_data_1_1  ,
    a_rd_o       => a_rd_0_03   ,
    a_valid_i    => a_valid_0_03,
    a_data_i     => a_data_0_03 ,
    b_rd_o       => b_rd_0_03   ,
    b_valid_i    => b_valid_0_03,
    b_data_i     => b_data_0_03
  );

  row_node_l0_4 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_1_2    ,
    m_valid_o    => a_valid_1_2 ,
    m_data_o     => a_data_1_2  ,
    a_rd_o       => a_rd_0_04   ,
    a_valid_i    => a_valid_0_04,
    a_data_i     => a_data_0_04 ,
    b_rd_o       => b_rd_0_04   ,
    b_valid_i    => b_valid_0_04,
    b_data_i     => b_data_0_04
  );

  row_node_l0_5 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_1_2    ,
    m_valid_o    => b_valid_1_2 ,
    m_data_o     => b_data_1_2  ,
    a_rd_o       => a_rd_0_05   ,
    a_valid_i    => a_valid_0_05,
    a_data_i     => a_data_0_05 ,
    b_rd_o       => b_rd_0_05   ,
    b_valid_i    => b_valid_0_05,
    b_data_i     => b_data_0_05
  );

  row_node_l0_6 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_1_3    ,
    m_valid_o    => a_valid_1_3 ,
    m_data_o     => a_data_1_3  ,
    a_rd_o       => a_rd_0_06   ,
    a_valid_i    => a_valid_0_06,
    a_data_i     => a_data_0_06 ,
    b_rd_o       => b_rd_0_06   ,
    b_valid_i    => b_valid_0_06,
    b_data_i     => b_data_0_06
  );

  row_node_l0_7 : row_node_l0
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_1_3    ,
    m_valid_o    => b_valid_1_3 ,
    m_data_o     => b_data_1_3  ,
    a_rd_o       => a_rd_0_07   ,
    a_valid_i    => a_valid_0_07,
    a_data_i     => a_data_0_07 ,
    b_rd_o       => b_rd_0_07   ,
    b_valid_i    => b_valid_0_07,
    b_data_i     => b_data_0_07
  );
  ----------Layer 1------------
  row_node_l1_0 : row_node_l1
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_2_0    ,
    m_valid_o    => a_valid_2_0 ,
    m_data_o     => a_data_2_0  ,
    a_rd_o       => a_rd_1_0    ,
    a_valid_i    => a_valid_1_0 ,
    a_data_i     => a_data_1_0  ,
    b_rd_o       => b_rd_1_0    ,
    b_valid_i    => b_valid_1_0 ,
    b_data_i     => b_data_1_0
  );

  row_node_l1_1 : row_node_l1
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_2_0    ,
    m_valid_o    => b_valid_2_0 ,
    m_data_o     => b_data_2_0  ,
    a_rd_o       => a_rd_1_1    ,
    a_valid_i    => a_valid_1_1 ,
    a_data_i     => a_data_1_1  ,
    b_rd_o       => b_rd_1_1    ,
    b_valid_i    => b_valid_1_1 ,
    b_data_i     => b_data_1_1
  );

  row_node_l1_2 : row_node_l1
  port map (
    clk          => clk         ,
    reset_n      => reset_n     ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_2_1    ,
    m_valid_o    => a_valid_2_1 ,
    m_data_o     => a_data_2_1  ,
    a_rd_o       => a_rd_1_2    ,
    a_valid_i    => a_valid_1_2 ,
    a_data_i     => a_data_1_2  ,
    b_rd_o       => b_rd_1_2    ,
    b_valid_i    => b_valid_1_2 ,
    b_data_i     => b_data_1_2
  );

  row_node_l1_3 : row_node_l1
  port map (
    clk          => clk        ,
    reset_n      => reset_n    ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_2_1   ,
    m_valid_o    => b_valid_2_1,
    m_data_o     => b_data_2_1 ,
    a_rd_o       => a_rd_1_3   ,
    a_valid_i    => a_valid_1_3,
    a_data_i     => a_data_1_3 ,
    b_rd_o       => b_rd_1_3   ,
    b_valid_i    => b_valid_1_3,
    b_data_i     => b_data_1_3
  );
  ----------Layer 2------------
  row_node_l2_0 : row_node_l2
  port map (
    clk          => clk        ,
    reset_n      => reset_n    ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_3_0   ,
    m_valid_o    => a_valid_3_0,
    m_data_o     => a_data_3_0 ,
    a_rd_o       => a_rd_2_0   ,
    a_valid_i    => a_valid_2_0,
    a_data_i     => a_data_2_0 ,
    b_rd_o       => b_rd_2_0   ,
    b_valid_i    => b_valid_2_0,
    b_data_i     => b_data_2_0
  );

  row_node_l2_1 : row_node_l2
  port map (
    clk          => clk        ,
    reset_n      => reset_n    ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => b_rd_3_0   ,
    m_valid_o    => b_valid_3_0,
    m_data_o     => b_data_3_0 ,
    a_rd_o       => a_rd_2_1   ,
    a_valid_i    => a_valid_2_1,
    a_data_i     => a_data_2_1 ,
    b_rd_o       => b_rd_2_1   ,
    b_valid_i    => b_valid_2_1,
    b_data_i     => b_data_2_1
  );
  ----------Layer 3------------
  row_node_l3_0 : row_node_l3
  port map (
    clk          => clk        ,
    reset_n      => reset_n    ,
    tree_reset_i => tree_reset  ,
    m_rd_i       => a_rd_4_0   ,
    m_valid_o    => a_valid_4_0,
    m_data_o     => a_data_4_0 ,
    a_rd_o       => a_rd_3_0   ,
    a_valid_i    => a_valid_3_0,
    a_data_i     => a_data_3_0 ,
    b_rd_o       => b_rd_3_0   ,
    b_valid_i    => b_valid_3_0,
    b_data_i     => b_data_3_0
  );

end rtl;

