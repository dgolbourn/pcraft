#!/bin/bash
startup() {
    echo "Server started"
    iptables -D INPUT -s $IP -j DROP
    aws lambda invoke --function-name percycraft-StartLambda /dev/null
    while true; do
        sleep 1
    done
}

shutdown() {
    kill $PID
    iptables -A INPUT -s $IP -j DROP
    aws lambda invoke --function-name percycraft-StopLambda /dev/null
    echo "Server complete"
}

trap shutdown TERM INT
IP=$1
startup &
PID=$!
wait $PID
trap - TERM INT
wait $PID
