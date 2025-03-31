#!/bin/bash

set -euo pipefail

# Load ID variable
. /etc/os-release


case "$ID" in
  centos*)  OS_FAMILY="redhat" ;;
  debian*)  OS_FAMILY="debian" ;;
  ubuntu*)  OS_FAMILY="ubuntu" ;;
  *)
     echo "Unknown OS family"
     exit 1;;
esac

REDHAT_DEPS=(
   autoconf 
   bind-utils
   lsof
   libtool 
   automake  
   ctags 
   git 
   tcl-devel
   ruby 
   ruby-devel
   lua 
   lua-devel
   luajit 
   luajit-devel 
   python 
   python-devel
   perl 
   perl-devel 
   perl-ExtUtils-ParseXS 
   perl-ExtUtils-XSpp 
   perl-ExtUtils-CBuilder
   perl-ExtUtils-Embed
   the_silver_searcher
   strace 
);

DEBIAN_DEPS=(
   sudo 
   vim 
   build-essential 
#   ctags 
   locales 
   automake 
   libtool 
   libncurses-dev 
   curl 
   dnsutils 
   strace 
   silversearcher-ag 
   tcpdump
   ripgrep
   ranger
);

UBUNTU_DEPS=(
   sudo 
   vim 
   build-essential
   exuberant-ctags
   locales 
   automake 
   libtool 
   libncurses-dev 
   curl 
   dnsutils 
   strace 
   silversearcher-ag 
   tcpdump
   ripgrep
   ranger 
); 

install_redhat_deps () {
  echo "Installing Redhate packages"

  sudo yum install -y epel-release.noarch
  sudo yum install -y ${REDHAT_DEPS[@]}
}

install_debian_deps () {
  echo "Installing $ID packages"

  sudo apt update

  sudo apt-get install -y $@
}


install_libevent () {

  if [[ -f "libevent/.install_completed" ]]; then
     echo "libevent already install"
     return
  fi

  git clone https://github.com/libevent/libevent.git
  pushd libevent/
  git checkout release-2.1.7-stable
  ./autogen.sh
  ./configure --prefix=/usr/local
  make
  sudo make install
  touch .install_completed
  popd

}

install_tmux () {

  if [[ -f "tmux-3.1/.install_completed" ]]; then
     echo "tmux already install"
     return
  fi
  
  curl -LOk  https://github.com/tmux/tmux/releases/download/3.1/tmux-3.1.tar.gz
  tar -zxvf tmux-3.1.tar.gz
  pushd tmux-3.1/
  LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
  make
  sudo make install
  touch .install_completed
  popd

}

install_vim () {

  if [[ -f "vim/.install_completed" ]]; then
     echo "vim already install"
     return
  fi

  git clone https://github.com/vim/vim.git
   
  pushd vim
  ./configure --with-features=huge \
              --enable-multibyte \
              --enable-rubyinterp \
              --enable-pythoninterp \
              --enable-perlinterp \
              --enable-luainterp
   
  make
  sudo make install

  touch .install_completed
  popd

}

install_fzf () {

  if [[ -f ".fzf/.install_completed" ]]; then
     echo "fzf already install"
     return
  fi 

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  pushd .fzf
  ./install 
  touch .install_completed 

  popd
}

install_zoixide () {

   curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

}

case "$OS_FAMILY" in
  redhat*) 
    install_redhat_deps ;;
  debian*)  
    install_debian_deps "${DEBIAN_DEPS[@]}" ;;
    VERSION=$(cat /etc/debian_version);

    if [[ $VERSION > 11 ]]: then 
       sudo apt-get install -y tmux
       SKIP_TMUX_BUILD=1;
    fi

    ;;

  ubuntu*)  
    install_debian_deps "${UBUNTU_DEPS[@]}"  ;;
  *)
esac

pushd ~/

if [[ $SKIP_TMUX_BUILD -ne 1 ]]; then
  install_libevent 
  install_tmux 
fi
install_vim
install_fzf 
install_zoixide

dotfiles/bin/dfm

vim +PlugInstall +qall

popd

