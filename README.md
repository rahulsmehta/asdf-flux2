<div align="center">

# asdf-flux2 [![Build](https://github.com/rahulsmehta/asdf-flux2/actions/workflows/build.yml/badge.svg)](https://github.com/rahulsmehta/asdf-flux2/actions/workflows/build.yml) [![Lint](https://github.com/rahulsmehta/asdf-flux2/actions/workflows/lint.yml/badge.svg)](https://github.com/rahulsmehta/asdf-flux2/actions/workflows/lint.yml)

[FluxCD](https://github.com/fluxcd/flux2) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add flux https://github.com/rahulsmehta/asdf-flux2.git
```

flux:

```shell
# Show all installable versions
asdf list-all flux

# Install specific version
asdf install flux latest

# Set a version globally (on your ~/.tool-versions file)
asdf global flux latest

# Now flux2 commands are available
flux version --client
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/rahulsmehta/asdf-flux2/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Rahul Mehta](https://github.com/rahulsmehta/)
