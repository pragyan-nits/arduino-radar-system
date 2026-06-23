# Arduino Radar System

A radar-like object detection system built using Arduino, an ultrasonic sensor, and a servo motor. The project includes a real-time radar visualization developed in Processing 4 that displays detected objects as the sensor scans its surroundings.

## Features
- Object detection using HC-SR04 ultrasonic sensor
- 180° scanning with servo motor
- Real-time serial communication
- Interactive radar visualization using Processing 4

## Hardware Components
- Arduino Uno/Nano
- HC-SR04 Ultrasonic Sensor
- SG90 Servo Motor
- Jumper Wires
- Breadboard

## Software
- Arduino IDE
- Processing 4

## Project Structure

```text
arduino-radar-system/
│
├── Processing_Code/
│   └── radar_visualization.pde
│
├── README.md
│
├── Arduino_Code/
│   └── Radar.ino
│
└── Images/
    └── radar_output
```

## How It Works
1. The servo rotates the ultrasonic sensor.
2. Distance measurements are collected.
3. Arduino sends angle and distance data via serial communication.
4. Processing receives the data and renders it as a radar display.


## Future Improvements
- Higher precision sensors
- Object tracking
- Data logging
- 360° scanning mechanism
