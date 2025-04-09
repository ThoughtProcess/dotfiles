#!/bin/bash

SSH_DIR="$HOME/.ssh"
BW_SSH_DIR="SSH Private Keys"

echo "Looking up GUID for target folder in Bitwarden..."
FOLDER_ID=$(bw list folders --search "$BW_SSH_DIR" | jq -r '.[0].id')

echo "Retrieving data from Bitwarden..."
FOLDER_CONTENTS=$(bw list items --folderid "$FOLDER_ID")

KEY_NAMES=$(echo "$FOLDER_CONTENTS" | jq -r '.[].name')

saveFile() {
    BASENAME=$(basename ${1})

    if ! [[ $KEY_NAMES =~ $BASENAME ]] then
        echo "$BASENAME does not appear to exist in Bitwarden.  Adding now."

        ENCODED_KEY=$(base64 -w 0 < "$1")
        echo "{\"organizationId\":null,\"folderId\":\"$FOLDER_ID\",\"type\":2,\"name\":\"$BASENAME\",\"notes\":\"$ENCODED_KEY\",\"favorite\":false,\"fields\":[],\"login\":null,\"secureNote\":{\"type\":0},\"card\":null,\"identity\":null}" | bw encode | bw create item
    else
        echo "$BASENAME is already in Bitwarden, skipping."
    fi
}

# Iterate over private key files (excluding *.pub files)
for key in "$SSH_DIR"/id_*; do
    if [[ -f "$key" && "$key" != *.pub ]]; then
        saveFile $key
    fi
done

# Save the config and authorized_keys files too.
saveFile "$SSH_DIR/config"
saveFile "$SSH_DIR/authorized_keys"
