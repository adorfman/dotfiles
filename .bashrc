# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

shopt -s expand_aliases
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) 
        color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[00;33m\]\u\[\033[00m\]@\[\033[1;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
unset color_prompt force_color_prompt
# 
# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    if [ -f  ~/.ls_colors ]; then 
        . ~/.ls_colors; 
    fi
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# IS stuff
if [ -f ~/.bashrc.adorfmandev ]; then
    . ~/.bashrc.adorfmandev
fi 

# Set environment variables
export EDITOR=vim
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR
export PATH=$PATH:$HOME/bin:./script

# TMUX with utf-8 support
alias tmux='tmux -u'

if [ ! -d ${HOME}/tmp ]; then 
    mkdir ${HOME}/tmp
fi

# Vim swap file directory
if [ ! -d ${HOME}/.vim/tmp ]; then 
    mkdir ${HOME}/.vim/tmp
fi 
      
## Handle screen windows ##

# automatically name our screen window to the current host
case "$TERM" in
screen*)
    WINDOW_NAME=$( echo -ne $HOSTNAME | cut -c 1-10 )
    PROMPT_COMMAND='echo -ne "\033k$WINDOW_NAME\033\\"'
    ;;
esac

# This should keep ssh-agent forwarding working in
# screen sessions after detach -> logout -> login
# -> attach

if [ $SSH_AUTH_SOCK ]; then
    screen_ssh_agent=${HOME}/tmp/ssh-agent-screen
    export screen_ssh_agent

    if [[ "$TERM" != screen* ]] && [ "${SSH_AUTH_SOCK}" != "$screen_ssh_agent" ]; then 
       ln -snf ${SSH_AUTH_SOCK} ${screen_ssh_agent}
    fi
fi

if [[ $TERM == screen* ]]; then  
    SSH_AUTH_SOCK=${screen_ssh_agent}
    export SSH_AUTH_SOCK 
fi

# Set TERM once we are done configuring for screen/tmux
# This probably isn't 'correct' but vim doesn't recognize 
# color support for screen-256color
if [[ $TERM == screen* ]]; then 
    export TERM=xterm-256color  
fi

parse_git_branch() {
     #git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/b(\1)/'
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/' 
}

## Perlbrew stuff ##
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then 
  source ~/perl5/perlbrew/etc/bashrc
fi 

alias pb="perlbrew"
alias pbl="perlbrew list"
alias pbu="perlbrew use"
alias pbe="perlbrew exec --with "
#alias pblib="perlbrew use lib ${PERLBREW_PERL}@" 

perllibadd() {
    mod_dir=`pwd`
    if [ -d "$mod_dir/lib" ] && [[ ":$PERL5LIB:" != *":$mod_dir/lib:"* ]]; then
        PERL5LIB="${PERL5LIB:+"$PERL5LIB:"}$mod_dir/lib"
        export PERL5LIB
    elif [ ! -d "$1/lib"  ]; then
        echo -e "\033[33mNo lib directory found\033[0m"
    fi
}     

pblib() {
  perlbrew use ${PERLBREW_PERL}@${1} 
}   

parse_perlbrew() {

   if [[ $SHOWPERL != 1 ]]; then
      echo ''
      return 0
   fi

   if [ $PERLBREW_PERL ]; then
     perlbrew list |  sed -e '/^\s\+[^*]/d' -e 's/* perl-\([^[:space:]]*\).*/p(\1)/'
     #perlbrew list |  sed -e '/^[^*]/d' -e 's/* perl-\(.*\)\s*/p(\1)/'
   else 
     perl -e 'print $^V'
   fi

}
 
# NPM stuff
export PATH=~/.npm-global/bin:$PATH

# Fuzzy finder
if [ -f ~/.fzf.bash ]; then
   source  ~/.fzf.bash
   export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
fi

# Final prompt 
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\] \$(parse_perlbrew) \$(parse_git_branch)\[\033[00m\]\n $ " 

if [ -f ~/.bashrc.load ]; then 
    . $HOME/.bashrc.load
fi

return 0

#intellisurvey defs
if [ -f ~/.bashrc.adorfmandev ]; then
    . ~/.bashrc.adorfmandev
#    PS1="[\u@\h \W]\$ "
fi
#intellisurvey defs
