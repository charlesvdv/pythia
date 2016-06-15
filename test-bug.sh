declare -i i=1
declare -i bug=0

while [ $bug -lt 50 ]; do
    echo "TEST NUMBER: "$((i++))" BUG NUMBER: "${bug}
    echo "STAT: "$(bc <<< "scale = 5; $bug/$i")

    out=$(make check)
    # If exit code != 0 then we got an error
    if [ $? -ne 0 ]; then
        ((bug++))

        # save the bug in a log file (random name)
        # https://gist.github.com/earthgecko/3089509
        randstr=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
        echo $out | grep "bad file descriptor"
        if [ $? -eq 0 ]; then
            randstr="bad-file-${randstr}"
        fi
        echo $out
        echo $out > "../log/${randstr}.txt"
    fi
done
