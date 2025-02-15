LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY tlc IS
PORT(
    clk : IN std_logic;
    request : IN std_logic;
    reset : IN std_logic;
    output : OUT std_logic_vector(4 DOWNTO 0);
	HEX1, HEX0 : OUT std_logic_vector(0 to 6));
END tlc;

ARCHITECTURE tlc_arch OF tlc IS
    -- Declare signals
    -- Build an enumerated type for the state machine.
    TYPE state_type IS (G, Y, R, W);
    -- Register to hold the current state
    SIGNAL state : state_type;
	 -- Register to hold the current number
	SIGNAL display_time : std_logic_vector(7 DOWNTO 0);
    -- Declare components
	COMPONENT bcd7seg
		PORT (
            BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            HEX : OUT STD_LOGIC_VECTOR(0 TO 6));
    END COMPONENT;
	 
BEGIN
    -- Logic to advance to the next state
    PROCESS (clk, reset)
        VARIABLE count : INTEGER;
    BEGIN
        IF reset = '0' THEN
            state <= G;
			display_time <= "11111111";
				
        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN G =>
                    IF	request = '0' THEN
                        state <= Y;
                        count := 250000000;
                    END IF;
                WHEN Y =>
                    -- Define time constants
                    -- (50MHz clk means 50000000 cycles/s)
                    IF count = 0 THEN
                        state <= R;
                        count := 500000000;
                    ELSE
                        count := count - 1;
                    END IF;
                WHEN R =>
                    IF count = 0 THEN
                        state <= W;
                        count := 500000000; -- Look to change this to not reset count
                    ELSE
                        count := count - 1;
                    END IF;
                WHEN W =>
                    IF count = 0 THEN
                        state <= G;
                    ELSE
                        count := count - 1;
                    END IF;
				END CASE;
        END IF;
			CASE count IS
				WHEN 0 => 
					display_time <= "11111111"; --No number (no point in displaying 00)
				WHEN 50000000 => 
					display_time <= "00000001";
				WHEN 100000000 => 
					display_time <= "00000010";
				WHEN 150000000 => 
					display_time <= "00000011";
				WHEN 200000000 => 
					display_time <= "00000100";
				WHEN 250000000 => 
					display_time <= "00000101";
				WHEN 300000000 => 
					display_time <= "00000110";
				WHEN 350000000 => 
					display_time <= "00000111";
				WHEN 400000000 => 
					display_time <= "00001000";
				WHEN 450000000 => 
					display_time <= "00001001";
				WHEN 500000000 => 
                    display_time <= "00010000";
				WHEN OTHERS => NULL;
			END CASE;
    END PROCESS;
	 -- Component instantiation must be inside BEGIN of architecture : Instantiate BCD to 7-segment decoder
    digit1: bcd7seg PORT MAP(display_time(7 DOWNTO 4), HEX1);
    digit0: bcd7seg PORT MAP(display_time(3 DOWNTO 0), HEX0);
    -- Output depends solely on the current state
    PROCESS (state)
    BEGIN
        CASE state IS
            WHEN G =>
                output <= "10001";
            WHEN Y =>
                output <= "10010";
            WHEN R =>
                output <= "01100";
				WHEN W =>
                output <= "10001"; 
        END CASE;
    END PROCESS;
END tlc_arch;

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY bcd7seg IS
	PORT (
		BCD : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		HEX : OUT STD_LOGIC_VECTOR(0 TO 6));
END bcd7seg;

ARCHITECTURE behavior OF bcd7seg IS
BEGIN
    PROCESS (BCD)
    BEGIN
        HEX <=  "0000001" WHEN (BCD = "0000") ELSE    -- 0
                "1001111" WHEN (BCD = "0001") ELSE    -- 1
                "0010010" WHEN (BCD = "0010") ELSE    -- 2
                "0000110" WHEN (BCD = "0011") ELSE    -- 3
                "1001100" WHEN (BCD = "0100") ELSE    -- 4
                "0100100" WHEN (BCD = "0101") ELSE    -- 5
                "1100000" WHEN (BCD = "0110") ELSE    -- 6
                "0001111" WHEN (BCD = "0111") ELSE    -- 7
                "0000000" WHEN (BCD = "1000") ELSE    -- 8
                "0001100" WHEN (BCD = "1001") ELSE    -- 9
                "1111111";  -- Blank
    END PROCESS;
END behavior;
