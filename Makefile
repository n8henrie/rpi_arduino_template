# Makefile
# For use with [Arduino Makefile](https://github.com/sudar/Arduino-Makefile)
# [Variables](https://github.com/sudar/Arduino-Makefile/blob/master/arduino-mk-vars.md)
# Depends on env variable: 
#   - export ARDUINO_MK=/path/to/Arduino.mk
# On OSX will also need:
#   - export ARDUINO_DIR=/path/to/Arduino.app/Contents/Java

# Standard Arduino Uno does not require any other changes.
# Uncomment below to program ATMEGA328p with USBasp

### BEGIN atmega328p on breadboard
# ISP_PROG        = usbasp
# BOARDS_TXT      = atmega328bb_boards.txt
# BOARD_TAG       = atmega328bb
# VARIANT         = standard    
### END atmega328p on breadboard

include $(ARDUINO_MK)
