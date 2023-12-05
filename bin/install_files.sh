#!/bin/bash

## This is actually the bootstrapper script that will setup our git repo
## on machines we want to install our dot files on. It will need to be 
## installed and run first somehow. ie: manual copy/puppet/etc

BRANCH='master'
USER='adorfman'

if type git &>/dev/null ; then
    if [ ! -d .dotfiles ]; then
        git clone git@github.com:${USER}/dotfiles.git .dotfiles
        git --git-dir=.dotfiles/.git --work-tree=.dotfiles checkout -b ${BRANCH} origin/${BRANCH}
    else
        echo ".dotfiles already exists, updating..."
        (cd .dotfiles && git pull)
    fi
else
    echo "Git does not exist, sorry."
fi

./.dotfiles/bin/dfm
bind -f ~/.inputrc
. ~/.bashrc
