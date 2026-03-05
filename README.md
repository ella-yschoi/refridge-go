# RefridgeGO

> An AI-powered recipe app that starts with your fridge

<br/>

## 🚀 Quick Start

1. **Install Flutter** (if not already installed)

   ```bash
   # Visit https://flutter.dev/docs/get-started/install
   flutter doctor
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Set Up Environment Variables**

   Copy the example file and add your API key:

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and replace `your_api_key_here` with your actual OpenAI API key:

   ```
   OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxx
   ```

   > **How to get an OpenAI API key:**
   > 1. Sign up at [platform.openai.com](https://platform.openai.com/)
   > 2. Go to **API Keys** section
   > 3. Click **Create new secret key**
   > 4. Copy the key (starts with `sk-`)
   >
   > Note: API usage requires a paid account with credits. The app uses `gpt-3.5-turbo` which costs ~$0.002 per recipe generation.

   The `.env` file is already in `.gitignore` — your API key will not be committed.

4. **Run the App**
   ```bash
   flutter run
   ```

   To run on a specific platform:
   ```bash
   flutter run -d chrome   # Web browser
   flutter run -d macos    # macOS desktop
   flutter run -d ios      # iOS simulator
   ```

<br/>

## 🎯 Features

- Ingredient selection with chips
- Cooking tool selection
- Difficulty level selection
- AI-powered recipe generation via OpenAI API
- Recipe history storage
- Dark mode support
- Modern Material Design 3 UI

<br/>

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/e2e/recipe_flow_test.dart

# Run with verbose output
flutter test --reporter expanded
```

<br/>

## 🛠️ Tech Stack

- Framework: Flutter
- Language: Dart
- API: OpenAI API
