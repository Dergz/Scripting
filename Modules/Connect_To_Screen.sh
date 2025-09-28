##Module, Connects to currently running servers screen instance

Connect_To_Screen(){
    echo "Entering screen for running pack"
    echo "Exit using ctrl+a , d"
    echo "Connecting"
    sleep 2
    clear
    screen -r "$Selected_Server"
    echo "Disconnected"
    sleep 1
    clear
    Server_Panel
}