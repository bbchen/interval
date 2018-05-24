#! /bin/sh
set -eu

rm -fr build release
mkdir build release

xcodebuild clean
xcodebuild build

mv build/Release/Timer.app release

commit=$(git log --format=%h HEAD -1)
(cd release && zip -r Timer-${commit}.zip Timer.app)
