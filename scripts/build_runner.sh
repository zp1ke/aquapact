#!/bin/sh

cd "$(dirname "$0")/.." || exit

dart run build_runner build
