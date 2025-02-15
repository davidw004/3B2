LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL; 

ENTITY counter IS
    GENERIC ( n : NATURAL := 4; k : INTEGER := 15 );
    PORT ( clock, reset: IN  STD_LOGIC;
           enable, load: IN  STD_LOGIC;
           start_time  : IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           count       : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           rollover    : OUT STD_LOGIC );
END ENTITY;

ARCHITECTURE behaviour OF counter IS
    SIGNAL count_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF (reset = '0') THEN
            count_s <= (OTHERS => '0'); -- OTHERS => '0' sets all bits to zero
        ELSIF ((clock'event) AND (clock = '1')) THEN
            -- synchronous load: more compatible with most CPLD/FPGAs
            IF (load = '1') THEN 
                count_s <= start_time;
            ELSIF (enable = '1') THEN
                IF (count_s = 0) THEN -- modulo-k down counter
                    count_s <= conv_std_logic_vector(k-1, n);
                ELSE
                    count_s <= count_s - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    count <= count_s; -- mirror output
    rollover <= '1' WHEN (count_s = 0) ELSE '0';
END behaviour;