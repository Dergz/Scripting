## Module, Boths checks for updates and can run updates

Check_For_Updates(){
    if [[ $Setting_Check_Updates = "TRUE" ]]; then
        printf "Updates: "
        if test "$(checkupdates | wc -l)" != 0; then
            echo "$(checkupdates | wc -l)"
        fi
    else
        echo "Skipping update check"
    fi
}
