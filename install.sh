#!/bin/zsh

set -eu

cd

MYCONFIG="$HOME/devel/myconfig"
CLONE_URL="git@github.com:natflow/myconfig.git"

SUCCESS="✅"
ACTION_NEEDED="❗️"
ELLIP="…"

action_needed_n() {
    echo -n $ACTION_NEEDED "$@"
}

action_needed() {
    action_needed_n "$@"
    echo
}

success() {
    echo $SUCCESS "$@"
}

link_if_not_exists() {
    SRC="$MYCONFIG/$1"
    DST="$2"
    if [[ -f "$DST" ]]; then
        success $DST already exists.
    else
        action_needed_n $DST does not exist. Linking now$ELLIP
        (
            cd
            mkdir -p "$(dirname "$DST")"
            rm -f "$DST" # fix for broken symlinks which return true with [[ -f
            ln -s "$SRC" "$DST"
        )
        success
    fi
}

wait_for_keypress() {
    echo press enter to continue$ELLIP
    read
}


## Homebrew

if which brew > /dev/null; then
    success brew already installed
else
    action_needed brew not found. Installing now$ELLIP
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | /bin/bash
    success
fi

if which nvim > /dev/null; then
    success nvim already installed.
else
    action_needed nvim not found. Installing now$ELLIP
    brew install nvim
    success
fi


## repo

if [[ -d $MYCONFIG ]]; then
    success myconfig repo already exists
else
    action_needed_n myconfig repo not found. Cloning now$ELLIP
    mkdir -p $DEVEL_DIR
    (
        cd $DEVEL_DIR
        git clone $CLONE_URL > /dev/null
    )
    success
fi


# Git

link_if_not_exists git/config .gitconfig


# Oh My Zsh

# this file has to happen before install for idempotency since otherwise
# the install script would create .zshrc and we wouldn't be able to reliably tell if it was freshly created or not.
link_if_not_exists zsh/zshrc .zshrc
link_if_not_exists zsh/zshenv .zshenv

if [[ -d $HOME/.oh-my-zsh ]]; then
    success Oh My Zsh already installed.
else
    action_needed Oh My Zsh not found. Installing now$ELLIP
    export KEEP_ZSHRC="yes"
    curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
    success Oh My Zsh successfully installed
fi

link_if_not_exists zsh/zsh_aliases .zsh_aliases
link_if_not_exists zsh/natflow.zsh-theme .oh-my-zsh/themes/natflow.zsh-theme


## iTerm2

if [[ -d /Applications/iTerm.app ]]; then
    success Iterm2 already installed.
else
    action_needed_n iTerm.app not found. Opening browser to manually download now$ELLIP
    open https://www.iterm2.com/
    wait_for_keypress
    echo Manual steps:
    echo "* iTerm2 > Scripts > Manage > Install Python Runtime"
    echo "* iTerm2 > Scripts > AutoLaunch > match-theme-to-system.iterm2.py"
    echo "* iTerm2 > iTerm2 > Preferences > Profiles > Colors > disable \"Brighten bold text\""
    echo "* iTerm2 > iTerm2 > Preferences > Profiles > Colors > enable \"Smart box cursor color\""
    echo "* iTerm2 > iTerm2 > Preferences > Profiles > Colors > Color Presets... > Import > $MYCONFIG/iterm2/LuciusLightHighContrast.itermcolors"
    echo "* iTerm2 > iTerm2 > Preferences > Profiles > Colors > Color Presets... > Import > $MYCONFIG/iterm2/Unicon.itermcolors"
fi

AUTOLAUNCH_FILE="match-theme-to-system.iterm2.py"
link_if_not_exists "iTerm2/$AUTOLAUNCH_FILE" "Library/Application Support/iTerm2/Scripts/AutoLaunch/$AUTOLAUNCH_FILE"


### Vim

if [[ -d /Applications/VimR.app ]]; then
    success VimR already installed.
else
    action_needed_n VimR.app not found. Opening browser to manually download now$ELLIP
    open https://github.com/qvacua/vimr/releases
    wait_for_keypress
fi

link_if_not_exists nvim/init.vim .config/nvim/init.vim
link_if_not_exists nvim/editorconfig .editorconfig

if [[ -s ~/notes ]]; then
    success ~/notes already exists
else
    action_needed_n "~/notes does not exist. Linking now$ELLIP"
    rm -f ~/notes
    ln -s "$HOME/notes" "$HOME/Library/Mobile Documents/com~apple~CloudDocs/notes"
    success
fi
