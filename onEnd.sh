#!/bin/bash

FLASKDIR=../mcde/app

rm -rf $FLASKDIR/static/webpack/
mkdir -p $FLASKDIR/static/webpack/
cp -r dist/* $FLASKDIR/static/webpack/
mv $FLASKDIR/static/webpack/index.html $FLASKDIR/templates/index.html
# rm -f $FLASKDIR/static/webpack/js/*.js.map
echo Copied files
