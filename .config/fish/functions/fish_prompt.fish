function fish_prompt
    set -l last_status $status

    set_color green
    echo -n -s "$USER@$hostname "

    set_color blue
    echo -n (prompt_pwd --dir-length=0)

    set_color red
    echo -n (fish_git_prompt " %s")
    if test $last_status -ne 0
        echo -n " [$last_status]"
    end

    echo -n -e "\n> "
end
