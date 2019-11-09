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

Autocompletion still works with the alias.

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

## Calling Directly

You can also call `aws-mfa-secure session` directly. The arguments are delegated to the aws cli. 

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

## Exports

You can also generate the exports script.

    $ aws-mfa-secure exports
    Please provide your MFA code: 147280
    export AWS_ACCESS_KEY_ID=ASIAXZ6ODJLBCEXAMPLE
    export AWS_SECRET_ACCESS_KEY=HgYHvNxacSsFSwls1FO9RoF5+tvYCFIABEXAMPLE
    export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEJ3//////////wEaCXVzLWVhc3QtMSJGMEQCIGnuGzUr8aszNWMFlFXQvFVhIA6aGdx3DskqY1JaIZWVAiANfE3xA79vIMVTqLnds4F2LpDy/qUeNRr7e9g9VQoS9SqyAQi2//////////8BEAEaDDUzNjc2NjI3MDE3NyIMgDgauwgJ4FIOMRV+KoYBRKR/MnKFB9/Q0Isc6D8gpG404xGJWqStNfGS0sHNsB5vVP/ccaAj4MG54p0Pl+V0LuIMXy345ua/bxxQFDWqhG0ORsXFEOo3iD1IQ+YA/yougAUl/0hbyvK3Jnf3NEHDejdL95iFCluJhoR0zFlDv7GwwBSXLUxS9K96/vgA0MmgK9a7kaAwoYiZ7gU63wHVDNYa1myqIP16Mi6KZ2zm9inMofixNN1ea3JMyRW+chWW8kdjjW4R3MFecpwoIayE7g3QLanmjE3jzrlxjIJWnl8tiipV+jassiSdlxLL2j1IIFH2pNEqrn4hkHG5t7OG+qZCTl8AnQ4W5wusmBoSIavr5w0dOdyx2mdsBMFtO82ZXvHSryY1gbIM9JyUd7dJ9h/mkfGL2p0n0R/lya8s9j8P8/8if+2uQcF+/BGDxojJ67kYXgstgfLjM5j8pZgyYj6YUFyTpyiOkllbPk/AjyxJY1svxW25wbNO+c13
    $

You can eval it to set the environment variables in one go:

    $ eval `aws-mfa-secure exports`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
