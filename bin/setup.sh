#!/bin/bash

set -euo pipefail

. /etc/os-release


case "$ID" in
  centos*)  OS_FAMILY="redhat" ;;
  debian*)  OS_FAMILY="bebian" ;; 
  *)        
     echo "Unknown OS family"
     exit 1;;
esac


REDHAT_DEPS=( autoconf libtool automake  
    ctags git tcl-devel
    ruby ruby-devel
    lua lua-devel
    luajit luajit-devel 
    python python-devel
    perl perl-devel 
    perl-ExtUtils-ParseXS 
    perl-ExtUtils-XSpp 
    perl-ExtUtils-CBuilder
    perl-ExtUtils-Embed
    the_silver_searcher
 
);

DEBIAN_DEPS=(
   sudo vim 
   build-essential 
   ctags locales 
   automake libtool 
   libncurses-dev 
   curl 
   dnsutils 
   strace 
   silversearcher-ag 
   tcpdump

);

install_redhat_deps () {
  echo "Installing Redhate packages"

  sudo yum install -y epel-release.noarch
  sudo yum install -y ${REDHAT_DEPS[@]}     
}

install_debian_deps () {
  echo "Installing Debian packages"

  apt-get install -y ${DEBIAN_DEPS[@]}     
}


install_libevent () {

  if [[ -f "libevent/.install_completed" ]]; then
     echo "libevent already install"
     return
  fi

  git clone https://github.com/libevent/libevent.git
  pushd libevent/
  git checkout release-2.1.8-stable
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

case "$OS_FAMILY" in
  redhat*) 
    install_redhat_deps ;;
  debian*)  
    install_debian_deps ;; 
  *)    
esac

pushd ~/

install_libevent 
install_tmux 
install_vim


dotfiles/bin/dfm

vim +PlugInstall +qall    

popd

