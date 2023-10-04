#!/bin/bash
source /opt/.env
aws lambda invoke --function-name $STARTSTOPLAMBDA --payload "{\"start\":false,\"referrer\":\"server\"}" --cli-binary-format raw-in-base64-out /dev/null
aws lambda invoke --function-name $STARTSTOPLAMBDA --payload "{\"start\":false,\"referrer\":\"scheduler\"}" --cli-binary-format raw-in-base64-out /dev/null
