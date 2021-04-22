# HASS Docker container for development & testing <!-- omit in toc -->

![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/QNimbus/hass-dev-container/Publish%20to%20Docker%20registry/main?style=for-the-badge)

- [About](#about)
- [Usage](#usage)
  - [Environment Variables](#environment-variables)
  - [About Lovelace plugins](#about-lovelace-plugins)
  - [Container script](#container-script)
  - [Basic configuration](#basic-configuration)
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
    qnimbus/hass-dev-container
```

### Environment Variables

| Name                   | Description                                                               | Default |
| ---------------------- | ------------------------------------------------------------------------- | ------- |
| `HASS_USERNAME`        | The username of the default user                                          | `hass`  |
| `HASS_PASSWORD`        | The password of the default user                                          | `hass`  |
| `LOVELACE_PLUGINS`     | List of lovelace plugins to download from GitHub                          | ''      |
| `LOVELACE_LOCAL_FILES` | List of filenames in `/config/www/workspace` to add as Lovelace resources | ''      |

### About Lovelace plugins

`LOVELACE_PLUGINS` should be a space separated list of author/repo pairs, e.g. `"thomasloven/lovelace-card-mod  kalkih/mini-media-player"`
`LOVELACE_LOCAL_FILES` is for the currently worked on plugins and should be a list of file names which are mounted in `/config/www/workspace`.

### Container script

Set up and launch Home Assistant

```bash
$ container.sh
```

Perform download and setup parts but do not launch Home Assistant

```bash
$ container.sh setup
```

Launch Home Assistant with `hass -c /config -v`

```bash
$ container.sh launch
```

### Basic configuration

Basic `configuration.yaml`

```yaml
# Configure a default setup of Home Assistant (frontend, api, etc)
default_config:

# Text to speech
tts:
  - platform: google_translate

group: !include groups.yaml
automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml
```

### VSCode 'devcontainer.json' example

Without existing `configuration.yaml`:

```json
{
  "image": "qnimbus/hass-dev-container",
  "postCreateCommand": "sudo -E /usr/bin/container.sh setup && npm add",
  "forwardPorts": [8123],
  "mounts": [
    "source=${localWorkspaceFolder},target=/config/www/workspace,type=bind"
  ]
}
```

With existing `configuration.yaml`:

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

#### Added <!-- omit in toc -->

- Status badge to README
- Basic configuration example for Home Assistant
- Added vscode `tasks.json` file
- Added vscode `settings.json` file
- Added `build.sh` script for testing Docker build

#### Changed <!-- omit in toc -->

- Fixed typos in example scripts of README
- Updated formatting of README
- Makefile default goal to 'build' instead of 'all'

### [v0.0.1] - 2021-04-21 <!-- omit in toc -->

#### Added <!-- omit in toc -->
- Initial version of `hass-dev-container` repository

[Unreleased]: https://github.com/qnimbus/hass-dev-container/compare/v0.0.1...HEAD
[v0.0.1]: https://github.com/qnimbus/hass-dev-container/releases/tag/v0.0.1
