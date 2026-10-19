--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("GameGui",10)
if not gui then warn("ENAM JAM: GameGui belum tersedia"); return end
local chapter = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Chapters"))
local narrative = require(ReplicatedStorage.Shared:WaitForChild("Narrative"))
local CinematicController = require(script.Parent.CinematicController)
local NarrativeController = require(script.Parent.NarrativeController)
local cinematic = CinematicController.new(player)
local remote
local state
local movement
local lobbyRemote
local LobbyController=require(script.Parent.LobbyController)
local lobby=LobbyController.new(player,function(action,revision,value)
 if lobbyRemote then lobbyRemote:FireServer(action,revision,value) end
end)
local MainMenuController = require(script.Parent.MainMenuController)
local menu = MainMenuController.new(player,function(action,chapterId)
 if not remote then return false end
 if action == "ready" then remote:FireServer("ready"); return true end
 if not state then return false end
 remote:FireServer(action,state.revision,chapterId)
 return true
end)
gui.Enabled=false
menu:show({loading=true,hasCheckpoint=false})
cinematic:setLocked(true)
local fadeTween
local lastClick = 0
local function advance()
 if not state or not remote or os.clock()-lastClick < 0.25 then return end
 lastClick = os.clock()
 local action = if state.phase == "completed" or state.phase == "error" then "menu" else "continue"
 remote:FireServer(action,state.revision)
end
local ui = NarrativeController.new(gui,advance)
local remoteFolder = ReplicatedStorage:WaitForChild("Remotes",10)
remote = remoteFolder and remoteFolder:FindFirstChild("NarrativeEvent")
lobbyRemote=remoteFolder and remoteFolder:FindFirstChild("LobbyEvent")
if remote and not remote:IsA("RemoteEvent") then remote=nil end
if not remote or not lobbyRemote or not lobbyRemote:IsA("RemoteEvent") then
 menu:requestFailed("Koneksi game belum siap. Periksa penyiapan, lalu mulai ulang Play.")
 return
end
local movementRemote=remoteFolder:WaitForChild("MovementEvent",10)
if not movementRemote or not movementRemote:IsA("RemoteEvent") then
 menu:requestFailed("Kontrol movement belum siap. Mulai ulang Play.");return
end
movement=require(script.Parent.MovementController).new(player,movementRemote)
local menuButton=Instance.new("TextButton")
menuButton.Name="OpenMenu"; menuButton.Size=UDim2.fromOffset(88,44); menuButton.Position=UDim2.new(1,-100,0,12)
menuButton.Text="MENU"; menuButton.Font=Enum.Font.GothamMedium; menuButton.TextSize=14
menuButton.BackgroundColor3=Color3.fromRGB(27,35,34); menuButton.TextColor3=Color3.fromRGB(225,217,194)
menuButton.BorderSizePixel=0; menuButton.ZIndex=11; menuButton.Parent=gui
menuButton.Activated:Connect(function()
 if not state or os.clock()-lastClick<0.25 then return end
 lastClick=os.clock(); remote:FireServer("menu",state.revision)
end)
local function render(nextState)
 if typeof(nextState) ~= "table" or typeof(nextState.revision) ~= "number" then return end
 if state and nextState.revision <= state.revision then
  if nextState.revision==state.revision and nextState.phase=="menu" then menu:show(nextState) end
  return
 end
 state = nextState
 if state.phase~="exploring" then movement:setEnabled(false) end
 cinematic:cancel()
 if fadeTween then fadeTween:Cancel(); fadeTween=nil end
 gui.Fade.BackgroundTransparency = 1
 cinematic:setLocked(state.phase ~= "exploring" and state.phase ~= "error")
 gui.Enabled=state.phase~="menu"
 if state.phase=="menu" then menu:show(state)
 else lobby:hide();menu:setLobbyActive(false);menu:hide() end
 if state.phase=="exploring" then movement:setEnabled(true,menu.reduced) end
 local scene = workspace:FindFirstChild("ActiveScene")
 for _,object in ipairs(if scene then scene:GetDescendants() else {}) do
  if object:IsA("ProximityPrompt") then
   local objective = chapter.objectives[state.objectiveIndex]
   object.Enabled = state.phase == "exploring" and objective ~= nil and object.Parent:GetAttribute("InteractionId") == objective.id
  end
 end
 if state.phase == "menu" then
  return
 elseif state.phase == "title" then
  ui:showCard(chapter.title,chapter.introduction,"Mulai")
 elseif state.phase == "exploring" then
  ui:showObjective(chapter.objectives[state.objectiveIndex].instruction)
 elseif state.phase == "dialogue" then
  local entry = narrative[chapter.objectives[state.objectiveIndex].narrativeId]
  gui.Card.Category.Text=({FACT="FAKTA SEJARAH",TESTIMONY="KESAKSIAN",FICTIONAL_ADAPTATION="ADAPTASI FIKSI",DISPUTED="CATATAN BERBEDA"})[entry.kind] or chapter.disclaimer
  ui:showCard(entry.speaker,entry.text,"Lanjut")
 elseif state.phase == "cinematic" then
  ui:showObjective("Menjelang fajar · transisi prolog")
  if not cinematic:play(workspace:FindFirstChild("ActiveScene"),chapter.closingDuration) then
   remote:FireServer("cameraFailed",state.revision)
  end
  task.delay(chapter.closingDuration-0.8,function()
   if state.revision ~= nextState.revision then return end
   fadeTween = TweenService:Create(gui.Fade,TweenInfo.new(0.7),{BackgroundTransparency=0})
   fadeTween:Play()
  end)
 elseif state.phase == "completed" then
  ui:showCard("Prolog selesai",chapter.ending,"Kembali ke menu")
 elseif state.phase == "error" then
  ui:showCard("Prototipe belum siap",(state.error or "Scene tidak lengkap.").."\n\nPerbaiki penyiapan lalu kembali ke lobby, atau mulai ulang Play.","Kembali ke menu")
 end
end
remote.OnClientEvent:Connect(render)
lobbyRemote.OnClientEvent:Connect(function(snapshot)
 if typeof(snapshot)~="table" then return end
 if state and state.phase=="menu" and snapshot.joined and snapshot.phase=="waiting" then
  menu:setLobbyActive(true);lobby:setReduced(menu.reduced);lobby:show(snapshot)
  gui.Enabled=false;cinematic:setLocked(true)
 else
  lobby:hide();menu:setLobbyActive(false)
  if state and state.phase=="menu" and snapshot.notice then menu:requestFailed(snapshot.notice) end
 end
end)
ContextActionService:BindActionAtPriority("EnamJamAdvance",function(_,inputState)
 if menu:isVisible() then return Enum.ContextActionResult.Pass end
 if state and (state.phase=="title" or state.phase=="dialogue" or state.phase=="completed" or state.phase=="error") then
  if inputState == Enum.UserInputState.Begin then advance() end
  return Enum.ContextActionResult.Sink
 end
 return Enum.ContextActionResult.Pass
end,false,3000,Enum.KeyCode.Return,Enum.KeyCode.Space)
player.CharacterAdded:Connect(function()
 cinematic:cancel()
 cinematic:setLocked(menu:isVisible())
 if menu:isVisible() then task.defer(function() menu:refreshCamera() end) end
end)
workspace:GetAttributeChangedSignal("EnamJamSetupError"):Connect(function()
 local message = workspace:GetAttribute("EnamJamSetupError")
 if menu:isVisible() then return end
 if message and (not state or state.phase ~= "error") then
  cinematic:cancel()
  cinematic:setLocked(false)
  ui:showCard("Prototipe belum siap",message.."\n\nPeriksa penyiapan lalu mulai ulang Play.",nil)
 end
end)
remote:FireServer("ready")
