--!strict
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local chapter=require(RS.Shared.Chapters)
local config=require(RS.Shared.GameConfig)
local ChapterService=require(script.Parent.ChapterService)
local InteractionService=require(script.Parent.InteractionService)
local LobbyService=require(script.Parent.LobbyService)
local service=ChapterService.new(chapter)
local lobby=LobbyService.new(config)
local remotes=RS:WaitForChild("Remotes",10)
local remote=remotes and remotes:FindFirstChild("NarrativeEvent")
local lobbyRemote=remotes and remotes:FindFirstChild("LobbyEvent")
if not remote or not remote:IsA("RemoteEvent") or not lobbyRemote or not lobbyRemote:IsA("RemoteEvent") then
 workspace:SetAttribute("EnamJamSetupError","Remote belum lengkap. Jalankan penyiapan prolog lalu mulai ulang Play.")
 warn("ENAM JAM: remote belum lengkap");return
end
local scene=workspace:FindFirstChild("ActiveScene")
local movement,lastRequest={},{}
local function sendState(player)
 local state=service:snapshot(player)
 if not state then return end
 local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 local defaults=movement[player]
 if humanoid and defaults then
  local enabled=state.phase=="exploring" or state.phase=="error"
  humanoid.WalkSpeed=if enabled then defaults.speed else 0
  humanoid.JumpPower=if enabled then defaults.power else 0
  humanoid.JumpHeight=if enabled then defaults.height else 0
  humanoid.AutoRotate=enabled
 end
 remote:FireClient(player,state)
end
local function broadcastLobby(notice)
 for _,player in ipairs(Players:GetPlayers()) do lobbyRemote:FireClient(player,lobby:snapshot(player,notice)) end
end
local function invalid(player)
 scene=workspace:FindFirstChild("ActiveScene")
 local message=InteractionService.sceneError(scene,chapter)
 workspace:SetAttribute("EnamJamSetupError",message)
 if message then service:fail(player,message);return true end
 return false
end
local timers={}
local publish
publish=function()
 local lobbyChanged=false
 for _,player in ipairs(Players:GetPlayers()) do
  local state=service:snapshot(player)
  if state then
   if state.phase~="menu" then invalid(player);state=service:snapshot(player) end
   sendState(player)
   if state.phase=="error" and lobby.phase=="playing" then lobby:finish();lobbyChanged=true end
   if state.phase=="cinematic" and timers[player]~=state.revision then
    timers[player]=state.revision
    task.delay(chapter.closingDuration,function()
     local latest=service:snapshot(player)
     if player.Parent==Players and latest and latest.phase=="cinematic" and latest.revision==state.revision then
      if not invalid(player) then service:finishCinematic(player,state.revision) end
      if lobby.phase=="playing" then lobby:finish() end
      publish();broadcastLobby()
     end
    end)
   end
  end
 end
 if lobbyChanged then broadcastLobby() end
end
local function onCharacter(player,character)
 local root=character:WaitForChild("HumanoidRootPart",10)
 local humanoid=character:WaitForChild("Humanoid",10)
 if not root or not humanoid or player.Character~=character then return end
 movement[player]={speed=humanoid.WalkSpeed,power=humanoid.JumpPower,height=humanoid.JumpHeight}
 local previous=service:snapshot(player)
 if not previous then
  service:reset(player);service:enterMenu(player,service:snapshot(player).revision)
 elseif previous.phase~="menu" then
  -- Respawn rejoins the live party progress, without resetting teammates.
  service:enterMenu(player,previous.revision);service:resume(player,service:snapshot(player).revision)
 end
 if not invalid(player) then character:PivotTo(scene.SpawnMarker.CFrame) end
 publish()
end
local function onPlayer(player)
 player.CharacterAdded:Connect(function(character) onCharacter(player,character) end)
 if player.Character then task.spawn(onCharacter,player,player.Character) end
end
Players.PlayerAdded:Connect(onPlayer)
for _,player in ipairs(Players:GetPlayers()) do onPlayer(player) end
Players.PlayerRemoving:Connect(function(player)
 service:remove(player);lobby:remove(player);movement[player]=nil;lastRequest[player]=nil;timers[player]=nil
 broadcastLobby()
end)
local function allowed(player)
 local now=os.clock()
 if now-(lastRequest[player] or -math.huge)<.15 then return false end
 lastRequest[player]=now;return true
end
remote.OnServerEvent:Connect(function(player,action,revision)
 if typeof(action)~="string" then return end
 local state=service:snapshot(player)
 if not state then return end
 if action=="ready" then sendState(player);lobbyRemote:FireClient(player,lobby:snapshot(player));return end
 if revision~=state.revision or not allowed(player) then return end
 if action=="menu" and service:enterMenu(player,revision) then publish()
 elseif action=="lobby" and state.phase=="menu" then
  if lobby:join(player) then sendState(player);broadcastLobby()
  else sendState(player);lobbyRemote:FireClient(player,lobby:snapshot(player,"Misi sedang berjalan atau regu penuh.")) end
 elseif action=="resume" and not invalid(player) and service:resume(player,revision) then publish()
 elseif action=="continue" and service:acknowledge(player,revision) then publish()
 elseif action=="cameraFailed" and state.phase=="cinematic" then
  service:fail(player,"Kamera belum tersedia. Kembali ke menu dan coba ulang.");publish()
 end
end)
lobbyRemote.OnServerEvent:Connect(function(player,action,revision,value)
 if typeof(action)~="string" or not allowed(player) then return end
 local state=service:snapshot(player)
 if not state or state.phase~="menu" then return end
 if action=="launch" then
  for _,member in ipairs(lobby:players()) do
   local other=service:snapshot(member)
   if not other or other.phase~="menu" or not member.Character or not member.Character:FindFirstChild("HumanoidRootPart") then
    lobbyRemote:FireClient(player,lobby:snapshot(player,"Tunggu semua anggota kembali ke lobby."));return
   end
  end
  if invalid(player) then publish();return end
 end
 if not lobby:request(player,action,revision,value) then
  lobbyRemote:FireClient(player,lobby:snapshot(player,"Pilihan sudah berubah. Periksa status regu."));return
 end
 if action=="launch" then
  service:startParty(lobby:players())
  for _,member in ipairs(lobby:players()) do member.Character:PivotTo(scene.SpawnMarker.CFrame) end
  publish()
 elseif action=="leave" then
  -- Leaving the waiting room also leaves its previous shared mission.
  if service.partyPlayers then service.partyPlayers[player]=nil end
  service.checkpoints[player]=nil
  sendState(player)
 end
 broadcastLobby()
end)
game:GetService("ProximityPromptService").PromptTriggered:Connect(function(object,player)
 local state=service:snapshot(player)
 if not state or state.phase~="exploring" or not allowed(player) then return end
 if not invalid(player) and InteractionService.isAllowed(player,object,scene,service:expectedInteraction(player)) then
  if service:interact(player,object.Parent:GetAttribute("InteractionId")) then publish() end
 end
end)
workspace.DescendantRemoving:Connect(function(object)
 if scene and (object==scene or object:IsDescendantOf(scene)) then task.defer(publish) end
end)
workspace:SetAttribute("EnamJamSetupError",InteractionService.sceneError(scene,chapter))
print("ENAM JAM: lobby dan prolog siap")
