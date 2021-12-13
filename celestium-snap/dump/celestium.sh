# !/bin/bash -ex
sleep 10
echo "\n\nStarting celestium" | tee /dev/tty1 > /home/ubuntu/celestium.log

mkdir /home/ubuntu/images

for I in 0 1 2 3 4 5 6 7 8 9
do
    FILE=smb://MIS-PL-AM12/shared/$I.jpg
	echo "Downloading noice image '$FILE'" | tee /dev/tty1 >> /home/ubuntu/celestium.log
    curl -u 'WORKGROUP\MISOWNER:00000000' $FILE -o /home/ubuntu/images/$I.jpg 2>&1 | tee /dev/tty1 >> celestium.log
done

echo "Generating 98/2048 random noice" | tee /dev/tty1 >> /home/ubuntu/celestium.log
/snap/celestium/x1/celestium-cli random -i /home/ubuntu/images -o /home/ubuntu/random-98-2048 -c 98 -s 2048 | tee /dev/tty1 >> /home/ubuntu/celestium.log

echo "Generating 10000/1024 random noice" | tee /dev/tty1 >> /home/ubuntu/celestium.log
/snap/celestium/x1/celestium-cli random -i /home/ubuntu/images -o /home/ubuntu/random-10000-1024 -c 10000 -s 1024 | tee /dev/tty1 >> /home/ubuntu/celestium.log

FILE=/home/ubuntu/blocks
if [ -f "$FILE" ]; then
    echo "$FILE exists, skipping download" | tee /dev/tty1 >> /home/ubuntu/celestium.log
else
    echo "Downloading blocks file..." | tee /dev/tty1 >> /home/ubuntu/celestium.log
    curl -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/blocks -o /home/ubuntu/blocks 2>&1 | tee /dev/tty1 >> celestium.log
fi

/snap/celestium/x1/celestium-cli mine -b /home/ubuntu/blocks | tee /dev/tty1 >> /home/ubuntu/celestium.log

echo "Uploading... " | tee /dev/tty1 >> /home/ubuntu/celestium.log
curl --upload-file /home/ubuntu/random-98-2048 -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
curl --upload-file /home/ubuntu/random-10000-1024 -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
curl --upload-file /home/ubuntu/blocks -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
curl --upload-file /home/ubuntu/celestium.log -u 'WORKGROUP\MISOWNER:00000000' smb://MIS-PL-AM12/shared/ 2>&1 | tee /dev/tty1 >> celestium.log
echo "Deleting blocks file" | tee /dev/tty1 >> /home/ubuntu/celestium.log
rm /home/ubuntu/blocks

echo "Done." | tee /dev/tty1 >> /home/ubuntu/celestium.log
