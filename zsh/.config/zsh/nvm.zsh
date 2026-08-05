# find where nvm is installed
if [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
  export NVM_DIR="$XDG_CONFIG_HOME/nvm"
else
  export NVM_DIR="$HOME/.nvm"
fi

# load if not already loaded
if [[ -s "$NVM_DIR/nvm.sh" ]] &&
   ! command -v nvm >/dev/null 2>&1; then
  source "$NVM_DIR/nvm.sh"
fi
