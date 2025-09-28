#!/usr/bin/env sh

## Just sources all the modules into the main script as a tie together

## First to establish link and function
SCR_Loc=/home/skarf/Scripting ## File Dir of script
MP_LOC=/home/skarf/ModPacks ## File Dir of modpacks

for file in $SCR_Loc/Modules/*
do
	source $file
done
source $SCR_Loc/Settings.sh ## Sources settings

Welcome(){ ##Script Welcome message
	clear
    echo "" 
    echo "###############################"
    echo "###                         ###"
    echo "###    Server Controller    ###"
    echo "###                         ###"
    echo "###############################"
    echo "" 
}

MainMenu () {
	echo "Server Controll center"
	echo
	Check_For_Updates
	Check_For_Screen
	echo
	echo " S) Controll Server"
	echo " M) Modify Server Properties"
	echo " U) Update Server"
	echo " E) Script Settings"
	echo " P) Power Options"
	echo 
    echo " Q) Quit"
	echo
	printf " Please choose an action: "
	read choice
	case "$choice" in
		s|S)	Server_Controller;;
		#m|M)	modifyMenu;;
		#u|U)	updateMenu;;
		q|Q)	clear; exit;;
		*)	printf "\n[ERROR]: That is not a valid choice"; sleep 1s; Induce;;
	esac
}

Check_For_Screen(){
	if ! screen -list | grep -q "Detached"; then
		echo "Currently running: Nothing"
	else
		SN="$(screen -list | grep "Detached")"
		echo "Server Running: $SN"
	fi
}

Induce(){ ## Runs all start screen scripts at once
	Welcome
	if [ "$Setting_Display_Stats" = "TRUE" ];then
		IP_ADDR_V4
		Disk_Usage
		echo
	fi
	MainMenu
}

Induce
