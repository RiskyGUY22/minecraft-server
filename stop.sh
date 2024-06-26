echo "Stopping Minecraft..."
tmux send-keys -t MinecraftGeneral:0 "stop" C-m
sleep 1
tmux send-keys -t MinecraftGeneral:0 "stop" C-m
echo "Waiting for minecraft to stop and finish backup..."
tmux wait FinishedMc

echo "Stopping playit..."
tmux send-keys -t MinecraftGeneral:1 C-c
sleep 1
tmux send-keys -t MinecraftGeneral:1 C-c


tmux send-keys -t MinecraftGeneral:1 "exit" C-m
tmux send-keys -t MinecraftGeneral:0 "exit" C-m

echo "All is stopped!"
