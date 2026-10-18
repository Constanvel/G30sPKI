--!strict
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local MenuCameraController={}
MenuCameraController.__index=MenuCameraController
local properties={ClockTime=0.3,Brightness=1.5,Ambient=Color3.fromRGB(96,109,120),OutdoorAmbient=Color3.fromRGB(91,104,114),FogColor=Color3.fromRGB(48,59,61),FogStart=45,FogEnd=205,ExposureCompensation=0.12}
local effects={
 Atmosphere={Density=0.24,Offset=0.05,Color=Color3.fromRGB(137,151,158),Decay=Color3.fromRGB(56,69,69),Haze=1.6,Glare=0},
 BloomEffect={Intensity=0.12,Threshold=2.3,Size=12},
 SunRaysEffect={Enabled=false},
}

function MenuCameraController.new(player)
 return setmetatable({player=player,reduced=false,time=0},MenuCameraController)
end

function MenuCameraController:refresh()
 if not self.active then return end
 local camera=workspace.CurrentCamera
 if camera then camera.CameraType=Enum.CameraType.Scriptable; camera.FieldOfView=58; camera.CFrame=self.pose or self.base end
end

function MenuCameraController:setReduced(reduced)
 self.reduced=reduced
 if self.frame then self.frame:Disconnect(); self.frame=nil end
 if not self.active then return end
 if not reduced then
  self.frame=RunService.RenderStepped:Connect(function(dt)
   self.time+=dt
   local camera=workspace.CurrentCamera
   self.pose=self.base*CFrame.new(math.sin(self.time*0.13)*0.45,math.sin(self.time*0.17)*0.12,0)*CFrame.Angles(0,math.sin(self.time*0.1)*0.004,0)
   if camera then camera.CFrame=self.pose end
  end)
 end
end

function MenuCameraController:start(scene)
 if self.active then return true end
 local camera=workspace.CurrentCamera
 if not camera then return false end
 self.saved={fov=camera.FieldOfView,lighting={},effects={}}
 for property,value in pairs(properties) do self.saved.lighting[property]=Lighting[property]; Lighting[property]=value end
 for _,effect in ipairs(Lighting:GetChildren()) do
  local overrides=effects[effect.ClassName]
  if overrides then
   local original={}; self.saved.effects[effect]=original
   for property,value in pairs(overrides) do original[property]=effect[property]; effect[property]=value end
  end
 end
 local marker=scene and scene:FindFirstChild("CameraAnchor")
 local valid=marker and marker:IsA("BasePart")
 self.base=if valid then marker.CFrame else CFrame.lookAt(Vector3.new(1005,135.2,40),Vector3.new(1010,130.3,-30))
 self.time=0; self.pose=self.base
 self.active=true
 self:refresh()
 self:setReduced(self.reduced)
 self.character=self.player.CharacterAdded:Connect(function() task.defer(function() self:refresh() end) end)
 self.changed=workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() self:refresh() end)
 return valid~=nil and valid~=false
end

function MenuCameraController:stop()
 if not self.active then return end
 self.active=false
 for _,key in ipairs({"frame","character","changed"}) do if self[key] then self[key]:Disconnect(); self[key]=nil end end
 for property,value in pairs(self.saved.lighting) do Lighting[property]=value end
 for effect,original in pairs(self.saved.effects) do
  if effect.Parent then for property,value in pairs(original) do effect[property]=value end end
 end
 local camera=workspace.CurrentCamera
 if camera then
  camera.CameraType=Enum.CameraType.Custom; camera.FieldOfView=self.saved.fov
  local humanoid=self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid")
  if humanoid then camera.CameraSubject=humanoid end
 end
 self.saved=nil
end

return MenuCameraController
