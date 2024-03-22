import os
import random
from time import sleep
from pynput.keyboard import Controller

keyboard = Controller()

alphabet = 'abcdefghijklmnopqrstuvwxyz'

try:
    while True:
        random_letter = random.choice(alphabet)
        sleep(1)
        keyboard.press(random_letter)
        keyboard.release(random_letter)
        print(f"Sent letter: {random_letter}")
except KeyboardInterrupt:
    print("Script interrupted by user.")
except Exception as e:
    print(f"Unexpected error: {e}")
    os._exit(2)
finally:
    print("Ciao ciao Alex")
