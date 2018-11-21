xcodebuild clean build test \
    -scheme Interval -only-testing:IntervalTests \
    -enableCodeCoverage YES clean build test
xcrun llvm-cov report \
    -instr-profile=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Coverage.profdata') \
    build/derived/Build/Products/Debug/Interval.app/Contents/MacOS/Interval
