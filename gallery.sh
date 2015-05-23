#!/bin/bash
 
#################################################
# script to make an html photo gallery with thumbnails
# by tony baldwin / tonybaldwin.info
# released according to the terms of the Gnu Public License v. 3 or later
#################################################
 
filedate=$(date +%m%d%y%H%M%S)

index_file=index.html
IMAGE_DIR=img
THUMBS_DIR=thumbs
##############################
# make thumbnails.
#############################

echo "normalize img ... "

for i in $(ls $IMAGE_DIR/*.*); do 
   lower=$(echo "$i" | sed -r "s/([^.]*)\$/\L\1/")
   if [ "$lower" != "$i" ]
   then
      mv "$i" "$lower"
   fi
done

echo "making thumbnails ... "
 
mkdir -p $THUMBS_DIR
rm -rf $THUMBS_DIR/*

for i in $(ls $IMAGE_DIR/*.jpg); do 
   convert $i -thumbnail x200 -resize '200x<' -resize 50% -gravity center -crop 100x100+0+0 +repage -format jpg -quality 91 $THUMBS_DIR/thumb.$(basename $i)
done
 
ls $THUMBS_DIR 
echo "thumbs done ... "
 
echo "making index file ... "
 
##############################
# make index page
##############################
 
title=${1:-galeria}

cat > $index_file <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> 
<html>
   <head> 
      <meta http-equiv="content-type" content="text/html; charset=utf-8"> 
      <link href="http://YOURURL.com/photo.css" rel="stylesheet" type="text/css" media="screen"> 
      <meta name="Author" content="YOUR NAME HERE"> 
      <meta name="Description" content="photos by YOUR NAME HERE"> 
      <meta name="Generator" content="photogal bash script by tony baldwin">
      <meta name="Keywords" content="photos"> 
      <meta name="Language" content="en"> 
      <link rel="icon" type="image/png" href="http://YOURURL.com/favicon.png"> 
      <title>tony's photos - $title - $filedate</title> 
   </head> 
   <body> 
      <div id="header"> 
         <p><a href="http://YOURURL.com"><img src="http://YOURURL.com/LOGOIMG.jpg"><br>photography by YOURNAME</a></p> 
      </div>
   <div id="main"> 
      <p> $title - $filedate</p> 
      <p>Click on a thumbnail to see the full size image.</p>
      <p>Newest comments added at the bottom of the page. <a href="#comment">Go down : add comment</a></p>
EOF
 
for i in $(ls $IMAGE_DIR/*.jpg); do
   cat >> $index_file <<EOF
      <p><a href="$i" target="_blank"><img src="thumbs/thumb.$(basename $i)"><br>$i</a></p>
EOF
done
 
cat >> $index_file <<EOF
   </div>
   <!-- start footer --> 
   <div id="footer"> 
      <p>all images &copy <a href="http://www.YOURURL.tld">YOUR NAME HERE</a></p> 
      <p>The gallery generation scripts with which this was was generated are <a href="http://wiki.tonybaldwin.me/doku.php/hax/bash/photogal">available at wiki.tonybaldwin.me</a></p> 
   </div> 
   <!-- end footer --> 
</body>
</html>
EOF
 
