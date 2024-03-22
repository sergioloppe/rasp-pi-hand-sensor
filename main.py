import os
import sys
import signal
from apds9960.const import *
from apds9960 import APDS9960
import RPi.GPIO as GPIO
import smbus2 as smbus
from time import sleep
from pynput.keyboard import Key, Controller

keyboard = Controller()

def signal_handler(sig, frame):
    print("\nApplication terminated with Ctrl+C.")
    os._exit(0)


def simulate_key_combination(keys):
    with keyboard.pressed(Key.ctrl):
        for key in keys:
            if key == "shift":
                with keyboard.pressed(Key.shift):
                    # Wait for another key to press along with Shift
                    continue
            else:
                # Press and release other keys
                keyboard.press(key)
                keyboard.release(key)


dirs = {
    APDS9960_DIR_NONE: "none",
    APDS9960_DIR_LEFT: "left",
    APDS9960_DIR_RIGHT: "right",
    APDS9960_DIR_UP: "up",
    APDS9960_DIR_DOWN: "down",
    APDS9960_DIR_NEAR: "near",
    APDS9960_DIR_FAR: "far",
}


try:
    signal.signal(signal.SIGINT, signal_handler)

    port = 1
    bus = smbus.SMBus(port)
    apds = APDS9960(bus)

    apds.setProximityIntLowThreshold(50)

    print("APDS9960 Gesture Test")
    print("============")
    apds.enableGestureSensor()

    while True:
        sleep(0.5)

        if apds.isGestureAvailable():
            motion = apds.readGesture()
            direction = dirs.get(motion, "unknown")
            print(f"Gesture={direction}")

            if direction == "left":
                simulate_key_combination([Key.shift, Key.tab])  # Ctrl+Shift+Tab
                print("Simulated Ctrl+Shift+Tab")
            elif direction == "right":
                simulate_key_combination([Key.tab])  # Ctrl+Tab
                print("Simulated Ctrl+Tab")

except OSError:
    print('No sensor found.')
    os._exit(1)

except Exception as e:
    print(f"Unexpected error: {e}")
    os._exit(2)

finally:
    GPIO.cleanup()
    print("Ciao ciao Alex")



