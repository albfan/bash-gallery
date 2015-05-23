#!/bin/bash
 
#################################################
# script to make an html photo gallery with thumbnails
# by tony baldwin / tonybaldwin.info
# released according to the terms of the Gnu Public License v. 3 or later
#################################################
 
filedate=$(date +%m%d%y%H%M%S)

IMAGE_DIR=${1:-img}
THUMBS_DIR=${2:-thumbs}
index_file=${3:-index.html}
title=${4:-gallery}
##############################
# make thumbnails.
#############################

echo "making thumbnails ... "
 
mkdir -p $THUMBS_DIR
rm -rf $THUMBS_DIR/*

for i in $(ls $IMAGE_DIR/*.*); do 
   lower=$(echo "$i" | sed -r "s/.*\.([^.]*)\$/\L\1/")
   if [ "$lower" == "jpg" ]
   then
      convert $i -thumbnail x200 -resize '200x<' -resize 50% -gravity center -crop 100x100+0+0 +repage -format jpg -quality 91 $THUMBS_DIR/thumb.$(basename $i)
   fi
done
 
ls $THUMBS_DIR 
echo "thumbs done ... "

echo "making index file ... "
 
##############################
# make index page
##############################
 

cat > $index_file <<EOF
<html class="">
   <head>
      <meta charset="UTF-8">
      <meta name="robots" content="noindex">
      <link rel="canonical" href="http://codepen.io/bradfrost/pen/xkcBn">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet prefetch" href="http://bradfrost.github.com/this-is-responsive/styles.css">
      <style type="text/css" class="cp-pen-styles">
      <title>$title - $filedate</title>
.g {
   padding: 0.25em;
   overflow: hidden;
}

.g li {
   float: left;
   width: 50%;
   padding: 0.25em;
}

.g img {
   display: block;
}

.g li:nth-child(odd) {
   clear: left;
}

  @media screen and (min-width: 40em) {
     .g li {
        width: 33.3333333333333333%;
     }
     .g li:nth-child(3n+1) {
        clear: left;
     }
     .g li:nth-child(odd) {
        clear: none;
     }
  }

  @media screen and (min-width: 55em) {
     .g li {
        width: 25%;
     }
     .g li:nth-child(4n+1) {
        clear: left;
     }
     .g li:nth-child(3n+1) {
        clear: none;
     }
  }

  @media screen and (min-width: 72em) {
     .g li {
        width: 20%;
     }
     .g li:nth-child(5n+1) {
        clear: left;
     }
     .g li:nth-child(4n+1) {
        clear: none;
     }
  }

  @media screen and (min-width: 90em) {
     .g li {
        width: 16.666666666%;
     }
     .g li:nth-child(6n+1) {
        clear: left;
     }
     .g li:nth-child(5n+1) {
        clear: none;
     }
  }</style></head><body>
      <!--Pattern HTML-->
      <div id="pattern" class="pattern">
         <ul class="g">
EOF
 
for i in $(ls $IMAGE_DIR/*.*); do
   lower=$(echo "$i" | sed -r "s/.*\.([^.]*)\$/\L\1/")
   if [ "$lower" == "jpg" ]
   then
   cat >> $index_file <<EOF
            <li><a href="$i"><img src="thumbs/thumb.$(basename $i)"><br>$i</a></li>
EOF
   fi
done
 
cat >> $index_file <<EOF
         </ul>
      </div>
      <!--End Pattern HTML-->

      <script src="/assets/editor/live/css_live_reload_init.js"></script>
</body>
</html>
EOF
 
