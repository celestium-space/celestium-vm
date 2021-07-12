# !/bin/bash -ex
sleep 10
echo "\n\nInitializing cryptosat" > /dev/tty1
FOLDER=/home/ubuntu/cryptosat
if [ -d "$FOLDER" ]; then
    echo "Cryptosat already initialized, done" > /dev/tty1
else
    mkdir /home/ubuntu/cryptosat /home/ubuntu/cryptosat_external
    mkdir /home/ubuntu/cryptosat/scripts
    mkdir /home/ubuntu/cryptosat/gotham
    cp /snap/cryptosat/x1/iss_scripts.tar.gz /home/ubuntu/cryptosat/scripts
    cp /snap/cryptosat/x1/gotham.tar /home/ubuntu/cryptosat/gotham
    cd /home/ubuntu/cryptosat/scripts
    tar -xzvf iss_scripts.tar.gz > /dev/tty1
    cd /home/ubuntu/cryptosat/gotham
    tar -xvf gotham.tar > /dev/tty1
    echo "Done." > /dev/tty1
fi
