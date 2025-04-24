#!/bin/sh

cd "$(dirname "$0")/.." || exit

flutter clean
flutter pub get
flutter build appbundle
