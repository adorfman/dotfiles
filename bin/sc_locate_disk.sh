#!/bin/bash

disk_label=$1

component=$( glabel status | awk "/$disk_label/ { print \$3 }" )
serial=$( diskinfo -v $component | awk '/Disk ident/ { print $1 }' )

enclosure_slot=$( sas3ircu 0 display | grep -B9 $serial | awk '{ if ( $1=="Enclosure" ) { ENC=$4 } else if ( $1=="Slot" ) { SLOT=$4 } } END { print ENC":"SLOT }' )

echo $enclosure_slot

sas3ircu  0 locate $enclosure_slot ON
