#!/bin/bash
source /opt/.env

get_player_count() {
    IFS=','
    read -a tmp <<< $(echo -n -e "\xFE\x01" | nc -w 60s 127.0.0.1 25565 | sed 's/\x0\x0\x0/,/g'| sed 's/\x0//g')
    echo ${tmp[4]}
}

ready() {
    echo waiting
    while true; do
        nc -w 60s -z 127.0.0.1 25565 < /dev/null
        if (( $? == 0 )); then
            echo ready >&2
            INSTANCE_ID=$(ec2-metadata --instance-id | cut -d " " -f 2)
            aws lambda invoke --function-name $STARTCONTINUELAMBDA --payload "{\"detail\":{\"EC2InstanceId\":\"$INSTANCE_ID\"}}" --cli-binary-format raw-in-base64-out /dev/null
            break
        fi
    done
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
                echo active >&2
                aws lambda invoke --function-name $STARTSTOPLAMBDA --payload "{\"start\":true,\"referrer\":\"server\"}" --cli-binary-format raw-in-base64-out /dev/null
            fi
        elif (( $SECONDS > 3600 )); then
            if (( !$DONE )); then
                DONE=true
                echo idle >&2
                aws lambda invoke --function-name $STARTSTOPLAMBDA --payload "{\"start\":false,\"referrer\":\"server\"}" --cli-binary-format raw-in-base64-out /dev/null
            fi
        else
            if (( $COUNT != $PLAYERS )); then
                PLAYERS=$COUNT
                echo $COUNT
                echo quiet >&2
            fi
        fi
        sleep 10
    done
}

ready
status
