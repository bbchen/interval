xcodebuild clean build test \
    -scheme Interval -only-testing:IntervalTests \
    -enableCodeCoverage YES clean build test

profdata=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Coverage.profdata')
bin=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Interval')
xcrun llvm-cov report "-instr-profile=$profdata" "$bin"
