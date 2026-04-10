function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l arrow_color (set_color magenta)
    set -l dir_color (set_color blue)
    set -l error_color (set_color red)
    set -l venv_color (set_color yellow)

    # Virtual env indicator (Python)
    if set -q VIRTUAL_ENV
        set -l venv_name (basename $VIRTUAL_ENV)
        echo -n -s $venv_color "(" $venv_name ") " $normal
    else if set -q CONDA_DEFAULT_ENV
        echo -n -s $venv_color "(" $CONDA_DEFAULT_ENV ") " $normal
    end

    # Directory
    set -l cwd (prompt_pwd --full-length-dirs 2)
    echo -n -s $dir_color $cwd $normal

    # Git info
    set -l git_info (__fish_git_prompt_info)
    if test -n "$git_info"
        echo -n -s $git_info
    end

    # Arrow — red if last command failed, magenta otherwise
    if test $last_status -ne 0
        echo -n -s " " $error_color "❯ " $normal
    else
        echo -n -s " " $arrow_color "❯ " $normal
    end
end
