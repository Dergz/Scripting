##Module, determins a files size form var $FILE (Ment to detect a worlds file size)

Determine_File_Size(){
    File_Size="$(du -sh $File)"
    echo "World Folder Size: ${File_Size%%/*}"

}