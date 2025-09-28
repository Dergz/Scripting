##Module, Kills the screen instance if possible
Kill_Screen(){
    echo "Starting server kill"
    echo "Gives a full minute to let server shut down fully"
    echo "Will return to script after"
    screen -r "$Selected_Server" -X stuff $"stop\n"
    sleep 60 
    screen -r "$Selected_Server" -X stuff $"exit\n"
    Server_Panel
}