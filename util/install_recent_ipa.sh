#!/bin/bash

# Define the app bundle identifier
PACKAGE_NAME="com.woong.client"  # Replace this with your app's package name

# Check if FIRST_DEVICE is provided, otherwise set it dynamically
if [ -z "$SELECT_DEVICE" ]; then
    # Check for booted iOS simulators
    SIMULATOR_DEVICE=$(xcrun simctl list devices | grep -w "Booted" | head -n 1 | awk -F '[()]' '{print $2}')

    if [ -z "$SIMULATOR_DEVICE" ]; then
        echo "No open iOS simulators found. Please open a simulator and try again."
        exit 1
    else
        SELECT_DEVICE=$SIMULATOR_DEVICE
    fi
fi

echo "Using iOS device or simulator: $SELECT_DEVICE"

# Navigate to the Flutter project directory
cd /client

# Build the iOS app
flutter build ios --debug --dart-define=ENV=TEST

# Define the app path
APP_PATH="build/ios/iphoneos/Runner.app"

# Check if the app exists
if [ -d "$APP_PATH" ]; then
    echo "iOS app built successfully: $APP_PATH"

    # Check if the FIRST_DEVICE is a simulator
    if xcrun simctl list devices | grep -w "Booted" | grep -q "$SELECT_DEVICE"; then
        echo "Installing app on simulator: $SELECT_DEVICE"

        # Uninstall the existing app
        xcrun simctl uninstall "$SELECT_DEVICE" "$PACKAGE_NAME"

        # Install the new app
        xcrun simctl install "$SELECT_DEVICE" "$APP_PATH"

        # Launch the app
        xcrun simctl launch "$SELECT_DEVICE" "$PACKAGE_NAME"
    else
        echo "Installing app on device: $SELECT_DEVICE"

        # Uninstall the existing app
        ideviceinstaller -u "$SELECT_DEVICE" -U "$PACKAGE_NAME"

        # Install the new app
        ideviceinstaller -u "$SELECT_DEVICE" -i "$APP_PATH"
    fi
else
    echo "iOS app not found at: $APP_PATH"
    exit 1
fi
