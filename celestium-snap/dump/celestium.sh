# !/bin/bash -ex
sleep 10
echo "\n\nStarting celestium" | tee /dev/tty1 > /home/ubuntu/celestium.log
echo "Generating 1000000 bytes of noice" | tee /dev/tty1 >> /home/ubuntu/celestium.log
dd if=/dev/urandom bs=1000 count=1000 of=/home/ubuntu/random

FILE=/home/ubuntu/blocks
if [ -f "$FILE" ]; then
    echo "$FILE exists, skipping download" | tee /dev/tty1 >> /home/ubuntu/celestium.log
else
    echo "Downloading blocks file..." | tee /dev/tty1 >> /home/ubuntu/celestium.log
    curl -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/blocks -o /home/ubuntu/blocks 2>&1 | tee /dev/tty1 >> celestium.log
fi

/snap/celestium/x1/celestium-cli -c mine -s /home/ubuntu/blocks | tee /dev/tty1 >> /home/ubuntu/celestium.log

echo "Uploading... " | tee /dev/tty1 >> /home/ubuntu/celestium.log
curl --upload-file /home/ubuntu/random -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
curl --upload-file /home/ubuntu/blocks -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
curl --upload-file /home/ubuntu/celestium.log -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
echo "Deleting blocks file" | tee /dev/tty1 >> /home/ubuntu/celestium.log
rm /home/ubuntu/blocks

echo "Done." | tee /dev/tty1 >> /home/ubuntu/celestium.log
