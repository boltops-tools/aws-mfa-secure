## Examples

    aws-mfa-secure completion

Prints words for TAB auto-completion.

    aws-mfa-secure completion
    aws-mfa-secure completion hello
    aws-mfa-secure completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(aws-mfa-secure completion_script)

Auto-completion example usage:

    aws-mfa-secure [TAB]
    aws-mfa-secure hello [TAB]
    aws-mfa-secure hello name [TAB]
    aws-mfa-secure hello name --[TAB]
