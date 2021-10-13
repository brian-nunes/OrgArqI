library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY multiplier IS
	PORT (
		sign1, sign2 : IN STD_LOGIC;
		exp1, exp2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		frac1, frac2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		sign_out : OUT STD_LOGIC;
		exp_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		frac_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END multiplier;

ARCHITECTURE multiplier_arch OF multiplier IS

BEGIN
	PROCESS (sign1, sign2, exp1, exp2, frac1, frac2)
		VARIABLE x_frac : STD_LOGIC_VECTOR (7 DOWNTO 0);
		VARIABLE x_exp : STD_LOGIC_VECTOR (3 DOWNTO 0);
		VARIABLE x_sign : STD_LOGIC;
		VARIABLE y_frac : STD_LOGIC_VECTOR (7 DOWNTO 0);
		VARIABLE y_exp : STD_LOGIC_VECTOR (3 DOWNTO 0);
		VARIABLE y_sign : STD_LOGIC;
		VARIABLE result_frac : STD_LOGIC_VECTOR (7 DOWNTO 0);
		VARIABLE result_exp : STD_LOGIC_VECTOR (3 DOWNTO 0);
		VARIABLE result_sign : STD_LOGIC;
		VARIABLE aux : STD_LOGIC;
		VARIABLE aux2 : STD_LOGIC_VECTOR (17 DOWNTO 0);
		VARIABLE exp_sum : STD_LOGIC_VECTOR (4 DOWNTO 0);
	BEGIN
		x_frac := frac1;
		x_exp := exp1;
		x_sign := sign1;
		y_frac := frac2;
		y_exp := exp2;
		y_sign := sign2;
		IF ((x_exp = "1111" AND y_exp = "0000") OR (x_exp = "0000" AND y_exp = "1111")) THEN
			-- Infinito * 0 resulta em NaN
			result_exp := "1111";
			result_frac := "11111111";
			result_sign := '1';
		ELSIF (x_exp = "1111" OR y_exp = "1111") THEN
			-- inf*x ou x*inf
			result_exp := "1111";
			result_frac := (OTHERS => '0');
			result_sign := x_sign XOR y_sign;

		ELSIF (x_exp = "0000" OR y_exp = "0000") THEN
			-- 0*x ou x*0
			result_exp := (OTHERS => '0');
			result_frac := (OTHERS => '0');
			result_sign := '0';

		ELSE

			aux2 := ('1' & x_frac) * ('1' & y_frac);
			-- argumentos em Q8 resultado em Q16
			IF (aux2(17) = '1') THEN
				-- >=2, shift left e soma um no expoente
				result_frac := aux2(16 DOWNTO 9) + aux2(8); -- com arredondamento
				aux := '1';
			ELSE
				result_frac := aux2(15 DOWNTO 8) + aux2(7); -- com arredondamento
				aux := '0';
			END IF;

			exp_sum := ('0' & x_exp) + ('0' & y_exp) + aux - "0111";

			IF (exp_sum(4) = '1') THEN
				IF (exp_sum(3) = '0') THEN -- overflow
					result_exp := "1111";
					result_frac := (OTHERS => '0');
					result_sign := x_sign XOR y_sign;
				ELSE -- underflow
					result_exp := (OTHERS => '0');
					result_frac := (OTHERS => '0');
					result_sign := '0';
				END IF;
			ELSE -- Ok
				result_exp := exp_sum(3 DOWNTO 0);
				result_sign := x_sign XOR y_sign;
			END IF;
		END IF;
		frac_out <= result_frac;
		exp_out <= result_exp;
		sign_out <= result_sign;

	END PROCESS;
END multiplier_arch;