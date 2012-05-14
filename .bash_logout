# ~/.bash_logout


# restore default screen window name
case "$TERM" in
screen)
    DEFAULT_NAME='screen'
    echo -ne "\033k$DEFAULT_NAME\033\\"
    ;;
esac



clear

