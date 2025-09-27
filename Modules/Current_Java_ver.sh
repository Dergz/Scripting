##Module, Grabs the currently active jvm ver from archlinux-java
Current_Java_Ver(){
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
    # echo "${JVarray[@]}" ##DEBUG
}