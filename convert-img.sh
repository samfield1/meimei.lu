#!/bin/bash
# Simple script to convert all images to webp
# The images are too large, so I need them to be webp before uploading to GitHub

# Only executes in project base directory
cd $(dirname $(basename $0))

quality=100
overwrite=false
while getopts ":q:f" opt; do
    case $opt in
    q) quality=$OPTARG;;
    f) overwrite=true;;
    ?) exit 1;;
    esac
done


images=$(find assets/og-img | grep -E ".*\.(jpg|gif|png|jpeg)$")
images=($images)
images_n=${#images[*]}
for (( i = 0; i < images_n; i++ )); do
    in_image=${images[$i]}
    out_image=$(sed -e 's/\/og-img//g' <<<$in_image)
    out_image=${out_image%.*}.webp

    mkdir -p $(dirname $out_image)
    if [[ -s $out_image && ! $overwrite ]]; then
        echo "($((i+1))/$images_n) Skipping $in_image (webp exists)"
    else
        echo "($((i+1))/$images_n) Coverting $in_image"
        cwebp -q $quality $in_image -o $out_image >/dev/null 2>&1
    fi
done

echo "Completed image conversion."