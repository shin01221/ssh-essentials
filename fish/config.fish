set -g fish_key_bindings fish_vi_key_bindings
set -gx MANPAGER "nvim +Man!"
bind -M insert jj 'set fish_bind_mode default; commandline -f repaint-mode'

# sourcing my functions
# for f in ~/.config/fish/functions/user/*.fish
#     source $f
# end

set -gx PATH $HOME/.local/bin $PATH
starship init fish | source

if status is-interactive # Commands to run in interactive sessions can go here
    # No greeting
    set fish_greeting
    bind \cr _atuin_search
    bind k _atuin_search
    bind -M insert \cr _atuin_search
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
end
zoxide init fish | source
# aliases

alias grep='grep --color=auto'
alias p='sudo pacman'
alias rm='trash -d'
alias cd='z'
alias cp='cp -r'
alias cat="bat --theme=base16"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias c='clear' # clear terminal
alias l='lsd -1 --icon=auto' # long list
alias ls='lsd -a --group-dirs=first --icon=auto' # short list
alias la='lsd -a -1 --group-dirs=first --icon=auto' # short list
alias ll='lsd -l --group-dirs=first --icon=auto --blocks permission,user,name --date "+%Y-%m-%d %H:%M"' # long list all
alias lt='lsd --tree --depth 2 --group-dirs=first --icon=auto' # list folder as tree
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'
