# Known Limitations

## Current Version: 1.0.0

This document outlines the known limitations and missing features in the current version of Interval Timer. These are intentional scope decisions for the MVP release and may be addressed in future versions based on user feedback.

---

## Feature Limitations

### 1. No Workout History / Statistics
**What's Missing:**
- No tracking of past workouts
- No statistics (total workouts, total time, etc.)
- No workout calendar or streak tracking
- No progress graphs or analytics

**Workaround:**
Users must track their workout history manually if needed.

**Future Consideration:**
Could add local database (SQLite) for workout history in v1.1+.

---

### 2. No Cloud Sync / Multi-Device Support
**What's Missing:**
- Presets don't sync across devices
- Settings don't sync across devices
- No user accounts or authentication
- No backup/restore functionality

**Workaround:**
Users must manually recreate presets on each device.

**Future Consideration:**
Could add Firebase or similar cloud backend for sync in v2.0+.

---

### 3. No Custom Sound Uploads
**What's Missing:**
- Cannot upload custom audio files
- Cannot choose from device music library
- Limited to 4 built-in sounds (start, work, rest, complete)

**Workaround:**
Users must use the provided sounds.

**Future Consideration:**
Could add file picker and custom sound management in v1.2+.

---

### 4. No Background Execution (iOS Limitation)
**What's Missing:**
- Timer pauses when app is backgrounded on iOS (without special configuration)
- Background audio requires specific implementation
- iOS requires background modes entitlement for continuous operation

**Workaround:**
Keep app in foreground during workouts. Screen stays awake to prevent accidental backgrounding.

**Technical Note:**
iOS requires `audio` background mode (which we enabled) but the timer itself won't tick in background without additional implementation. This is intentional for battery optimization.

**Future Consideration:**
Could implement background task handling, but adds complexity and battery drain.

---

### 5. No Apple Watch / Wear OS Support
**What's Missing:**
- No companion app for smartwatches
- No glanceable workout progress on watch
- No watch-based controls

**Workaround:**
Use phone directly during workouts.

**Future Consideration:**
Significant development effort. Could be v3.0+ feature if demand exists.

---

### 6. No Social Features
**What's Missing:**
- Cannot share workouts with friends
- No social media integration
- No workout challenges or competitions
- No leaderboards or achievements

**Workaround:**
Users can manually share their workout plans via text/messaging.

**Future Consideration:**
Would require backend infrastructure and user accounts.

---

### 7. Single User Only
**What's Missing:**
- No user profiles
- No user accounts
- No ability to switch between multiple users on same device
- Settings are device-wide, not per-user

**Workaround:**
If multiple people use the device, they must share settings and presets.

**Future Consideration:**
Could add simple profiles stored locally in v1.3+.

---

### 8. Limited Customization Options
**What's Missing:**
- Cannot customize app theme colors
- Cannot adjust font sizes independently
- No dark/light theme override (follows system)
- No custom countdown formats (always MM:SS)
- No ability to skip preparation phase after starting

**Workaround:**
Use system theme settings for dark/light mode.

**Future Consideration:**
Theme customization could be added in v1.4+ based on user requests.

---

### 9. No Advanced Interval Patterns
**What's Missing:**
- Cannot create pyramid intervals (increasing/decreasing times)
- Cannot create EMOM (Every Minute On the Minute) style timers
- Cannot create intervals with different work times (e.g., Round 1: 40s, Round 2: 30s)
- Cannot create "Active Rest" intervals (different activities during rest)
- No "cooldown" phase separate from rest

**Workaround:**
Use multiple presets and run them sequentially.

**Future Consideration:**
"Advanced Workout Builder" could be a premium feature in v2.0+.

---

### 10. No Export / Import Functionality
**What's Missing:**
- Cannot export presets to file
- Cannot import presets from file
- Cannot share presets with other users
- Cannot backup app data

**Workaround:**
Must manually recreate presets if app data is lost.

**Future Consideration:**
JSON export/import could be added in v1.2+.

---

## Technical Limitations

### 1. Timer Accuracy
**Current Implementation:**
- Dart's `Timer.periodic` with 1-second intervals
- Subject to system delays and scheduling
- May drift ±100-200ms over long workouts (30+ minutes)

**Impact:**
Generally not noticeable for fitness workouts, but not suitable for precision timing applications.

**Mitigation:**
We use `DateTime.now()` checks to minimize drift.

---

### 2. Audio Playback Limitations
**Current Implementation:**
- Uses `audioplayers` package
- Sounds may not play if device is muted (depends on OS)
- No ducking of other audio sources

**Impact:**
Background music may not automatically lower during cues.

**Mitigation:**
Clear audio cue descriptions in settings so users know to expect sounds.

---

### 3. Platform Differences
**Android vs iOS:**
- Haptic feedback strength differs between devices
- Screen wake lock behavior may vary by manufacturer (Android)
- Audio interruption handling differs between platforms
- Background behavior differs (iOS more restrictive)

**Impact:**
User experience may vary slightly across devices.

**Mitigation:**
Documented in user guide (if created).

---

### 4. Minimum OS Requirements
**Android:**
- Minimum SDK 21 (Android 5.0 Lollipop, 2014)
- Some older devices may have performance issues

**iOS:**
- Minimum deployment target: iOS 12.0 (2018)
- Older devices not supported

**Impact:**
Users with very old devices cannot use the app.

---

### 5. Offline Only
**Current Implementation:**
- No internet connection required
- No server-side logic
- All data stored locally

**Impact:**
- No remote updates to presets
- No cross-device sync
- No analytics for developer (no usage data collected)

**Benefit:**
Complete privacy - no data leaves the device.

---

## Performance Limitations

### 1. Device Resource Usage
**Screen Wake Lock:**
- Keeps screen on during workouts = increased battery usage
- Expected: ~10-15% battery per hour (varies by device)

**Audio Playback:**
- Minimal CPU/battery impact
- Sounds loaded into memory (small files)

**Haptic Feedback:**
- Minimal battery impact per vibration
- Cumulative effect over long workouts

---

### 2. Memory Usage
**Typical Memory Footprint:**
- ~30-50MB RAM during active use
- ~20-30MB when backgrounded (iOS)
- Sounds loaded: ~500KB total

**Impact:**
Minimal - should not cause issues even on low-end devices.

---

## Privacy & Data Limitations

### 1. No Analytics
**What's Missing:**
- No crash reporting (by default)
- No usage analytics
- No performance monitoring
- Developer has no visibility into app usage

**Impact:**
- Cannot proactively identify bugs in production
- Cannot measure feature popularity
- Relies entirely on user reports

**Benefit:**
Complete user privacy - no data collection.

**Future Consideration:**
Optional opt-in analytics could be added if users consent.

---

### 2. No User Support System
**What's Missing:**
- No in-app support chat
- No bug reporting system
- No feedback mechanism
- Support email only (see app_config.dart)

**Workaround:**
Users must email support directly for help.

---

## Localization Limitations

### 1. English Only
**Current Implementation:**
- All UI text in English
- No internationalization (i18n)
- No right-to-left (RTL) support

**Impact:**
Non-English speakers may find the app difficult to use.

**Future Consideration:**
Could add Flutter's intl package for multi-language support in v1.5+.

---

## Accessibility Limitations

### 1. Basic Accessibility Support
**What's Missing:**
- No VoiceOver/TalkBack optimization
- No high contrast mode
- No haptic feedback customization (strength, pattern)
- No audio cue volume per sound type
- No visual-only mode (for users who can't hear)

**Current Support:**
- Standard Flutter accessibility features
- Screen reader compatibility (basic)
- Dynamic type support (follows system settings)

**Future Consideration:**
Dedicated accessibility pass in v1.6+ if users request it.

---

## Scope Decisions (Intentional Omissions)

These features were considered but intentionally left out of v1.0:

1. **Video Instructions** - Not a video workout app, just a timer
2. **Exercise Library** - Not a workout planner, just a timer
3. **Calorie Tracking** - Not a fitness tracker, just a timer
4. **Heart Rate Monitoring** - Requires additional hardware integration
5. **GPS Tracking** - Not for outdoor running intervals (out of scope)
6. **Music Player Integration** - Users can use separate music apps
7. **Voice Commands** - "Hey Siri/Google, start workout" not implemented
8. **Widget Support** - Home screen widget for quick access (future consideration)

---

## Workaround Summary

For most limitations, users can:
1. Use the app as designed for basic interval timing
2. Manually track additional data in a separate app/notebook
3. Combine with other fitness apps for full workout tracking
4. Run multiple preset workouts in sequence for complex routines

---

## Future Roadmap

Based on user feedback, potential future enhancements might include:

**v1.1 - Quality of Life**
- Workout history (last 30 days, local only)
- Export/import presets (JSON)
- More sound options or volume per sound type

**v1.2 - Customization**
- Theme color options
- Custom fonts
- More preset workouts

**v1.3 - Advanced Features**
- User profiles (local)
- Advanced interval patterns (pyramid, EMOM)
- Rest phase skipping

**v2.0 - Cloud & Social**
- User accounts
- Cloud sync
- Social features (optional)
- Analytics (opt-in only)

**Note:** Roadmap is subject to change based on user needs and development resources.

---

## Reporting Issues

If you encounter a bug or have a feature request not listed here:

**Email:** support@intervaltimer.app (see `lib/core/constants/app_config.dart` for actual contact)

**Include:**
- Device model and OS version
- App version (currently 1.0.0)
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Screenshots if applicable

---

## Document Version
- **Version:** 1.0
- **Last Updated:** Pre-Release
- **Next Review:** After 1 month of public release

---

*This app is designed to be a focused, simple interval timer. Many "limitations" are intentional scope decisions to keep the app lightweight, privacy-friendly, and easy to use. Future versions may expand features based on real user needs.*
