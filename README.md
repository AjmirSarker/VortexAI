VortexAI - AI-Powered Chat App
VortexAI Banner
Unleash the power of conversation with VortexAI!
VortexAI is a sleek, modern Flutter-based chat application that integrates the Gemini AI API to provide intelligent, context-aware responses. With a stunning gradient UI, image support, and a user-friendly interface, VortexAI offers a seamless chatting experience powered by artificial intelligence.
Features
AI Conversations: Chat with VortexAI, powered by the Gemini API, for smart and responsive replies.

Image Support: Upload images from your gallery and ask VortexAI to describe or analyze them.

Beautiful UI: A visually appealing gradient design with a deep space navy to electric sky blue AppBar and an arctic night blue to ice glow body.

Typing Indicator: See "VortexAI is typing" while the AI processes your message.

Error Handling: User-friendly error messages keep the experience smooth, even when issues arise.

Contextual Prompts: Send messages with conversation history (currently simplified to avoid API errors).


Getting Started
Prerequisites
Flutter: Ensure you have Flutter installed (version 3.0.0 or higher recommended). Run flutter doctor to verify your setup.

Gemini API Key: Obtain an API key from the Google Cloud Console for the Gemini API.

Android/iOS Device or Emulator: For testing the app.

Installation
Clone the Repository:
bash

git clone https://github.com/yourusername/vortexai.git
cd vortexai

Install Dependencies:
bash

flutter pub get

Ensure your pubspec.yaml includes:
yaml

dependencies:
  flutter:
    sdk: flutter
  dash_chat_2: ^0.1.0
  flutter_gemini: ^2.0.0
  image_picker: ^1.0.0

Configure API Key:
Open lib/main.dart and add your Gemini API key:
dart

void main() {
  Gemini.init(apiKey: 'YOUR_API_KEY_HERE');
  runApp(const MaterialApp(home: HomePage()));
}

Set Permissions (Android):
Edit android/app/src/main/AndroidManifest.xml:
xml

<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

Run the App:
bash

flutter run

Building the APK
To create a release APK:
bash

flutter build apk --release

Output: build/app/outputs/flutter-apk/app-release.apk

See Flutter documentation for signing instructions.

Usage
Text Chat: Type a message in the input field and press send to chat with VortexAI.

Image Chat: Tap the image icon, select a photo, enter a prompt in the dialog, and send.

Error Messages: If something goes wrong, VortexAI will display a friendly message like "Oops, something went wrong. Try again!"

Project Structure

vortexai/
├── android/             # Android-specific files
├── ios/                 # iOS-specific files
├── lib/                 # Main Dart code
│   ├── main.dart        # App entry point
│   └── home_page.dart   # HomePage widget with chat logic and UI
├── pubspec.yaml         # Dependencies and configuration
└── README.md            # This file

Known Issues
Gemini API Response: The app occasionally returns "instance of 'TextPart'" instead of actual text. This is a parsing issue with flutter_gemini—help fixing _extractAnswerFromResponse is welcome!

HTTP 400 Error: Simplified prompts to avoid bad request errors; context-aware prompts need refinement.

Contributing
We’d love your help to make VortexAI even better! Here’s how to contribute:
Fork the Repository: Click "Fork" on GitHub.

Create a Branch: git checkout -b feature/your-feature-name

Commit Changes: git commit -m "Add your feature"

Push to GitHub: git push origin feature/your-feature-name

Open a Pull Request: Submit your changes for review.

Please follow the Flutter style guide and include tests if applicable.

