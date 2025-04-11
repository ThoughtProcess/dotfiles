#!/bin/bash

if ! command -v bw 2>&1 >/dev/null; then
  echo >&2 "The BitWarden CLI does not appear to be installed.  Please install and configure before continuing."
  exit 1
fi

if [[ -z "$BW_SESSION" ]]; then
  echo >&2 "You must have a BW_SESSION in order to run chezmoi pull/sync/etc..."
  echo "bw config server YOUR_SERVER_NAME"
  echo "bw login"
  echo "export BW_SESSION=\$(bw unlock --raw)"
  exit 1
fi
