function fish_right_prompt
    set -l normal (set_color normal)
    set -l dim (set_color brblack)
    set -l segments

    if test -n "$CMD_DURATION"
        set -l duration $CMD_DURATION
        if test $duration -ge 1000
            set -l seconds (math --scale=1 $duration / 1000)
            if test $seconds -ge 60
                set -l minutes (math --scale=0 "floor($seconds / 60)")
                set -l secs (math --scale=0 "$seconds % 60")
                set segments $segments "$minutes""m""$secs""s"
            else
                set segments $segments "$seconds""s"
            end
        end
    end

    set segments $segments (date "+%H:%M")

    if test (count $segments) -gt 0
        echo -n -s $dim (string join "  " -- $segments) $normal
    end
end
