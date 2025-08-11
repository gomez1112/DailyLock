# DailyLock 📓

**Capture life's moments, one sentence at a time.**

DailyLock is a beautifully crafted journaling app for iOS, macOS, and visionOS, designed to make daily reflection a simple and meaningful habit. With a focus on minimalism and mindfulness, it encourages you to distill your day into a single, memorable sentence that gets locked in time.

---

## ✨ Features

DailyLock offers a clean and focused journaling experience with powerful features to help you reflect and grow.

### Core Features
* **One-Sentence Journal:** A minimalist editor to capture the essence of your day.
* **Sentiment Tracking:** Assign a positive, neutral, or negative sentiment to each entry.
* **Beautiful Timeline:** Scroll through your life's moments in a beautifully designed, chronological timeline.
* **Streak Tracking:** Build a consistent journaling habit and watch your streak grow.
* **Grace Period:** An optional one-day grace period ensures that a single missed day doesn't break your momentum.
* **Secure & Private:** All your entries are stored securely on your device and synced via iCloud using SwiftData.

### DailyLock+ (Premium Features)
* **Yearly Statistics:** Visualize your writing habits with a beautiful year-at-a-glance chart.
* **Mood Distribution Insights:** Understand your emotional patterns with an elegant mood distribution chart.
* **Weekly AI Summaries:** Leveraging on-device **Apple Intelligence**, get personalized, AI-generated weekly summaries that highlight your progress and patterns.
* **Unlimited Entries:** (Future) Capture multiple moments in a single day.
* **Annual Yearbook:** (Future) Generate a beautiful, shareable yearbook of your entries.

---

## 🛠️ Technical Deep Dive & Architecture

This project is a modern showcase of native Apple development, built with the latest technologies and best practices.

### Core Technologies
* **UI:** 100% **SwiftUI**, embracing a declarative and platform-adaptive approach.
* **Data Persistence:** **SwiftData** for a robust, modern, and type-safe data layer synced via CloudKit.
* **Concurrency:** Modern concurrency with **`async/await`**, **`ModelActor`** and **`Task`** used throughout, especially for IAP and AI operations.
* **In-App Purchases:** **StoreKit 2** for managing subscriptions (`DailyLock+`) and one-time tips (`TipsView`).
* **On-Device AI:** **FoundationModels** (`@Generable`) for generating `WeeklyInsight` summaries securely and privately on-device.
* **Testing:** A comprehensive suite of **UI Tests** (`XCTest`) and **Unit Tests** (Swift Testing framework) to ensure reliability and quality.

### Architectural Highlights
* **Dependency Management:** A centralized `AppDependencies` observable class is used to manage and inject shared services (like `DataService`, `Store`, `HapticEngine`, `NavigationContext`) into the SwiftUI environment, promoting a clean and testable architecture.
* **MVVM-inspired Design:** The app uses a modern interpretation of MVVM, with views like `TodayView` delegating their logic and state management to observable classes like `EntryViewModel`.
* **Custom View Modifiers:** The codebase makes extensive use of custom modifiers like `.cardBackground()`, `.premiumFeature()`, and `.trackDeviceStatus()` to create a consistent design system and encapsulate view logic.
* **Advanced UI Components:**
    * `ConfettiView` & `StreakAchievementView`: Fun, animated views to celebrate user achievements.
    * `TipsView`: A highly animated and interactive view for in-app tipping, featuring floating hearts and a dynamic progress goal.
* **Robust Error Handling:** A centralized `ErrorState` manager queues and presents user-friendly alerts for different error types (`DatabaseError`, `StoreError`, `IntelligenceError`).

---

## 🚀 Getting Started

### Prerequisites
* Xcode 16 or later
* macOS Sequoia or later
* An Apple ID for StoreKit testing

### Installation
1.  Clone the repository:
    ```bash
    git clone [https://github.com/your-username/DailyLock.git](https://github.com/your-username/DailyLock.git)
    ```
2.  Open `DailyLock.xcodeproj` in Xcode.
3.  Select a simulator or device and run the project.

---

## ✅ Testing

The project includes both UI and Unit tests to ensure code quality.

* **UI Tests (`/DailyLockUITests`)**: Cover key user flows like onboarding, creating and locking entries, navigating the timeline, and interacting with the paywall.
* **Unit Tests (`/DailyLockTests`)**: Use the new Swift Testing framework to validate the logic of models, view models, and utility classes like `StreakCalculator` and `NavigationContext`.

To run the tests, open the Test Navigator in Xcode (`Cmd + 6`) and click the play button.

---

## 🗺️ Future Work

* Implement the `SearchView`.
* Build out the "Annual Yearbook" premium feature.
* Add custom themes and app icons.
* Expand AI insights with keyword trend analysis.

---

## 📧 Contact

Created by Gerard Gomez - [gerard@transfinite.cloud](mailto:gerard@transfinite.cloud)

---

## 📜 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
