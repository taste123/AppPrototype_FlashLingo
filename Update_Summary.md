# 📝 Project Updates & Optimization Changelog (FlashLingo)

This document provides a concise and comprehensive record of all specific updates, bug fixes, and performance optimizations implemented in the **FlashLingo** codebase (`AppPrototype_FlashLingo`).

---

## 📌 Detailed Breakdown of Changes by File

### 1. App Configuration & Native Platforms
* **`lib/main.dart`**
  * Locked the device screen orientation to portrait only (`DeviceOrientation.portraitUp` & `DeviceOrientation.portraitDown`) using `SystemChrome.setPreferredOrientations` to prevent layout breaks when the device is rotated.
* **`android/app/src/main/AndroidManifest.xml`**
  * Updated the Android application label from `learn` to `FlashLingo`.
  * Added the `android.permission.INTERNET` permission.
* **`ios/Runner/Info.plist`**
  * Updated `CFBundleDisplayName` to `FlashLingo`.
  * Removed landscape orientations from `UISupportedInterfaceOrientations` to ensure portrait-only mode on iOS devices.
* **`pubspec.yaml`**
  * Adjusted the Dart SDK constraint from `^3.13.2` to `^3.12.0` for broader compatibility across developer Flutter environments.

---

### 2. Data Layer: `lib/data/progress_manager.dart`
* **Baseline Behavior:**
  Every time the UI queried category scores (`getLevelScore`), completion status (`hasPassedLevel`), or stored scores, it re-read strings from `SharedPreferences` and ran `jsonDecode()`. This caused unnecessary I/O and CPU overhead during grid rendering on the home screen.
* **Optimizations Implemented:**
  * Added in-memory caching via `_cachedCompletedLevels` and `_cachedLevelScores`.
  * Moved JSON decoding into the constructor so it executes **only once** at app startup.
  * Exposed data through `List.unmodifiable` and `Map.unmodifiable` to ensure immutability and fast $O(1)$ memory access.
  * Only writes to persistent storage when a new score is strictly higher than the recorded score (`score > currentScore`).

---

### 3. Core UI Widgets: `lib/ui/widgets/`
* **`app_background.dart`**
  * **Before:** Wrapped the background image inside an `Opacity(opacity: 0.55, child: ...)` widget, which triggered an expensive offscreen buffer (`saveLayer`) pass on the GPU.
  * **After:** Removed `Opacity` and replaced it with native `color: Color.fromRGBO(255, 255, 255, 0.55)` and `colorBlendMode: BlendMode.modulate` on `Image.asset`. The background is now drawn in a single raster pass with zero offscreen layer overhead.
* **`buttons.dart`**
  * **TactileScale:** Refined the return spring animation using `Curves.elasticOut` (220ms duration) and integrated tactile haptic feedback (`HapticFeedback.lightImpact()`).
  * **ShakeWidget (New Component):** Built a reusable shake animation widget based on damped sine wave oscillation `sin(val * pi * 4)` paired with `HapticFeedback.mediumImpact()`. It provides playful and intuitive tactile/visual feedback when children make mistakes or tap locked categories.

---

### 4. Home Screen: `lib/ui/home_screen.dart`
* **Floating Logo:** Added a continuous, gentle vertical floating animation to the header logo using `AnimatedBuilder` and `_floatAnimation`.
* **Staggered Scale Entrance:** Category cards now appear with a staggered, springy scale-up entrance animation using `TweenAnimationBuilder` and `Curves.easeOutBack`.
* **Locked Category Feedback:** Tapping a locked category triggers the `ShakeWidget` wobble animation and haptic vibration instead of remaining unresponsive.
* **Progress Percentage Badge:** Added an interactive pill badge displaying the percentage of total stars collected (e.g., `24 / 27 (89%)`) beside the star meter.

---

### 5. Flashcard Screen: `lib/ui/flashcard_screen.dart`
* **Swipe Gestures:** Enabled natural horizontal swipe gestures (swipe left for Next, swipe right for Prev) on cards using `GestureDetector.onHorizontalDragEnd`.
* **Slide Transition Animation:** Added an `AnimationController` for smooth horizontal slide transitions when navigating between cards.
* **Vocabulary Text Transitions:** English and Indonesian text labels now transition smoothly using `AnimatedSwitcher` combining `ScaleTransition` and `FadeTransition`.
* **Micro-Interactions & Haptics:** Added `HapticFeedback.selectionClick()` on card navigation and visual interaction pills (*"Tap to flip"* / *"Tap to flip back"*).
* **Bitmap Memory Optimization:** Added `cacheWidth: 800` on `Image.asset` to downsample high-resolution assets and conserve device RAM.

---

### 6. Quiz Screen & Minigames: `lib/ui/quiz_screen.dart`
* **GPU & Memory Optimization:**
  * Reduced `ImageFilter.blur` intensity on modal sheets from `sigma: 12` to `sigma: 8` for smoother 60 FPS mobile rendering.
  * Added `cacheWidth: 500` to downsample minigame option images.
* **Modal & Star Popping Animations:**
  * The quiz completion dialog enters with an elastic scale pop (`Curves.elasticOut`).
  * Stars pop in with staggered, sequential bounce delays.
* **Drag & Drop Minigame:**
  * Lifted draggable chips scale up to 1.1x for clear touch feedback.
  * Successfully matched slots display a vibrant green glow border and an elastic pop effect.
* **Scramble (Word Builder) Minigame:**
  * Sanitized target strings from spaces, underscores, and hyphens using regex `.replaceAll(RegExp(r'[\s\-_]'), '')`.
  * Connected every letter tile to a `ShakeWidget`; tapping an incorrect letter tile triggers a wobble animation and haptic vibration.
* **Pick (Card Selection) Minigame:**
  * Incorrect answer cards shake and trigger haptic feedback.
  * The prompt word changes smoothly with `AnimatedSwitcher`.
* **Memory Leak & Crash Prevention:**
  * Added `if (!mounted) return;` guards before all `setState` calls inside asynchronous `Future.delayed` timers to prevent exceptions when a user navigates away mid-game.

---

## 📊 Summary Table of Updates

| Module / File | Change Type | Key Highlights |
| :--- | :--- | :--- |
| `AndroidManifest.xml` & `Info.plist` | Configuration | Renamed app to FlashLingo, added Internet permission, locked iOS to portrait. |
| `main.dart` | Configuration | Programmatically enforced portrait orientation. |
| `progress_manager.dart` | Performance / Cache | In-memory cache for scores and level progress; removed repeated JSON parsing. |
| `app_background.dart` | Render Performance | Replaced `Opacity` with `BlendMode.modulate` (zero GPU `saveLayer` overhead). |
| `buttons.dart` | Components / UX | Added `ShakeWidget`, haptic feedback, and elastic spring curves. |
| `home_screen.dart` | UI / UX | Floating logo, staggered card entrance, locked category shake, progress percentage. |
| `flashcard_screen.dart` | Features / UX | Horizontal swipe gestures, card slide animation, text transitions, `cacheWidth: 800`. |
| `quiz_screen.dart` | Logic / Gamification | Incorrect option shake, star pop-ins, drag glowing borders, `mounted` safety guards. |
| `pubspec.yaml` | Environment | Adjusted SDK constraint to `^3.12.0` for wider compatibility. |
