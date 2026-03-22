# Dynamic Island Demo

An iOS application demonstrating Apple's **Dynamic Island** using **ActivityKit** and **WidgetKit** Live Activities.

## Overview

This app simulates a pizza delivery tracker that displays real-time order status on the Dynamic Island and Lock Screen. It showcases all Dynamic Island presentation modes:

- **Compact** — minimal leading/trailing views in the pill-shaped island
- **Expanded** — full expanded view with leading, trailing, center, and bottom regions
- **Minimal** — icon-only view when multiple Live Activities are running
- **Lock Screen** — banner-style widget on the Lock Screen

## Requirements

- **Xcode 15+**
- **iOS 17.0+**
- **iPhone 14 Pro or later** (for Dynamic Island hardware; Lock Screen Live Activity works on all supported devices)

## Project Structure

```
├── DynamicIslandDemo/                # Main app target
│   ├── DynamicIslandDemoApp.swift     # App entry point
│   ├── ContentView.swift              # Root view
│   ├── DeliveryView.swift             # Delivery tracking UI
│   ├── LiveActivityManager.swift      # ActivityKit lifecycle management
│   └── Info.plist                     # NSSupportsLiveActivities = YES
│
├── Shared/                            # Shared between app & widget extension
│   └── DeliveryAttributes.swift       # ActivityAttributes + DeliveryStatus model
│
└── DynamicIslandDemoWidgetExtension/  # Widget extension target
    ├── DynamicIslandDemoWidgetBundle.swift
    ├── DynamicIslandDemoLiveActivity.swift  # Dynamic Island & Lock Screen UI
    └── Info.plist
```

## How It Works

1. **Start** a delivery Live Activity from the main app
2. **Advance** through delivery statuses: Preparing → In Oven → Out for Delivery → Almost There → Delivered
3. Each status update is reflected in real-time on the Dynamic Island and Lock Screen
4. **End** the activity manually, or it ends automatically when the order is delivered

## Key APIs Used

- [`ActivityKit`](https://developer.apple.com/documentation/activitykit) — start, update, and end Live Activities
- [`ActivityAttributes`](https://developer.apple.com/documentation/activitykit/activityattributes) — define static and dynamic data
- [`DynamicIsland`](https://developer.apple.com/documentation/widgetkit/dynamicisland) — build the Dynamic Island UI
- [`ActivityConfiguration`](https://developer.apple.com/documentation/widgetkit/activityconfiguration) — configure Lock Screen and Dynamic Island views

## References

- [Apple Developer Documentation — Dynamic Island](https://developer.apple.com/documentation/WidgetKit/DynamicIsland)
- [WWDC23 — Meet ActivityKit](https://developer.apple.com/videos/play/wwdc2023/10184/)
