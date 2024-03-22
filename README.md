



## How to run the thing
```shell
# activate i2c
$ sudo raspi-config

# Create virtual 
$ python3 -m venv venv
$ source venv/bin/activate

# Install dependencies
$ pip install apds9960 RPi.GPIO smbus2 smbus

# Run the thing
$ python gesture.py
```

## How to test that the thing is sending the signal to/as the keyboard
```shell
# Xvfb (X Virtual FrameBuffer) to simulate an X server
sudo apt-get install xvfb
xvfb-run python main.py

# This is not working
sudo apt-get install evtest
sudo evtest

# This also not
sudo cat /dev/input/event* | hexdump -C
```

# Hand Sensor Service
```shell
sudo mv hand-sensor.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start hand-sensor.service
sudo systemctl status hand-sensor.service
```
