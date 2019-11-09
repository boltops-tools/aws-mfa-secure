## Example

    aws-mfa-secure exports

## Example with Output

    $ aws-mfa-secure exports
    Please provide your MFA code: 147280
    export AWS_ACCESS_KEY_ID=ASIAXZ6ODJLBCEXAMPLE
    export AWS_SECRET_ACCESS_KEY=HgYHvNxacSsFSwls1FO9RoF5+tvYCFIABEXAMPLE
    export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEJ3//////////wEaCXVzLWVhc3QtMSJGMEQCIGnuGzUr8aszNWMFlFXQvFVhIA6aGdx3DskqY1JaIZWVAiANfE3xA79vIMVTqLnds4F2LpDy/qUeNRr7e9g9VQoS9SqyAQi2//////////8BEAEaDDUzNjc2NjI3MDE3NyIMgDgauwgJ4FIOMRV+KoYBRKR/MnKFB9/Q0Isc6D8gpG404xGJWqStNfGS0sHNsB5vVP/ccaAj4MG54p0Pl+V0LuIMXy345ua/bxxQFDWqhG0ORsXFEOo3iD1IQ+YA/yougAUl/0hbyvK3Jnf3NEHDejdL95iFCluJhoR0zFlDv7GwwBSXLUxS9K96/vgA0MmgK9a7kaAwoYiZ7gU63wHVDNYa1myqIP16Mi6KZ2zm9inMofixNN1ea3JMyRW+chWW8kdjjW4R3MFecpwoIayE7g3QLanmjE3jzrlxjIJWnl8tiipV+jassiSdlxLL2j1IIFH2pNEqrn4hkHG5t7OG+qZCTl8AnQ4W5wusmBoSIavr5w0dOdyx2mdsBMFtO82ZXvHSryY1gbIM9JyUd7dJ9h/mkfGL2p0n0R/lya8s9j8P8/8if+2uQcF+/BGDxojJ67kYXgstgfLjM5j8pZgyYj6YUFyTpyiOkllbPk/AjyxJY1svxW25wbNO+c13
    $

Eval example:

    $ eval `aws-mfa-secure exports`

Note: Prompts write to stderr so eval-ing the exports works even if with the prompt.

## Related

You may also be interested in the `aws-mfa-secure unset` command. It provides a quick way to unset the AWS_* environment variables.  Example:

    $ aws-mfa-secure unset # generates script
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    $ eval `aws-mfa-secure unset` # to unset
    $