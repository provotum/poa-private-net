#!/bin/bash

#### If you sucessfully installed and built eth-netstats & eth-intelligence-api, this script will start a smalll cluster of 5 geth nodes with pre-allocated ether. 
#### eth-private-net was written by Vincent Chu, check ./poa-private-net for more info in the header
#### This script just additionally starts a full cluster & opens the netstats dashboard
#### Written by Christian Killer

GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)


# Make sure geth is not already running
printf "${CYAN}[poa-private-net] ${NORMAL}Make sure geth is not already running. \n"
killall -q --signal SIGINT geth &> /dev/null
sleep 1
killall -q geth &> /dev/null
bash poa-private-net teardown > /dev/null

printf "${CYAN}[poa-private-net] ${NORMAL}Initializing genesis. \n"
bash poa-private-net init &
sleep 1

printf "${CYAN}[poa-private-net] ${NORMAL}Starting bootnode. \n"
bootnode -nodekey boot.key -verbosity 9 -addr :30310 > /dev/null 2>&1 &

printf "${CYAN}[poa-private-net] ${NORMAL}Starting all the nodes. \n"
bash poa-private-net start node1 &
sleep 1
bash poa-private-net start node2 &
sleep 1
bash poa-private-net start node3 &
sleep 1
bash poa-private-net start node4 &
sleep 1
bash poa-private-net start node5 &
sleep 1

#printf "${CYAN}[poa-private-net] ${NORMAL}Interconnecting all the nodes. \n"
bash poa-private-net connect node1 node2 &> /dev/null
bash poa-private-net connect node1 node3 &> /dev/null
bash poa-private-net connect node1 node4 &> /dev/null
bash poa-private-net connect node1 node5 &> /dev/null
bash poa-private-net connect node2 node3 &> /dev/null
bash poa-private-net connect node2 node4 &> /dev/null
bash poa-private-net connect node2 node5 &> /dev/null
bash poa-private-net connect node3 node4 &> /dev/null
bash poa-private-net connect node3 node5 &> /dev/null
bash poa-private-net connect node4 node5 &> /dev/null
sleep 1

printf "${CYAN}[eth-net-intelligence-api]${NORMAL}Starting pm2 to relay all communication: nodes -> eth-netstats.\n"
(cd eth-net-intelligence-api; pm2 start provotum.json) > /dev/null 2>&1 &

printf "${CYAN}[eth-netstats]${NORMAL} Starting npm on PORT=3002 with WS_SECRET=tabequals4\n"
(cd eth-netstats; WS_SECRET=tabequals4 PORT=3002 npm start) > /dev/null 2>&1 &

printf "${GREEN}[Done]${NORMAL} Check localhost:3002 for the dashboard \n"
printf "${CYAN} Waiting a second for the dashboard to start ... \n"
sleep 3

open http://localhost:3002