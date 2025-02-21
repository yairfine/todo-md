#!/bin/bash
SEARCH_PATTERN="(TODO|todo)(\s+(\w){1,3})?\s*[:-]?\s*"
ROOT=$(git rev-parse --show-toplevel)
OUTFILE="TODO.md"
EXCLUDE=''

while getopts "ohlf:t:e:i:" option; do
    case $option in
        'o' )
            STDOUT=true
        ;;
        'h' )
            echo "$(basename $0) - generate a todo file based on your code"
            echo "---"
            echo    "  -h - display this help"
            echo -n "  -l - LIVE MODE this will add the generated file to your "
            echo    "staged changes."
            echo -n "       Use this in the git hook. Off by default "
            echo    "for playing around in the terminal"
            echo    "  -o - print output to STDOUT"
            echo -n "  -f - write to this file (defaults to TODO.md and path "
            echo    "starts at the repo's root)"
            echo    "  -t - text to search for (defaults to TODO)"
            echo    "  -e - exclude pattern"
            echo    "  -i - include patter"
            exit
        ;;
        'l' )
            LIVEMODE=true
        ;;
        'f' )
            OUTFILE=$OPTARG
        ;;
        't' )
            SEARCH_PATTERN=$OPTARG
        ;;
        'e' )
            EXCLUDE="$EXCLUDE$OPTARG|"
        ;;
        'i' )
            if [[ -z $INCLUDE ]]; then
                INCLUDE=$OPTARG
            else
                INCLUDE="$INCLUDE|$OPTARG"
            fi
        ;;
    esac
done

if [[ $INCLUDE ]] && [[ $EXCLUDE ]]; then
    echo "-i and -e can't be used together!"
    exit 1
fi

EXCLUDE=$EXCLUDE$OUTFILE

if [ $STDOUT ] && [ $LIVEMODE ]; then
    echo "-o and -l can't be used together! Ignoring -l" >&2
    unset LIVEMODE
fi

OUTFILE="$ROOT/$OUTFILE"
if [ -z $STDOUT ]; then
    exec 1>$OUTFILE
fi

echo "# To Do"
echo

# For performance reasons, prefer use ripgrep or ag
# Otherwise, fallback to git-grep

if command -v rg > /dev/null; then
    IFS=$'\r\n' tasks=($(rg --no-heading --with-filename --line-number --hidden -e "$SEARCH_PATTERN" "$ROOT" | egrep -v "($EXCLUDE)"))
elif command -v ag > /dev/null; then
    IFS=$'\r\n' tasks=($(ag --no-heading --filename --numbers --hidden "$SEARCH_PATTERN" "$ROOT" | egrep -v "($EXCLUDE)"))
else
    IFS=$'\r\n' tasks=($(git -C "$ROOT" grep -I --full-name --line-number -E "$SEARCH_PATTERN" | egrep -v "($EXCLUDE)"))
fi

# TODO: add support for -i (include)

for task in ${tasks[@]}; do
    file=$(echo $task | cut -f1 -d':')
    line=$(echo $task | cut -f2 -d':')
    item=$(echo $task | cut -f3- -d':' | sed -E "s/.*$SEARCH_PATTERN *//g")

    echo "- [ ] [$file:$line]($file#L$line) : $item"

done

echo
echo "###### Auto generated using [todo-md](https://github.com/yairfine/todo-md)"

if [ -z $LIVEMODE ]; then
    exit
fi

$(git add $OUTFILE)
