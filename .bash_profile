# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

if command -v neofetch &> /dev/null; then
  neofetch
elif command -v fastfetch &> /dev/null; then
  fastfetch
fi

