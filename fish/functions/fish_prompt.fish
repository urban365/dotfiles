function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l accent_color (set_color magenta)
    set -l dir_color (set_color cyan)
    set -l meta_color (set_color brblack)
    set -l error_color (set_color red)
    set -l venv_color (set_color yellow)

    # Keep the first line focused on repo context, similar to a compact starship layout.
    if set -q VIRTUAL_ENV
        set -l venv_name (basename $VIRTUAL_ENV)
        echo -n -s $venv_color $venv_name $normal " " $meta_color "in" $normal " "
    else if set -q CONDA_DEFAULT_ENV
        echo -n -s $venv_color $CONDA_DEFAULT_ENV $normal " " $meta_color "in" $normal " "
    end

    set -l cwd (prompt_pwd --dir-length 2)
    echo -n -s $dir_color $cwd $normal

    set -l git_info (__fish_git_prompt_info)
    if test -n "$git_info"
        echo -n -s " " $git_info
    end

    echo

    if test $last_status -ne 0
        echo -n -s $error_color "❯ " $normal
    else
        echo -n -s $accent_color "❯ " $normal
    end
end
