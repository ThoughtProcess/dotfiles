#!/bin/bash

SSH_DIR="$HOME/.ssh"
SSH_DIR="SSH Private Keys"
FOLDER_ID=$(bw list folders --search "$SSH_DIR" | jq -r '.[0].id')
FOLDER_CONTENTS=$(bw list items --folderid "$FOLDER_ID")
KEY_NAMES=$(echo "$FOLDER_CONTENTS" | jq -r '.[].name')

loadEntry() {
    if ! [ -f ~/.ssh/$privkey ]; then
        echo "Load $privkey out of BitWarden"
        NOTE=$(echo "$FOLDER_CONTENTS" | jq -r --arg KEYNAME "$privkey" '.[] | select(.name==$KEYNAME).notes | @base64d')
        install -m 600 /dev/null ~/.ssh/$privkey
        echo "$NOTE" > ~/.ssh/$privkey
    else
        echo "Skipping existing file ~/.ssh/$privkey..."
    fi

    # If this is a private key, auto-generate the public key
    if ! [[ "$privkey" == config ]] && ! [[ "$privkey" == authorized_keys ]]; then
      if ! [ -f ~/.ssh/$privkey.pub ]; then
          echo "Generate public key from private key."
          ssh-keygen -y -f ~/.ssh/$privkey > ~/.ssh/$privkey.pub
      else
          echo "Skipping existing public key ~/.ssh/$privkey.pub..."
      fi
    fi
}

echo "$KEY_NAMES" | while read -r privkey; do
    loadEntry $privkey
done
