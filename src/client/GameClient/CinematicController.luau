--!strict
local TweenService = game:GetService("TweenService")
local CinematicController = {}
CinematicController.__index = CinematicController

function CinematicController.new(player)
 local controls
 local playerModule = player.PlayerScripts:FindFirstChild("PlayerModule")
 if playerModule then
  local ok,result = pcall(function() return require(playerModule):GetControls() end)
  if ok then controls = result end
 end
 return setmetatable({player=player,controls=controls},CinematicController)
end

function CinematicController:setLocked(locked)
 local touchGui = self.player.PlayerGui:FindFirstChild("TouchGui")
 if touchGui then touchGui.Enabled = not locked end
 if self.controls then
  if locked then self.controls:Disable() else self.controls:Enable() end
 end
end

function CinematicController:cancel()
 if self.tween then self.tween:Cancel(); self.tween=nil end
 if self.camera then
  self.camera.CameraType = Enum.CameraType.Custom
  local character = self.player.Character
  local humanoid = character and character:FindFirstChildOfClass("Humanoid")
  if humanoid then self.camera.CameraSubject = humanoid end
  self.camera = nil
 end
end

function CinematicController:play(scene, duration)
 self:cancel()
 local start = scene and scene:FindFirstChild("CameraStart")
 local finish = scene and scene:FindFirstChild("CameraEnd")
 local camera = workspace.CurrentCamera
 if not start or not start:IsA("BasePart") or not finish or not finish:IsA("BasePart") or not camera then return false end
 self.camera = camera
 camera.CameraType = Enum.CameraType.Scriptable
 camera.CFrame = start.CFrame
 self.tween = TweenService:Create(camera,TweenInfo.new(duration,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{CFrame=finish.CFrame})
 self.tween:Play()
 return true
end

return CinematicController
