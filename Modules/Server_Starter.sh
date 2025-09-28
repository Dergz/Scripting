## Module, Starts the server then exits back to menu

Server_Starter(){ ## SPLIT INTO SEG's, Currently working on grabbing the jvm needed then replace in the run.sh java with the exact path for the jvm req'd
    clear
    echo "Starting server in screen session"
    #Java_Version_Array
    #echo " JVM Selected: $JVM_Requested"
    Java_Version_Array
    for (( i=0; i<$JVListLength; i++ )); do
        # TMP="$(echo "${JVarray[$i]}/bin/java" | grep $S_JVM_VER)"
        # echo $TMP
        [[ "$(echo "${JVarray[$i]}/bin/java")" =~ "$S_JVM_VER" ]] && TMP=${JVarray[$i]}/bin/java
    done
    TMP2="$(cat "$ModPack_Folder"/"$S_Server_Start_File")"
    Cut="java"
    Replace="$TMP"
    NRs=${TMP2/$Cut/$Replace}
    ## echo "$NRs"
    
    screen -S "$Selected_Server" -dm
    screen -r "$Selected_Server" -X stuff $"cd $ModPack_Folder \n"
    sleep 1
    screen -r "$Selected_Server" -X stuff $"$NRs\n"
    sleep 1
    clear
    Server_Panel
}
