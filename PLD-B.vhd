library ieee; 

use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

-- This combinational logic code was used to reset the main counter value at each change of state. The inputs were the car counts (given by M and H), the counter bits (given by A through D), and the state of each LED (given by R120 through MG). The programmed GAL22V10 IC only had one output, Reset, which was used to reset the main counter.

entity Reset is 
	port (
		M:		in		std_logic;
		H:		in		std_logic;
		
		D:		in		std_logic;
		C:		in		std_logic;
		B:		in		std_logic;
		A:		in		std_logic;
		
		R120:		in		std_logic;
		Y120:		in		std_logic;
		G120:		in		std_logic;
		Y120T:		in		std_logic;
		G120T:		in		std_logic;
		MR:		in		std_logic;
		MY:		in		std_logic;
		MG:		in		std_logic;
		
		Reset:		out		std_logic); 
end Reset; 

architecture Traffic of Reset is
begin
  Reset <= 
  (R120 and MR and not Y120T and not G120T and not D and not C and B and not A) or 				-- safety state reset
  ((G120 and (M or H)) and ((D and B) or (D and C))) or 							-- default to 120Y
  (Y120 and ((not D and not C) and (B and not A))) or 								-- 120 is yellow and time is 2
  (G120T and ((D and not C) and (B and not A))) or 								-- 120G turn to 120Y turn 
  (Y120T and ((not D and not C) and (B and not A))) or 								-- turn is yellow and time is 2
  ((MG and not M) and ((D and not C) and (B and not A))) or 							-- miller green : change state if miller green and no cars and time is 10
  (MG and ((A and B) and (C and D))) or 									-- miller is green and time is 15
  (MY and ((not D and not C) and (B and not A))); 								-- miller is yellow and time is 2
end Traffic;
