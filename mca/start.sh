#!/bin/bash
while read -r line; do
    java -jar mcaselector.jar $line
done