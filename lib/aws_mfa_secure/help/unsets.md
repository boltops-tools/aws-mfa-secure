Quick way to clean up AWS_* env variables.

## Example

    aws-mfa-secure unsets

## Example with Output

    $ aws-mfa-secure unsets # generates script
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    $

Eval example:

    $ eval `aws-mfa-secure unsets` # to unset
