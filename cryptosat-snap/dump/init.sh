# !/bin/bash -ex
sleep 10
echo "\n\nInitializing cryptosat" > /dev/tty1
FOLDER=/home/ubuntu/cryptosat
if [ -d "$FOLDER" ]; then
    echo "Cryptosat already initialized, done" > /dev/tty1
else
    mkdir /home/ubuntu/cryptosat /home/ubuntu/cryptosat_external
    cp /snap/cryptosat/x1/iss_scripts.tar.gz /home/ubuntu/cryptosat
    cp /snap/cryptosat/x1/gotham.tar /home/ubuntu/cryptosat
    cd /home/ubuntu/cryptosat
    tar -xzvf iss_scripts.tar.gz > /dev/tty1
    mv iss_scripts-0.7 scripts
    tar -xvf gotham.tar > /dev/tty1
    chown -R ubuntu:ubuntu /home/ubuntu
    echo "Done." > /dev/tty1
fi
