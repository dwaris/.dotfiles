#!/bin/bash

RED="\e[0;91m"
GREEN="\e[0;92m"
BLUE="\e[0;96m"

RESET="\e[0m"
RESETN="\e[0m\n"

rust=false
flatpak=false

check_exit_status() {
	if [[ $? -eq 0 ]]; then
		echo
		printf "${GREEN}===> Success!${RESET}"
		echo

		echo
		printf '%.0s-' {1..42}
		echo
	else
		echo
		printf "${RED}[ERROR]${RESET}"
		echo

		read -pr 'The last command exited with an error. Exit script? (y/n) ' input

		if [[ $input =~ y(es)?||j ]]; then
			echo
			printf "${RED}Aborting update...${RESET}"
			echo

			read -rp 'Press enter to exit...'
			exit 1
		fi
	fi
}

update() {
	printf "${BLUE}=== upgrade packages ===${RESETN}"
	echo

	if [[ $OS == "Fedora Linux" ]]; then
		sudo dnf update --refresh
		check_exit_status
	elif [[ $OS == "Arch Linux" ]]; then
		paru
		check_exit_status
	fi

    if [[ $flatpak == true ]]; then
        printf "${BLUE}=== upgrade flatpaks ===${RESETN}"
        echo

        flatpak update
        check_exit_status
    fi


    if [[ $rust == true ]]; then
	printf "${BLUE}=== upgrade Rust ===${RESETN}"
	echo

	rustup update stable
	check_exit_status
    fi
}

cleanup() {
	printf "${BLUE}=== cleanup packages ===${RESETN}"
	echo

	if [[ $OS == "Fedora Linux" ]]; then
		sudo dnf autoremove
		check_exit_status
	elif [[ $OS == "Arch Linux" ]]; then
        to_remove=$(pacman -Qdtq)

        if [ -n "$to_remove" ]; then
            sudo pacman -Rs $to_remove
        else
            printf "Nothing unused to uninstall"
            echo
        fi
        check_exit_status
	fi

    if [[ $flatpak == true ]]; then
        printf "${BLUE}=== cleanup flatpaks ===${RESETN}"
        echo

        flatpak uninstall --unused
        check_exit_status
    fi

}

leave() {
	printf "${GREEN}[Done]${RESET}"
	echo

	read -p "Press enter to exit..."
	exit 0
}

if [ -f /etc/os-release ]; then
	. /etc/os-release
	OS=$NAME
fi

while getopts "fr" flag; do
 case $flag in
   f) # flatpak
    flatpak=true
    ;;
   r) # rust
    rust=true
    ;;
   ?)
    echo "Usage: $0 [-f] [-r]"
    exit 1
    ;;
 esac
done

update "$OS"
cleanup "$OS"
leave
