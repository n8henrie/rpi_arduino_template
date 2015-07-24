# Makefile
# For use with [Arduino Makefile](https://github.com/sudar/Arduino-Makefile)
# [Variables](https://github.com/sudar/Arduino-Makefile/blob/master/arduino-mk-vars.md)
# Depends on env variable: 
#   - export ARDUINO_MK=/path/to/Arduino.mk
# On OSX will also need:
#   - export ARDUINO_DIR=/path/to/Arduino.app/Contents/Java
# 
# Standard Arduino Uno does not require any other changes.
#
# May need to uncomment `AVRDUDE_OPTS = -B4` or connect the USBasp Jumper 3 in
# order to slow things down enough to `make set_fuses`

### BEGIN atmega328p on breadboard
ISP_PROG        = usbasp
BOARDS_TXT      = packages/atmega/avr/boards.txt
BOARD_TAG       = atmega328p
VARIANT         = standard    
F_CPU           = 8000000L
## Only uncomment if needed
# AVRDUDE_OPTS = -B4
### END atmega328p on breadboard

### BEGIN attiny85 on breadboard
# ISP_PROG = usbasp
# ALTERNATE_CORE_PATH = packages/attiny/attiny
# BOARD_TAG       = attiny85
# Needs either USBasp jumper 3 or `-B4` flag (with appropriate firmware) for
# 1000000L
# F_CPU = 1000000L
# AVRDUDE_OPTS = -B4
### END ATtiny85 on breadboard

include $(ARDUINO_MK)
