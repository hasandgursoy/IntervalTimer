# Pre-Release Checklist

## Development Complete ✅
- [x] All features implemented (Phases 1-4)
- [x] Unit tests passing (35/35)
- [x] App branding configured
- [x] Platform-specific settings configured

## Code Cleanup
- [ ] **Remove debug print() statements** (High Priority)
  - `lib/features/timer/presentation/providers/timer_provider.dart` - 21 print statements
  - `lib/core/services/audio_service.dart` - Multiple print statements
  - `lib/core/services/audio_provider.dart` - Print statements in loaders
  - `lib/features/timer/data/repositories/preset_repository.dart` - Print statements
  - Note: Keep ERROR prints for production debugging, remove info/debug prints
  
- [ ] **Code review**
  - Review all TODOs in code
  - Check for any hardcoded test data
  - Verify no API keys or secrets in code
  - Remove commented-out code

## Testing - Functional

### Basic Workflow
- [ ] App launches successfully
- [ ] Setup screen displays correctly
- [ ] Can input valid workout configuration (work/rest/rounds/prep)
- [ ] Input validation works (shows errors for invalid values)
- [ ] "START WORKOUT" button navigates to timer screen
- [ ] Timer counts down correctly
- [ ] Pause/Resume works during all interval types
- [ ] Stop button shows confirmation dialog
- [ ] Workout completes successfully
- [ ] "DONE" button returns to setup screen

### Interval Transitions
- [ ] Preparation → Work transition works
- [ ] Work → Rest transition works
- [ ] Rest → Work (next round) transition works
- [ ] Final rest → Completion works
- [ ] Round counter updates correctly
- [ ] Total elapsed time displays correctly

### Preset System
- [ ] Can navigate to Presets screen
- [ ] Default presets load (Tabata, HIIT, Quick)
- [ ] Can load a preset (values populate setup screen)
- [ ] Can save new preset with custom name
- [ ] Cannot delete default presets
- [ ] Can delete custom presets
- [ ] Preset deletion shows confirmation
- [ ] Empty state shows when no custom presets

### Settings Screen
- [ ] Can navigate to Settings
- [ ] Sound toggle works (enable/disable)
- [ ] Volume slider works
- [ ] Volume slider disabled when sound off
- [ ] Haptic feedback toggle works
- [ ] Sound test buttons work (all 5 sounds)
- [ ] "TEST ALL SOUNDS" plays sequence
- [ ] Settings persist after app restart

### Audio & Haptic
- [ ] Start sound plays at workout start
- [ ] Work sound plays at work interval start
- [ ] Rest sound plays at rest interval start
- [ ] Complete sound plays at workout end
- [ ] Countdown beeps work (if implemented)
- [ ] Sounds respect enable/disable setting
- [ ] Volume control works correctly
- [ ] Haptic feedback triggers on transitions (if device supports)
- [ ] Haptic feedback for workout complete (stronger vibration)

## Testing - Edge Cases

### Error Handling
- [ ] Invalid input shows proper error messages
- [ ] App handles zero values gracefully
- [ ] App handles very large values (999+ seconds)
- [ ] Audio file missing doesn't crash app (fallback behavior)
- [ ] SharedPreferences failure doesn't crash app

### State Management
- [ ] Pausing during preparation works
- [ ] Pausing during final second works
- [ ] Back button during workout shows confirmation
- [ ] Navigating away and back maintains state (if applicable)
- [ ] Multiple rapid pause/resume presses don't break timer
- [ ] Stopping workout cleans up properly

### Device-Specific
- [ ] App works on small screens (4" phone)
- [ ] App works on large screens (tablet/iPad)
- [ ] App works in portrait orientation
- [ ] App works in landscape orientation (if supported)
- [ ] Screen stays awake during active workout
- [ ] Screen can sleep when paused or on setup screen
- [ ] Haptic feedback works (or gracefully fails on unsupported devices)

## Testing - Real Device (Android)

### Installation
- [ ] APK installs successfully
- [ ] App icon displays on home screen
- [ ] App name is "Interval Timer"
- [ ] App launches without errors

### Functionality
- [ ] All basic workflow tests pass
- [ ] Audio plays through device speakers
- [ ] Audio plays through Bluetooth headphones
- [ ] Vibration/haptic works
- [ ] Screen stays awake during workout
- [ ] Back button behavior is correct
- [ ] App survives screen rotation
- [ ] App survives screen lock/unlock

### Interruptions
- [ ] Incoming phone call pauses timer (or appropriate behavior)
- [ ] Notification sounds don't stop workout audio
- [ ] Low battery warning doesn't crash app
- [ ] App switching works correctly
- [ ] App resumes correctly after being backgrounded

### Performance
- [ ] No lag or stuttering during countdown
- [ ] Timer remains accurate over long workouts (30+ minutes)
- [ ] Memory usage stays reasonable
- [ ] Battery drain is acceptable
- [ ] No ANR (Application Not Responding) errors

## Testing - Real Device (iOS)

### Installation
- [ ] IPA installs successfully (TestFlight or direct)
- [ ] App icon displays on home screen
- [ ] App name is "Interval Timer"
- [ ] App launches without errors

### Functionality
- [ ] All basic workflow tests pass
- [ ] Audio plays through device speakers
- [ ] Audio plays through AirPods/Bluetooth
- [ ] Haptic feedback works
- [ ] Screen stays awake during workout
- [ ] Back/navigation behavior is correct
- [ ] App survives screen rotation
- [ ] App survives screen lock/unlock

### Interruptions
- [ ] Incoming phone call handles appropriately
- [ ] Siri activation doesn't crash app
- [ ] Control Center usage works
- [ ] Notification sounds don't interfere
- [ ] App switching works correctly
- [ ] App resumes correctly after being backgrounded

### Performance
- [ ] No lag or stuttering during countdown
- [ ] Timer remains accurate over long workouts
- [ ] Memory usage stays reasonable
- [ ] Battery drain is acceptable
- [ ] No crash reports in Console.app

## Data Persistence
- [ ] Audio settings persist after app restart
- [ ] Haptic settings persist after app restart
- [ ] Volume level persists after app restart
- [ ] Custom presets persist after app restart
- [ ] Last used workout config persists (if implemented)
- [ ] Settings survive app uninstall/reinstall (SharedPreferences behavior)

## Accessibility
- [ ] Text is readable at default size
- [ ] Text scales with system font size settings
- [ ] Touch targets are large enough (44x44pt minimum iOS, 48x48dp Android)
- [ ] Color contrast meets WCAG guidelines
- [ ] Screen readers work (basic support)

## Performance Benchmarks
- [ ] App size < 50MB
- [ ] Cold start time < 3 seconds
- [ ] Setup → Timer navigation < 500ms
- [ ] Timer tick accuracy ±100ms over 10 minutes
- [ ] Memory usage < 100MB during workout
- [ ] No memory leaks (check after 30min+ use)

## App Store Assets

### App Icon
- [ ] 1024x1024 master icon created
- [ ] Icon generated for all platform sizes
- [ ] Icon displays correctly on device
- [ ] Icon follows design guidelines
- [ ] Icon tested on light/dark backgrounds

### Screenshots
- [ ] Setup Screen screenshot (required)
- [ ] Timer Screen - Active workout (required)
- [ ] Timer Screen - Completed state
- [ ] Presets Screen
- [ ] Settings Screen
- [ ] Screenshots for all required device sizes:
  - [ ] iPhone 6.7" (iPhone 15 Pro Max, etc.)
  - [ ] iPhone 6.5" (iPhone XS Max, 11 Pro Max, etc.)
  - [ ] iPhone 5.5" (iPhone 8 Plus, etc.)
  - [ ] iPad Pro 12.9" (3rd gen+)
  - [ ] Android Phone (1080x1920 minimum)
  - [ ] Android Tablet (optional)

### App Store Listing
- [ ] **App Name:** "Interval Timer" (or your chosen name)
- [ ] **Subtitle/Short Description:** "HIIT & Workout Timer" (30 chars iOS)
- [ ] **Description written** (4000 chars max, include keywords)
- [ ] **Keywords researched and selected** (iOS: 100 chars)
- [ ] **Category selected:** Health & Fitness
- [ ] **Privacy Policy URL set** (update app_config.dart first)
- [ ] **Support URL set** (email or website)
- [ ] **Copyright text set** (current year + your name/company)

### Example Description Template:
```
Interval Timer - HIIT & Workout Timer

The ultimate interval timer for your workout routines. Perfect for HIIT, Tabata, circuit training, boxing, running intervals, and any workout that needs work/rest timing.

FEATURES:
✓ Customizable Work & Rest Intervals
✓ Multiple Rounds
✓ Preparation Timer
✓ Audio Cues for Hands-Free Workouts
✓ Haptic Feedback
✓ Save & Load Workout Presets
✓ Built-in Tabata & HIIT Presets
✓ Clean, Easy-to-Read Interface
✓ Screen Stays Awake During Workouts
✓ Pause/Resume Anytime
✓ No Ads, No Subscriptions

PRESET WORKOUTS:
• Tabata (20s work / 10s rest, 8 rounds)
• HIIT (40s work / 20s rest, 10 rounds)
• Quick Workout (30s work / 15s rest, 5 rounds)

PERFECT FOR:
• High-Intensity Interval Training (HIIT)
• Tabata Protocol
• Circuit Training
• Boxing & MMA Rounds
• Running Intervals
• Yoga & Stretching Routines
• Strength Training Circuits
• Crossfit WODs

Simple, focused, and effective. Start your workout in seconds!
```

## Technical Release Prep

### Package Names & Bundle IDs
- [ ] Android package name set: `com.yourdomain.interval_timer`
  - Update in: `android/app/build.gradle.kts`
  - Update in: `app_config.dart`
- [ ] iOS bundle ID set: `com.yourdomain.intervalTimer`
  - Update in: Xcode project settings
  - Update provisioning profile

### Version Management
- [ ] Version set to 1.0.0+1 in `pubspec.yaml` ✅
- [ ] Version matches in `app_config.dart` ✅
- [ ] Android versionCode: 1
- [ ] Android versionName: "1.0.0"
- [ ] iOS CFBundleShortVersionString: "1.0.0"
- [ ] iOS CFBundleVersion: "1"

### Build Configuration

#### Android
- [ ] **Build APK for testing:**
  ```bash
  flutter build apk --release
  ```
- [ ] **Build App Bundle for Play Store:**
  ```bash
  flutter build appbundle --release
  ```
- [ ] Signing configured (keystore created)
- [ ] ProGuard/R8 rules configured (if needed)
- [ ] `android:label` set to "Interval Timer" ✅
- [ ] Permissions declared correctly ✅
- [ ] Min SDK version appropriate (21 recommended)
- [ ] Target SDK version current (34+ recommended)

#### iOS
- [ ] **Build for testing:**
  ```bash
  flutter build ios --release
  ```
- [ ] Signing certificate configured
- [ ] Provisioning profile configured
- [ ] App capabilities set (audio background mode ✅)
- [ ] Bundle display name set ✅
- [ ] Deployment target appropriate (iOS 12.0+ recommended)
- [ ] Archive created in Xcode
- [ ] TestFlight upload successful (if using)

### Code Signing
- [ ] Android: keystore created and secure
- [ ] Android: key.properties configured
- [ ] Android: keystore password stored securely
- [ ] iOS: Developer certificate installed
- [ ] iOS: Distribution certificate installed  
- [ ] iOS: Provisioning profiles downloaded

### Legal & Compliance
- [ ] Privacy Policy written and hosted
- [ ] Terms of Service written and hosted (if needed)
- [ ] COPPA compliance reviewed (if targeting kids)
- [ ] GDPR compliance reviewed (if EU users)
- [ ] Age rating determined (4+ recommended)
- [ ] Content rating questionnaire completed

## Pre-Submission Checklist

### Google Play Store
- [ ] Google Play Developer account created ($25 one-time)
- [ ] App bundle (.aab) built and signed
- [ ] Store listing complete (title, description, screenshots)
- [ ] Content rating completed
- [ ] Pricing & distribution set
- [ ] Privacy policy URL provided
- [ ] App reviewed for policy violations
- [ ] Release notes written (What's New)
- [ ] Internal testing track used (optional but recommended)
- [ ] Production release submitted

### Apple App Store
- [ ] Apple Developer account created ($99/year)
- [ ] App ID registered in Developer Portal
- [ ] Certificates and profiles configured
- [ ] App record created in App Store Connect
- [ ] Build uploaded via Xcode or Transporter
- [ ] Build processed (wait for email confirmation)
- [ ] Screenshots uploaded (all required sizes)
- [ ] Privacy information completed
- [ ] Age rating selected
- [ ] Pricing tier set
- [ ] App reviewed for guidelines compliance
- [ ] Release notes written
- [ ] Submitted for review

## Post-Release

### Monitoring
- [ ] Monitor crash reports (Firebase Crashlytics recommended)
- [ ] Monitor user reviews and ratings
- [ ] Monitor download numbers
- [ ] Check for reported bugs
- [ ] Track user feedback

### Support
- [ ] Set up support email monitoring
- [ ] Prepare FAQ document
- [ ] Create bug reporting template
- [ ] Plan for update cycle (monthly/quarterly)

### Marketing (Optional)
- [ ] Share on social media
- [ ] Post on Reddit (r/fitness, r/HIIT, etc.)
- [ ] Create simple website/landing page
- [ ] App Store Optimization (ASO) keywords
- [ ] Consider ProductHunt launch

## Known Issues
Refer to `.ai/KNOWN_LIMITATIONS.md` for current limitations.

## Emergency Rollback Plan
- [ ] Previous version APK/IPA backed up
- [ ] Rollback procedure documented
- [ ] Team notified of release process

---

## Final Sign-Off

**Developer:** _______________  
**Date:** _______________  
**Build Number:** _______________  
**Ready for Release:** YES / NO  

**Notes:**
_____________________________________
_____________________________________
_____________________________________
