# HASS Docker container for development & testing <!-- omit in toc -->

- [About](#about)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [About Lovelace plugins](#about-lovelace-plugins)
- [Container script](#container-script)
- [VSCode 'devcontainer.json' example](#vscode-devcontainerjson-example)
- [Troubleshooting](#troubleshooting)
- [Changelog](#changelog)

## About

TODO

## Usage

```bash
docker run --rm -it \
    --name hass-dev-container \
    -p 5000:8123 \
    -v $(pwd):/workspaces/test \
    -v $(pwd):/config/www/workspace \
    -e LOVELACE_LOCAL_FILES="" \
    -e LOVELACE_PLUGINS="" \
    besquared/hass-dev-container
```

## Environment Variables

| Name | Description | Default |
|---|---|---|
| `HASS_USERNAME` | The username of the default user | `hass` |
| `HASS_PASSWORD` | The password of the default user | `hass` |
| `LOVELACE_PLUGINS` | List of lovelace plugins to download from GitHub | '' |
| `LOVELACE_LOCAL_FILES` | List of filenames in `/config/www/workspace` to add as Lovelace resources | '' |

## About Lovelace plugins

`LOVELACE_PLUGINS` should be a space separated list of author/repo pairs, e.g. `"thomasloven/lovelace-card-mod  kalkih/mini-media-player"`
`LOVELACE_LOCAL_FILES` is for the currently worked on plugins and should be a list of file names which are mounted in `/config/www/workspace`.

## Container script

Set up and launch Home Assistant

```bash
$ container
```

Perform download and setup parts but do not launch Home Assistant

```bash
$ container setup
```

Launch Home Assistant with `hass -c /config -v`

```bash
$ container launch
```

## VSCode 'devcontainer.json' example

```json
{
  "image": "qnimbus/hass-dev-container",
  "postCreateCommand": "sudo -E /usr/bin/container.sh setup && npm add",
  "forwardPorts": [8123],
  "mounts": [
    "source=${localWorkspaceFolder},target=/config/www/workspace,type=bind",
    "source=${localWorkspaceFolder}/test,target=/config/test,type=bind",
    "source=${localWorkspaceFolder}/test/configuration.yaml,target=/config/configuration.yaml,type=bind"
  ],
  "runArgs": ["--env-file", "${localWorkspaceFolder}/test/.env"]
}
```

## Troubleshooting

When running the docker commands from a Windows Git Bash shell (MSYS) you may need to prepend the `MSYS_NO_PATHCONV=1` environment variable to the commands like so:

```bash
MSYS_NO_PATHCONV=1 docker run --rm -it \
    --name hass-dev-container \
    -p 5000:8123 \
    -v ${PWD}:/workspaces/test \
    -v ${PWD}:/config/www/workspace \
    -e LOVELACE_LOCAL_FILES="" \
    -e LOVELACE_PLUGINS="" \
    qnimbus/hass-dev-container
```

## Changelog

### [Unreleased] <!-- omit in toc -->

### [v0.0.1] - 2021-04-21 <!-- omit in toc -->

#### Added <!-- omit in toc -->
- Initial version of `hass-dev-container` repository

[Unreleased]: https://github.com/qnimbus/hass-dev-container/compare/v0.0.1...HEAD
[v0.0.1]: https://github.com/qnimbus/hass-dev-container/releases/tag/v0.0.1
