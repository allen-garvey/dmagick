#!/usr/bin/env bash

#.jpg often smaller than .png at small sizes since we don't need perfect quality anyway
# uses liquid (seam carving) resizing to generate thumbnail directly from masters



convert *.png -resize 200 -set filename:name '%t' '%[filename:name]-thumb.png'

time convert *.png -liquid-rescale 200x200! -quality 60% -set filename:name '%t' '%[filename:name].jpg'