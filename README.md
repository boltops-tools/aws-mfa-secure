# AWS MFA Secure

[![Gem Version](https://badge.fury.io/rb/aws-mfa-secure.png)](http://badge.fury.io/rb/aws-mfa-secure)

Surprisingly, the [aws cli](https://docs.aws.amazon.com/cli/latest/reference/) does not yet support MFA for normal IAM users. See: https://github.com/boto/botocore/pull/1399  The aws-mfa-secure tool wraps the AWS CLI to handle MFA authentication.

## Installation

    gem install aws-mfa-secure

## Usage

Set up `mfa_serial` in credentials file for the profile section that requires it. Example:

~/.aws/credentials:

    [mfa]
    aws_access_key_id = BKCAXZ6ODJLQ1EXAMPLE
    aws_secret_access_key = ABCDl4hXikfOHTvNqFAnb2Ea62bUuu/eUEXAMPLE
    mfa_serial = arn:aws:iam::536766270177:mfa/MFAUser

Set up alias:

    alias aws="aws-mfa-secure session"

Call `aws` command like you normally would:

    aws s3 ls

Example with output:

    $ export AWS_PROFILE=mfa
    $ aws s3 ls
    Please provide your MFA code: 751888
    2019-09-21 15:53:34 my-example-test-bucket
    $ aws s3 ls
    2019-09-21 15:53:34 my-example-test-bucket
    $

You get prompted for the MFA token once and the MFA secure session lasts for 12 hours. You can override the default expiration time with `AWS_MFA_TTL`. For example, `AWS_MFA_TTL=3600` means the session expires in 1 hour instead.

Autocompletion still works with the alias.

## Calling Directly

You can also call `aws-mfa-secure session` directly.

    aws-mfa-secure session --version
    aws-mfa-secure session s3 ls

## How It Works

The wrapper `aws-mfa-secure session` command uses [sts.get_session_token](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/STS/Client.html#get_session_token-instance_method) to fetch temporary session AWS access tokens.

The tokens get saved to `~/.aws/aws-mfa-secure-sessions/AWS_PROFILE` and are then used to set the environment variables, which take the [higher precedence](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#config-settings-and-precedence).

* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_SESSION_TOKEN

The arguments are delegate the to the `aws` command.  So:

    aws-mfa-secure session s3 ls

Is the same as:

    aws s3 ls

Except using the environment `AWS_*` variables values.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
