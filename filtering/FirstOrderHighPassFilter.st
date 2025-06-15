(*----------------------------------------------------------------------------------
-- Function Block: FirstOrderHighPassFilter
-- Author: Simon Marceau 
-- Creation Date: 15-06-2025
-- Purpose: 
--      This function block implements a first-order high-pass filter designed
--      to highlight rapid changes and remove slow-moving or constant
--      components from an input signal.
--
-- Dependencies: None
-- 
-- All rights reserved (c) 2025 Simon Marceau.
-----------------------------------------------------------------------------------*)
FUNCTION_BLOCK FirstOrderHighPassFilter
VAR_INPUT
    signal: REAL;                   (* Input signal to be filtered *)
    alpha: REAL;                    (* Smoothing factor for the filter, typically between 0.01 and 1.0 *)
END_VAR
VAR_OUTPUT
    filteredSignal: REAL;           (* The resulting filtered output signal  *)
END_VAR
VAR   
    clippedAlpha: REAL;             (* Variable storing 'alpha' after it's clamped to valid range [0.01, 1.0] *)
    prevFilteredSignal: REAL;       (* Stores the filtered signal value from the previous cycle *)
    prevInputSignal: REAL;          (* Stores the raw input signal value from the previous cucle *)
    firstCycleFlag: BOOL := TRUE;   (* Flag indicating the first execution cycle for proper filter initialization *)
END_VAR

(* Clamps the given alpha value within the valid range of [0.01, 1.0] to ensure filter stability and proper characteristics *)
clippedAlpha := MAX(REAL#0.01, MIN(alpha, REAL#1.0));

(* Initializes the filter's state on the very first execution cycle *)
IF firstCycleFlag THEN 
    prevInputSignal := signal;
    firstCycleFlag := FALSE;
END_IF;

(* Applies the standard first-order high-pass filter equation *)
filteredSignal := clippedAlpha * ((prevFilteredSignal + signal) - prevInputSignal);

(* Updates the previous raw and filtered signal for the next calculation cycle *)
prevInputSignal := signal;
prevFilteredSignal := filteredSignal;

END_FUNCTION_BLOCK
