fish_add_path /snap/nvim/current/usr/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/bin

set -g fish_greeting

zoxide init fish --cmd cd | source
starship init fish | source

abbr -a c clear
abbr -a cd.. cd ..
abbr -a gdb-gef gdb -x ~/.gdb/gef/gef.py
abbr -a gdb-pwn gdb -x ~/.gdb/pwndbg/gdbinit.py
