#!/bin/bash

set -e

echo ""
echo "*********************************************"
echo "**************    build.sh    **************"
echo "*********************************************"
echo ""
echo "Building the project"
echo ""
cd ..
make
make install-poetry
make build
echo "*********************************************"
echo "*********************************************"
echo ""