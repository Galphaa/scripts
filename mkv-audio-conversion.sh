#!/bin/bash

for f in *.mkv; do avconv -i "$f" -vcodec copy -acodec aac -scodec copy -strict experimental "${f%.mkv}-out.mkv"; done