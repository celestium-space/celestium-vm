# !/bin/bash -ex
sleep 10
mkdir /home/ubuntu/cryptosat /home/ubuntu/cryptosat_external
mkdir /home/ubuntu/cryptosat/scripts
mkdir /home/ubuntu/cryptosat/gotham
cp /snap/cryptosat/x1/iss_scripts.tar.gz /home/ubuntu/cryptosat/scripts
cp /snap/cryptosat/x1/gotham.tar /home/ubuntu/cryptosat/gotham
cd /home/ubuntu/cryptosat/scripts
tar -xzf iss_scripts.tar.gz
cd /home/ubuntu/cryptosat/gotham
tar -xzf gotham.tar