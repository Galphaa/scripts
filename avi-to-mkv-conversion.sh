#!/bin/bash

# This is a one-line for loop for batch avi conversion

for f in *.avi; do avconv -i "$f" -vcodec h264 -acodec aac -scodec copy -strict experimental "${f%.avi}.mkv"; done
