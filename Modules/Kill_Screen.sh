##Module, Kills the screen instance if possible
Kill_Screen(){
    echo " Starting server kill"
    echo " May take a minute"
    screen -r "$Selected_Server" -X stuff $"stop\n"
    sleep 45
    screen -r "$Selected_Server" -X stuff $"exit\n"
    Server_Panel
}