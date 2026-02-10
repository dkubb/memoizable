# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2026-02-09

### Added

- `Memory#delete` method to remove a specific memoized value from cache
- `Memory#clear` method to remove all memoized values from cache
- `Memory#fetch` now accepts an optional default argument
- Steep for static type checking
- Mutant for mutation testing
- RuboCop and Standard Ruby for linting
- YARD and Yardstick for documentation coverage
- GitHub Actions CI pipeline (replacing Travis CI)
- GitHub Actions workflow for publishing gems to RubyGems with Sigstore attestation

### Changed

- Renamed `Memory#[]=` to `Memory#store`
- `ModuleMethods#memoize` now raises `ArgumentError` when method is already memoized
- Memoization cache now uses composite keys `[class, method_name]` to support inheritance ([#13](https://github.com/dkubb/memoizable/issues/13))
- Replaced `thread_safe` gem dependency with Ruby's built-in `Monitor`

### Removed

- `Memory#key?` method
- `ModuleMethods#memoized?` method
- `ModuleMethods#included` method
- `thread_safe` gem dependency

## [0.4.2] - 2014-03-27

### Changed

- Updated `thread_safe` dependency to use semantic versioning compatible version

## [0.4.1] - 2014-03-04

### Added

- Support for Ruby 2.1.0

### Changed

- Updated `thread_safe` dependency to ~> 0.2.0

## [0.4.0] - 2013-12-24

### Added

- `Memory#marshal_dump` and `Memory#marshal_load` methods for Marshal serialization support ([#10](https://github.com/dkubb/memoizable/issues/10))

## [0.3.1] - 2013-12-18

### Changed

- Added double-checked locking to `Memory#fetch` for improved thread safety

### Removed

- Unnecessary `Memory#set` method

## [0.3.0] - 2013-12-15

### Added

- Thread-safe memory operations using `thread_safe` gem
- `BlockNotAllowedError` raised when passing a block to memoized methods
- `ModuleMethods#included` to allow module methods to be memoized

### Changed

- Memory is now shallowly frozen after initialization

## [0.2.0] - 2013-11-18

### Added

- Core memoization functionality
- `Memoizable::MethodBuilder` for memoized method creation
- `InstanceMethods#memoize` to manually set memoized values
- `InstanceMethods#freeze` support for frozen objects
- `ModuleMethods#unmemoized_instance_method` to access original method
- Thread-safe cache using `ThreadSafe::Cache`

[Unreleased]: https://github.com/dkubb/memoizable/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/dkubb/memoizable/compare/v0.4.2...v0.5.0
[0.4.2]: https://github.com/dkubb/memoizable/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/dkubb/memoizable/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/dkubb/memoizable/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/dkubb/memoizable/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/dkubb/memoizable/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/dkubb/memoizable/compare/v0.0.0...v0.2.0
