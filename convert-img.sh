#!/bin/bash
# Simple script to convert all images to webp
# The images are too large, so I need them to be webp before uploading to GitHub

# Only executes in project base directory
cd $(dirname $(basename $0))

if [[ -n $1 ]]; then
    QUALITY=$1
else
    QUALITY=100
fi

images=$(find assets/og-img/ | grep -E ".*\.(jpg|gif|png|jpeg)$")
images=($images)
images_n=${#images[*]}
for (( i = 0; i < images_n; i++ )); do
    in_image=${images[$i]}
    out_image=${in_image//"/og-img"/}
    out_image=${out_image%.*}.webp

    mkdir -p $(dirname $out_image)
    echo "($((i+1))/$images_n) Coverting $in_image"
    cwebp -q $QUALITY $in_image -o $out_image >/dev/null 2>&1
done

echo "Completed image conversion."