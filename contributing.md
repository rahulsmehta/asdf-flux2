# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test flux2 https://github.com/rahulsmehta/asdf-flux2.git "flux version --client"
```

Tests are automatically run in GitHub Actions on push and PR.
