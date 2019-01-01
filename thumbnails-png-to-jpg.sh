#!/usr/bin/env bash

#.jpg often smaller than .png at small sizes since we don't need perfect quality anyway

convert *.png -resize 200 -quality 60% -set filename:name '%t' '%[filename:name].jpg' && jpegoptim *.jpg