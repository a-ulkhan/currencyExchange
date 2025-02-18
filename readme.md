
# CurrencyExchange iOS App

## Overview

CurrencyExchange is a simple iOS app that allows users to convert an amount from one currency to another. The app features a single screen where users can select source and target currencies using a picker, enter an amount to be exchanged, and view the converted amount. The app also implements a polling mechanism that refreshes the exchange rate every 15 seconds when the user is not actively editing.

The app is built using **UIKit** for the UI and uses programatic UI, **Combine** for reactive programming, and **Swift Concurrency** (async/await) for modern asynchronous programming.

---

## Architecture

The app follows the **MVVM + Router** architecture with a **Linear Tree Style Dependency Management** system. The architecture is designed to ensure separation of concerns, testability, and scalability.

### Key Components

1. **Builder**:
   - Takes `Dependency` and builds/returns a `Router`.
   - Responsible for constructing the dependency graph and initializing the flow.

2. **Router**:
   - Manages the flow scope, including the `View`, `ViewModel`, and dependency graph.
   - Ensures that all components are released from memory when the flow is dismissed.
   - Handles navigation and flow coordination.

3. **Dependency**:
   - A tree-structured dependency graph where child components can request properties from their parents.
   - Lifecycle is maintained by the `Router`. When the `Router` is detached, all associated dependencies are deallocated.

4. **ViewController**:
   - Abstracts most of the action handling away from the `View`.
   - Delegates actions to the `ViewModel`.
   - `View` components are self-contained and only responsible for layout/content.

5. **ViewModel**:
   - Acts as a bridge between the `View` (ViewController) and the Domain/Business logic.
   - Holds a private internal mutable state, which is mapped to `ViewState` on each update cycle.
   - Converts user commands into operations that the Domain layer can understand.
   - Injects `UseCases` and delegates navigation to the `Router`.

---

## Layers

The app is divided into three main layers, each with its own responsibilities and test bundles:

1. **Domain Layer**:
   - Contains pure business logic.
   - `UseCases` encapsulate self-contained business operations.
   - Has no external dependencies.

2. **Data Layer**:
   - Depends on the Domain layer (Dependency Inversion Principle).
   - Handles data operations such as:
     - Services (e.g., API calls).
     - Repository implementations (`RepoImpls`).
     - Mapping between Data Models and Domain Entities.

3. **Presentation Layer**:
   - Depends on the Domain layer.
   - Converts business logic (via `UseCases`) into content for the `View`.
   - Handles UI updates and user interactions.

---

## Features

- **Single Screen UI**:
  - Currency selection via picker.
  - Amount input for exchange.
  - Real-time conversion result display.

- **Polling Mechanism**:
  - Automatically refreshes exchange rates every 15 seconds when the user is not editing.

- **Reactive Programming**:
  - Uses Combine to handle state updates and data binding.

- **Modern Swift Concurrency**:
  - Utilizes `async/await` for asynchronous operations.

---

## Dependency Management

The app uses a **Linear Tree Style Dependency Management** system:
- Each child component can request properties from its parent.
- Dependencies are scoped to the `Router` and released when the flow is dismissed.

---

## Testing

Each layer has its own test bundle:
- **Domain Layer**: Unit tests for business logic and `UseCases`.
- **Data Layer**: Unit tests for services, repositories, and data mapping.
- **Presentation Layer**: Unit tests for `ViewModel` and UI logic.

---

## Future Improvements

1. **Automation**:
   - Generate the app using tools like **Tuist** or **Xcodegen**.
   
2. **CI Automation**:
   - Set up continuous integration for automated testing.

3. **Mock Generation**:
   - Use tools like **Sourcery** to automate mock creation for testing.
   
   
## Third party dependency

Currently no 3rd party libraries.

1. **Autolayout**:
   - Currently no third party tool is used, would beneficial if **Snapkit** or **EasyPeasy** or own layout manager can be added.

   




