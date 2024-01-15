# SwiftUI MVVM demo
This is a demo iOS project which utilizes [Xcodegen](https://github.com/yonaskolb/XcodeGen), Makefile, [Swiftlint](https://github.com/realm/SwiftLint), [Sourcery](https://github.com/krzysztofzablocki/Sourcery), [Swiftgen](https://github.com/SwiftGen/SwiftGen) and [Swinject](https://github.com/Swinject/Swinject) in order to install and generate the project with all the necessary dependencies. 

This is a modern SwiftUI+Combine replacement for the old RxSwift-MVVM [project](https://github.com/dinocata/rxswift-mvvm-demo) I made few years ago, which is now deprecated.

This app has minimal functionality and serves mainly as a showcase for how to setup a SwiftUI MVVM modular architecture which uses different tools to help you develop your app faster, to make it more maintainable and to improve its scalability. This is especially useful for larger projects.

### Note:
This is a work-in-progress project and will be updated in the future with further code examples.

### Todos:
- User defaults store manager
- Dark-light mode switcher
- Form view for creating new articles and editing existing ones
- Creating new devices on the API using a <code>POST</code> example
- Background caching of devices fetched from network API
- Possibly more stuff in the future...

## Tech Stack
- Swift
- SwiftUI
- Combine
- Async await

This is not just a mashup of bunch of different tools and frameworks just to have it in the project for the sake of it. All the tools and frameworks are used with specific purpose where it was appropriate so they properly complement each other without overlapping.

Tools such as Xcodegen and Sourcery might be overkill for small projects, but will be both a life and time saver for large projects, as long as you use them properly, just like any tool. 🔨 

Luckily, they are really easy to use and require minimal maintenance after an initial setup.

## How to install
Simply run the following commands in the root directory after pulling the project:

<code>make install</code> (required only once or when you want to update dependency versions)

<code>make project</code>

This will install all the necessary dependencies, git hooks and generate the Xcode project. 

Run <code>make project</code> whenever you change the <code>project.yml</code> configuration file.

## Git hooks
Whenever you pull the project or switch branches, <code>make project</code> command will be automatically executed to ensure Xcode project file references are up-to-date.

Whenever you commit on a branch, Swiftlint will be executed to validate your code. In case linting fails, whole commit will fail.
There is also a custom <code>commit-msg</code> hook for validating commit messages which also prepends a Jira ticket to the commit message.

## Why XcodeGen
XcodeGen will save you time and headaches. It provides several benefits:
- Ensures consistent Xcode project file structure that matches the finder file structure. No more hanging dead files in the finder that aren't referenced anywhere in the Xcode project.
- Provides a single centralized <code>project.yml</code> file for all project-specific configuration. There is no longer need to navigate and search through various tabs in the project settings to edit what you need with a risk to mess something up. 
Only the custom project-specific configuration is contained in the configuration file, which ensures default configuration is unnaffected if omitted from the file.
- Simplifies dependency and target definitions. Creating a new module framework is easier than ever.
- <code>.xcodeproj</code> file can be added to <code>.gitignore</code> ensuring no more nasty <code>.pbxproj</code> file conflicts.
- Ensures that dynamically creating a new Swift file during build time will automatically add it to the Xcode project, which is especially useful when utilized with Sourcery.

## Why Makefile
Makefile is used as a "glue" to pull all the necessary dependencies (defined in <code>Gemfile</code> and <code>Brewfile</code>) and generate the whole project using two simple commands. Without it, all the depedencies would have to be manually installed one-by-one.
It also provides a convenient custom command for running a local CI and several other custom commands.

## Why Sourcery
This tool automatically generates boiler plate code, saving you bunch of time from writing repetitive code such as class mocks or dependency injection containers, while providing consistency and better code maintenance.

When utilized with Swinject, Sourcery can automatically generate dependency injection containers for you. To inject any dependency to any class, simply use the custom <code>Injectable</code> protocol. To learn more how this works, read [this](https://blog.trikoder.net/dependency-injection-in-swift-666a6c51ca3a) article on how to setup automized dependency injection in Swift.

## Why Swiftgen
This tool generates type-safe enums for Assets, colors and localizations, minimizing risks of crashes or bugs when referencing missing resources while improving maintainability and consistency. It complements well with Sourcery.

## License
This repository code uses the MIT license, therefore you are free (and encouraged) to use it and modify it to your liking. Still, it would be highly appreciated if you drop a star if you found it helpful. 

For any question or feedback send me an email at dino.chata@gmail.com
