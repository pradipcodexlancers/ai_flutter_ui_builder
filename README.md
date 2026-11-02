# Flutter UI Architect AI 🎨 ➔ 🚀

A modern Flutter application that converts uploaded UI screenshots into production-ready Flutter Dart code using **Google Gemini Vision API** (free tier).

Built with **Flutter 3.x**, **GetX (State Management, Routing, Dependency Injection)**, and clean MVC-style architecture.

---

## 🌟 Key Features

### 1. Home & Screenshot Ingestion
- **Image Picker**: Choose screenshots from Gallery or Camera.
- **Image Replacement & Preview**: View image dimensions, size, and replace at any time.
- **One-Click Built-in UI Presets**: Includes synthetic mobile screens (E-Commerce Checkout, Crypto Wallet, Profile) so you can test instantly without transferring images.
- **Optional Custom Prompts**: Add custom instructions before generating (e.g., *"Use dark mode"*, *"Make cards 16px rounded"*).

### 2. AI UI Analysis (Gemini Vision)
- **Palette Extractor**: Identifies all UI colors with exact Hex codes, visual swatches, and 1-tap copy for `ThemeData`.
- **Component Identifier**: Detects AppBars, TextFields, Buttons, Cards, Lists, Chips, and Badges.
- **Typography Hierarchy**: Analyzes font sizes, weights, and text roles.
- **Responsive Architecture**: Generates layout hierarchy notes with responsive design best practices.

### 3. Flutter Dart Code Generation
- Clean, modular, responsive Flutter Dart code.
- Uses responsive widgets (`SafeArea`, `SingleChildScrollView`, `Expanded`, `Wrap`, etc.) to prevent overflow.
- Follows Flutter Material 3 design patterns.

### 4. Code Preview
- Syntax-highlighted code viewer (`HighlightView` with Atom One Dark theme).
- 1-click **Copy to Clipboard**.
- Code statistics badge (lines of code, character count).
- **Interactive Regeneration**: Bottom sheet with prompt suggestions (e.g. *"Add form validation"*, *"Use Material 3"*) to refine code iteratively.

### 5. Live UI Preview & Comparison
- **Dynamic In-App UI Renderer**: Synthesizes and renders an interactive Flutter widget representation from the screenshot.
- **Realistic Phone Mockup Frame**: Displays notch/dynamic island, status bar, and bezel.
- **3 Comparison Modes**:
  1. **Split-Wipe Slider**: Drag slider left/right to wipe between original screenshot and generated UI.
  2. **Side-by-Side**: Side-by-side or paginated view of screenshot vs. generated UI.
  3. **Toggle Switch**: Instant 1-tap switch between original and generated UI.

---

## 📁 Architecture & Folder Structure

```
lib/
├── core/
│   ├── routes/
│   │   ├── app_pages.dart          # GetX GetPage definitions
│   │   └── app_routes.dart         # Route constant strings
│   ├── theme/
│   │   ├── app_colors.dart         # Color palette definitions
│   │   └── app_theme.dart          # Dark theme configuration
│   └── utils/
│       ├── app_constants.dart      # Storage keys, limits, endpoints
│       └── prompt_templates.dart   # Gemini multimodal vision prompts
├── data/
│   ├── models/
│   │   ├── generated_code_model.dart
│   │   └── ui_analysis_model.dart  # ColorItem, TypographyItem, UIComponentItem
│   └── repositories/
│       └── gemini_repository.dart  # Gemini repository interface & implementation
├── modules/
│   ├── home/
│   │   ├── bindings/home_binding.dart
│   │   ├── controllers/home_controller.dart
│   │   └── views/
│   │       ├── home_view.dart
│   │       └── widgets/            # ImageUploadCard, ApiKeyDialog, SamplePresets
│   ├── analysis/
│   │   ├── bindings/analysis_binding.dart
│   │   ├── controllers/analysis_controller.dart
│   │   └── views/
│   │       ├── analysis_view.dart
│   │       └── widgets/            # ColorPaletteCard, TypographyCard, ComponentsCard
│   └── code_preview/
│       ├── bindings/code_preview_binding.dart
│       ├── controllers/code_preview_controller.dart
│       └── views/
│           ├── code_preview_view.dart
│           ├── ui_preview_view.dart
│           └── widgets/            # DynamicUiRenderer, PhoneFrameWrapper, UiComparisonWidget, RegenerationBottomSheet
├── services/
│   ├── api_service.dart            # Gemini REST API service with error handling
│   └── image_service.dart          # Cross-platform image picking & validation
└── main.dart                       # App entry point with GetMaterialApp
```

---

## 🔑 Setting up Gemini API Key

You can configure your Google Gemini API Key in two easy ways:

### Option A: `.env` file (Recommended for development)
1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Get your free key from [Google AI Studio](https://aistudio.google.com/app/apikey).
3. Paste it in `.env`:
   ```env
   GEMINI_API_KEY=AIzaSyYourActualKeyHere
   ```

### Option B: Directly inside the App UI
- Launch the app and tap the **"Set API Key"** button in the AppBar.
- Paste your key and tap **Save API Key** (it is saved in local device storage via `SharedPreferences`).

---

## 🚀 Running the App

```bash
# Get dependencies
flutter pub get

# Run on macOS desktop
flutter run -d macos

# Run on Chrome Web
flutter run -d chrome

# Run on iOS Simulator / Android Device
flutter run
```
