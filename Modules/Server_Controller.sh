##Module, Controlls starting,editing,etc of a mod pack

##list servers
##user selects one
##give user options

Server_List(){ ## List avalable server in Server Dir
    List="$(ls $MP_LOC -1)"
    ListLength="$(echo "$List" | wc -l)"
    SNarray=() ## Array of server names
    counter=1
    while [ $counter -le "$ListLength" ]; do ## Appends server names to a list for easy picking
        CSN="$(echo "$List" | head -n $counter | tail -n 1)"
        SNarray+=("$CSN")
        ((counter++))
    done
    ## echo "${SNarray[@]}" ##DEBUG
    ## echo "$List" ##DEBUG
    ## echo "$ListLength" ##DEBUG
    echo "Avalible Servers:"
    for (( i=0; i<$ListLength; i++ )); do
        echo " ($i) ${SNarray[$i]}"
    done
    echo " ($ListLength) exit"
    ##echo "${SNarray[@]}"
}

Server_Picker(){
    printf "Please pick a server: "
    read USO ## Users Server Choice
    if [ $USO = "$ListLength" ]; then
        Induce
    elif [ $USO -lt $ListLength ]; then
        Selected_Server="${SNarray[$USO]}"
        echo "Now entering $Selected_Server:"
        sleep 1s
        clear
        Server_Options
    else
        echo "Not an option"
        sleep 1
        clear
        Server_List
        Server_Picker
    fi
}

Server_Options(){ ##Must be induced by Server_Picker due to var dep, WORLD FILE MUST STAY AS "world"
    ModPack_Folder=$MP_LOC/$Selected_Server
    ## ls $ModPack_Folder
    ModPack_Settings
    sleep 2s
    Server_Panel
}
Server_Panel(){
    clear
    echo "ModPack: $Selected_Server"
    File=$ModPack_Folder/world
    Determine_File_Size
    echo ""
    echo "Options: "
    echo ""
    echo " S) Start Server"
	echo " E) Edit Settings"
	echo " C) Screen to Server"
    echo " Q) Quit to main menu"
	echo
	printf " Please choose an action: "
	read choice
	case "$choice" in
		s|S)	Server_Starter;;
		#k|K)	Edit_ModPack_Settings;;
		#c|C)	Connect_To_Screen;;
		q|Q)	clear; Induce;;
		*)	printf "\n[ERROR]: That is not a valid choice"; sleep 1s; clear; Server_Panel;;
	esac
}

Server_Controller(){
    echo
    Server_List
    Server_Picker
}