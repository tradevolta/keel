--  SPDX-License-Identifier: Apache-2.0
--  Written once against the signature: any chip's pins will do.
with Keel.GPIO.Output_Signature;

generic
   with package Pins is new Keel.GPIO.Output_Signature (<>);
procedure Pulse (P : in out Pins.Pin);
