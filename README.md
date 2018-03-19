# Proof-of-Authority Private Ethereum Network

This repository contains a simple proof-of-authority ethereum private network that can be run on your local machine. 
This is a customized version of [eth-private-net](github.com/vincentchu/eth-private-net) by Vincent Chu. 

If you plan to deploy a cluster of nodes in the cloud, have a look at the [remote branch of the setup repository](https://github.com/provotum/setup/tree/remote) where you can find a bunch of deployment scripts for remote deployment.

Basically, this script initializes 5 geth nodes with sufficient ether and then interconnects them to form a small private network. Then, the script starts `pm2` with `eth-netstat-intelligence-api/provotum.json` in order to relay all information from the node to the `eth-netstats` dashboard which is started at last and opened on `http://localhost:3002`.

After that, the nodes can be individually attached via terminal. (*e.g.* `geth attach http://localhost:PORT`, whereas `PORT` is ranging from `8101-8105`)


## Prerequisites

Make sure `geth` is installed and in the `$PATH`. `geth` is a golang implementation of the Ethereum protocol and provides command line tools for interacting with the Ethereum network. You can download [pre-compiled binaries](https://ethereum.github.io/go-ethereum/downloads/) or install from Homebrew or source using the [installation instructions](https://www.ethereum.org/cli).

Additionally, make sure `npm` is installed.

Make sure you run `git submodule init && git submodule update` to get the submodules `eth-netstats` and `eth-net-intelligence-api`.


```bash
cd eth-net-intelligence-api
sudo npm install -g pm2
npm install
```

```bash
cd eth-netstats
npm install
sudo npm install -g grunt-cli
grunt all
```

## Starting the Cluster

Now you should be ready to go 
```bash
./run.sh
```

Additionally, start / stop mining with 
```bash
./startmining.sh
./stopminer.sh
```


## Stopping the Cluster

```bash
./teardown.sh
```

