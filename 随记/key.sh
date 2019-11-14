#!/bin/bash
case $1 in
redhat)
echo "fedora";;
fedora)
echo "redhat";;
*)
echo "用法:$0 {redhat|fedora}"
esac
