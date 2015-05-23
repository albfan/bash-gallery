#!/bin/bash
 
#################################################
# script to make an html photo gallery with thumbnails
# to upload to my server.
# by tony baldwin / tonybaldwin.info
# released according to the terms of the Gnu Public License v. 3 or later
#################################################
 
filedate=$(date +%m%d%y%H%M%S)
 
##############################
# make thumbnails.
#############################
 
echo "making thumbnails ... "
 
for i in $(ls *.jpg); do 
convert $i -thumbnail x200 -resize '200x<' -resize 50% -gravity center -crop 100x100+0+0 +repage -format jpg -quality 91 thumb.$i
done
 
mkdir thumbs
mv thumb* thumbs
ls thumbs/
 
echo "thumbs done ... "
 
echo "making index file ... "
 
##############################
# make index page
##############################
 
read -p "Enter title: " title
 
echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"> 
<html><head> 
<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"> 
<link href=\"http://YOURURL.com/photo.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\"> 
<meta name=\"Author\" content=\"YOUR NAME HERE\"> 
<meta name=\"Description\" content=\"photos by YOUR NAME HERE\"> 
<meta name=\"Generator\" content=\"photogal bash script by tony baldwin\">
<meta name=\"Keywords\" content=\"photos\"> 
<meta name=\"Language\" content=\"en\"> 
<link rel=\"icon\" type=\"image/png\" href=\"http://YOURURL.com/favicon.png\"> 
<title>tony's photos - $title - $filedate</title> 
</head> 
<body> 
<div id=\"header\"> 
<p><a href=\"http://YOURURL.com\"><img src=\"http://YOURURL.com/LOGOIMG.jpg\"><br> 
photography by YOURNAME</a></p> 
</div>
<div id=\"main\"> 
 
<p> $title - $filedate</p> 
<p>Click on a thumbnail to see the full size image.</p>
<p>Newest comments added at the bottom of the page. <a href="#comment">Go down : add comment</a></p>" >> index.php
 
for i in $(ls *.jpg); do
 echo "<p><a href=\"$i\" target=\"_blank\"><img src=\"thumbs/thumb.$i\"><br>$i</a></p>" >> index.php
done
 
echo "</div>
<!-- start footer --> 
<div id=\"footer\"> 
<p>all images &copy <a href=\"http://www.YOURURL.tld\">YOUR NAME HERE</a></p> 
<p>The gallery generation scripts with which this was was generated are <a href=\"http://wiki.tonybaldwin.me/doku.php/hax/bash/photogal\">available at wiki.tonybaldwin.me</a></p> 
</div> 
<!-- end footer --> 
</body></html>" >> index.php
 
echo "all done ...  load em up!"
 
###########################
# scp copy to server
##########################
 
 
scp -r $(pwd) USERNAME@IPADDRESSORURL:/path/to/directory/
 
pdir=${PWD##*/}
 
echo "Your gallery is now at http://YOURURL.com/DIRECTORY/$pdir"
read -p "Would you like to open it in your a browser now? (y/n): " op
 
if [ $op = "y" ]; then
	xdg-open http://YOURURL.com/DIRECTORY/$pdir
fi
 
exit