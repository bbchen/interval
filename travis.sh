xcodebuild clean build test \
    -scheme Interval -only-testing:IntervalTests \
    -enableCodeCoverage YES \
    -derivedDataPath build/derived clean build test
xcrun llvm-cov report \
    -instr-profile=$(find build/derived/Build/ -name 'Coverage.profdata') \
    build/derived/Build/Products/Debug/Interval.app/Contents/MacOS/Interval
