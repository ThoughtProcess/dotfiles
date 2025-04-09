#!/bin/bash

# Import GPG settings
cd ~/.gnupg
gpg --import-options restore --import GPG_Public_Key
gpg --import-ownertrust GPG_Owner_Trust
gpg --import GPG_Secret_Keys
gpg --import GPG_Secret_Subkeys

