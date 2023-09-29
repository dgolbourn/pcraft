#!/bin/bash
get_player_count() {
    IFS=','
    read -a tmp <<< $(echo -n -e "\xFE\x01" | nc 127.0.0.1 25565 | sed 's/\x0\x0\x0/,/g'| sed 's/\x0//g')
    echo ${tmp[4]}
}

status() {
    SECONDS=0
    DONE=false
    PLAYERS=0
    while true; do
        COUNT=$(get_player_count)
        COUNT=$(($COUNT+0))
        if (( $COUNT > 0 )); then
            SECONDS=0
            if (( $COUNT != $PLAYERS )); then
                PLAYERS=$COUNT
                echo $COUNT
            fi
            if (( $DONE )); then
                DONE=false
                echo active
                aws lambda invoke --function-name percycraft-StartStopLambda --payload "{\"start\":true,\"referrer\":\"server\"}" /dev/null
            fi
        elif (( $SECONDS > 3600 )); then
            if (( !$DONE )); then
                DONE=true
                echo idle
                aws lambda invoke --function-name percycraft-StartStopLambda --payload "{\"start\":false,\"referrer\":\"server\"}" /dev/null
            fi
        else
            if (( $COUNT != $PLAYERS )); then
                PLAYERS=$COUNT
                echo quiet                            
            fi
        fi
        sleep 10
    done
}

status
