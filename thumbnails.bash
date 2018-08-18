#!/usr/bin/env bash

convert *.tif -resize 200 -quality 90% -set filename:name '%t' '%[filename:name].jpg' && jpegoptim *.jpg