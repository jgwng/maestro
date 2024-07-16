#!/bin/bash

# Navigate to the Flutter project directory
cd /client

fvm flutter build apk --debug --dart-define=ENV=TEST

# Define the APK path
APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
PACKAGE_NAME="com.woong.client"  # Replace this with your app's package name

# Check if the APK exists
if [ -f "$APK_PATH" ]; then
    echo "APK built successfully: $APK_PATH"

    # Use the provided FIRST_DEVICE if available, otherwise find the first connected device
    if [ -z "$SELECT_DEVICE" ]; then
        SELECT_DEVICE=$(adb devices | grep -w "device" | head -n 1 | cut -f1)
    fi

    if [ -n "$SELECT_DEVICE" ]; then
        echo "Installing APK on device: $SELECT_DEVICE"

        # Uninstall the existing app
        adb -s "$SELECT_DEVICE" uninstall "$PACKAGE_NAME"

        # Install the new APK
        adb -s "$SELECT_DEVICE" install -r "$APK_PATH"
    else
        echo "No connected devices found."
    fi
else
    echo "APK not found at: $APK_PATH"
fi
