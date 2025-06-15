(*----------------------------------------------------------------------------------
-- Function Block: OverAlarm
-- Author: Simon Marceau 
-- Creation Date: 24-05-2025
-- Purpose: 
--      Handles "Over" type alarms with hysteresis and suppression.
--
-- Dependencies: None
-- 
-- All right reserved (c) 2025 Simon Marceau.
-----------------------------------------------------------------------------------*)
FUNCTION_BLOCK OverAlarm
VAR_INPUT
    signal: REAL;           (* Current process value being monitored *)
    alarmSetpoint: REAL;    (* Value above which the alarm activates *)
    alarmHysteresis: REAL;  (* Hysteresis value for alarm deactivation *)
    suppress: BOOL;         (* External signal to bypass the alarm *)
END_VAR
VAR_OUTPUT
    alarm: BOOL;            (* Over alarm state *)
END_VAR

IF suppress THEN 
    alarm := FALSE;
    RETURN;
END_IF;

(* Compute the over alarm state *)
alarm := (signal > alarmSetpoint) OR (alarm AND (signal >= (alarmSetpoint - alarmHysteresis)));

END_FUNCTION_BLOCK

