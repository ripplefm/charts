# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.11.0] - 2019-03-28

### Changed

* Web service bumpted to `0.4.0`

## [0.10.0] - 2019-03-28

### Changed

* Web service updated to `0.3.0` along with required environment and port updates

## [0.9.0] - 2019-03-28

### Changed

* Core API service bumped to `0.4.1`
* Auth service bumped to `0.2.3`

## [0.8.0] - 2019-03-24

### Changed

* Core API service bumped to `0.4.0`

## [0.7.0] - 2019-03-20

### Changed

* Added stations to station_templates

## [0.6.0] - 2019-03-20

### Changed

* Web service bumped to `0.2.0`

## [0.5.0] - 2019-03-20

### Changed

* CI Setup now has specific version for helm diff plugin
* Auth service version bumped to `0.2.1`

## [0.4.1] - 2019-03-18

### Added

* Readiness probe for web deployment since it takes time to start up

## [0.4.0] - 2019-03-18

### Changed

* Web service version bumped to `0.1.3`

## [0.3.1] - 2019-03-18

### Fixed

* Travis CI helm version now matches version running on cluster

## [0.3.0] - 2019-03-17

### Changed

* Sensitive values are now stored in Kubernetes secret objects
* Use helm secrets to track encrypted value files in version control
* Configure Travis CI to run `helmfile diff` on all branches and `helmfile apply` on changes to `master` branch

## [0.2.0] - 2019-03-12

### Changed

* Auth service version bumped to `0.1.5`
* Auth service now has `AUTH_DOMAIN` environment variable used for emails

## [0.1.2] - 2019-03-11

### Changed

* Traefik now requests certificate for www subdomain
* Traefik now redirects www to naked domain

## [0.1.1] - 2019-03-11

### Changed

* Traefik is now deployed as a Kubernetes Deployment instead of a Daemonset

## [0.1.0] - 2019-03-09

### Added

* Added documentation for configuration/deployment in README
