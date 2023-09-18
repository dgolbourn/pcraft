#!/bin/bash
cat /opt/percycraft/mc_init/bluemap/maps/overworld.conf

cat << EOF
marker-sets: {
    places: {
        label: "Places"
        toggleable: true
        default-hidden: false
        sorting: 0
        markers: {
EOF

counter=0
while read p; do
  if [[ $p == *"overworld"* ]]; then
    label="\"${p%=*}\""
    coordstring=${p#*,}
    IFS="," read -a coords <<< ${coordstring}
cat << EOF
            marker-${counter}: {
                type: "poi"
                position: {x:${coords[0]}, y:${coords[1]}, z:${coords[2]}}
                label: ${label}
            }
EOF
    (counter=counter+1)
  fi
done < /opt/data/config/coordfinder/places.properties

cat << EOF
        }
    }
}
EOF
