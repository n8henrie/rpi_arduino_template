"""serial_example.py
Shows how you can send a command to an Arduino using pyserial.
Usage: `python3 serial_example.py`
"""

import serial

ARDUINO_SERIAL = '/dev/arduino_serial'

ser = serial.Serial(ARDUINO_SERIAL, 115200)
ser.write('1'.encode())
ser.close()
