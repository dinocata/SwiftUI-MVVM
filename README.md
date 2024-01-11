# SwiftUI MVVM demo
This is a demo iOS project which utilizes [Xcodegen](https://github.com/yonaskolb/XcodeGen), Makefile, [Swiftlint](https://github.com/realm/SwiftLint), [Sourcery](https://github.com/krzysztofzablocki/Sourcery), [Swiftgen](https://github.com/SwiftGen/SwiftGen) and [Swinject](https://github.com/Swinject/Swinject) in order to install and generate the project with all the dependencies. 

This is a modern SwiftUI+Combine replacement for the old RxSwift-MVVM [project](https://github.com/dinocata/rxswift-mvvm-demo) I made few years ago, which is now deprecated.

This app has minimal functionality and serves mainly as a showcase for how to setup a SwiftUI MVVM modular architecture which uses different tools to help you build your app faster and to make it more maintainable and improve its scalability. This is especially useful for larger projects.

### Note:
This is a work-in-progress project and will be updated in the future with further code examples.

# Tech Stack
- Swift
- SwiftUI
- Async await
- Combine

## How to install
Simply run the following commands in the root directory after pulling the project:
<code>make install</code>
<code>make project</code>

This will install all the necessary dependencies, git hooks and generate the Swift code.

## Git hooks
Whenever you pull the project or switch branches, <code>make project</code> command will be automatically executed to ensure Xcode project file references are up-to-date.

Whenever you commit on a branch, Swiftlint will be executed to validate your code. In case linting fails, whole commit will fail.
There is also a custom <code>commit-msg</code> hook for validating commit messages which also pre-pends a Jira ticket to the commit message.

## Why XcodeGen
XcodeGen provides several huge benefits:
- Ensures consistent Xcode project structure that matches the finder project structure. No more hanging dead files in the finder that aren't referenced in the Xcode project.
- Provides single centralized <code>.yml</code> file for all project-specific configuration. There is no longer a need to navigate through various tabs in the project settings to edit what you need. 
Only the custom project-specific configuration is contained in the configuration file, which ensures default configuration is unnaffected if omitted from the file.
- Simplifies dependency and target definitions. Creating a new module framework is easier than ever.
- <code>.xcodeproj</code> file can be added to <code>.gitignore</code> ensuring no more nasty <code>.pbxproj</code> file conflicts.
- Ensures that dynamically creating a new Swift file during build time will automatically add it to the Xcode project, which is especially useful when utilized with Sourcery.

## Why Makefile
Makefile is used as a "glue" to pull all the necessary dependencies (defined in <code>Gemfile</code> and <code>Brewfile</code>) and generate the whole project using two simple commands. Without it, all the depedencies would have to be manually installed one-by-one.
It also provides a custom command for running a local CI.

## Why Sourcery
This tool automatically generate boiler plate code, saving you bunch of time from writing repetitive code such as class mocks, while providing consistency and easier maintenance.

When utilized with Swinject, Sourcery can automatically generate dependency injection Containers. To inject any dependency to any class, simply use the custom <code>Injectable</code> protocol. To learn more how this works, read [this](https://blog.trikoder.net/dependency-injection-in-swift-666a6c51ca3a)https://blog.trikoder.net/dependency-injection-in-swift-666a6c51ca3a article.

## Why Swiftgen
This tool generates type-safe enums for Assets, colors and localizazations, minimizing risks of crashes or bugs when referencing missing resources.
