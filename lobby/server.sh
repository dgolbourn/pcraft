#!/bin/bash
startup() {
    echo "Server started"
    aws lambda invoke --function-name percycraft-StartLambda /dev/null
    while true; do
        sleep 1
    done
}

shutdown() {
    kill $PID
    echo "Server complete"
}

trap shutdown TERM INT
IP=$1
startup &
PID=$!
wait $PID
trap - TERM INT
wait $PID
