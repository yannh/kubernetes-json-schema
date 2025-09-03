#!/usr/bin/env bash
set -euo pipefail

/bin/ls -1d master* v* | cut -f1 -d- | sort | uniq >| index.lst
