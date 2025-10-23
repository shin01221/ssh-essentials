set -g fish_key_bindings fish_vi_key_bindings
set -Ux fifc_editor nvim
set -gx MANPAGER "nvim +Man!"
bind -M insert jj 'set fish_bind_mode default; commandline -f repaint-mode'

set -gx PATH $HOME/.local/bin $PATH

if status is-interactive # Commands to run in interactive sessions can go here
    # No greeting
    set fish_greeting
    starship init fish | source
    atuin init fish --disable-up-arrow | source
    bind \cr _atuin_search
    bind k _atuin_search
    bind -M insert \cr _atuin_search

end
zoxide init fish | source
source ~/.config/fish/atuin.fish

# aliases

alias df="_df"
alias mirrors='sudo reflector --verbose --country Germany,France,Italy --protocol https --sort rate --latest 20 --download-timeout 6 --save /etc/pacman.d/mirrorlist'
alias grep='grep --color=auto'
alias p='sudo pacman'
alias rm='trash -d'
alias cd='z'
alias cp='cp -r'
alias cat="bat --theme=base16"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'
