# App Icon Design Guide

## Overview
This guide provides instructions for creating and generating app icons for the Interval Timer app.

## Design Recommendations

### Icon Concept
The app icon should clearly communicate the app's purpose: **interval training/workout timer**.

**Suggested Design Elements:**
- ⏱️ Stopwatch or timer symbol
- 🔄 Circular progress indicator
- 💪 Fitness/workout related imagery
- 🎯 Simple, bold shapes for visibility at small sizes
- ⚡ Energy/action indicators (optional)

### Design Specifications

#### Master Icon
- **Size:** 1024x1024 pixels (required for both platforms)
- **Format:** PNG with transparency OR solid background
- **Color Space:** sRGB
- **Safe Zone:** Keep important elements within center 80% (avoid edges)

#### Style Guidelines
1. **Simple & Bold:** Icon should be recognizable at small sizes (16x16 to 1024x1024)
2. **High Contrast:** Ensure good visibility on both light and dark backgrounds
3. **No Text:** Avoid text labels - use visual symbols only
4. **Platform Consistency:** Follow iOS Human Interface Guidelines and Material Design principles

#### Color Palette Suggestions
Based on the app's current theme:
- **Primary:** Blue/Teal (`#2196F3` - work interval color)
- **Accent:** Orange/Red (`#FF5722` - rest interval color)
- **Background:** White or gradient
- **Alternative:** Monochrome with bold shape

### Example Concepts
```
Concept 1: Circular Timer
┌─────────────┐
│   ⏱️ 🔄    │  Stopwatch with circular arrow
│             │
└─────────────┘

Concept 2: Split Circle
┌─────────────┐
│    ◐ ◑     │  Half blue (work) / half orange (rest)
│             │
└─────────────┘

Concept 3: Progress Ring
┌─────────────┐
│     ◯      │  Circular progress indicator with timer
│    30:00    │  (stylized, no actual text)
└─────────────┘
```

## Icon Generation

### Option 1: Using flutter_launcher_icons Package (Recommended)

#### Step 1: Add the Package
Add to `pubspec.yaml` under `dev_dependencies`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

#### Step 2: Create Configuration
Add to `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"  # Your 1024x1024 icon
  adaptive_icon_background: "#FFFFFF"      # Or use image
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
  
  # Remove old launcher icons
  remove_alpha_ios: true
  
  # Platform-specific settings (optional)
  min_sdk_android: 21
```

#### Step 3: Generate Icons
```bash
# Install the package
flutter pub get

# Generate all platform icons
dart run flutter_launcher_icons
```

This will automatically create:
- Android: `mipmap` folders with all required sizes
- iOS: `AppIcon.appiconset` with all required sizes
- Adaptive icons for Android 8.0+

### Option 2: Manual Icon Creation

#### Android Icons Required
Place in `android/app/src/main/res/`:
```
mipmap-mdpi/ic_launcher.png      (48x48)
mipmap-hdpi/ic_launcher.png      (72x72)
mipmap-xhdpi/ic_launcher.png     (96x96)
mipmap-xxhdpi/ic_launcher.png    (144x144)
mipmap-xxxhdpi/ic_launcher.png   (192x192)
```

#### iOS Icons Required
Place in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:
```
Icon-App-20x20@1x.png    (20x20)
Icon-App-20x20@2x.png    (40x40)
Icon-App-20x20@3x.png    (60x60)
Icon-App-29x29@1x.png    (29x29)
Icon-App-29x29@2x.png    (58x58)
Icon-App-29x29@3x.png    (87x87)
Icon-App-40x40@1x.png    (40x40)
Icon-App-40x40@2x.png    (80x80)
Icon-App-40x40@3x.png    (120x120)
Icon-App-60x60@2x.png    (120x120)
Icon-App-60x60@3x.png    (180x180)
Icon-App-76x76@1x.png    (76x76)
Icon-App-76x76@2x.png    (152x152)
Icon-App-83.5x83.5@2x.png (167x167)
Icon-App-1024x1024@1x.png (1024x1024)
```

## Design Tools

### Free Options
1. **Figma** (https://figma.com) - Professional design tool, free tier available
2. **Canva** (https://canva.com) - Simple icon creator with templates
3. **GIMP** (https://gimp.org) - Free Photoshop alternative
4. **Inkscape** (https://inkscape.org) - Free vector graphics editor

### Online Icon Generators
1. **App Icon Generator** (https://appicon.co) - Upload 1024x1024, generates all sizes
2. **Icon Kitchen** (https://icon.kitchen) - Android adaptive icon generator
3. **MakeAppIcon** (https://makeappicon.com) - Multi-platform icon generator

### Paid Options
1. **Adobe Illustrator** - Professional vector graphics
2. **Sketch** (Mac only) - UI/UX design tool
3. **Affinity Designer** - One-time purchase design tool

## Testing Your Icon

### Visual Checks
1. View at multiple sizes (16x16 to 1024x1024)
2. Test on both light and dark backgrounds
3. Check on actual device home screens
4. Verify clarity and recognition at distance

### Platform Testing
**Android:**
```bash
flutter run -d <android-device>
# Check home screen and app drawer
```

**iOS:**
```bash
flutter run -d <ios-device>
# Check home screen and app library
```

## Best Practices

### Do:
✅ Keep it simple and memorable
✅ Use bold, recognizable shapes
✅ Test at small sizes (thumbnail view)
✅ Ensure good contrast
✅ Follow platform guidelines
✅ Use vector graphics when possible (scale better)

### Don't:
❌ Use photos or complex gradients
❌ Include small text or fine details
❌ Copy other app icons
❌ Use copyrighted imagery
❌ Make it too busy or cluttered
❌ Ignore platform-specific guidelines

## Resources

### Official Guidelines
- [iOS Human Interface Guidelines - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Material Design - Product Icons](https://material.io/design/iconography/product-icons.html)
- [Android Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)

### Inspiration
- [Dribbble - App Icons](https://dribbble.com/tags/app_icon)
- [Behance - Mobile App Icons](https://www.behance.net/search/projects?search=mobile%20app%20icon)
- [App Store & Play Store](https://apps.apple.com) - Browse fitness timer apps

## Checklist

Before finalizing your icon:
- [ ] Master icon created at 1024x1024 pixels
- [ ] Icon looks good at 48x48 (smallest Android size)
- [ ] Icon tested on light background
- [ ] Icon tested on dark background
- [ ] No text used in icon design
- [ ] Important elements within safe zone
- [ ] Icon matches app's purpose and branding
- [ ] flutter_launcher_icons configured in pubspec.yaml
- [ ] Icons generated for all platforms
- [ ] Tested on real Android device
- [ ] Tested on real iOS device
- [ ] App builds successfully with new icons

## Next Steps

1. Create your 1024x1024 master icon
2. Place it in `assets/icon/app_icon.png` (create folder if needed)
3. Add flutter_launcher_icons to dev_dependencies
4. Configure flutter_launcher_icons in pubspec.yaml
5. Run `flutter pub get`
6. Run `dart run flutter_launcher_icons`
7. Build and test on devices
8. Iterate based on how it looks on actual home screens

---

**Need Help?** Check the official Flutter documentation or the flutter_launcher_icons package documentation for troubleshooting.
