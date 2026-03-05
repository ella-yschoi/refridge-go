# RefridgeGO

> An AI-powered recipe app that starts with your fridge.

Select ingredients from your fridge, choose a cooking tool and difficulty level, and get a personalized recipe recommendation powered by OpenAI.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) 3.0+
- An [OpenAI API key](https://platform.openai.com/)

### Setup

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Set up environment variables:

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and add your OpenAI API key:

   ```
   OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxx
   ```

   The `.env` file is in `.gitignore` and will not be committed.

3. Run the app:

   ```bash
   flutter run -d chrome   # Web
   flutter run -d macos    # macOS
   flutter run -d ios      # iOS simulator
   ```

## Features

- Ingredient selection with chips UI
- Cooking tool and difficulty level selection
- AI-powered recipe generation via OpenAI API
- Recipe history with local storage
- Light / Dark mode
- Material Design 3

## Testing

```bash
flutter test                                    # Run all tests
flutter test test/e2e/recipe_flow_test.dart      # Run E2E tests
flutter test --reporter expanded                 # Verbose output
```

## Deployment

The web version is deployed on [Vercel](https://vercel.com/) with a serverless function proxy to keep the OpenAI API key secure.

## Roadmap

- iOS / Android app release

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **AI:** OpenAI API (gpt-3.5-turbo)
- **Deployment:** Vercel (Web)

## License

This project is for personal use.
