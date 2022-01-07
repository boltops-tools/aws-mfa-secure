# Change Log

All notable changes to this project will be documented in this file.
This project *tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.4.4] - 2022-01-07
- [#5](https://github.com/tongueroo/aws-mfa-secure/pull/5) fix activesupport require

## [0.4.3] - 2020-12-10
- [#4](https://github.com/tongueroo/aws-mfa-secure/pull/4) require singleton

## [0.4.2]
- add helpful message

## [0.4.1]
- #3 no-mfa option for exports

## [0.4.0]
- #2 do not eager load ext/aws.rb

## [0.3.8]
- fix edge case when aws profile not found

## [0.3.7]
- check aws cli is fully setup

## [0.3.6]
- #1 speed up iam_mfa? detection with AWSConfig parser

## [0.3.5]
- prompt for mfa when using AWS_* env and `AWS_MFA_SERIAL`

## [0.3.4]
- always set AWS_* env vars when in iam_mfa mode

## [0.3.3]
- fix aws_cli_installed? check

## [0.3.2]
- check for aws_cli_installed, allow to work on aws lambda

## [0.3.1]
- allow specs to pass in other projects

## [0.3.0]
- require aws_mfa_secure so ext can be one line: require "aws_mfa_secure/ext/aws"

## [0.2.0]
- add clean command
- flush memo cache for updated aws tokens

## [0.1.0]
- Initial release.
