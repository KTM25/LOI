#!/bin/bash

#--------Conversion-SVG > PNG
if [[ ! -d ./pngIcons ]]; then mkdir ./pngIcons; fi

prog() {
    local w=100 p=$1;  shift
    show="$(($p*$w/$filec))"
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$show" ""; dots=${dots// /#};
    # # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$show" "$*";
}

filec=$(ls -l *.svg | wc -l)

for i in *.svg
do
x=$((x+1))
prog "$x" Converting to PNG
sleep .1
rsvg-convert $i -o `echo $i | sed -e 's/svg$/png/'` > out.log 2> /dev/null
mv *.png ./pngIcons/

done ; echo

# # #----------------------Batch-PNG > ICNS
x=0
filec=$(ls -l *.svg | wc -l)

for i in ./pngIcons/*.png
do

x=$((x+1))
prog "$x" Converting to ICNS
sleep .1

mkdir ./pngIcons/MyIcon.iconset
sips -z 16 16     $i --out ./pngIcons/MyIcon.iconset/icon_16x16.png > out.log 2> /dev/null
sips -z 32 32     $i --out ./pngIcons/MyIcon.iconset/icon_16x16@2x.png > out.log 2> /dev/null
sips -z 32 32     $i --out ./pngIcons/MyIcon.iconset/icon_32x32.png > out.log 2> /dev/null
sips -z 64 64     $i --out ./pngIcons/MyIcon.iconset/icon_32x32@2x.png > out.log 2> /dev/null
sips -z 128 128   $i --out ./pngIcons/MyIcon.iconset/icon_128x128.png > out.log 2> /dev/null
sips -z 256 256   $i --out ./pngIcons/MyIcon.iconset/icon_128x128@2x.png > out.log 2> /dev/null
sips -z 256 256   $i --out ./pngIcons/MyIcon.iconset/icon_256x256.png > out.log 2> /dev/null
sips -z 512 512   $i --out ./pngIcons/MyIcon.iconset/icon_256x256@2x.png > out.log 2> /dev/null
sips -z 512 512   $i --out ./pngIcons/MyIcon.iconset/icon_512x512.png  > out.log 2> /dev/null

cp $i ./pngIcons/MyIcon.iconset/icon_512x512@2x.png
iconutil -c icns ./pngIcons/MyIcon.iconset
mv ./pngIcons/MyIcon.icns $i.icns
newName=$(echo $i.icns | sed 's/\.png//')
mv $i.icns $newName
rm -R ./pngIcons/MyIcon.iconset
done ; echo

if [[ ! -d ./complete ]]; then mkdir ./complete; fi
mv ./pngIcons/*.icns ./complete

x=0
filec=$(ls -l *.svg | wc -l)

#------Cleanup
for i in ./pngIcons/*.png
do

x=$((x+1))
prog "$x" Cleanup
if [[ -f out.log ]]; then rm out.log; fi
rm -rf ./pngIcons

done; echo
