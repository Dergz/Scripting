#!/usr/bin/env sh

##Seting static vars and file links;

##Dir for avalable servers
# ServerDir="/home/skarf/ModPacks"
ServerDir="/home/skarf/Documents/Projects/Fake_modpack_enviroment/" ##FOR LAPTOP TESTING
Archives="/home/skarf/Archives"
##Java Verions, parsed from "archlinux-java status"

## DOESNT RUN PROPERLY AS JVM METHOD NOT DONE YET

Welcome(){ ##Script Welcome message
    echo "" 
    echo "###############################"
    echo "###                         ###"
    echo "###      Server Picker      ###"
    echo "###                         ###"
    echo "###############################"
    echo "" 
}

Server_Stats(){ ##Server statistics
    echo "IP: 192.168.1.155"
    echo "Tailscale: Server"
    echo "JVM: $JVMCVer"
    echo ""
}

get_Server_list(){ ##Grabs avalible servers and outputs it as a array
    List="$(ls $ServerDir -1)"
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
}

Main_Menu(){ ## Main Menu for selection
    echo "(1) Servers"
    echo "(2) Power Options"
    echo "(3) Java Options"
    echo "(4) Archiving" ## NOT YET IMPLIMENTED
    echo "(5) Exit Script"
    printf "Select a option: " 
    read option
    echo ""
    if [ "$option" = "1" ]; then
        Server_list
        Server_Choose
    elif [ "$option" = "2" ]; then
        Power_Options
    elif [ "$option" = "3" ]; then
        Java_Versions
    elif [ "$option" = "5" ]; then
        Exit_Script
    else
        induce
    fi
}

Java_Versions(){ ## Outputs avalible JVM Versions using "archlinux-java"
    JVList="$(archlinux-java status)"
    JVListLength="$(echo "$JVList" | wc -l)"
    JVarray=() ## Array of server names
    counter=1
    while [ $counter -le "$JVListLength" ]; do ## Appends server names to a list for easy picking
        CSN="$(echo "$JVList" | head -n $counter | tail -n 1)"
        JVarray+=("$CSN")
        ((counter++))
    done
    echo "### REQUIRES ROOT PRIVLAGES ###"
    echo "Available Java environments:"
    for (( i=1; i<$JVListLength; i++ )); do
        echo "($i) ${JVarray[$i]}"
    done
    ## echo "${JVarray[@]}" ##DEBUG
    Java_Selector
}

Java_Lib_Versions(){ ## Uses direct /lib local instead of relying on archlinux-java for java ver's
    echo "/usr/lib/jvm"
}

Java_Selector(){ ## Sets jvm version
    echo "($JVListLength)   Exit"
    printf "Select a JVM version: "
    read JVMChoice
    echo ""
    if [ $JVMChoice = $JVListLength ]; then
        induce
    else
        JVMVer=${JVarray[$JVMChoice]}
        sudo archlinux-java set $JVMVer
        printf "Setting JVM Ver : "
        echo "$JVMVer"
        Get_jvmver_on_start
        sleep 2s
        induce
    fi
}

## RELIES OFF OF SERVER_CHOOSE DONT INVOKE OTHERWISE
Server_Start_JVMVer_Change(){ ## Changes JVM Ver if the server attempting to start requires a diffrent jvm ver
    ## echo "JVM CHANGER" ##DEBUG
    if [ ! -f $ServerDir/"$Modpack"/JVMVer.txt ]; then
        echo "File not found!"
        echo "Creating JVM Version file"
        echo "NULL" > $ServerDir/$Modpack/JVMVer.txt
        Choose_JVM_Version
    else
        jver="$(cat $ServerDir/$Modpack/JVMVer.txt)"
        if [ "$jver" != "$JVMCVer" ]; then
            echo "Changing to proper version"
            ## auto change jvm ver
        else
            CANRUN="TRUE"
        fi
    fi
}

Choose_JVM_Version(){ ## Changes a servers jvm ver assuming the file is there and just needs to be edited
    ## echo "JVM CHOOSE" ##DEBUG
    SJVMV="$(cat $ServerDir/$Modpack/JVMVer.txt)"
    if [ $SJVMV = "NULL" ]; then
        JVList="$(archlinux-java status)"
        JVListLength="$(echo "$JVList" | wc -l)"
        JVarray=() ## Array of server names
        counter=1
        while [ $counter -le "$JVListLength" ]; do ## Appends server names to a list for easy picking
            CSN="$(echo "$JVList" | head -n $counter | tail -n 1)"
            JVarray+=("$CSN")
            ((counter++))
        done
        echo "Available Java environments:"
        for (( i=1; i<$JVListLength; i++ )); do
            echo "($i) ${JVarray[$i]}"
        done
        printf "Select a JVM version: "
        read SJVMChoice
        echo ""
        TMP=${JVarray[$SJVMChoice]}
        ## run  a does contain check to ensure it doesnt add (default)
        echo $TMP > $ServerDir/$Modpack/JVMVer.txt
    fi
    ## DONT OUTPUT (default) into JVMVer
}

Server_list(){ ## List avalable server in Server Dir
    get_Server_list
    echo "Avalible Servers:"=
    for (( i=0; i<$ListLength; i++ )); do
        echo "($i) ${SNarray[$i]}"
    done
    echo "($ListLength) exit"
    ##echo "${SNarray[@]}"
}

Server_Choose(){ ## Launches the server the user pics
    ## Change to launch serevr into a screen not directly outputted
    printf "Select a option:"
    read ServerChoice
    echo ""
    if [ "$ServerChoice" = "$ListLength" ]; then 
        induce
    fi
    if [  "$ServerChoice" -le "$ListLength" ];then
        Modpack=${SNarray[$ServerChoice]}
        Server_Start_JVMVer_Change
        if [ "$CANRUN" = "TRUE" ]; then
            ## Not yet set to launch server as screen output instead of direct
            cd $ServerDir/$Modpack
            ./run.sh
        fi
    else
    induce
    fi
    
}

Power_Options(){ ## Power options :P
    echo "(1) Power Off"
    echo "(2) Reboot"
    echo "(3) Back to menu"
    printf "Select a option: " 
    read option
    echo ""
    if [ "$option" = "1" ]; then
        systemctl poweroff
    elif [ "$option" = "2" ]; then
        systemctl reboot
    else
        induce
    fi
}

Exit_Script(){ ## Exits the script :P
    printf "Are you sure? (Y/N) "
    read exitConfirm
    if [ "$exitConfirm" = "Y" ]; then 
        exit
    else
        induce
    fi
}

Get_jvmver_on_start(){ ## parse archlinux-java status, grabbing (default/active) for link
    JVMVAR="$(archlinux-java status | grep "(default)")"
    Cut=" (default)"
    Replace=""
    JVMCVer=${JVMVAR/$Cut/$Replace}
    JVMCVer="${JVMCVer:2}"
    ## echo "$JVMCVer"
}

induce(){ ## Launches the main scripts for menus and options
    clear
    Get_jvmver_on_start
    Welcome
    Server_Stats
    Main_Menu
}

### EXEC LINES ###
induce