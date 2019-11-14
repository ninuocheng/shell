#!/bin/bash
case $1 in
t|T|tt|TTT)
touch  $2 ;;
m|M)
mkdir $2 ;;
r)
rm -rf $2 ;;
*)
echo "t|m|r"
esac
