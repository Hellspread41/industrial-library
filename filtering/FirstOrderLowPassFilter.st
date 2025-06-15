(*----------------------------------------------------------------------------------
-- Function Block: FirstOrderLowPassFilter
-- Author: Simon Marceau 
-- Creation Date: 15-06-2025
-- Purpose: 
--      This function block implements a first-order low-pass filter to smooth
--      input signals. It attenuates higher-frequency components, allowing
--      lower-frequency signals to pass through. This effectively reduces noise
--      and provides a more stable and less volatile output, which is crucial
--      in applications like industrial control systems, sensor data processing,
--      and measurement systems where signal integrity is paramount.
--
-- Dependencies: None
-- 
-- All right reserved (c) 2025 Simon Marceau.
-----------------------------------------------------------------------------------*)
FUNCTION_BLOCK FirstOrderLowPassFilter 
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
    firstCycleFlag: BOOL := TRUE;   (* Flag indicating the first execution cycle for proper filter initialization *)
END_VAR

(* Clamps the given alpha value within the valid range of [0.01, 1.0] to ensure filter stability and proper characteristics *)
clippedAlpha := MAX(REAL#0.01, MIN(alpha, REAL#1.0));

(* Initializes the filter's state on the very first execution cycle *)
IF firstCycleFlag THEN 
    prevFilteredSignal := signal;
    firstCycleFlag := FALSE;
END_IF;

(* Applies the standard first-order low-pass filter equation *)
filteredSignal := (clippedAlpha * signal) + ((REAL#1.0 - clippedAlpha) * prevFilteredSignal);

(* Updates the previous filtered signal for the next calculation cycle *)
prevFilteredSignal := filteredSignal;

END_FUNCTION_BLOCK

