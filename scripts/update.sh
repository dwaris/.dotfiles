#!/bin/bash

RED="\e[0;91m"
GREEN="\e[0;92m"
BLUE="\e[0;96m"

RESET="\e[0m"
RESETN="\e[0m\n"

check_exit_status() {
	if [[ $? -eq 0 ]]; then
		echo
		printf "${GREEN}===> Success!${RESET}"
		echo

		echo
		printf '%.0s-' {1..42};
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

			read -p 'Press enter to exit...'
			exit 1
		fi
	fi
}

update() {
	printf "${BLUE}===> DNF/Pacman package upgrade${RESETN}"
	echo

	if [[ $OS == "Fedora Linux" ]]; then
		sudo dnf5 up;
		check_exit_status
	elif [[ $OS == "Arch Linux" ]]; then
		paru
		check_exit_status
	fi

	printf "${BLUE}===> Flatpaks upgrade${RESETN}"
	echo

	flatpak update;
	check_exit_status

	printf "${BLUE}===> Rust upgrade${RESETN}"
	echo

	rustup update stable;
	check_exit_status
}

cleanup() {
	printf "${BLUE}===> Cleaning DNF/Pacman packages${RESETN}"
	echo

	if [[ $OS == "Fedora Linux" ]]; then
		sudo dnf5 autoremove;
		check_exit_status
	elif [[ $OS == "Arch Linux" ]]; then
		sudo pacman -Qdtq | sudo pacman -Rs -;
		echo
	fi

	printf "${BLUE}===> Cleaning Flatpak packages${RESET}"
	echo

	sudo flatpak remove --unused;
	check_exit_status
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

update  "$OS"
cleanup "$OS"
leave
