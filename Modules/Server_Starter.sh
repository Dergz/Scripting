## Module, Starts the server then exits back to menu

Server_Starter(){ ## SPLIT INTO SEG's, Currently working on grabbing the jvm needed then replace in the run.sh java with the exact path for the jvm req'd
    clear
    echo "Starting server in screen session"
    #Java_Version_Array
    #echo " JVM Selected: $JVM_Requested"
    Java_Version_Array
    for (( i=0; i<$JVListLength; i++ )); do
        TMP="$(echo "${JVarray[$i]}/bin/java" | grep $S_JVM_VER)"
        echo $TMP
    done
    ## echo $S_JVM_VER
}
