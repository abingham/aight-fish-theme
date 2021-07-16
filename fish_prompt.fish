function fish_prompt

    # Keep the command executed status
    set --local last_status $status

    show_status $last_status
end


function show_path

    set_color blue
    echo -en "["

    set_color yellow
    echo -en (prompt_pwd)

    set_color blue
    echo -en "]"
end


function show_status -a last_status

    set --local current_color "FFF"

    if [ $last_status -ne 0 ]
        set current_color red
    end

    set_color $current_color
    echo -en "\$ "
    set_color normal
end


function fish_right_prompt

    # A dark grey
    set --local dark_grey 555

    set_color $dark_grey

    show_virtualenv_name
    show_git_info
    show_path

    set_color normal
end


function show_virtualenv_name

    if set -q VIRTUAL_ENV
        echo -en "["(basename "$VIRTUAL_ENV")"] "
    end
end


function show_git_info

    set --local LIMBO /dev/null
    set --local git_status (git status --porcelain 2> $LIMBO)
    set --local git_stash (git stash list 2> $LIMBO)
    set --local dirty ""

    [ $status -eq 128 ]; and return  # Not a repository? Nothing to do

    # If there is modifications, set repository dirty to '*'
    if not [ -z (echo "$git_status" | grep -e '^ M') ]
        set dirty "*"
    end

    # If there is new or deleted files, add  '+' to dirty
    if not [ -z (echo "$git_status" | grep -e '^[MDA]') ]
        set dirty "$dirty+"
    end

    # If there is stashed modifications on repository, add '^' to dirty
    if not [ -z (echo "$git_stash" | head -n1) ]
        set dirty "$dirty^"
    end

    # Prints git repository status
    echo -en "("
    echo -en (git_branch_name)$dirty
    echo -en ") "
end
