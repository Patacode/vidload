# Changelogs

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]

### Changed

- Cli base class now split into vidload types
- Migration to new github repo

## [0.6.0] - 24/03/2026

### Added

- custom downloader to ease creation of any other custom downloaders
- support to download multiple videos in one command

## [0.5.3] - 14/03/2026

### Changed

- flag option 'non-headless' now renamed 'headless' and used as inverse

## [0.5.2] - 13/03/2026

### Changed

- shorten name of release local rake task

### Fixed

- case conversion issue

## [0.5.1] - 13/03/2026

### Changed

- auto-naming feature in mp2t downloader remove all non-alphabetic chars except
  spaces
- rake tasks split in multiple small importable rake files

### Fixed

- add missing lucky_case runtime gem dependency to perform case conversion

## [0.5.0] - 13/03/2026

### Added

- new flag option to create video file in a directory named with author name

## [0.4.0] - 13/03/2026

### Added

- flag option to run in non-headless mode

### Changed

- typical workflow in command described in README.md is now more detailed

## [0.3.4] - 13/03/2026

### Fixed

- output_dir option of mp2t downloader

## [0.3.3] - 13/03/2026

### Added

- rake task to save rubocop changes

### Fixed

- infinite download hang when using mp2t

## [0.3.2] - 13/03/2026

### Fixed

- loading messages with proper animation in mp4 downloader (spinner dependency
  was missing in required section)

## [0.3.1] - 13/03/2026

### Removed

- terminal-specific attributes in mp4 downloader

## [0.3.0] - 13/03/2026

### Added

- downloader of mp4 videos
- rubocop suggestions applied with rake 'format' task, along with commit msg

## [0.2.1] - 13/03/2026

### Added

- code formatting using rubocop gem
- rake task to format code with rubocop

### Changed

- workflow updated with code formatting step

## [0.2.0] - 13/03/2026

### Added

- option to output video in custom dir
- option to group videos by authors in separate directory

## [0.1.11] - 13/03/2026

### Added

- thor-based binary for mp2t downloader
- possibility to create mp2t downloader from thor method options

## [0.1.10] - 13/03/2026

### Added

- cli arg to provide video author name

### Changed

- auto naming for video author and title if not provided

## [0.1.9] - 13/03/2026

### Changed

- Progress bar during remuxing and reduced output

## [0.1.8] - 12/03/2026

### Added

- rake task to release gem locally for dev purpose

## [0.1.7] - 12/03/2026

### Added

- Gemfile to describe runtime and dev dependencies to be used along bundler

## [0.1.6] - 12/03/2026

### Fixed

- Closing quote (') in git commit command of `todo_task` rake task (causing
  Syntax error, now all is fine)

## [0.1.5] - 12/03/2026

### Added

- rake tasks to manage TODO.md

### Changed

- new pre-steps in typical workflow around todos

## [0.1.4] - 12/03/2026

### Added

- rake to manage project tasks
- some basic common rake tasks

### Changed

- new steps in typical workflow described in README.md around TODO.md

### Fixed

- exit status of release-dryrun.sh is now consistent (was always 1, now 0 in
  case of success and 0 otherwise)

## [0.1.3] - 12/03/2026

### Changed

- git push at the end of release.sh script

## [0.1.2] - 12/03/2026

### Changed

- add empty `[unreleased]` section when making new releases

## [0.1.1] - 12/03/2026

### Added

- todo file to list tasks to be done

## [0.1.0] - 12/03/2026

### Added

- display loading spinner during loading messages
- support download of mp2t videos
- init project
