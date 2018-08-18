#!/usr/bin/env bash

convert *.png -resize 200 -set filename:name '%t' '%[filename:name].png' && optipng *.png