#!/bin/bash
startup() {
    echo "Server started"
    aws lambda invoke --function-name percycraft-StartStopLambda --payload "{\"start\":true,\"referrer\":\"server\"}" /dev/null
    while true; do
        sleep 1
    done
}

startup &
