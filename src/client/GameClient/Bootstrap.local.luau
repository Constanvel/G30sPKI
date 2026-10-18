--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("GameGui",10)
if not gui then warn("VS01: GameGui belum tersedia"); return end
local chapter = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Chapters"))
local narrative = require(ReplicatedStorage.Shared:WaitForChild("Narrative"))
local CinematicController = require(script.Parent.CinematicController)
local NarrativeController = require(script.Parent.NarrativeController)
local cinematic = CinematicController.new(player)
local remoteFolder = ReplicatedStorage:WaitForChild("Remotes",10)
local remote = remoteFolder and remoteFolder:FindFirstChild("NarrativeEvent")
local state
local fadeTween
local lastClick = 0
local function advance()
 if not state or not remote or os.clock()-lastClick < 0.25 then return end
 lastClick = os.clock()
 local action = if state.phase == "completed" or state.phase == "error" then "restart" else "continue"
 remote:FireServer(action,state.revision)
end
local ui = NarrativeController.new(gui,advance)
if not remote then
 ui:showCard("Prototipe belum siap",workspace:GetAttribute("VS01SetupError") or "Remote tidak tersedia. Periksa penyiapan scene.",nil)
 return
end
local function render(nextState)
 if typeof(nextState) ~= "table" or typeof(nextState.revision) ~= "number" then return end
 if state and nextState.revision <= state.revision then return end
 state = nextState
 cinematic:cancel()
 if fadeTween then fadeTween:Cancel(); fadeTween=nil end
 gui.Fade.BackgroundTransparency = 1
 cinematic:setLocked(state.phase ~= "exploring" and state.phase ~= "error")
 local scene = workspace:FindFirstChild("ActiveScene")
 for _,object in ipairs(if scene then scene:GetDescendants() else {}) do
  if object:IsA("ProximityPrompt") then
   local objective = chapter.objectives[state.objectiveIndex]
   object.Enabled = state.phase == "exploring" and objective ~= nil and object.Parent:GetAttribute("InteractionId") == objective.id
  end
 end
 if state.phase == "title" then
  ui:showCard(chapter.title,chapter.introduction,"Mulai")
 elseif state.phase == "exploring" then
  ui:showObjective(chapter.objectives[state.objectiveIndex].instruction)
 elseif state.phase == "dialogue" then
  local entry = narrative[chapter.objectives[state.objectiveIndex].narrativeId]
  ui:showCard(entry.speaker,entry.text,"Lanjut")
 elseif state.phase == "cinematic" then
  ui:showObjective("Transisi chapter · dramatisasi teknis")
  if not cinematic:play(workspace:FindFirstChild("ActiveScene"),chapter.closingDuration) then
   remote:FireServer("cameraFailed",state.revision)
  end
  task.delay(chapter.closingDuration-0.8,function()
   if state.revision ~= nextState.revision then return end
   fadeTween = TweenService:Create(gui.Fade,TweenInfo.new(0.7),{BackgroundTransparency=0})
   fadeTween:Play()
  end)
 elseif state.phase == "completed" then
  ui:showCard("Akhir demo VS01",chapter.ending,"Ulangi demo")
 elseif state.phase == "error" then
  ui:showCard("Prototipe belum siap",(state.error or "Scene tidak lengkap.").."\n\nPerbaiki penyiapan lalu pilih Coba lagi, atau hentikan dan mulai ulang Play.","Coba lagi")
 end
end
remote.OnClientEvent:Connect(render)
ContextActionService:BindActionAtPriority("VS01Advance",function(_,inputState)
 if state and (state.phase=="title" or state.phase=="dialogue" or state.phase=="completed" or state.phase=="error") then
  if inputState == Enum.UserInputState.Begin then advance() end
  return Enum.ContextActionResult.Sink
 end
 return Enum.ContextActionResult.Pass
end,false,3000,Enum.KeyCode.Return,Enum.KeyCode.Space)
player.CharacterAdded:Connect(function()
 cinematic:cancel()
 cinematic:setLocked(false)
end)
workspace:GetAttributeChangedSignal("VS01SetupError"):Connect(function()
 local message = workspace:GetAttribute("VS01SetupError")
 if message and (not state or state.phase ~= "error") then
  cinematic:cancel()
  cinematic:setLocked(false)
  ui:showCard("Prototipe belum siap",message.."\n\nPeriksa penyiapan lalu mulai ulang Play.",nil)
 end
end)
remote:FireServer("ready")
