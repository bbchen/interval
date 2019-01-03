xcodebuild clean build test \
    -scheme Interval -only-testing:IntervalTests \
    -enableCodeCoverage YES clean build test

profdata=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Coverage.profdata')
bin=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Interval')
# xcrun llvm-cov report "-instr-profile=$profdata" "$bin"

commit=$(git log --format=%h HEAD -1)

mkdir build
build_dir=$PWD/build

app_dir=$(find $HOME/Library/Developer/Xcode/DerivedData -name 'Interval.app')
(cd $app_dir/.. && zip -r "$build_dir/Interval-$commit.zip" Interval.app)
