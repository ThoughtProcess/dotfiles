#!/bin/bash

# Save GPG settings

GNUPG_ID="promba@gmail.com"
GNUPG_BACKUP_DIR=".local/share/chezmoi/private_dot_gnupg/"
FOLDER_ID=$(bw list folders --search "GNUPG" | jq '.[0].id')

saveEntry() {
  if [[ "$(bw list items --search $1)" = "[]" ]] then
    TEMPLATE_FILE="private_$(echo ${1} | sed -e 's/ /_/g').tmpl"
    echo "{{ (bitwarden \"item\" \"$1\").notes | b64dec }}" > ~/.local/share/chezmoi/private_dot_gnupg/$TEMPLATE_FILE
    echo "{\"organizationId\":null,\"folderId\":\"$FOLDER_ID\",\"type\":2,\"name\":\"$1\",\"notes\":\"$2\",\"favorite\":false,\"fields\":[],\"login\":null,\"secureNote\":{\"type\":0},\"card\":null,\"identity\":null}" | bw encode | bw create item
  fi
}

mkdir $GNUPG_BACKUP_DIR
ENCODED_PUBLIC_KEY=$(gpg --export --armor ${GNUPG_ID} | base64 -w 0)
ENCODED_SECRET_KEYS=$(gpg --export-secret-keys --armor ${GNUPG_ID} | base64 -w 0)
ENCODED_SECRET_SUBKEYS=$(gpg --export-secret-subkeys --armor ${GNUPG_ID} | base64 -w 0)
ENCODED_OWNERTRUST=$(gpg --export-ownertrust | base64 -w 0)

# mv pubring.gpg publickeys.backup
saveEntry "GPG Public Key" $ENCODED_PUBLIC_KEY
saveEntry "GPG Secret Keys" $ENCODED_SECRET_KEYS
saveEntry "GPG Secret Subkeys" $ENCODED_SECRET_SUBKEYS
saveEntry "GPG Owner Trust" $ENCODED_OWNERTRUST

