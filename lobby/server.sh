#!/bin/bash
startup() {
    echo "Server started"
    aws lambda invoke --function-name percycraft-StartStopLambda --payload "{\"start\":true,\"referrer\":\"server\"}" --cli-binary-format raw-in-base64-out/dev/null
    nc -lv 25566
}

startup &
