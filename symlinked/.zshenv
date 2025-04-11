# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Expand $PATH to include the directory where snappy applications go.
if [[ -n "${PATH//*:\/snap\/bin:*}" ]]; then
    export PATH="$PATH:/snap/bin"
fi

