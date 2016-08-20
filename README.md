This is a RHEL7 kernel src.rpm with configs and bonus patches to enable additional functionality on Soekris net6501 hardware.

Right now, the patches are:
  * `e6xx-force-hpet.patch`: Force-enable the high-precision event timer on E6xx systems that don't support ACPI
  * `soekris-net6501-leds.patch`: Enable access to status (green) and error (red) LEDs, accessible 
  under /sys/class/leds as `net6501:green:ready` and `net6501:red:error`
