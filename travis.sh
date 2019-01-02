xcodebuild clean build test \
    -scheme Interval -only-testing:IntervalTests \
    -enableCodeCoverage YES clean build test

profdata=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Coverage.profdata')
bin=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Interval')
# xcrun llvm-cov report "-instr-profile=$profdata" "$bin"

commit=$(git log --format=%h HEAD -1)

app_dir=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Interval.app')
mkdir build
cp -r $app_dir build/
(cd build && zip -r Interval-${commit}.zip Interval.app)
