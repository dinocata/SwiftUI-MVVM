# We don't want lint errors to block a build. So all lint
# errors are converted to warnings.
# Notice that both lint warnings and lint errors are not
# acceptable in the codebase and dev will be forced to
# fix them by pre-commit and pre-push git hooks anyways.
if [ "$NO_SWIFTLINT" = "1" ]; then
    echo "Skipped swiftlint"
else
    if test -f /opt/homebrew/bin/swiftlint; then
        /opt/homebrew/bin/swiftlint | sed -e 's/ error: / warning: /g'
    else
        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
fi
