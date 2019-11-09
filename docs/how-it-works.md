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

Except using the session environment `AWS_*` variables values.
