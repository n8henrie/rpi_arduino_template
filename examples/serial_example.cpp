/* 
 * Name: serial_example.cpp
 * Author: Nathan Henrie
 * License: MIT
 * Example sketch that blinks the onboard LED, toggles blinking if it receives
 * '1' by serial.
 * Usage: From terminal, `echo 1 > /dev/DEVICE`
 * Can also test with `make monitor` from arduino-mk, or `cu -l /dev/DEVICE`
 */                                                                               

#include <Arduino.h>
#define LED_PIN 13
#define WAIT_SECS 1

bool blinkToggle = true;

// Blink the LED
void blink() {
    if(blinkToggle) {
        digitalWrite(LED_PIN, HIGH);
        delay(WAIT_SECS * 1000);
        digitalWrite(LED_PIN, LOW);
        delay(WAIT_SECS * 1000);
    }
}

void setup() {                
    // Default serial port speed on the RPi is 115200
    Serial.begin(115200);
    pinMode(LED_PIN, OUTPUT);     
}

void loop() {
    if (Serial.available()) {
        char ser = Serial.read();

        // Debug by echoing the input char
        Serial.println(ser);

        // Toggle blinking the onboard LED if the char was 1
        if (ser == '1') {
            blinkToggle = !blinkToggle;
        }     
    }
    blink();
}
