#!/bin/bash
set -euo pipefail

cd /opt/app
yarn install
npm run build
