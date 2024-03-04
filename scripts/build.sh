#!/bin/bash

set -e

echo ""
echo "*********************************************"
echo "**************    build.sh    **************"
echo "*********************************************"
echo ""
echo "Building the project"
echo ""
make
make install-poetry
make build
echo "*********************************************"
echo "*********************************************"
echo ""