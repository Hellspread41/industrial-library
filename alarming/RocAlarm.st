(*----------------------------------------------------------------------------------
-- Function Block: RateOfChangeAlarm
-- Author: Simon Marceau
-- Creation Date: 15-06-2025
-- Purpose:
--      Monitors the rate of change of an input signal at fixed time intervals
--      defined by samplingTime. Activates separate alarms if the computed
--      rate exceeds a positive setpoint or drops below a negative setpoint.
--
-- Dependencies: 
    - Requires a IEC TON function block.
--
-- All rights reserved (c) 2025 Simon Marceau.
-----------------------------------------------------------------------------------*)
FUNCTION_BLOCK RocAlarm 
VAR_INPUT
    signal: REAL;                   (* Current process value being monitored *)
    samplingTime: UINT := 1000;     (* Fixed time interval for rate calculation in milliseconds (ms). Must be higher than 0 *)
    posRateSetpoint: REAL;          (* Rate (units/ms) above which positive ROC alarm activates (must be positive) *)
    posRateHysteresis: REAL;        (* Hysteresis value for positive ROC alarm deactivation (must be positive) *)
    negRateSetpoint: REAL;          (* Rate (units/ms) below which negative ROC alarm activates (must be negative) *)
    negRateHysteresis: REAL;        (* Hysteresis value for negative ROC alarm deactivation (must be positive) *)
    suppress: BOOL;                 (* External signal to bypass both alarms *)
END_VAR
VAR_OUTPUT
    posRocAlarm: BOOL;              (* Alarm state for excessively positive rate of change *)
    negRocAlarm: BOOL;              (* Alarm state for excessively negative rate of change *)
    rateOfChange: REAL;             (* The calculated rate of change of the signal (units/ms)  *)
END_VAR
VAR  
    prevInputSignal: REAL;          (* Stores the input signal value from the previous calculation *)
    firstCycleFlag: BOOL := TRUE;   (* Flag indicating the first execution cycle *)
    samplingTimer: TON;             (* TON timer to control the sampling period. *)
END_VAR

(* First cycle initialization *)
IF firstCycleFlag THEN 
    prevInputSignal := signal;
    firstCycleFlag := FALSE;
END_IF;

(* Bypass the rate of change alarm states *)
IF suppress THEN 
    posRocAlarm := FALSE;
    negRocAlarm := FALSE;
    RETURN;
END_IF;

samplingTimer(IN:=TRUE, PT:=UINT_TO_TIME(samplingTime));
IF samplingTimer.Q THEN 
    samplingTimer(IN:=FALSE);   (* Reset the output of the TON timer *)
    (* Compute the rate of change at each sampling time *)
    IF samplingTime <> UINT#0 THEN 
        rateOfChange := (signal - prevInputSignal) / UINT_TO_REAL(samplingTime);
    ELSE 
        rateOfChange := REAL#0.0;   (* Assume no change if samplingTime has invalid value *)
    END_IF;

    prevInputSignal := signal;
END_IF;

(* Alarm logic for positive rate of change *)
posRocAlarm := (rateOfChange > posRateSetpoint) OR (posRocAlarm AND (rateOfChange >= (posRateSetpoint - posRateHysteresis)));

(* Alarm logic for negative rate of change *)
negRocAlarm := (rateOfChange < negRateSetpoint) OR (negRocAlarm AND (rateOfChange <= (negRateSetpoint + negRateHysteresis)));

END_FUNCTION_BLOCK



