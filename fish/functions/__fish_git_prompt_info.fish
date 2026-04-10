function __fish_git_prompt_info
    # Fast check — bail if not in a git repo
    set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
    or return

    set -l normal (set_color normal)
    set -l branch_color (set_color green)
    set -l dirty_color (set_color yellow)
    set -l staged_color (set_color cyan)
    set -l ahead_behind_color (set_color magenta)

    # Branch or detached HEAD
    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch (command git describe --tags --exact-match HEAD 2>/dev/null)
        if test -z "$branch"
            set branch (command git rev-parse --short HEAD 2>/dev/null)
        end
    end

    set -l info " $branch_color $branch"

    # Staged / unstaged / untracked counts using porcelain for speed
    set -l git_status (command git status --porcelain=v1 2>/dev/null)

    set -l staged 0
    set -l modified 0
    set -l untracked 0

    for line in $git_status
        set -l idx (string sub -l 2 -- $line)
        set -l x (string sub -s 1 -l 1 -- $idx)
        set -l y (string sub -s 2 -l 1 -- $idx)

        if test "$x" = "?"
            set untracked (math $untracked + 1)
        else
            if string match -qr '[MADRC]' -- $x
                set staged (math $staged + 1)
            end
            if string match -qr '[MADRC]' -- $y
                set modified (math $modified + 1)
            end
        end
    end

    if test $staged -gt 0
        set info "$info $staged_color+$staged"
    end
    if test $modified -gt 0
        set info "$info $dirty_color!$modified"
    end
    if test $untracked -gt 0
        set info "$info $dirty_color?$untracked"
    end

    # Ahead/behind upstream
    set -l ab (command git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
    if test $status -eq 0
        set -l ahead (string split \t -- $ab)[1]
        set -l behind (string split \t -- $ab)[2]
        if test "$ahead" -gt 0
            set info "$info $ahead_behind_color↑$ahead"
        end
        if test "$behind" -gt 0
            set info "$info $ahead_behind_color↓$behind"
        end
    end

    # Stash count
    set -l stash_count (command git stash list 2>/dev/null | count)
    if test $stash_count -gt 0
        set info "$info $dirty_color≡$stash_count"
    end

    echo -n -s $info $normal
end
