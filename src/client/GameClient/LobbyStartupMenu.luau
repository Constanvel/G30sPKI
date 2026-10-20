--!strict
local Menu=require(script.Parent.MainMenuController)
local Cinematic=require(script.Parent.CinematicController)
local Startup={};Startup.__index=Startup

function Startup:lock(character)
 local humanoid=character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid",10)
 if not self.active or character~=self.player.Character or not humanoid then return end
 if self.saved[humanoid] then return end
 self.saved[humanoid]={WalkSpeed=humanoid.WalkSpeed,JumpPower=humanoid.JumpPower,JumpHeight=humanoid.JumpHeight,AutoRotate=humanoid.AutoRotate}
 humanoid.WalkSpeed=0;humanoid.JumpPower=0;humanoid.JumpHeight=0;humanoid.AutoRotate=false
end

function Startup:release()
 for humanoid,properties in pairs(self.saved)do
  if humanoid.Parent then for name,value in pairs(properties)do humanoid[name]=value end end
 end
 table.clear(self.saved)
 self.cinematic:setLocked(false)
end

function Startup:enter()
 if not self.active then return end
 self.active=false
 self.menu:hide()
 self:release()
 self.gui.Enabled=true
end

function Startup.new(player,lobbyGui)
 local self=setmetatable({player=player,gui=lobbyGui,active=true,saved={}},Startup)
 self.cinematic=Cinematic.new(player)
 self.menu=Menu.new(player,function(action)
  if action=="lobby" then self:enter();return true end
  return false
 end)
 self.added=player.CharacterAdded:Connect(function(character)
  if self.active then task.spawn(function()self:lock(character)end)end
 end)
 self.gui.Enabled=false
 self.cinematic:setLocked(true)
 if player.Character then task.spawn(function()self:lock(player.Character)end)end
 self.menu:show({loading=false,hasCheckpoint=false})
 return self
end

function Startup:destroy()
 self.active=false;self.added:Disconnect();self:release();self.menu:destroy()
end
return Startup
