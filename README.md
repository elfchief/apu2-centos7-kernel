This is a RHEL7 kernel src.rpm with configs and bonus patches to enable additional functionality on Soekris net6501 hardware.

Right now, the patches are:
  * `e6xx-force-hpet.patch`: Force-enable the high-precision event timer on E6xx systems that don't support ACPI (unknown origin)
  * `soekris-net6501.patch`: All the magic for everything else

The patches should be applyable to most any kernel tree, but definitely applies cleanly to the kernel in this repository.

The parts of soekris-net6501.patch:
  * `soekris-net6501.c`: The platform driver for the other modules. It sets up the LED and GPIO device entries used by the other modules
  * `leds-net6501.c`: Courtesy [aptivate](https://github.com/aptivate/ischool-net6501-kernel/), this module sets up two devices under /sys/class/leds as `net6501:green:ready` and `net6501:red:error`
  * `gpio-ioport.c`: A generic GPIO device set up to handle IO port based devices. It is largely identical to gpio-generic.c (or gpio-mmio.c in modern kernels), and could probably be merged with that without much effort. On stock net6501 devices, it will create /sys/class/gpio/gpiochip240, which can export gpio240 - gpio255

Other notes:
  * You will want to load all three modules. Order shouldn't matter.
  * I'm not sure if I should give the GPIO devices a lower number (I think gpiochip14), or let it get dynamically alocated as it currently is.
  * As far as I know, the net6501 does not have interrupt functionality on the GPIO device. If someone knows differently, please let me know!
  * It has been on the order of a decade since I've done any real kernel work. Don't use anything here as a model on how to do, well, anything. I will glady accept corrections, complaints, or improvements!
  * Also, if this code blows up and reformats your house, don't blame me. Use at your own risk!

Comments/complaints/recommendations for good heavy metal to: J. Grizzard <jg-github@lupine.org>
