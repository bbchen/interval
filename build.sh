#! /bin/sh
set -eu

rm -fr build
mkdir -p build/release

xcodebuild clean build -scheme Timer -derivedDataPath build/private

mv build/private/Build/Products/Debug/Timer.app build/release/

commit=$(git log --format=%h HEAD -1)
(cd build/release && zip -r Timer-${commit}.zip Timer.app)
