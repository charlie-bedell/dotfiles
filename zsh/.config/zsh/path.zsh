# Central static PATH configuration.

typeset -U path PATH

# find homebrew installation
if [[ -x /opt/homebrew/bin/brew ]]; then
  path=(
    /opt/homebrew/bin
    /opt/homebrew/sbin
    $path
  )
elif [[ -x /usr/local/bin/brew ]]; then
  path=(
    /usr/local/bin
    /usr/local/sbin
    $path
  )
fi

path=(
  /usr/local/share/dotnet
  "$HOME/.dotnet/tools"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  $path
)

export PATH
