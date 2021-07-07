# !/bin/bash -ex
sleep 10
echo "\n\nStarting celestium" > /dev/tty1 > celestium.log
# Generate 1000000 bytes of noice
dd if=/dev/urandom bs=1000 count=1000 of=random

FILE=blocks
if [ -f "$FILE" ]; then
    echo "$FILE exists, skipping download" > /dev/tty1 > celestium.log
else
    echo "Downloading blocks file..." > /dev/tty1 > celestium.log
    curl -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/blocks > blocks
fi
/snap/celestium/x1/celestium-cli -c mine -s blocks > /dev/tty1 > celestium.log

echo "Uploading... " > /dev/tty1 > celestium.log
curl --upload-file random -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/
curl --upload-file blocks -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/
curl --upload-file celestium.log -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/
echo "Deleting blocks file" > /dev/tty1 > celestium.log
rm blocks

echo "Done." > /dev/tty1 > celestium.log