# RPi Arduino Template
- Author: Nathan Henrie
- License: MIT
- Originally posted at: http://n8henrie.com/2015/07/rpi_arduino_template

## Background
A simple template for using an Arduino with your Raspberry Pi, connect by USB, interacting over serial, thanks to [arduino-mk](https://github.com/sudar/Arduino-Makefile).

**Rationale:** I want to be able to connect my Arduino (via *powered* USB hub) to my headless Raspberry Pi, then be able to upload sketches and trigger actions on the Arduino via SSH. Because this has taken me a while to get working as envisioned, I thought I'd share a template with some instructions. I also use it to program a bare ATMEGA328p on a breadboard via USBasp, so I've included a boards.txt, a udev rule, and some lines in the Makefile for this purpose. FWIW, I also have this setup working well on my Macbook Pro.

Of note, one of the primary reasons I'm interested in connecting the Arduino (instead of just using the Pi's GPIO) is that I've found 433 MHz RF transmission to be much more reliable when sent from the Arduino. This is likely because Linux doesn't default to real-time capabilities, so when other running processes make the CPU busy, the time-dependent RF transmission gets messed up. (Some of my Arduino 433 MHz testing [here](http://n8henrie.com/2015/03/range-testing-for-wireless-arduino-projects-rf-433-mhz-and-nrf24l01/)).

## Requirements
### SSH access to Raspberry Pi
I've [covered this elsewhere](http://n8henrie.com/2015/02/raspberry-pi-setup-direct-ethernet/).

### arduino-core
`sudo aptitude install arduino-core`. This provides the libraries you're taking advantage of when you write Arduino sketches in the Arduino IDE, without the GUI stuff.

### [arduino-mk](https://github.com/sudar/Arduino-Makefile)
While this is available in the Raspbian repo, I *strongly* recommend you install a more recent version, e.g. `sudo git clone https://github.com/sudar/Arduino-Makefile.git /opt/arduino-mk`. Arduino-mk requires [pyserial](http://pyserial.sourceforge.net) and expects it to be installed for `/usr/bin/env python`, so make sure you `which python` and either `pip install pyserial` or `sudo aptitude install python-serial` accordingly.

### Optional
- `screen` if you want to be able to use `make monitor` from `arduino-mk`. `sudo aptitude install screen`
- `cu` for a simple serial connection. `sudo aptitude install cu`

## Setup

### Git Submodules

I've added a few boards.txt files that seem to work (found at the [Unofficial list of 3rd party boards support urls](https://github.com/arduino/Arduino/wiki/Unofficial-list-of-3rd-party-boards-support-urls) from the Arduino GitHub site) as [git submodules](http://git-scm.com/docs/git-submodule). After cloning this repo, you may need to `git submodule update --init --recursive` and `git submodule foreach git pull origin master` to get them all pulled in and up to date.

### Env Variables

Export the `ARDUINO_MK` env variable as the path to `Arduino.mk`. If you installed via GitHub to `/opt/arduino-mk` like I did, you could run `export ARDUINO_MK=/opt/arduino-mk/Arduino.mk`. Once this seems to be working, add that to your `~/.bash_profile` or `~/.bashrc`, depending on your setup. Make sure it's properly set with `env | grep ARDUINO_MK`. On OSX you'll also need to export `ARDUINO_DIR` as noted in `Makefile`.

### USB Permissions

Whenever you plug the Arduino or USBasp into your (powered) USB hub, it will get assigned to something like `/dev/ttyACM0` or `/dev/ttyUSB1`. There are a number of ways to figure out which one -- I recommend `ls -lAtr /dev/tty{A,U}*`, look at the timestamps, plug and unplug the USB a few times, and you should be able to figure it out. While not strictly necessary, I recommend setting up a udev rule to automatically set appropriate permissions and to symlink the device to something static (e.g. `/dev/arduino_serial`), which will make it much easier to write your scripts. You can see my udev rules in `10-local.rules`. You may choose to edit these to suit your situation and `sudo cp -i 10-local.rules /etc/udev/rules.d/` once you're satisfied.

A few tips for working with udev rules:
- Add yourself to the dialout group `sudo usermod -a -G dialout $USER`, then **log out and log back in**.
- [Read this](http://www.reactivated.net/writing_udev_rules.html)
- `udevadm` is your friend
- To see the attributes you can use in writing your rules: `udevadm info --query=all --attribute-walk --name=/dev/ttyACM0 | less` (replace `/dev/ttyACM0` as appropriate).
- `sudo udevadm trigger` to refresh the rules and test if you have it working.

## Usage
Once you have everything set up, you should be able to use the test scripts I've provided, `serial_example.cpp` and `serial_example.py`. Open each of these and see if you need to change anything (like the `/dev/tty` part in `serial_example.py`). Once you're satisfied, `make upload` should compile and upload `serial_example.cpp` to the Arduino. If you're also working with a USBasp and an ATMEGA328p on breadboard, uncomment the relevant lines from `Makefile`, and `make ispload` instead.

If it uploaded without errors, **your onboard LED (13) should be blinking on and off.** If it is, then congrats! You can now upload sketches via CLI. If you can access your Pi via WiFi, you should be able to remotely write sketches and upload them without ever having to connect or disconnect your Arduino or deal with a GUI.

Next, we'll test whether or not your Pi can talk to the Arduino over serial. The current sketch should *toggle* the blinking on or off if you send it a `1`. There are a few ways of doing this, but the easiest is `echo 1 > /dev/arduino_serial`. Sometimes it doesn't work the very first time after a reboot (you see the blinking RX/TX lights but LED 13 doesn't toggle), so you may have to try one more time. With any luck, the blinking should stop. Send the command again and it returns to blinking. If it is working, then you are ready to rock and roll. You can now connect to your Pi via SSH, write an Arduino sketch in your favorite text editor, upload it, and even trigger events on the Arduino from your Pi.

Other ways to interact with the serial device, which should print whatever key you hit and toggle blinking if it's a `1`:
- `cu -l /dev/arduino_serial` (`~.` to exit)
- `screen /dev/arduino_serial` (`ctrl a` then `k` to exit)
- `make monitor`, which will have `arduino-mk` open `screen` to the appropriate port. May need to `export MONITOR_BAUDRATE=115200`

Because I'm most familiar with Python, I also included `serial_example.py`. Open it and make sure the settings look correct and make sure you have `pyserial` installed for Python3 (`pip3 list | grep serial`). If so, you should be able to `python3 serial_example.py` and it will toggle the blinking on and off.

## Troubleshooting
- Permissions errors?
    - Check the output of `ls -l $(readlink -f /dev/arduino_serial)` (or `ls -l /dev/ttyACM0` or what have you).
    - Check the current user's group memberships with the `id` command, make sure you've logged out and back in to see any changes.
    - Make sure permissions are 0660 and that you have appropriate group membership.
- Check serial port speed: `stty < /dev/arduino_serial`.
    - I've put everything as 115200 because that's what my Pi seems to have defaulted to, though 9600 seems more popular.
    - If yours is different, you'll need to either change the port's rate to 115200 with `stty` or change the scripts to whatever rate you prefer.
- Cannot set SCK period errors using chips with USBasp
    - If you're using a brand new chip, you may need to set the fuses -- `make set_fuses` seems to work fairly well.
    - If you're running a device very slow (e.g. ATtiny85 at internal clock's 1MHz), you may need to either:
        - Set avrdude's `-B` flag to something like `-B4` (may not be possible depending on your USBasp firmware)
        - Bridge jumper 3 on your USBasp

## Changelog

### 20150724

- Moved sketches to examples
- Added [git submodules](http://git-scm.com/docs/git-submodule) for appropriate boards.txt files

### 20150709

- Initial commit
