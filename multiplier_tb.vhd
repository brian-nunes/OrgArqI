library ieee;
use ieee.std_logic_1164.all;

entity multiplier_tb is
end multiplier_tb;

architecture tb of multiplier_tb is

    component multiplier
        port (sign1    : in std_logic;
              sign2    : in std_logic;
              exp1     : in std_logic_vector (3 downto 0);
              exp2     : in std_logic_vector (3 downto 0);
              frac1    : in std_logic_vector (7 downto 0);
              frac2    : in std_logic_vector (7 downto 0);
              sign_out : out std_logic;
              exp_out  : out std_logic_vector (3 downto 0);
              frac_out : out std_logic_vector (7 downto 0));
    end component;

    signal sign1    : std_logic;
    signal sign2    : std_logic;
    signal exp1     : std_logic_vector (3 downto 0);
    signal exp2     : std_logic_vector (3 downto 0);
    signal frac1    : std_logic_vector (7 downto 0);
    signal frac2    : std_logic_vector (7 downto 0);
    signal sign_out : std_logic;
    signal exp_out  : std_logic_vector (3 downto 0);
    signal frac_out : std_logic_vector (7 downto 0);

begin

    dut : multiplier
    port map (sign1    => sign1,
              sign2    => sign2,
              exp1     => exp1,
              exp2     => exp2,
              frac1    => frac1,
              frac2    => frac2,
              sign_out => sign_out,
              exp_out  => exp_out,
              frac_out => frac_out);

    stimuli : process
    begin
        assert False report "Testes Iniciados" severity note;
        
        assert False report "Teste Inf*0" severity note;

        sign1 <= '0';
        sign2 <= '0';
        exp1 <= "1111";
        exp2 <= "0000";
        frac1 <= (others => '0');
        frac2 <= (others => '0');

        wait for 50 ns;

        assert exp_out="1111" report "Erro no expoente" severity error;
        assert frac_out="11111111" report "Erro na mantissa" severity error;
        assert sign_out='1' report "Erro no sinal" severity error;

        assert False report "Teste Inf*x" severity note;

        sign1 <= '0';
        sign2 <= '1';
        exp1 <= "1111";
        exp2 <= "0101";
        frac1 <= (others => '0');
        frac2 <= (others => '0');

        wait for 50 ns;

        assert exp_out="1111" report "Erro no expoente" severity error;
        assert frac_out="00000000" report "Erro na mantissa" severity error;
        assert sign_out='1' report "Erro no sinal" severity error;

        assert False report "Teste x*0" severity note;

        sign1 <= '0';
        sign2 <= '0';
        exp1 <= "1011";
        exp2 <= "0000";
        frac1 <= (others => '0');
        frac2 <= (others => '0');

        wait for 50 ns;

        assert exp_out="0000" report "Erro no expoente" severity error;
        assert frac_out="00000000" report "Erro na mantissa" severity error;
        assert sign_out='0' report "Erro no sinal" severity error;

        wait;
    end process;

end tb;