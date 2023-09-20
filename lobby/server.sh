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
    aws lambda invoke --function-name percycraft-StopLambda /dev/null
    echo "Server complete"
}

trap shutdown TERM INT
startup &
PID=$!
wait $PID
trap - TERM INT
wait $PID