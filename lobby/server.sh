#!/bin/bash
startup() {
    echo "Server started"
    aws lambda invoke --function-name percycraft-StartLambda /dev/null
    while true; do
        sleep 1
    done
}

startup &
