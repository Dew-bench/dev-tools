#!/bin/bash



echo "
▀██▀▀█▄                             ▀██                               ▀██      
 ██   ██    ▄▄▄▄  ▄▄▄ ▄▄▄ ▄▄▄        ██ ▄▄▄    ▄▄▄▄  ▄▄ ▄▄▄     ▄▄▄▄   ██ ▄▄   
 ██    ██ ▄█▄▄▄██  ██  ██  █         ██▀  ██ ▄█▄▄▄██  ██  ██  ▄█   ▀▀  ██▀ ██  
 ██    ██ ██        ███ ███    ████  ██    █ ██       ██  ██  ██       ██  ██  
▄██▄▄▄█▀   ▀█▄▄▄▀    █   █           ▀█▄▄▄▀   ▀█▄▄▄▀ ▄██▄ ██▄  ▀█▄▄▄▀ ▄██▄ ██▄ 
"

echo "Loading..."


workdir="dew-bench"
gitURL="https://github.com"
repos=($(curl -s  https://github.com/Dew-bench | grep "codeRepository" | awk -F '"' '{print $6}'))
repoClean=()
repoNames=()

for repo in "${repos[@]}"
do
    repoClean+="$gitURL${repo%hovercard}" # remove "hovercard"
    repoNames+=$(echo ${repo%hovercard} | cut -c12- )
done

# echo ${repoClean[@]}
# echo ${repoNames[@]}


echoMenu(){
    echo "1 - clone all git repos"
    echo "2 - stage * & commit with message & push repo"
    echo "3 - set repos workdir"
    echo "0 - exit"
    printf ">> "
}


cloneGit(){
    for repo in "${repos[@]}"
    do
        repoClean=${repo%hovercard} # remove "hovercard"
        echo "Cloning "$gitURL$repoClean" ..."
        $(git clone "$gitURL$repoClean")
    done
}


setRepoWorkdir(){
    echo "Input Name"
    printf ">> "
    read name
    workdir=$name
}


stageAndPush(){
    echo "Input Repo name"
    printf ">> "
    read name
    echo "Input Commit msg"
    printf ">> "
    read msg
    $(cd ./$workdir)
    $(git stage *)
    $(git commit -a -m \"$msg\")
    $(git push)
}

while :
do
    echoMenu
    read input
    echo $input

    if [ $input == "0" ]
    then
        exit
    elif [ $input == "1" ]
    then 
        $(mkdir $workdir)
        $(cd $workdir)
        cloneGit
    elif [ $input == "2" ]
    then
        stageAndPush
    elif [ $input == "3" ]
    then 
        setRepoWorkdir
    else 
        echo "Kernel Panic"
    fi
done