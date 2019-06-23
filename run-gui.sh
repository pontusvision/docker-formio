#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
echo DIR=$DIR
export PATH=$PATH:/opt/pontus/node/current/bin
cd $DIR
npm start
