# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="philips"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting)

# aliases
alias python="python3.12"
alias -s py=python3.12
alias tf='terraform'
alias pm='python3.12 manage.py'

source $ZSH/oh-my-zsh.sh

# load nvm
[[ -r "$HOME/.config/zsh/nvm.zsh" ]] &&
  source "$HOME/.config/zsh/nvm.zsh"

[[ -r "$HOME/dotfiles/.specialrc" ]] &&
  source "$HOME/dotfiles/.specialrc"



# ==================== FIXED CUSTOMIZATIONS ==================== #
# these customizations overwrite the theme! comment them out and restart
# so see how these are customized per theme

# hard codes ls colors, see LSCOLORS in man ls
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
# i want my prompt to be a little shorter, so I shorten my user, but only if its me
if [[ $USER == "charlesbedell" || $USER == "ccb" || $USER == "cbedell" ]]; then USERDISPLAY="cb"; else USERDISPLAY="$USER"; fi

# hard codes the prompt
PROMPT='%{$fg[$NCOLOR]%}$USERDISPLAY%{$reset_color%}:%{$fg[blue]%}%c/%{$reset_color%} $(git_prompt_info)%(!.#.$) '
RPROMPT='--------------------[%*]'
# git theme stuff for prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"
# colors for ls
export LSCOLORS="gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:*.patch=00;34:*.o=00;32:*.so=01;35:*.ko=01;31:*.la=00;33'
# ================== FIXED CUSTOMIZATIONS END ================== #"
