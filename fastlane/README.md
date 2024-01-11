fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the project

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Lint the source code

### ios test

```sh
[bundle exec] fastlane ios test
```

Test the build

### ios lint_staged

```sh
[bundle exec] fastlane ios lint_staged
```

Lint the source code (staged in GIT)

### ios local_ci

```sh
[bundle exec] fastlane ios local_ci
```

Local Continuous Integration checks: lint, build and test

### ios pre_commit

```sh
[bundle exec] fastlane ios pre_commit
```

Pre commit checks on staged files

### ios staging

```sh
[bundle exec] fastlane ios staging
```

Build the STAGING variant of the project

### ios prod

```sh
[bundle exec] fastlane ios prod
```

Build the PROD variant of the project

### ios match_local

```sh
[bundle exec] fastlane ios match_local
```

Fetches provisioning profiles for local device developing

### ios match_adhoc

```sh
[bundle exec] fastlane ios match_adhoc
```

Fetches provisioning profiles for adhoc builds

### ios match_app_store

```sh
[bundle exec] fastlane ios match_app_store
```

Fetches provisioning profiles for app store upload

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
