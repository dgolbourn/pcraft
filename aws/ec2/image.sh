#!/bin/bash
echo "Generating png of world started"
ts=$(date +"%Y%m%d-%H%M%S")
imageFile="/efs/album/world-${ts}.png"
/opt/mca-selector/bin/java -D/opt/mca-selector/bin -Xmx6g -jar /opt/mca-selector/lib/mca-selector.jar --mode select --world /opt/data/world --query "InhabitedTime > \"2 minutes\"" --radius 5 --output selection.csv
xvfb-run /opt/mca-selector/bin/java -D/opt/mca-selector/bin -Xmx6g -jar /opt/mca-selector/lib/mca-selector.jar --mode image --world /opt/data/world --selection selection.csv --output $imageFile
rm selection.csv
ln -sf ${imageFile} /efs/album/latest.png
aws s3 cp /efs/album/latest.png $FILEBUCKETS3URI/album/
echo "Generating png of world complete"
