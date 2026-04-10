zoxide init fish | source
set -gx DIRENV_LOG_FORMAT ""
direnv hook fish | source

set -gx EDITOR nvim

# opencode
fish_add_path /Users/michalurban/.opencode/bin
