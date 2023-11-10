library ieee; 

use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

-- The following state machine was produced for a class project in Digital Logic Design at Kennesaw State University under the supervision of Dr. Lance Crimm. 
-- This state machine has seven states that are determined by the current output state and the current inputs. The primary factors that cause state changes are the number of cars present at each "intersection" (given by a logic level low or high) and the time spent at each intersection (given by the counter bits A through D). The comments after each conditional statement describe the scenario the statement describes and the states are separated by commenting (i.e.,  -- 120 Green (Default) ---- ).

entity Main is 
	port (
		CLK:		in		std_logic;			-- clock input
		M:		in		std_logic; 			-- Miller car counter over necessary car count
		H:		in		std_logic;			-- Highway 120 car counter over necessary car count
		D:		in		std_logic;			-- main counter bit D
		C:		in		std_logic;			-- main counter bit C
		B:		in		std_logic; 			-- main counter bit B
		A:		in		std_logic; 			-- main counter bit A
		Q:		buffer	std_logic_vector (7 downto 0)); 	-- output vector for light conditions
end Main; 

architecture Traffic of Main is
begin 
	process(CLK, M, H, D, C, B, A)
	begin 
		if CLK = '1' and CLK' event then
			case Q is 
			-- 120 Green (Default) -----------------------------------------------------------------------------------------------
			when "00100001" => if M = '0' then Q <= "00100001";
				-- (miller cars < 4)
				elsif ((M = '1') or (H = '1')) and (((D and C) or (D and B)) = '1') then Q <= "01000001"; -- 120 yellow
				-- (miller cars >= 4) and (time > 10)
				end if;  
			
			-- 120 Yellow -----------------------------------------------------------------------------------------------
			when "01000001" => if ((not B and not C) and not D) = '1' then Q <= "01000001"; 
				-- (time < 2)
				elsif ((B or C) or D) = '1' then Q <= "10000001"; -- safety state
				-- (time >= 2)
				end if; 
				
			-- Safety State -----------------------------------------------------------------------------------------------
			when "10000001" => if ((not B and not C) and not D) = '1' then Q <= "10000001"; 
				-- (time < 2)
				elsif (H = '0') and (((B or C) or D) = '1') and (M = '0') then Q <= "00100001"; -- 120 green
				-- (highway cars < 2) and (time >= 2)
				elsif (H = '1') and (((B or C) or D) = '1') then Q <= "10001001"; -- 120 turn green
				-- (highway cars >= 2) and (time >= 2)
				elsif (M = '1') and ((B or C) or D) = '1' and (H = '0') then Q <= "10000100"; -- miller green
				-- (miller cars >= 4) and (time >= 2) and (highway cars < 2)
				end if; 

			-- 120 Turn Green -----------------------------------------------------------------------------------------------
			when "10001001" => if ((not D or (not C and not B)) = '1') or (H = '1') then Q <= "10001001"; 
				-- (time < 10) or (highway cars >= 2)
				elsif (((D and B) or (D and C)) = '1') or (H = '0') then Q <= "10010001";  -- 120 turn yellow
				-- (time >= 10) or (highway cars < 2)
				end if; 

			-- 120 Turn Yellow -----------------------------------------------------------------------------------------------
			when "10010001" => if ((not B and not C) and not D) = '1' then Q <= "10010001"; 
				-- (time < 2)
				elsif ((B or C) or D) = '1' then Q <= "10000001"; -- safety state
				-- (time >= 2)
				end if; 
				
			-- Miller Green -----------------------------------------------------------------------------------------------
			when "10000100" => if ((not D or (not C and not B)) = '1') or ((M = '1') and (((D and not C) and (B and not A)) = '1')) or (( ((D and C) and not B) or ((D and C) and not A) or ((D and not C) and (B and A))) = '1') then Q <= "10000100"; 
				-- (time < 10) or (miller cars >= 4)and(time = 10) or (10 < time < 15)
				elsif ((((D and not C) and (B and not A)) = '1') and (M = '0')) or (((A and B) and (C and D)) = '1') then Q <= "10000010"; -- miller yellow
				-- (time >= 10) and (miller cars < 4) or (time = 15)
				end if; 

			-- Miller Yellow -----------------------------------------------------------------------------------------------
			when "10000010" => if ((not B and not C) and not D) = '1' then Q <= "10000010"; 
				-- (time < 2)
				elsif ((B or C) or D) = '1' then Q <= "10000001"; -- safety state
				-- (time >=2)
				end if; 
			-- protection -----------------------------------------------------------------------------------------------
			when others => Q <= "11111111";      -- this is simply for protection

			end case; 
		end if;
	end process; 
end architecture Traffic; 

