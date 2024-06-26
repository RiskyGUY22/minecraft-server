#!/bin/bash
echo "Configuring git..."
if [ -n "$GITHUB_USER" ] && [ -n "$GITHUB_TOKEN" ]; then
    git config --global credential.helper '!f() { sleep 1; echo "username=${GITHUB_USER}"; echo "password=${GITHUB_TOKEN}"; }; f'
    
    if [ -n "$GIT_COMMITTER_EMAIL" ] && [ -n "$GIT_COMMITTER_NAME" ]; then
        git config --global user.email $GIT_COMMITTER_EMAIL 
        git config --global user.name $GIT_COMMITTER_NAME
    else 
        git config --global user.name $GITHUB_USER
        git config --global user.email "noreply@github.com"
    fi

    git config --global commit.gpgsign false
    git config commit.gpgsign false
    echo -e "\nGit credential helper configured successfully.\n"
else
    echo -e "\nEither GITHUB_USER and GITHUB_TOKEN env var is not set...Are we not in a codespace??? Assuming git auth is configured correctly"
fi

echo "Starting minecraft script..."

tmux new-session -d -s MinecraftGeneral

sleep 1
tmux send-keys -t MinecraftGeneral 'tmux new-window' C-m # New tmux window, used by playit later on

tmux send-keys -t MinecraftGeneral:0 'tmux rename-window Minecraft&&' C-m

tmux send-keys -t MinecraftGeneral:0 'echo -e "\n_____Before-Backup_____"               &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT PULL *****"                  &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git pull                                         &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT ADD *****"                   &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git add .                                        &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT COMMIT *****"                &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git commit -m "Backup at $(date) - BeforeStart"  ||' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT PUSH *****"                  &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git push                                         &&' C-m

tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** SERVER  START *****"             &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' java -Xms6G -jar server.jar nogui                ||' C-m

tmux send-keys -t MinecraftGeneral:0 'echo -e "\n_____AfterStop______"                  &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT PULL *****"                  &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git pull                                         &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT ADD *****"                   &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git add .                                        &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT COMMIT *****"                &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git commit -m "Backup at $(date) - AfterStop"    &&' C-m
tmux send-keys -t MinecraftGeneral:0 'echo -e "\n***** GIT PUSH *****"                  &&' C-m
tmux send-keys -t MinecraftGeneral:0 ' git push                                         &&' C-m
tmux send-keys -t MinecraftGeneral:0 '  tmux wait -S FinishedMc                           ' C-m


echo "Starting playit script..."1
tmux send-keys -t MinecraftGeneral:1 'tmux rename-window Playit&&' C-m
tmux send-keys -t MinecraftGeneral:1 'echo -e "\nStarting playit"  &&' C-m
tmux send-keys -t MinecraftGeneral:1 ' playit --secret 11becd60efc5bd2877f8000e731bd47ba5c6fdbe7f6f8d988461343ca55a177f' C-m
