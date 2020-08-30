#!/usr/bin/env bash

set -euo pipefail

# Check .circleci/config.yml is up to date and valid
# Fail early if we accidentally used '.yaml' instead of '.yml'
if ! git diff --name-only --cached --exit-code -- '.circleci/***.yaml'; then
  echo "ERROR: File(s) with .yaml extension detected. Please rename them .yml instead."
	exit 1
fi

# Succeed early if no changes to yml files in .circleci/ are currently staged.
# make ci-verify is slow so we really don't want to run it unnecessarily.
if git diff --name-only --cached --exit-code -- '.circleci/***.yml'; then
  exit 0
fi

# Make sure to add no explicit output before this line, as it would just be noise
# for those making non-circleci changes.
echo "==> Verifying config changes in .circleci/"
echo "--> OK: All files are .yml not .yaml"

if ! make circle-config; then
  echo "ERROR: make ci-verify failed"
	exit 1
fi
echo "--> OK: make ci-verify succeeded."
