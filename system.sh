#!/bin/bash

function check_argument_and_print_usage() {
    if [ "$#" -ne 3 ]; then
        echo "Usage:"
        echo "  ${FUNCNAME[0]} <functionName> <numberArgumentActual> <exampleArgument>"
        return -1
    fi

    functionName="${1}"
    numberArgumentActual="${2}"
    exampleArgument="${3}"
    numberArgumentExpected=$(wc -w <<<"${exampleArgument}")


    if [ "${numberArgumentActual}" -ne "${numberArgumentExpected}" ]; then
        echo "Usage:"
        echo "  ${functionName} ${exampleArgument}"
        return -1
    fi

    return 0
}

function add_line_if_not_exist() {
    arguments="<fileName> <line>"
    check_argument_and_print_usage $funcstack[1] $# ${arguments}
    [ $? -ne 0 ] && return

    file=$1
    line=$2
    if grep -Fxq "$line" $file
    then
        # code if found
    else
        echo $line >> $file
    fi
}

############################################
# WORK STATION
############################################
function new_station_machine() {
    # Tool for developer
    mkdir -p $HOME/Custom
    # Lazygit
    wget -O $HOME/Custom/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz
    # Neovim
    mkdir -p $HOME/Custom/nvim
    wget -O $HOME/Custom/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.6.1/nvim-linux64.tar.gz
    # Install plug
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    # Install node
    # https://nodejs.org/en/download/
    # tar -xJvf node-v16.14.2-linux-x64.tar.xz # to ~/Custom/node
    # Nvim setting command line
    # nvim +'PlugInstall' +qall
    # nvim +'CocInstall -sync coc-tabnine coc-protobuf coc-yaml coc-sh coc-pyright coc-go coc-cmake coc-clangd' +qall

    # Tools
    # if which programname >/dev/null; then
        # go env -w GOPROXY=nexus.taservs.net/repository/goproxy/
        # go env -w GONOPROXY=none
        # go env -w GOPRIVATE=git.taservs.net
    # fi
    #
    # export PATH="$HOME/.config/tools:$PATH"
    # export PATH="$HOME/Custom/bin:$PATH"
    # export PATH="$HOME/Custom/nvim/bin:$PATH"
    # source /Users/dla/workspace/minhduc/Programming/Bash/magic.sh
    # source /Users/dla/workspace/axon/mac-command/ab3-command.sh
    # source /Users/dla/workspace/axon/mac-command/system.sh
}

############################################
# MAC
############################################
function new_mac() {
    # Install brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update && brew upgrade
    brew install minicom
    brew install wget
    brew install curl
    brew install git
    brew install hub
    brew install gpg
    brew install lazygit
    brew install neovim
    brew install ripgrep
    brew install pkg-config
    brew install --cask itsycal
    brew install --cask tunnelblick
    brew install --cask android-platform-tools # adb
    brew install --cask flameshot # next-level screenshot
}

function install_shell_tools() {
    # Install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # Install powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    # Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc

    # Install zsh-autosuggestions, suggest command as you type with blur suggestion
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    # Add zsh-autosuggestions to plugins field in ~/.zshrc

    # Fuzzy search for history, Ctrl-R
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

    # Nvim
    git clone git@github.com:lala74/nvim.git $HOME/.config/nvim
}

function clone_axon_git() {
    axonDir="$HOME/workspace/axon"
    janusDir="$HOME/workspace/axon/janus"
    customDir="$HOME/workspace/axon/custom"
    imageDir="$HOME/workspace/axon/images/janus-images"
    shellFile="$HOME/.zshrc"

    mkdir -p $janusDir
    mkdir -p $customDir
    mkdir -p $imageDir

    # Git
    # ssh-keygen -t ed25519 -C "dla@axon.com"
    # # Add public key to
    # # https://github.com/settings/keys
    # # https://git.taservs.net/settings/keys
    git config --global user.email "dla@axon.com"
    git config --global user.name "La Minh Duc"
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
    git config --global url."git@git.taservs.net:".insteadOf "https://git.taservs.net"

    cd $axonDir
    git clone git@git.taservs.net:ecom/ui-automation-test.git
    cd $janusDir
    git clone git@git.taservs.net:Janus/axon-camera.git
    cd $customDir
    git clone git@git.taservs.net:dla/mac-command.git
    git clone git@git.taservs.net:dla/janus-fake-button.git
    git clone git@git.taservs.net:dla/bwc-img.git
    git clone git@git.taservs.net:dla/tools.git

    echo "#### Source tools"
    add_line_if_not_exist $shellFile '#### Tools'
    add_line_if_not_exist $shellFile 'source $HOME/workspace/axon/custom/mac-command/ab3-command.sh'
    add_line_if_not_exist $shellFile 'source $HOME/workspace/axon/custom/mac-command/system.sh'
    add_line_if_not_exist $shellFile 'source $HOME/workspace/axon/custom/mac-command/collect-and-parse-audit-log.sh'
    echo "---- Done"

    go env -w GOPROXY=nexus.taservs.net/repository/goproxy/
    go env -w GONOPROXY=none
    go env -w GOPRIVATE=git.taservs.net
}

function clone_minhduc_git() {
    minhducDir="$HOME/workspace/minhduc"
    mkdir -p $minhducDir

    # Git
    # ssh-keygen -t ed25519 -C "dla@axon.com"
    # # Add public key to
    # # https://github.com/settings/keys
    # # https://git.taservs.net/settings/keys
    git config --global user.email "dla@axon.com"
    git config --global user.name "La Minh Duc"
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

    cd $minhducDir
    git clone git@github.com:lala74/Programming.git
    git clone git@github.com:lala74/Socket-cpp.git
    git clone git@github.com:lala74/Coding-Exercises.git
}

function modify_shell_file() {
    customDir="$HOME/workspace/axon/custom"
    shellFile="$HOME/.zshrc"

    echo "#### Fix some issues"
    add_line_if_not_exist $shellFile '#### Fix'
    add_line_if_not_exist $shellFile 'LC_CTYPE=en_US.UTF-8 # Fix perl locale warning'
    add_line_if_not_exist $shellFile 'LC_ALL=en_US.UTF-8'
    add_line_if_not_exist $shellFile 'export TERM=xterm-256color'
    echo "---- Done"

    echo "#### Consistent history"
    add_line_if_not_exist $shellFile '#### Consistent history'
    add_line_if_not_exist $shellFile 'export HISTCONTROL=ignoreboth:erasedups'
    add_line_if_not_exist $shellFile 'export HISTFILESIZE=-1'
    add_line_if_not_exist $shellFile "export HISTFILE=$customDir/mac-command/bash_eternal_history"
    add_line_if_not_exist $shellFile 'PROMPT_COMMAND="history -a; $PROMPT_COMMAND"'

    echo "#### Export"
    add_line_if_not_exist $shellFile '#### WORKSTATION IP'
    add_line_if_not_exist $shellFile "export IP_LUCAS=10.163.60.27"
    add_line_if_not_exist $shellFile "export IP_VNFW=10.163.60.21"
    add_line_if_not_exist $shellFile "export IP_JANUS=10.163.60.33"
    add_line_if_not_exist $shellFile 'export MY_INSTALL_DIR=$HOME/.local'
    add_line_if_not_exist $shellFile 'export PATH=$MY_INSTALL_DIR/bin:$PATH'
    add_line_if_not_exist $shellFile 'export PATH=/usr/local/include:$PATH'
    add_line_if_not_exist $shellFile 'export PATH=/usr/local/lib:$PATH'
    add_line_if_not_exist $shellFile 'export PATH=/usr/local/go/bin:$PATH'
    add_line_if_not_exist $shellFile 'export PATH=$HOME/go/bin:$PATH'
    add_line_if_not_exist $shellFile 'export PATH=$HOME/Custom/platform-tools:$PATH'
    echo "---- Done"

    echo "#### Alias"
    add_line_if_not_exist $shellFile '#### Custom PATH'
    add_line_if_not_exist $shellFile "alias ssh_lucas='ssh dla@\$IP_LUCAS'"
    add_line_if_not_exist $shellFile "alias ssh_vnfw='ssh dla@\$IP_VNFW'"
    add_line_if_not_exist $shellFile "alias ssh_janus='ssh dla@\$IP_JANUS'"
    add_line_if_not_exist $shellFile 'alias cda=$HOME/workspace/axon/janus/axon-camera'
    add_line_if_not_exist $shellFile 'alias cdc=$HOME/workspace/axon/custom'
    echo "---- Done"

    echo "####  Tools for image display"
    mkdir -p $HOME/.config/tools
    wget -P $HOME/.config/tools https://iterm2.com/utilities/imgls
    wget -P $HOME/.config/tools https://iterm2.com/utilities/imgcat
    wget -P $HOME/.config/tools https://iterm2.com/utilities/it2dl
    wget -P $HOME/.config/tools https://iterm2.com/utilities/divider
    chmod +x $HOME/.config/tools/imgls
    chmod +x $HOME/.config/tools/imgcat
    chmod +x $HOME/.config/tools/it2dl
    chmod +x $HOME/.config/tools/divider
    add_line_if_not_exist ~/.zshrc 'export PATH=$HOME/.config/tools:$PATH'
    echo "---- Done"

    # Get ssh config, keys ,shell history from old machine
    # tar -cvf profile.tar .zsh* .oh* .ssh* .bash*
}

function modify_ssh_config_file() {
    shellFile="$HOME/.ssh/config"

    touch $shellFile

    echo "####  Ssh key for Axon"
    add_line_if_not_exist $shellFile 'Host git.taservs.net'
    add_line_if_not_exist $shellFile '    IdentityFile ~/.ssh/axon'
    add_line_if_not_exist $shellFile 'Host *'
    add_line_if_not_exist $shellFile '    IdentityFile ~/.ssh/minhduc'
    echo "---- Done"
}

function dla_proxy_to_ip() {
    arguments="<ip> <port>"
    check_argument_and_print_usage $funcstack[1] $# ${arguments}
    [ $? -ne 0 ] && return

    ip=$1
    port=$2

    ssh -D ${port} -q -N -f dla@${ip}
}

function dla_proxy_git_to_port() {
    arguments="<port>"
    check_argument_and_print_usage $funcstack[1] $# ${arguments}
    [ $? -ne 0 ] && return

    port=$1

    export GIT_SSH_COMMAND='ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:'$port' %h %p"'
}

function dla_proxy_all_to_ip() {
    arguments="<ip> <port>"
    check_argument_and_print_usage $funcstack[1] $# ${arguments}
    [ $? -ne 0 ] && return

    ip=$1
    port=$2

    dla_proxy_to_ip $ip $port
    dla_proxy_git_to_port $port
}

