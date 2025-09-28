## Module that just arrays java verions and there paths for exec purposes,
    ## Similar to Avalable_JVM_Vers but w/o output and more direct

Java_Version_Array(){ ## puts all avalable java versions into an array
    JVList="$(find /usr/lib/jvm/* -maxdepth 0 ! -type l)"
    JVListLength="$(echo "$JVList" | wc -l)"
    JVarray=() ## Array of server names
    counter=1
    while [ $counter -le "$JVListLength" ]; do ## Appends server names to a list for easy picking
        CSN="$(echo "$JVList" | head -n $counter | tail -n 1)"
        JVarray+=("$CSN")
        ((counter++))
    done
}