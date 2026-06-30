# 🎥 Alive

Alive is a premium, feature-rich Flutter live-streaming social network mobile application. Designed with modern visual aesthetics, smooth page transitions, and adaptive layout support, it provides users with an immersive space to discover active live streams, interact in real-time, launch live broadcasts, and customize their viewing environment with dynamic theme switching.

---

## 📱 App Demonstration

Watch the video below to see the application's core functionality, transitions, theme switching, and live feed interactions in action:

<video src="app%20functionality.mov" width="100%" controls autoplay loop muted></video>

*If the video player doesn't render above, you can access the file directly:*  
👉 **[Watch App Functionality Demonstration](app%20functionality.mov)**

---

## ✨ Key Features

- **🔐 Hybrid Authentication System**:
  - Seamless login flow supporting Google Sign-In and secure Email credentials.
  - Automatically falls back to a secure Mock Authentication flow if Firebase Core services are unavailable in local/development environments.
  
- **📺 Live Feed Exploration**:
  - A dynamic grid showcasing active stream broadcasts from around the world.
  - Interactive tab filters for stream categories: **Stream**, **Hot**, and **Follow**.
  - Geographic filtering using location pills (e.g., Global, India, Brazil, Philippines).
  - Quick-follow functionality allowing users to follow/unfollow streamers directly from the feed card.
  - Built-in pull-to-refresh to pull the latest feed data on demand.

- **🗺️ Interactive Navigation**:
  - Integrated 5-tab responsive navigation layout:
    1. **Live Feed**: Discover active streams.
    2. **Party Mode**: Join collaborative group streams, interactive gaming hubs, and voice chatrooms.
    3. **Go Live**: Set up broadcast details, toggle filters, and start high-definition streams.
    4. **Chats (Inbox)**: Stay connected with direct messages, notifications, and friends.
    5. **User Profile**: Access key user metrics, follower stats, and account settings.

- **👤 Rich Profile Card**:
  - Displays user profile pictures, display names, and registration emails.
  - Tracks user metrics: **Followers**, **Following**, and **Live Level**.
  - Secure logout trigger protected by a styled confirmation dialog box.

- **🌓 Dynamic Theme Engine**:
  - Tap the header icon to switch instantly between light and dark modes.
  - Features high-contrast dark backgrounds and elegant light layouts tailored for comfort in any lighting environment.

- **✨ Premium UI/UX Details**:
  - Customized system status bars and navigation bar overlays.
  - Modern typography powered by the **Outfit** font from Google Fonts.
  - Smooth animation fades, sliding screen transitions, and interactive scale indicators.

---

## 🛠️ Technology Stack & Libraries

- **Framework**: [Flutter](https://flutter.dev/) (SDK `^3.12.2`)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (`^9.1.1`) for predictable state flow using Cubits.
- **Backend Services**: [firebase_core](https://pub.dev/packages/firebase_core) (`^4.11.0`) & [firebase_auth](https://pub.dev/packages/firebase_auth) (`^6.5.4`).
- **OAuth Integrations**: [google_sign_in](https://pub.dev/packages/google_sign_in) (`^7.2.0`).
- **Typography & Assets**: [google_fonts](https://pub.dev/packages/google_fonts) (`^8.1.0`) and [flutter_svg](https://pub.dev/packages/flutter_svg) (`^2.3.0`).

---

## 📐 Architecture & Folder Structure

The project adopts a Clean Architecture pattern, segregating UI representation, business logic, and data sources:

```
lib/
├── core/
│   ├── constants/       # App Colors, Theme text styles, & assets
│   ├── theme/           # Light & Dark theme definitions
│   └── utils/           # Responsive helper functions for layout scaling
├── data/
│   ├── models/          # Data models (StreamModel, UserModel)
│   └── repositories/    # Repositories handling Auth & Stream state syncing
├── logic/
│   └── cubits/          # Cubit logic managers (Auth, Navigation, Stream, Theme)
├── presentation/
│   ├── screens/         # Page components (Splash, Login, Home, Chats, Go Live, Party, Profile)
│   └── widgets/         # Shared UI components
└── main.dart            # Entry point initializing dependencies & loading Cubit providers
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the Flutter SDK installed on your machine. Check your environment with:
```bash
flutter doctor
```

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd Assignment
   ```

2. **Fetch packages & dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   - Launch in debug mode on a connected simulator, emulator, or web browser:
     ```bash
     flutter run
     ```
