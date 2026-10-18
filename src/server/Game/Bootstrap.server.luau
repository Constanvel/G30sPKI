--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local chapter = require(ReplicatedStorage.Shared.Chapters)
local ChapterService = require(script.Parent.ChapterService)
local InteractionService = require(script.Parent.InteractionService)
local ProximityPromptService = game:GetService("ProximityPromptService")
local service = ChapterService.new(chapter)
local scene = workspace:FindFirstChild("ActiveScene")
local remote = ReplicatedStorage:WaitForChild("Remotes",10)
remote = remote and remote:FindFirstChild("NarrativeEvent")
if not remote or not remote:IsA("RemoteEvent") then
 workspace:SetAttribute("VS01SetupError","Remote belum lengkap. Periksa penyiapan VS01 lalu mulai ulang Play.")
 warn("VS01: remote tidak lengkap; chapter tidak dijalankan")
 return
end
workspace:SetAttribute("VS01SetupError",InteractionService.sceneError(scene,chapter))
local lastRequest = {}
local movement = {}

local function sendState(player)
 local state = service:snapshot(player)
 if not state then return end
 local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 local defaults = movement[player]
 if humanoid and defaults then
  local enabled = state.phase == "exploring" or state.phase == "error"
  humanoid.WalkSpeed = if enabled then defaults.speed else 0
  humanoid.JumpPower = if enabled then defaults.power else 0
  humanoid.JumpHeight = if enabled then defaults.height else 0
  humanoid.AutoRotate = enabled
 end
 remote:FireClient(player,state)
end

local function failIfInvalid(player)
 scene = workspace:FindFirstChild("ActiveScene")
 local message = InteractionService.sceneError(scene,chapter)
 workspace:SetAttribute("VS01SetupError",message)
 if message then
  service:fail(player,message)
  sendState(player)
  return true
 end
 return false
end

local function publish(player)
 if failIfInvalid(player) then return end
 sendState(player)
 local state = service:snapshot(player)
 if state.phase == "title" then
  task.delay(45,function()
   if player.Parent == Players and service:acknowledge(player,state.revision) then publish(player) end
  end)
 elseif state.phase == "cinematic" then
  task.delay(chapter.closingDuration,function()
   if player.Parent == Players and not failIfInvalid(player) and service:finishCinematic(player,state.revision) then publish(player) end
  end)
 end
end

local function onCharacter(player, character)
 local root = character:WaitForChild("HumanoidRootPart",10)
 local humanoid = character:WaitForChild("Humanoid",10)
 if not root or not humanoid or player.Character ~= character then return end
 movement[player] = {speed=humanoid.WalkSpeed,power=humanoid.JumpPower,height=humanoid.JumpHeight}
 service:reset(player)
 if failIfInvalid(player) then return end
 character:PivotTo(scene.SpawnMarker.CFrame)
 publish(player)
end

local function onPlayer(player)
 player.CharacterAdded:Connect(function(character) onCharacter(player,character) end)
 if player.Character then task.spawn(onCharacter,player,player.Character) end
end
Players.PlayerAdded:Connect(onPlayer)
for _,player in ipairs(Players:GetPlayers()) do onPlayer(player) end
Players.PlayerRemoving:Connect(function(player)
 service:remove(player)
 lastRequest[player], movement[player] = nil,nil
end)

remote.OnServerEvent:Connect(function(player,action,revision)
 if typeof(action) ~= "string" then return end
 local state = service:snapshot(player)
 if not state then return end
 if action == "cameraFailed" and revision == state.revision and state.phase == "cinematic" then
  service:fail(player,"Kamera belum tersedia di client. Coba lagi atau mulai ulang Play.")
  sendState(player)
  return
 end
 local now = os.clock()
 if now - (lastRequest[player] or -math.huge) < 0.2 then return end
 lastRequest[player] = now
 if action == "ready" then
  if not failIfInvalid(player) then sendState(player) end
 elseif typeof(revision) == "number" and revision == revision and revision == state.revision then
  if action == "continue" and service:acknowledge(player,revision) then
   publish(player)
  elseif action == "restart" and (state.phase == "completed" or state.phase == "error") then
   service:reset(player)
   if failIfInvalid(player) then return end
   local character = player.Character
   if character then character:PivotTo(scene.SpawnMarker.CFrame) end
   publish(player)
  end
 end
end)

ProximityPromptService.PromptTriggered:Connect(function(object,player)
   local now = os.clock()
   if now - (lastRequest[player] or -math.huge) < 0.2 then return end
   lastRequest[player] = now
   if not failIfInvalid(player) and InteractionService.isAllowed(player,object,scene,service:expectedInteraction(player)) then
    if service:interact(player,object.Parent:GetAttribute("InteractionId")) then publish(player) end
   end
end)
workspace.DescendantRemoving:Connect(function(object)
 if scene and (object == scene or object:IsDescendantOf(scene)) then
  task.defer(function()
   for _,player in ipairs(Players:GetPlayers()) do failIfInvalid(player) end
  end)
 end
end)
print("VS01: fondasi teknis siap")
