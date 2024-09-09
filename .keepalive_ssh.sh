#!/bin/bash
if ! pgrep -x "sshd" > /dev/null
then
    sshd
fi
