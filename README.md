# StepTracker

A SwiftUI-based iOS application for tracking daily steps and health metrics using HealthKit integration.

## Overview

StepTracker provides users with an intuitive dashboard to monitor their daily activity levels, focusing on step counting and related health metrics. The app leverages Apple's HealthKit framework to securely access and display health data.

**Note**: This project is based on the initial version created by Sean Allen, with additional enhancements and modifications.

## Features

- **Step Tracking**: Real-time step count monitoring throughout the day
- **Health Dashboard**: Clean, easy-to-read interface displaying key health metrics
- **HealthKit Integration**: Secure access to health data with proper privacy controls
- **SwiftUI Interface**: Modern, responsive user interface built with SwiftUI

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+
- Device with HealthKit support (iPhone)

## Architecture

The app follows SwiftUI best practices with a clean architecture:

- **StepTrackerApp.swift**: Main app entry point with HealthKit manager initialization
- **HealthKitManager**: Handles all HealthKit interactions and data management
- **DashboardView**: Primary user interface for displaying health metrics
- **Environment Objects**: Used for dependency injection of the HealthKit manager

## Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd StepTracker
```

2. Open the project in Xcode:
```bash
open StepTracker.xcodeproj
```

3. Build and run the project on a physical device (HealthKit requires actual hardware)

## Configuration

### HealthKit Permissions

The app requires specific HealthKit permissions to function properly. Ensure the following capabilities are enabled in your project:

1. Add HealthKit capability in Project Settings → Signing & Capabilities
2. Configure required health data types in `HealthKitManager`
3. Add appropriate usage descriptions in `Info.plist`:

```xml
<key>NSHealthShareUsageDescription</key>
<string>This app needs access to health data to display your step count and activity metrics.</string>
```

## Usage

1. Launch the app on your iOS device
2. Grant HealthKit permissions when prompted
3. View your daily step count and health metrics on the dashboard
4. Data automatically syncs with Apple Health app

## Development

### Project Structure

```
StepTracker/
├── StepTrackerApp.swift          # App entry point
├── Views/
│   └── DashboardView.swift       # Main dashboard interface
├── Managers/
│   └── HealthKitManager.swift    # HealthKit data management
└── Supporting Files/
    └── Info.plist               # App configuration
```

### Key Components

- **HealthKitManager**: Singleton class managing HealthKit authorization and data queries
- **DashboardView**: SwiftUI view presenting health data in a user-friendly format
- **Environment Integration**: Dependency injection pattern for clean testability

## Privacy & Security

This app prioritizes user privacy:

- All health data remains on the user's device
- HealthKit permissions are explicitly requested
- No health data is transmitted to external servers
- Follows Apple's HealthKit privacy guidelines

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Document public interfaces with DocC comments
- Maintain clear, readable code with appropriate internal documentation

## License

MIT License

Copyright (c) 2024 StepTracker

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Credits

Initial version created by Sean Allen. Subsequent enhancements and modifications by the current maintainers.

---

**Note**: This app requires a physical iOS device for testing and use, as the iOS Simulator does not support HealthKit functionality.
