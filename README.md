# CLAUDE Plugins

## Utility Plugins

### prefer-jq

Blocks use of Python for JSON processing in Bash commands, enforcing `jq` instead.

    /plugin install prefer-jq@leviysoft

Requires `jq` to be installed.

## LSP Plugins

    /plugin marketplace add leviysoft/claude-plugins

### HOW TO SCALA

First of all, install [coursier](https://get-coursier.io/docs/cli-installation)

Then:

    cs install metals

Don't forget to add `export ENABLE_LSP_TOOL=1`

    /plugin install scala-lsp@leviysoft

Coursier does not perform automatical updates, so periodically call

    cs update

### HOW TO HASKELL

Install [haskell-language-server](https://haskell-language-server.readthedocs.io/en/latest/installation.html)

Don't forget to add `export ENABLE_LSP_TOOL=1`

    /plugin install haskell-lsp@leviysoft

### HOW TO IDRIS2

First of all, install [pack](https://github.com/stefan-hoeck/idris2-pack/blob/main/INSTALL.md)

Then:

    pack install-app idris2-lsp

Don't forget to add `export ENABLE_LSP_TOOL=1`

    /plugin install idris2-lsp@leviysoft

### HOW TO F#

Install [FsAutoComplete](https://github.com/ionide/FsAutoComplete):

    dotnet tool install --global fsautocomplete

Don't forget to add `export ENABLE_LSP_TOOL=1`

    /plugin install fsharp-lsp@leviysoft
