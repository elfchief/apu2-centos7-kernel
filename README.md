This is a CentOS 7 kernel src.rpm with configs and bonus patches to enable additional functionality on PC Engines' [apu2](http://www.pcengines.ch/apu2.htm) hardware.

Right now, the patches are:
  * `apu2-leds`: Control the three front LEDs (off the FCH GPIO controller), courtesy [dduke](https://daduke.org/linux/apu2/)
  * `gpio-nct5104d`: Control the 16 GPIO lines on the NCT5104D Super I/O chip, coutesy [tasanakorn](https://github.com/tasanakorn/linux-gpio-nct5104d/)
  * `sp5100_tco`: Watchdog timer support, backported from mainline kernel 4.5
  * `i2c-piix4`: i2c support, backported from  mainline kernel 3.19


Other changes:
  * If one does not exist, creates `/etc/modules-load.d/apu2.conf` to automatically load these modules. This file will not be changed once created, so can be used to adjust which apu2-specific modules load in the future.
  * Enabled a bunch of additional kernel modules that are generally useful in embedded systems (GPIO, i2c, etc)
  * Disabled a bunch of drivers that will definitely never be present on an apu2 box (PCI cards, intel CPUs, etc)
  * Disabled virtualization drivers (don't worry, Docker still works)

Other Notes:
  * I could have just compiled the apu2-specific modules in statically, so something like modules-load.d wasn't actually required, but if new versions were released I wanted to make it so you could just unload an old version and load a new one, which you can't do if they're static. If additional modules are added after that config file has been created, though, you'll have to add them by hand. Not sure there's a good way around that.
  * I may adjust the GPIO driver at some point to have one bank of 16 GPIOs rather than two banks of 8.
  * It has been on the order of a decade since I've done any real kernel work. Don't use anything here as a model on how to do, well, anything. I will glady accept corrections, complaints, or improvements!
  * Also, if this code blows up and reformats your house, don't blame me. Use at your own risk!

Usage examples, once modules are loaded:

```
# Turn LED2 on
$ echo 1 > /sys/class/leds/apu2:2/brightness

# Make power light heartbeat
$ modprobe ledtrig-heartbeat
$ echo heartbeat > /sys/class/leds/apu2:1/trigger

# Our generic GPIO handler
$ cat /sys/class/gpio/gpiochip0/label
gpio-nct5104d

# Number of GPIO lines
$ cat /sys/class/gpio/gpiochip0/ngpio
8

# Export a GPIO line (will create /sys/class/gpio/gpioN
$ echo 0 > /sys/class/gpio/export

$ cat /sys/class/gpio/gpio0/direction
in

# I think these may have a weak pullup on them, since the value reads '1'
# even when nothing is connected, and my meter reads ~3.25v. If I'm wrong,
# someone please correct me
$ cat /sys/class/gpio/gpio0/value
1

$ echo out > /sys/class/gpio/gpio0/direction

# Meter reads 0v after this
$ cat /sys/class/gpio/gpio0/value
0

# Meter reads 3.25v after this
$ echo 1 > /sys/class/gpio/gpio0/value
```

Comments/complaints/recommendations for good heavy metal to: J. Grizzard <jg-github@lupine.org>
