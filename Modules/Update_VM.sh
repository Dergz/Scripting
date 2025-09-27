## Module, Checks for system updates and runs them if auto update is enabled

#if test "$(checkupdates | wc -l)" != 0; then
#    echo "Updates avalible"
#fi



## Uses checkupdates to determine if there are updaes
## If there are updates prompt user to update
## ^ check if previous update check has ran, if not updated dont check again & assume update is needed (Use a tmpfile)
## OR use setting panel to enable auto update & Log said update
## ^ IF auto then also use a timer to run for update checks on x intervol