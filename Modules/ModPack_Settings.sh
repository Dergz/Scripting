## Module that sets and manipulates a mods packs runtime settings (Relies off vars from Server_Controller//Server_Options)

ModPack_Settings(){
    if [ ! -f "$ModPack_Folder"/Settings.sh ]; then
        echo "Settings file not found!"
        echo "Creating setting file"
        echo "# Settings for $Selected_Server #" > "$ModPack_Folder"/Settings.sh
        echo
    fi
    Settings_Loc=$ModPack_Folder/Settings.sh
    source $Settings_Loc

    #ensures EULA is true
    EULA_Loc=$ModPack_Folder/eula.txt
    echo "eula=true" > "$EULA_Loc"

    # cats settings to check for if jvm ver is set
    JVM_VER="$(cat $Settings_Loc | grep "S_JVM_VER")"
    if [[ $? != 0 ]]; then
        echo "JVM Not Detected"
        JVM_NEED_SET="TRUE"
    elif [[ $JVM_VER ]]; then
        echo "JVM found, proceeding"
        JVM_NEED_SET="False"
        echo
    else
        echo "ERROR"
        sleep 3s
        Induce
    fi

    # Sets jvm version if none is detected
    if [ $JVM_NEED_SET = "TRUE" ]; then
        echo "Please select a JVM Version"
        Avalable_JVM_Vers
        printf "JVM Ver for server: "
        read UJVMVER
        TMP=${JVarray[$UJVMVER]}
        JVM_OUT=${TMP:13}
        echo "Setting JVM ver too: $JVM_OUT"
        echo "S_JVM_VER=$JVM_OUT" >> $Settings_Loc
        echo "JVM version is now set, proceeding"
        echo
    fi

    # cats settings to check what server has as start file, otherwise set start file
    Server_Start_File="$(cat $Settings_Loc | grep "S_Server_Start_File")"
    if [[ $? != 0 ]]; then
        echo "Server start file not set"
        SSF_NEED_SET="TRUE"
    elif [[ $Server_Start_File ]]; then
        echo "Server start file defined, proceeding"
        SSF_NEED_SET="False"
        echo
    else
        echo "ERROR"
        sleep 3s
        Induce
    fi

    # Sets server run file if none is detected
    if [ $SSF_NEED_SET = "TRUE" ]; then
        echo "Please select a Server start file"
        ## ls -p $ModPack_Folder | grep -v / 
        List="$(ls -p $ModPack_Folder | grep -v /)"
        ListLength="$(echo "$List" | wc -l)"
        SSFarray=() ## Array of server files
        counter=1
        while [ $counter -le "$ListLength" ]; do ## Appends to a list for easy picking
            CSN="$(echo "$List" | head -n $counter | tail -n 1)"
            SSFarray+=("$CSN")
            ((counter++))
        done
        for (( i=0; i<$ListLength; i++ )); do
            echo " ($i) ${SSFarray[$i]}"
        done
        printf "Start file for server: "
        read USSF
        Server_Start_File=${SSFarray[$USSF]}
        echo "Setting server start file too: $Server_Start_File"
        echo "S_Server_Start_File=$Server_Start_File" >> $Settings_Loc
        echo "Start file is now set, proceeding"
        echo
    fi




    # sets the jvm args folder
    Server_Java_Args="$(cat $Settings_Loc | grep "S_Server_Java_Args")"
    if [[ $? != 0 ]]; then
        echo "Server Java args not set"
        SJA_NEED_SET="TRUE"
    elif [[ $Server_Java_Args ]]; then
        echo "Server Java args defined, proceeding"
        SJA_NEED_SET="False"
        echo
    else
        echo "ERROR"
        sleep 3s
        Induce
    fi

    # Sets jvm args if needed
    if [ $SJA_NEED_SET = "TRUE" ]; then
        echo "Please select a Server Java arguments file"
        ## ls -p $ModPack_Folder | grep -v / 
        List="$(ls -p $ModPack_Folder | grep -v /)"
        ListLength="$(echo "$List" | wc -l)"
        SJAFarray=() ## Array of java args
        counter=1
        while [ $counter -le "$ListLength" ]; do ## Appends to a list for easy picking
            CSN="$(echo "$List" | head -n $counter | tail -n 1)"
            SJAFarray+=("$CSN")
            ((counter++))
        done
        for (( i=0; i<$ListLength; i++ )); do
            echo " ($i) ${SJAFarray[$i]}"
        done
        printf "Java args file for server: "
        read USJA
        Server_Java_Args=${SJAFarray[$USJA]}
        echo "Setting Java args file too: $Server_Java_Args"
        echo "S_Server_Java_Args=$Server_Java_Args" >> $Settings_Loc
        echo "Start Java args is now set, Running match check"
        echo
    fi

    ## Runs check to ensure java args match args
    FILE1=$ModPack_Folder/$S_Server_Java_Args
    FILE2=$SCR_Loc/Java_Ver_Args_Files/$S_JVM_VER.txt
    if cmp --silent -- "$FILE1" "$FILE2"; then
        echo "JVM args match, proceeding"
    else
        echo "files differ"
        cat $FILE2 > $FILE1
        echo "JVM args updated, proceeding"
    fi
    echo
}