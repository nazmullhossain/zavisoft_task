# havisoft-Task



A Flutter application that mimics a Daraz-style product listing with collapsible header, sticky tabs, local search, and user profile integration using the Fake Store API.

## 📱 Features

-  **Collapsible Header** - Header smoothly collapses when scrolling up, expands when scrolling down
-  **Sticky Tab Bar** - Tab bar remains visible at the top when header collapses
-  **3 Product Categories** - Men's Clothing, Women's Clothing, Electronics
-  **Horizontal Swipe** - Switch tabs by swiping left/right
-  **Pull to Refresh** - Works from any tab
-  **Scroll Position Preservation** - Scroll position is saved per tab and restored when switching
-  **Local Search** - Real-time search across all products
-  **User Profile** - Login and display user profile from Fake Store API
-  **Single Scroll Architecture** - No scroll conflicts, one vertical scroll for entire screen

##  How to Run the App

### Prerequisites
- Flutter SDK installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Android Studio  setup


### Steps to Run

1. -  project clone ((https://github.com/nazmullhossain/zavisoft_task.git))
   

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```


##  Login Credentials

The app uses [Fake Store API](https://fakestoreapi.com/) for authentication:

```
Username: johnd
Password: m38rmF$
```

The app will auto-login when started.



### 1. How Horizontal Swipe Was Implemented

Horizontal swipe is implemented using a `GestureDetector` wrapping the `TabBarView` with `NeverScrollableScrollPhysics()`:



**Why this works:**
- `NeverScrollableScrollPhysics()` prevents TabBarView from handling its own horizontal scrolls


### 2. Who Owns the Vertical Scroll and Why

**The vertical scroll is owned by the parent `CustomScrollView` with a single `ScrollController`.**



