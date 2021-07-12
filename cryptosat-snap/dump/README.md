# ISS Scripts

Scripts for running the ISS experiment

## Bootstapping a Cryptosat VM


### Install Snaps:

	sudo snap install cryptosat-iss-pos --edge --devmode
	sudo snap install drand --edge --devmode
	sudo snap install bounce-blockchain --edge --devmode
	sudo snap install gotham-city --edge --devmode
	sudo snap install demo-wget --devmode

### Setup:

   1. Create 'cryptosat' and 'cryptosat_external' directories under `/home/ubuntu/`

    mkdir /home/ubuntu/cryptosat /home/ubuntu/cryptosat_external
  
   2. Download the scripts:

    demo-wget.wget https://github.com/cryptosat/iss_scripts/archive/refs/tags/v0.7.tar.gz

   3. Untar the scripts into the `/home/ubuntu/cryptosat/scripts` directory.
   4. Download the `gotham.tar` archive into the  image:
         
	 demo-wget.wget -O gotham.tar https://drive.google.com/u/0/uc?id=1Dk9rG0J4XLOrU5unhZ3XcBwnKPTNbmjt&export=download

   5. Unzip it into the `/home/ubuntu/cryptosat/gotham` directory using the command: `tar -xvf gotham.tar`

## Cleanup

   1. Remove all installed snaps

    sudo snap remove cryptosat-iss-pos drand bounce-blockchain gotham-city demo-wget

   2. Delete all contents of the `/home/ubuntu/` directory
	
	 rm -rf /home/ubuntu/*
