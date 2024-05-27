#!/usr/bin/env bash

set -xeuo pipefail

base_dir="$(cd "$(dirname "$0")"; pwd)"

cd "$base_dir"

git pull
poetry install
poetry run python web.py
