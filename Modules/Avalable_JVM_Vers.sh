## Module, Reads /usr/lib/jvm to grab open jvm versions

Avalable_JVM_Vers(){ ## grabs all avalable jvm versions and displays them as a list
    JVList="$(find /usr/lib/jvm/* -maxdepth 0 ! -type l)"
    JVListLength="$(echo "$JVList" | wc -l)"
    JVarray=() ## Array of server names
    counter=1
    while [ $counter -le "$JVListLength" ]; do ## Appends server names to a list for easy picking
        CSN="$(echo "$JVList" | head -n $counter | tail -n 1)"
        JVarray+=("$CSN")
        ((counter++))
    done
    echo "Available Java environments:"
        for (( i=0; i<$JVListLength; i++ )); do
            echo "($i) ${JVarray[$i]}"
        done
}