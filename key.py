import os
from pynput.keyboard import Controller

keyboard = Controller()

try:
    keyboard.press('a')
    keyboard.release('a')
except OSError:
    print('No sensor found.')
    os._exit(1)

except Exception as e:
    print(f"Unexpected error: {e}")
    os._exit(2)

finally:
    print("Ciao ciao Alex")
