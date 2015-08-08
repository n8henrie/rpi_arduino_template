/* 
 * Name: blink.cpp
 * Author: Nathan Henrie
 * License: MIT
 * Example for use with attiny85
 */                                                                               

#include <Arduino.h>
#define LED_PIN 3
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
    pinMode(LED_PIN, OUTPUT);     
}

void loop() {
    blink();
}
