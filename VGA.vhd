library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_triangle is
    port (
        clk    : in  std_logic;  -- 100 MHz 系統時鐘
        rst_n  : in  std_logic;  -- 低有效重設
        vga_hs : out std_logic;
        vga_vs : out std_logic;
        vga_r  : out std_logic_vector(2 downto 0);
        vga_g  : out std_logic_vector(2 downto 0);
        vga_b  : out std_logic_vector(2 downto 0)
    );
end entity;

architecture Behavioral of vga_triangle is

    -- VGA 時序參數 (640x480 @ 60Hz)
    constant H_VISIBLE  : integer := 640;
    constant H_FRONT    : integer := 16;
    constant H_SYNC     : integer := 96;
    constant H_BACK     : integer := 48;
    constant H_TOTAL    : integer := 800;

    constant V_VISIBLE  : integer := 480;
    constant V_FRONT    : integer := 10;
    constant V_SYNC     : integer := 2;
    constant V_BACK     : integer := 33;
    constant V_TOTAL    : integer := 525;

    -- 計數器
    signal h_cnt : integer range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : integer range 0 to V_TOTAL - 1 := 0;

    -- 分頻產生 25MHz 像素時脈使能 (100MHz/4)
    signal clk_div  : unsigned(1 downto 0) := (others => '0');
    signal pix_en   : std_logic := '0';

    -- 可見區域旗標
    signal visible  : std_logic;

begin

    -- 產生 pixel enable (每 4 個 clk)
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            clk_div <= (others => '0');
            pix_en <= '0';
        elsif rising_edge(clk) then
            clk_div <= clk_div + 1;
            if clk_div = "11" then
                pix_en <= '1';
                clk_div <= (others => '0');
            else
                pix_en <= '0';
            end if;
        end if;
    end process;

    -- 水平與垂直掃描計數器
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif rising_edge(clk) then
            if pix_en = '1' then
                if h_cnt = H_TOTAL - 1 then
                    h_cnt <= 0;
                    if v_cnt = V_TOTAL - 1 then
                        v_cnt <= 0;
                    else
                        v_cnt <= v_cnt + 1;
                    end if;
                else
                    h_cnt <= h_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- 產生同步訊號 (active low)
    vga_hs <= '0' when (h_cnt >= H_VISIBLE + H_FRONT and h_cnt < H_VISIBLE + H_FRONT + H_SYNC) else '1';
    vga_vs <= '0' when (v_cnt >= V_VISIBLE + V_FRONT and v_cnt < V_VISIBLE + V_FRONT + V_SYNC) else '1';

    -- 可視區域旗標
    visible <= '1' when (h_cnt < H_VISIBLE and v_cnt < V_VISIBLE) else '0';

    -- 畫面產生 (粉紅色三角形)
    process(h_cnt, v_cnt, visible)
        variable r, g, b : std_logic_vector(2 downto 0);
    begin
        r := (others => '0');
        g := (others => '0');
        b := (others => '0');
        
        if visible = '1' then
            -- 三角形區域 (中間置中)
            -- 三角形頂點：(320,100)，左底(220,380)，右底(420,380)
            if (v_cnt >= 100 and v_cnt <= 380) then
                -- 左右邊界用簡單線性方程式近似
                if (h_cnt >= (320 - (v_cnt - 100) / 2)) and (h_cnt <= (320 + (v_cnt - 100) / 2)) then
                    r := "111";  -- 紅強
                    g := "001";  -- 一點點綠
                    b := "011";  -- 一點點藍
                end if;
            end if;
        end if;

        vga_r <= r;
        vga_g <= g;
        vga_b <= b;
    end process;

end architecture;