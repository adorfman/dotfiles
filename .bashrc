# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Define some colors first:
red='\e[0;31m'
#RED='\e[1;31m'
blue='\e[0;34m'
#BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color

NOC='\e[0m'
WHITE='\e[1m'
GREY='\e[2m'
UNDERLINE='\e[4m'
DEFACE='e[[9m'
DARK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELOW='\e[33m'
BLUE='\e[34m'
PINK='\e[35m'
AZURE='\e[36m'
BDARK='\e[40m'
BRED='\e[41m'
BGREEN='\e[42m'
BYELOW='\e[43m'
BBLUE='\e[44m'
BPINK='\e[45m'
BAZURE='\e[46m'
BWHITE='\e[7m'
HDARK='\e[90m'
HRED='\e[91m'
HGREEN='\e[92m'
HYELOW='\e[93m'
HBLUE='\e[94m'
HPINK='\e[95m'
HAZURE='\e[96m'

shopt -s expand_aliases

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

# Don't timeout and exit
export TMOUT=0

# More options
ulimit -S -c 0		# Don't want any coredumps
set -o notify
set -o noclobber
set -o ignoreeof
#set -o nounset
#set -o xtrace          # useful for debuging
# 
# # Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s mailwarn
shopt -s sourcepath
shopt -s no_empty_cmd_completion  # bash>=2.04 only
shopt -s cmdhist
shopt -s histreedit histverify
shopt -s extglob	# necessary for programmable completion

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
export PATH=$PATH:$HOME/bin:./script:$HOME/.local/bin

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


#=========================================================================
#
# PROGRAMMABLE COMPLETION - ONLY SINCE BASH-2.04
# Most are taken from the bash 2.05 documentation and from Ian McDonalds
# 'Bash completion' package (https://www.caliban.org/bash/index.shtml#completion)
# You will in fact need bash-2.05a for some features
#
#=========================================================================

if [ "${BASH_VERSION%.*}" \< "2.05" ]; then
    echo "You will need to upgrade to version 2.05 for programmable completion"
    return
fi

shopt -s extglob        # necessary
set +o nounset          # otherwise some completions will fail

complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory   -o default cd

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
# Postscript,pdf,dvi.....
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' acroread pdf2ps
complete -f -o default -X '!*.+(pdf|ps)' gv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
# Multimedia
complete -f -o default -X '!*.+(jp*g|gif|xpm|png|bmp)' xv gimp
complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
complete -f -o default -X '!*.+(ogg|OGG)' ogg123


parse_git_branch() {

    if git ls-files ./ --error-unmatch >/dev/null 2>/dev/null ; then
        branch=$( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' ) 

        status=$(git status | grep -e "^.*Your branch is")
        mod=$(git status -s --porcelain | egrep -v "^\?\?"| grep -E "^.{0,1}[RM]"|wc -l)
        add=$(git status -s --porcelain | egrep -v "^\?\?"| grep -E "^.{0,1}A"|wc -l)
        del=$(git status -s --porcelain | egrep -v "^\?\?"| grep -E "^.{0,1}D"|wc -l)
        unk=$(git status -s --porcelain | egrep  "^\?\?"| wc -l )

        if echo $status | grep 'ahead' > /dev/null ; then
                num=$(echo $status | grep -o "[0-9]*")
                rstat=" ${AZURE}U:${HYELOW}->${HRED}$num$NOC"
        elif echo $status | grep 'behind' > /dev/null ; then
            num=$(echo $status | grep -o "[0-9]*")
            rstat=" ${AZURE}U:${HYELOW}<-${HRED}$num$NOC"
        else
                rstat=""
        fi


        if [ $mod -gt 0 ] ; then 
            mod="$HRED\u2248$mod$NOC"
        else
            mod="$NOC\u2248$WHITE$mod$NOC"
        fi
        if [ $add -gt 0 ] ; then 
            add="$HRED$add$NOC"
        else
            add="$NOC$WHITE$add$NOC"
        fi
        if [ $del -gt 0 ] ; then 
            del="$HRED$del$NOC"
        else
            del="$NOC$WHITE$del$NOC"
        fi

        if [ $unk -gt 0 ] ; then 
            unk="?$CYAN$unk$NOC"
        else
            unk=""
        fi   

        gitpart="  [$branch]$NOC $mod \u002b$add \u2212$del $unk $rstat"

        echo -e $gitpart;
     fi

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

# Zoxide
eval "$(zoxide init --cmd cd bash)"

# Go dev
export GOROOT=/usr/local/go
export GOPATH=$HOME/golib

GOCODE=$HOME/gocode
mkdir -p $GOCODE
mkdir -p $GOCODE/src
mkdir -p $GOCODE/pkg
mkdir -p $GOCODE/bin

GOBIN=$GOROOT/bin:$GOCODE/bin:$GOPATH/bin

export GOPATH=$GOPATH:$GOCODE 
export PATH=$PATH:$GOBIN


# Final prompt 
export PS1="\[\e[36;1m\]┌───=[ \[\e[39;1m\]\u@\[\e[36;36m\]\h ] \[\e[0;32m\]\w\[\033[33m\] \$(parse_perlbrew) \$(parse_git_branch)\[\033[00m\]\n\[\e[36;1m\]└──$ \[\e[0m\]" 
#export PS1="\[\e[36;1m\]┌───=[ \[\e[39;1m\]\u@\h\[\e[33;32m\] \w\[\033[33m\] \$(parse_perlbrew) \$(parse_git_branch)\[\033[00m\]\n\[\e[36;1m\]└──( \[\e[0m\]"  

if [ -f ~/.bashrc.load ]; then 
    . $HOME/.bashrc.load
fi

if [ -f $HOME/.bashrc.aliases ]; then
    . $HOME/.bashrc.aliases 
fi 


if [ -f ~/.bashrc.$HOSTNAME ]; then
    . ~/.bashrc.$HOSTNAME
fi

# Sub domain file.
if [ -f ~/.bashrc.${HOSTNAME%%.*} ]; then
    . ~/.bashrc.${HOSTNAME%%.*}
fi


return 0


