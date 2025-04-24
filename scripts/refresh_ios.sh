#!/bin/sh

cd "$(dirname "$0")/.." || exit

flutter pub get

rm -rf ios/Podfile.lock

cd ios || exit

pod repo update
pod install --repo-update
