# !/bin/bash -ex
sleep 10
echo "\n\nStarting celestium" > /dev/tty1
# Generate 1000000 bytes of noice
dd if=/dev/urandom bs=1000 count=1000 of=random

echo "Downloading blocks file..." > /dev/tty1
curl -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/blocks > blocks
/snap/celestium/x1/celestium-cli -c mine -s blocks > /dev/tty1

echo "Uploading... " > /dev/tty1
curl --upload-file random -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/
curl --upload-file mined_blocks -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/

echo "Done" > /dev/tty1