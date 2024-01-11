.PHONY: \
	help \
	check \
	check-rbenv \
	check-gem \
	check-gems \
	check-git-hooks \
	install-gems \
	install-git-hooks \
	update-ruby-version \
	update-ruby-gems \
	update-ruby \
	test \
	lint \
	staging \
	prod \
	local_ci \

ifeq ($(DEBUG),1)
Q=
else
Q=@
endif

help:
	@echo "Check, Install and Build the project"
	@echo "To get debug shell command logs, please run with DEBUG=1 - e.g. 'make lint DEBUG=1'"
	@echo ""
	@echo "Install dependencies:"
	@echo "  make install"
	@echo ""
	@echo "Check dependencies and setup:"
	@echo " make check"
	@echo ""
	@echo "Generate Xcode project:"
	@echo " make project"
	@echo ""
	@echo "Lint the source code:"
	@echo "	make lint"
	@echo ""
	@echo "Build commands (default configuration: Debug)"
	@echo ""
	@echo "Build the STAGING variant"
	@echo " make STAGING CONFIGURATION=Debug"
	@echo ""
	@echo "Build the prod variant"
	@echo " make prod CONFIGURATION=Release"
	@echo ""
	@echo "Test the built software (default variant: STAGING, default configuration: Debug)"
	@echo " make test"
	@echo ""
	@echo "Run the local CI pipeline (lint, build, test):"
	@echo " make local_ci"

GEM=gem
BUNDLE=bundle
BUNDLE_EXEC=$(BUNDLE) exec
FASTLANE=$(BUNDLE_EXEC) fastlane
RBENV=rbenv
RUBY=ruby
HOMEBREW=brew
RUBY_VERSION=3.2.2
SHA1SUM:=$(shell which sha1sum 2>/dev/null || which shasum)

FLAVOR_STAGING=STAGING
FLAVOR_PROD=PROD

CONFIGURATION_DEBUG=Debug
CONFIGURATION_RELEASE=Release

FLAVOR?=$(FLAVOR_STAGING)
CONFIGURATION?=$(CONFIGURATION_DEBUG)

install-gems:
	$(Q)if ! `$(SHA1SUM) -c -q .installed-gemfile 2>/dev/null`; then \
		echo "Downloading and installing Gems..."; \
		BUNDLE_FROZEN=true $(BUNDLE) install --quiet || (echo "ERROR: Could not install deps" 1>&2; exit 1); \
		$(SHA1SUM) Gemfile.lock .ruby-version > .installed-gemfile; \
	fi

install-git-hooks:
	$(Q)echo "Installing Git hooks..."; \
        utils/git/install-git-hooks.sh && echo "Git hooks installed successfully"

install-homebrew-dependencies:
	$(Q)$(HOMEBREW) bundle

check-rbenv:
	$(Q)which $(RBENV) >/dev/null || which $(RUBY) | grep asdf >/dev/null || (echo "ERROR: Please use rbenv or asdf-vm in order not to mess with the system's ruby https://rubygems.org/pages/download also, FYI, here's how to use it https://gist.github.com/stonehippo/cc0f3098516fb52390f1"  1>&2; exit 1)

check-gem:
	$(Q)which $(GEM) $(BUNDLE) >/dev/null || (echo "ERROR: Please install https://rubygems.org/pages/download" 1>&2; exit 1)

check-gems: check-gem
	$(Q)$(BUNDLE) check

check-homebrew:
	$(Q)which $(HOMEBREW) > /dev/null ||  (echo "ERROR: Please install https://brew.sh" 1>&2; exit 1)
	$(Q)$(HOMEBREW) bundle check

update-ruby-version:
	$(RBENV) install -s $$RUBY_VERSION && \
	$(RBENV) local $$RUBY_VERSION

update-ruby-gems: update-ruby-version
	$(Q)$(GEM) update
	$(Q)rm -f Gemfile.lock
	$(Q)$(BUNDLE) lock

update-ruby: update-ruby-version update-ruby-gems
	$(Q)make install-gems

check: check-homebrew check-rbenv check-gems
install: update-ruby install-git-hooks install-homebrew-dependencies project

lint: install-gems
	$(Q)$(FASTLANE) lint

staging: install-gems
	$(Q)$(FASTLANE) staging configuration:$(CONFIGURATION)

prod: install-gems
	$(Q)$(FASTLANE) prod configuration:$(CONFIGURATION)

test: install-gems
	$(Q) arch -x86_64 $(FASTLANE) test flavor:$(FLAVOR) configuration:$(CONFIGURATION)

local_ci: install-gems
	$(Q) arch -x86_64 $(FASTLANE) local_ci flavor:$(FLAVOR) configuration:$(CONFIGURATION)

pre-commit: install-gems
	$(Q)$(FASTLANE) pre_commit

pre-push: install-gems
	$(Q) arch -x86_64 make local_ci

project: install-gems
	$(Q) sourcery
	$(Q) swiftgen
	$(Q) xcodegen
	$(Q) mkdir -p SwiftUI-MVVM.xcodeproj/project.xcworkspace/xcshareddata

match-local:
	$(Q)$(FASTLANE) match_local
