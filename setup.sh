#!/usr/bin/env bash
#flutter pub global activate intl_utils
if [ "$1" == "" ]; then
    echo "Renaming package"
    flutter pub global activate rename
    flutter pub global run rename --bundleId $1
fi
flutter packages pub run build_runner build --delete-conflicting-outputs