--!strict
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local MenuCameraController={}
MenuCameraController.__index=MenuCameraController
local properties={ClockTime=0.3,Brightness=1.1,Ambient=Color3.fromRGB(61,70,81),OutdoorAmbient=Color3.fromRGB(47,57,68),FogColor=Color3.fromRGB(34,44,51),FogStart=30,FogEnd=175,ExposureCompensation=-0.15}

function MenuCameraController.new(player)
 return setmetatable({player=player,reduced=false,time=0},MenuCameraController)
end

function MenuCameraController:refresh()
 if not self.active then return end
 local camera=workspace.CurrentCamera
 if camera then camera.CameraType=Enum.CameraType.Scriptable; camera.FieldOfView=58; camera.CFrame=self.base end
end

function MenuCameraController:setReduced(reduced)
 self.reduced=reduced
 if self.frame then self.frame:Disconnect(); self.frame=nil end
 if not self.active then return end
 self:refresh()
 if not reduced then
  self.frame=RunService.RenderStepped:Connect(function(dt)
   self.time+=dt
   local camera=workspace.CurrentCamera
   if camera then camera.CFrame=self.base*CFrame.new(math.sin(self.time*0.13)*0.45,math.sin(self.time*0.17)*0.12,0)*CFrame.Angles(0,math.sin(self.time*0.1)*0.004,0) end
  end)
 end
end

function MenuCameraController:start(scene)
 if self.active then return true end
 local camera=workspace.CurrentCamera
 if not camera then return false end
 self.saved={fov=camera.FieldOfView,lighting={}}
 for property,value in pairs(properties) do self.saved.lighting[property]=Lighting[property]; Lighting[property]=value end
 local marker=scene and scene:FindFirstChild("CameraAnchor")
 local valid=marker and marker:IsA("BasePart")
 self.base=if valid then marker.CFrame else CFrame.lookAt(Vector3.new(1005,6.7,42),Vector3.new(1005,5,-38))
 self.active=true
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
 local camera=workspace.CurrentCamera
 if camera then
  camera.CameraType=Enum.CameraType.Custom; camera.FieldOfView=self.saved.fov
  local humanoid=self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid")
  if humanoid then camera.CameraSubject=humanoid end
 end
 self.saved=nil
end

return MenuCameraController
