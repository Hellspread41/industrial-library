(*----------------------------------------------------------------------------------
-- Function: Clamp
-- Author: Simon Marceau
-- Creation Date: 15-06-2025
-- Purpose:
--      Clamps an input value within a specified minimum and maximum range.
--      This function can also be enabled/disabled via the 'clampEnable' input.
--      When disabled, the signal passes through unaffected.
--
-- Dependencies: None
--
-- All rights reserved (c) 2025 Simon Marceau.
-----------------------------------------------------------------------------------*)
FUNCTION Clamp : REAL
VAR_INPUT
    signal: REAL;           (* The input signal to be clamped *)
    clampEnable: BOOL;      (* Allows to bypass the clamp process if FALSE *)
    clampHighLevel: REAL;   (* The upper bound of the clamping range *)
    clampLowLevel: REAL;    (* The lower bound of the clamping range *)
END_VAR

IF NOT clampEnable THEN 
    Clamp := signal;
    RETURN;
END_IF;

(* Clamp the input signal value between the given clampLowLevel and clampHighLevel *)
Clamp := MAX(clampLowLevel, MIN(signal, clampHighLevel));
    
END_FUNCTION
