# vidload

[<img alt="rubygems.org" src="https://img.shields.io/gem/v/vidload?logoColor=E9573F&style=for-the-badge&color=E9573F&logo=ruby" height="20">](https://rubygems.org/gems/vidload)
[<img alt="rubygems.org" src="https://img.shields.io/gem/dt/vidload?logoColor=E9573F&style=for-the-badge&color=152673" height="20">](https://rubygems.org/gems/vidload)
[<img alt="documentation" src="https://img.shields.io/badge/Documentation-blue?style=for-the-badge&logo=ruby" height="20">](https://www.rubydoc.info/gems/vidload/0.6.0)

Current version: [0.6.1](/CHANGELOG.md#061---27032026)

An extendible CLI utility to download videos from various websites

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'vidload'
```

And then execute:

```bash
bundle install
```

Or install it yourself:

```bash
gem install vidload
```

## Quick start

_To complete..._

## CLI usage

_To complete..._

## Library usage

_To complete..._

## Development

Clone the repo and install dependencies:

```bash
bundle install
```

Typical workflow:

1. Look at tasks in [TODO.md](/TODO.md)
2. Add any new desired tasks
3. Pick tasks to achieve in next release, marking them with 🎯
4. Commit changes made to [TODO.md](/TODO.md) with message _chore(todo): add/update tasks'_
5. List changes in [CHANGELOG.md](/CHANGELOG.md) under `[unreleased]` section
   - Available sections to describe changes:
     - `Added` for new features
     - `Changed` for changes in existing functionality
     - `Deprecated` for soon-to-be removed features
     - `Removed` for now removed features
     - `Fixed` for any bug fixes
     - `Security` in case of vulnerabilities
6. Commit changes made to [CHANGELOG.md](/CHANGELOG.md) with message _chore(changelog): update with
   changes of next release_
7. Apply changes to source code
8. Format code using `rubocop`
9. Commit changes made by `rubocop` with message _format(rubocop): apply suggested corrections"_
10. Checkmark achieved tasks in [TODO.md](/TODO.md)
11. Commit changes made to [TODO.md](/TODO.md) with message _chore(todo): checkmark achieved tasks_
12. Trigger a release dryrun via `./scripts/release-dryrun.sh` giving desired dump level (i.e.
    patch|minor|major)
13. Trigger a concrete release via `./scripts/release.sh` giving same dump level

All `rake` tasks available:

```bash
bundle exec rake -T
## -- Output --
rake git:changelog                  # Prepare changelogs for next release
rake git:format:update              # Save code formatting/refactoring
rake git:todo                       # Prepare todo for next release
rake git:todo:update                # Add/Update tasks in TODO.md
rake rb:format                      # Format code using rubocop
rake rb:release[bump_level]         # Release new gem version
rake rb:release:dryrun[bump_level]  # Dryrun release of new gem version
rake rb:release:local               # Release current gem version to local
```

## License

This project is licensed under the [MIT](/LICENSE) License.
