function fish_right_prompt
    set -l normal (set_color normal)
    set -l dim (set_color brblack)

    # Command duration (show if > 1 second)
    if test $CMD_DURATION
        set -l duration $CMD_DURATION
        if test $duration -ge 1000
            set -l seconds (math --scale=1 $duration / 1000)
            if test $seconds -ge 60
                set -l minutes (math --scale=0 "floor($seconds / 60)")
                set -l secs (math --scale=0 "$seconds % 60")
                echo -n -s $dim $minutes "m" $secs "s" $normal
            else
                echo -n -s $dim $seconds "s" $normal
            end
        end
    end
end
