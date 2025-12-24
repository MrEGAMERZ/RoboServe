# 🤖 RoboServe - Autonomous Restaurant Service Robot

<div align="center">

![RoboServe Logo](https://img.shields.io/badge/RoboServe-Restaurant_Robot-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-ESP32-blue?style=for-the-badge)
![iOS](https://img.shields.io/badge/iOS-SwiftUI-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**An autonomous line-following robot with AI-powered table detection and iOS ordering app**

[Features](#-features) • [Hardware](#-hardware) • [Setup](#-setup) • [Demo](#-demo) • [Contributing](#-contributing)

</div>

---

## 📖 Overview

RoboServe is a complete restaurant automation system combining:
- **Autonomous Robot** - Line following with obstacle avoidance
- **AI Vision** - Table detection using Edge Impulse ML
- **iOS App** - Customer ordering and kitchen management
- **ESP-NOW Communication** - Real-time wireless control

## ✨ Features

### 🤖 Robot Features
- ✅ Line following with 3 IR sensors
- ✅ Obstacle detection using ultrasonic sensor
- ✅ AI-powered table recognition (Edge Impulse)
- ✅ ESP-NOW wireless communication
- ✅ Physical button resume system
- ✅ LED status indicators

### 📱 iOS App Features
- ✅ Table-based ordering system
- ✅ Real-time menu browsing
- ✅ Kitchen order management
- ✅ Firebase Firestore integration
- ✅ Multiple order status tracking
- ✅ Built-in games for customers

### 🧠 AI/ML Features
- ✅ On-device inference (no cloud needed)
- ✅ Custom trained Edge Impulse model
- ✅ 85%+ detection accuracy
- ✅ Real-time table identification

---

## 🎥 Demo

> *Add your demo video/GIF here*

### System in Action:
1. Robot follows black line autonomously
2. ESP32-CAM detects table marker
3. Robot stops at table
4. Customer orders via iOS app
5. Waiter presses button to resume
6. Robot continues to next table

---

## 🛠️ Hardware

### Components List

#### ESP32 DevKit V1 (Robot Controller)
- **Microcontroller**: ESP32-WROOM-32
- **Motor Drivers**: 2x L298N H-Bridge
- **Motors**: 4x DC motors with wheels
- **Sensors**:
  - 1x HC-SR04 Ultrasonic sensor
  - 3x IR line sensors
  - 1x Resume button (GPIO 16)
- **Power**: 11.1V LiPo battery (3S)

#### ESP32-CAM (Vision System)
- **Camera Module**: AI Thinker ESP32-CAM
- **Sensor**: OV2640 (2MP)
- **Power**: 5V via buck converter

### Pin Configuration

#### ESP32 DevKit V1
```
Motors:
  L298N #1: ENA1=18, IN1_1=21, IN2_1=22, ENA2=19, IN1_2=23, IN2_2=5
           ENB1=25, IN3_1=26, IN4_1=27
  L298N #2: ENB2=32, IN3_2=33, IN4_2=4

Sensors:
  Ultrasonic: TRIG=13, ECHO=12
  IR Sensors: LEFT=15, CENTER=2, RIGHT=14
  Button: GPIO 16 (to GND)
  LED: GPIO 2 (built-in)
```

#### ESP32-CAM
```
Standard AI Thinker pinout
Camera: OV2640
Communication: ESP-NOW
```

### Circuit Diagram
```
┌─────────────┐         ┌──────────────┐
│ ESP32-CAM   │─ESP-NOW→│ ESP32 DevKit │
│             │         │              │
│  • Camera   │         │  • Motors    │
│  • ML Model │         │  • Sensors   │
└─────────────┘         │  • Button    │
                        └──────────────┘
```

---

## 💻 Software Architecture

### System Architecture
```
┌─────────────────────────────────────────┐
│              iOS App (SwiftUI)          │
│  ┌────────────────────────────────┐    │
│  │ • Order Management             │    │
│  │ • Kitchen Dashboard            │    │
│  │ • Firebase Integration         │    │
│  └────────────────────────────────┘    │
└─────────────┬───────────────────────────┘
              │
              ▼
    ┌─────────────────┐
    │ Firebase        │
    │ Firestore       │
    └─────────────────┘
    
┌─────────────────────────────────────────┐
│         ESP32-CAM System                │
│  ┌────────────────────────────────┐    │
│  │ • Edge Impulse Model           │    │
│  │ • Table Detection              │    │
│  │ • ESP-NOW TX                   │    │
│  └────────────────────────────────┘    │
└─────────────┬───────────────────────────┘
              │ ESP-NOW
              ▼
┌─────────────────────────────────────────┐
│         ESP32 DevKit Robot              │
│  ┌────────────────────────────────┐    │
│  │ • Line Following               │    │
│  │ • Obstacle Avoidance           │    │
│  │ • Button Resume                │    │
│  │ • Motor Control                │    │
│  └────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

---

## 🚀 Setup

### Prerequisites
- Arduino IDE 2.0+
- ESP32 board support installed
- Edge Impulse account (for custom models)
- Xcode 14+ (for iOS app)
- Firebase project setup

### 1️⃣ Hardware Assembly

1. **Assemble robot chassis** with 4 motors
2. **Connect L298N motor drivers** to ESP32 DevKit
3. **Mount sensors** (IR sensors on bottom, ultrasonic on front)
4. **Install ESP32-CAM** on top of robot
5. **Wire button** between GPIO 16 and GND
6. **Connect power supply** (separate for motors and ESP32s)

### 2️⃣ Arduino Setup (Robot)

```bash
# Install Arduino IDE
# Add ESP32 board support:
# File → Preferences → Additional Board URLs:
https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Install libraries:
# - ESP32Servo (for servo support if needed)
```

**Upload Steps:**
1. Open `ESP32_DevKit_Robot/robot_controller.ino`
2. Select board: `ESP32 Dev Module`
3. Upload and note the MAC address from Serial Monitor
4. Open `ESP32_CAM/table_detection.ino`
5. Update MAC address in code
6. Select board: `AI Thinker ESP32-CAM`
7. Upload (hold BOOT button)

### 3️⃣ Edge Impulse Model Training

1. Create account at [edgeimpulse.com](https://edgeimpulse.com)
2. Create new project
3. Collect images:
   - 50-100 images of table1 marker
   - 50-100 images of table2 marker
   - 50+ background/noise images
4. Train model using MobileNetV2
5. Deploy as Arduino library
6. Add library to Arduino IDE
7. Update `#include` statement in ESP32-CAM code

### 4️⃣ iOS App Setup

```bash
# Navigate to iOS app directory
cd FoodOrdering

# Open in Xcode
open FoodOrdering.xcodeproj

# Update GoogleService-Info.plist with your Firebase config
# File → Add Files → Select your GoogleService-Info.plist
```

**Firebase Setup:**
1. Create Firebase project
2. Add iOS app
3. Download `GoogleService-Info.plist`
4. Enable Firestore Database
5. Set up authentication (if needed)

### 5️⃣ Testing

1. **Test ESP-NOW communication**
   - Upload both ESP32 codes
   - Check Serial Monitors for data transfer
   
2. **Test table detection**
   - Print table markers
   - Show to ESP32-CAM
   - Verify detection in Serial Monitor

3. **Test robot movement**
   - Place on black line
   - Verify line following
   - Test obstacle avoidance

4. **Test iOS app**
   - Run on simulator/device
   - Place test order
   - Verify Firebase integration

---

## 📁 Repository Structure

```
RoboServe/
├── ESP32_DevKit_Robot/
│   ├── robot_controller/
│   │   └── robot_controller.ino
│   └── README.md
│
├── ESP32_CAM/
│   ├── table_detection/
│   │   └── table_detection.ino
│   └── README.md
│
├── EdgeImpulse/
│   ├── training_data/
│   ├── model_files/
│   └── README.md
│
├── FoodOrdering/
│   ├── FoodOrdering.xcodeproj
│   ├── FoodOrdering/
│   │   ├── Models/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Managers/
│   └── README.md
│
├── Hardware/
│   ├── circuit_diagram.png
│   ├── wiring_guide.md
│   └── parts_list.md
│
├── docs/
│   ├── setup_guide.md
│   ├── troubleshooting.md
│   └── api_documentation.md
│
├── LICENSE
└── README.md
```

---

## 🎯 Usage

### Starting the System

1. **Power on robot** and wait for initialization
2. **Launch iOS app** on iPad/iPhone
3. **Place robot** on black line track
4. **Position table markers** along the route

### Customer Flow
1. Customer scans QR code or opens app
2. Enters table number
3. Browses menu and adds items to cart
4. Places order
5. Kitchen receives notification

### Robot Operation
1. Robot follows line autonomously
2. Detects table marker via ESP32-CAM
3. Stops and waits (LED blinks)
4. Customer can order via app
5. Waiter presses button after service
6. Robot continues to next table

---

## 🔧 Configuration

### Adjustable Parameters

**Robot Speed** (`robot_controller.ino`):
```cpp
const int MOTOR_SPEED = 200;  // 0-255
```

**Detection Threshold** (`table_detection.ino`):
```cpp
if (maxConfidence > 0.70) {  // Adjust threshold
```

**Obstacle Distance** (`robot_controller.ino`):
```cpp
if (distance < 25) {  // Distance in cm
```

---

## 🐛 Troubleshooting

### Common Issues

**Robot doesn't stop at table:**
- Check ESP-NOW MAC address is correct
- Verify camera can see table marker clearly
- Increase lighting if needed

**ESP-NOW connection fails:**
- Ensure both ESP32s are powered on
- Check MAC address in code
- Verify WiFi mode is set to WIFI_STA

**iOS app can't connect to Firebase:**
- Check `GoogleService-Info.plist` is added
- Verify Firebase rules allow read/write
- Check internet connection

**Motors not responding:**
- Check L298N connections
- Verify motor power supply (7-12V)
- Test with simple motor test sketch

See [docs/troubleshooting.md](docs/troubleshooting.md) for more details.

---

## 📊 Performance

- **Table Detection Accuracy**: 85-92%
- **Detection Speed**: ~200ms per frame
- **Line Following**: 95%+ accuracy on standard black line
- **Obstacle Avoidance**: 25cm minimum distance
- **Battery Life**: ~2-3 hours continuous operation
- **WiFi Range**: ~30 meters (ESP-NOW)

---

## 🛣️ Roadmap

- [ ] Add more table support (table3, table4, etc.)
- [ ] Implement SLAM for autonomous navigation
- [ ] Add voice ordering capability
- [ ] Multi-robot coordination
- [ ] Android app version
- [ ] Cloud dashboard for analytics
- [ ] Automatic docking/charging station

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - *Initial work* - [@MrEGAMERZ](https://github.com/MrEGAMERZ)

---

## 🙏 Acknowledgments

- Edge Impulse for embedded ML platform
- ESP32 community for excellent documentation
- OpenAI for development assistance
- Arduino community for libraries and examples

---

## 📧 Contact

- **Email**: mohammadrehan432432@gmail.com
- **Project Link**: https://github.com/MrEGAMERZ/RoboServe
- **Demo Video**: [[YouTube Link]](https://youtu.be/SfOplXveABE?si=HYPNmYnsvF1Ss-IX)

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/RoboServe&type=Date)](https://star-history.com/#yourusername/RoboServe&Date)

---

<div align="center">

**Made with ❤️ by Mohammad Rehan And Team**

If this project helped you, please consider giving it a ⭐!

</div>
