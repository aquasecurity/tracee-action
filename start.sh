#!/bin/bash

workdir="$1"

until [ -f "$workdir"/out/tracee.pid ]
do
		docker ps
    echo "Waiting for Tracee to get ready..."
    sleep 2
done
echo "Tracee Running..."
exit
