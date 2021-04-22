#!/bin/bash

docker run --rm -it \
    --name build_test \
    -p 8080:8123 \
    -e LOVELACE_PLUGINS="" \
    -e LOVELACE_LOCAL_FILES="" \
    qnimbus/hass-dev-container
