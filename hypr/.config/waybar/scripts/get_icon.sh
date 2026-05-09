#!/bin/sh

DISTRO=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [ "$DISTRO" = "nixos" ]; then
    echo ""
elif [ "$DISTRO" = "arch" ]; then
    echo ""
else
    echo ""
fi
