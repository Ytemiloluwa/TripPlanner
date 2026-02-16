# Trip Planner

A native iOS app for planning and managing trips, built with Swift, SwiftUI, and UIKit.

## Features

- Trip Management - Create and view planned trips
- City Selection - Pick from predefined destinations
- Date Selection - Choose travel start/end dates with a custom UIKit flow
- Trip Details - Review trip info with flights, hotels, and activities sections
- API Integration - Fetch and create trips via Beeceptor REST endpoints

## Tech Stack

| Category | Technology |
| --- | --- |
| Language | Swift |
| UI | SwiftUI + UIKit |
| Architecture | MVVM + Coordinator |
| Networking | URLSession |
| Async | async/await + @MainActor |
| Navigation | UINavigationController + SwiftUI NavigationStack |

## Requirements

- Xcode 15 or later
- iOS Simulator or physical iPhone
- macOS with Apple development tooling installed

## Project Structure

```text
TripPlanner/TripPlanner/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCordinator.swift
├── Core/
│   ├── Model/             # Trip model
│   └── Network/           # APIError, TripService, protocol
├── Features/
│   ├── TripList/          # Home/list screen, view model, create sheet
│   ├── TripDetails/       # Trip details + itineraries views
│   ├── CitySelection/     # Storyboard + view controller
│   └── DateSelection/     # Programmatic UIKit date flow
└── Resources/
    └── Assets.xcassets/   # Images, icons, colors
```

## Best Practices & Architecture

This project follows clean architecture principles to ensure scalability, testability, and maintainability.

### SOLID Principles Applied

- **Single Responsibility Principle (SRP)**:
  - **ViewModels** (e.g., `TripListViewModel`) handle business logic and state management exclusively.
  - **Views** (SwiftUI/UIKit) are responsible only for rendering the UI.
  - **Coordinators** (`AppCoordinator`) manage navigation flow, decoupling it from view controllers.
  - **Services** (`TripService`) handle networking and data fetching.

- **Open/Closed Principle (OCP)**:
  - The networking layer is designed to be extended without modification. New endpoints can be added by extending the service or creating new service implementations conforming to protocols.

- **Liskov Substitution Principle (LSP)**:
  - `TripListViewModel` depends on the `TripServiceProtocol` abstraction rather than a concrete class. This allows swapping the real network service with a mock service for testing without breaking the application.

- **Interface Segregation Principle (ISP)**:
  - Protocols like `TripServiceProtocol` define specific contracts for data operations, ensuring clients only depend on the methods they use.

- **Dependency Inversion Principle (DIP)**:
  - High-level modules (ViewModels) do not depend on low-level modules (Network Services). Both depend on abstractions (`TripServiceProtocol`).
  - Dependencies are injected via initializers, making the code modular and testable.

### Other Key Practices

- **MVVM-C Architecture**: Combines Model-View-ViewModel with the Coordinator pattern to separate UI, business logic, and navigation.
- **Protocol-Oriented Programming**: Heavy use of protocols to define interfaces and enable dependency injection.
- **Modern Concurrency**: Utilizes Swift's `async/await` for clean, readable asynchronous code.
- **UIKit & SwiftUI Interoperability**: Demonstrates seamless integration of legacy UIKit components (View Controllers, Storyboards) within a modern SwiftUI app structure.
- **Responsive Design**: UI components adapt to different screen sizes using dynamic layout calculations.

## Setup

1. Clone the repository
2. Open `TripPlanner.xcodeproj` in Xcode
3. Select an iOS simulator/device
4. Build and run

Demo Link 

https://drive.google.com/file/d/1gnRog0DD2yM9Dg0Jh17eZgCRmL0jJrQx/view?usp=sharing
