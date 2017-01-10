#!/bin/bash

# This is a one-line for loop for batch mkv conversion

mkdir out && for f in *.mkv; do avconv -i "$f" -vcodec copy -acodec aac -scodec copy -strict experimental ./out/"${f%.mkv}.mkv"; done
