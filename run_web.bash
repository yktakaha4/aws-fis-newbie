#!/usr/bin/env bash

set -xeuo pipefail

git pull
poetry install
poetry run python web.py

