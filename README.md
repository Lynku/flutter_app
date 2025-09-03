# Health Tracker Flutter App

A multi-platform application built with Flutter to track daily calories and water intake.

## Getting Started

### 1. Install Dependencies
Ensure you have the Flutter SDK installed. From the root of the project directory, run the following command to fetch all the necessary packages:

```sh
flutter pub get
```

### 2. Run the Application

You can run the application on an emulator, a connected physical device, or the web.

**To run on your selected device (Android/iOS):**
```sh
flutter run
```

**To run specifically on the Chrome web browser:**
```sh
flutter run -d chrome
```

**To see a list of all available devices:**
```sh
flutter devices
```

### 3. Running the Development Server (for Web)

If you are developing for the web and need to save data as physical JSON files (mimicking the I/O behavior), you need to run a local development server.

1.  **Start the server:**
    Open a new terminal and navigate to the `server` directory within your project:
    ```bash
    cd server
    ```
    Then, run the Dart server:
    ```bash
    dart main.dart
    ```
    This server will listen on `http://127.0.0.1:8080` and save JSON files to a `dashboard_data` directory within the `server` directory.

2.  **Run your Flutter web application:**
    In a separate terminal, run your Flutter web application as usual:
    ```bash
    flutter run -d chrome
    ```
    Your web application will now send data to the local server for file saving.
