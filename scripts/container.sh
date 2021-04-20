#!/bin/bash

plugins=

function ensure_hass_config() {
    hass --script ensure_config -c /config
}

function create_hass_user() {
    local username=${HASS_USERNAME:-dev}
    local password=${HASS_PASSWORD:-dev}
    echo "Creating Home Assistant User ${username}:${password}"
    hass --script auth -c /config add "${username}" "${password}"
}

function bypass_onboarding() {
    cat > /config/.storage/onboarding << EOF
{
    "data": {
        "done": [
            "user",
            "core_config",
            "integration"
        ]
    },
    "key": "onboarding",
    "version": 3
}
EOF
}

function fetch_lovelace_plugins() {
    mkdir -p /config/www/workspace
    for plugin in $LOVELACE_PLUGINS
    do
        local author
        local repo
        local prefix
        local file

        author=$(cut -d '/' -f1 <<<"$plugin")
        repo=$(cut -d '/' -f2 <<<"$plugin")
        prefix=$(cut -d '-' -f1 <<<"$repo")

        if [[ $prefix == "lovelace" ]]; then
            file=$(cut -c 10- <<<"$repo")
        else
            file=$repo
        fi

        echo "Downloading ${plugin} to ${file}.js"
        curl "https://raw.githubusercontent.com/${author}/${repo}/master/dist/${file}.js" --output "/config/www/${file}.js" --fail \
        || curl "https://raw.githubusercontent.com/${author}/${repo}/master/${file}.js" --output "/config/www/${file}.js" --fail \
        || curl -L "https://github.com/${author}/${repo}/releases/latest/download/${file}.js" --output "/config/www/${file}.js" --fail \
        || curl -L "https://github.com/${author}/${repo}/releases/latest/download/${file}-bundle.js" --output "/config/www/${file}.js" --fail
        plugins="${plugins} /local/${file}.js"
    done
}

function install_lovelace_plugins() {

    for file in $LOVELACE_LOCAL_FILES
    do
        plugins="${plugins} /local/workspace/${file}"
    done

    fetch_lovelace_plugins

    cat > /config/.storage/lovelace_resources << EOF
{
    "data": {
        "items": [
EOF

    local i="0"
    for plugin in $plugins
    do
        if [ $i -gt "0" ]; then
            echo "," >> /config/.storage/lovelace_resources
        fi

        i=$((i+1))
        
        head -c -1 >> /config/.storage/lovelace_resources << EOF
            {
                "id": "${i}",
                "type": "module",
                "url": "${plugin}"
            }
EOF
    done

    cat >> /config/.storage/lovelace_resources << EOF

        ]
    },
    "key": "lovelace_resources",
    "version": 1
}
EOF
}

function install_hacs() {
    curl -sfSL https://hacs.xyz/install | bash -
}

function setup() {
    ensure_hass_config
    create_hass_user
    bypass_onboarding
    install_hacs
    install_lovelace_plugins
}

function get_dev() {
    pip3 --disable-pip-version-check --no-cache-dir install --upgrade git+git://github.com/home-assistant/core.git@dev
}

function run() {
    hass -c /config -v
}

case $1 in
    setup-dev)
        get_dev
        setup
        ;;
    setup)
        setup
        ;;
    launch)
        run
        ;;
    *)
        setup
        run
        ;;
esac
