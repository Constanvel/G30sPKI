--!strict
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local MenuCameraController={}
MenuCameraController.__index=MenuCameraController
local properties={ClockTime=6.65,GeographicLatitude=-7.8,Brightness=3,Ambient=Color3.fromRGB(146,129,105),OutdoorAmbient=Color3.fromRGB(166,146,116),FogColor=Color3.fromRGB(225,193,143),FogStart=90,FogEnd=325,ExposureCompensation=.28,EnvironmentDiffuseScale=.7,EnvironmentSpecularScale=.18,ShadowSoftness=.65}
local effects={
 Atmosphere={Density=.28,Offset=.12,Color=Color3.fromRGB(255,222,176),Decay=Color3.fromRGB(190,150,96),Haze=2.1,Glare=.08},
 BloomEffect={Intensity=.07,Threshold=2.5,Size=16},
 ColorCorrectionEffect={TintColor=Color3.fromRGB(255,224,181),Contrast=.035,Saturation=-.03,Brightness=.025},
 Sky={SunAngularSize=6},
 DepthOfFieldEffect={Enabled=false},
 SunRaysEffect={Enabled=false},
}

function MenuCameraController.new(player)
 return setmetatable({player=player,reduced=false,time=0,lights={},motions={},created={}},MenuCameraController)
end

function MenuCameraController.sample(time)
 local phase=time*math.pi*2/28
 local ease=math.sin(math.min(time/1.2,1)*math.pi/2)^2
 return CFrame.new(math.sin(phase)*.38*ease,math.sin(phase*2)*.06*ease,(1-math.cos(phase))*.1*ease)
  *CFrame.Angles(math.sin(phase*2)*.0004*ease,math.sin(phase)*.0015*ease,0)
end

function MenuCameraController.fieldOfView(aspect,base)
 return math.clamp(math.deg(2*math.atan(math.tan(math.rad(base or 52)/2)*math.max(1,(16/9)/math.max(.1,aspect)))),base or 52,115)
end

function MenuCameraController:refresh()
 if not self.active then return end
 local camera=workspace.CurrentCamera
 if camera then
  if self.viewportCamera~=camera then
   if self.viewport then self.viewport:Disconnect()end
   self.viewportCamera=camera;self.viewport=camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()self:refresh()end)
  end
  camera.CameraType=Enum.CameraType.Scriptable
  camera.FieldOfView=MenuCameraController.fieldOfView(camera.ViewportSize.X/math.max(1,camera.ViewportSize.Y),self.fov)
  camera.CFrame=self.pose or self.base
 end
end

function MenuCameraController:setReduced(reduced)
 self.reduced=reduced
 if self.frame then self.frame:Disconnect(); self.frame=nil end
 if not self.active then return end
 if not reduced then
  self.frame=RunService.RenderStepped:Connect(function(dt)
   self.time+=dt
   local camera=workspace.CurrentCamera
   self.pose=self.base*MenuCameraController.sample(self.time)
   if camera then camera.CFrame=self.pose end
   for i,light in ipairs(self.lights) do
    if light.instance.Parent then light.instance.Brightness=light.brightness*(1+.018*math.sin(self.time*math.pi*2/10+(i-1)*math.pi)) end
   end
   local ease=math.sin(math.min(self.time/1.2,1)*math.pi/2)^2
   for _,motion in ipairs(self.motions)do
    if motion.instance.Parent then motion.instance.CFrame=motion.pivot*CFrame.Angles(math.sin(self.time*motion.speed+motion.phase)*motion.amplitude*ease,0,0)*motion.offset end
   end
  end)
 end
end

function MenuCameraController:start(scene)
 if self.active then return true end
 local camera=workspace.CurrentCamera
 if not camera then return false end
 self.saved={fov=camera.FieldOfView,lighting={},effects={}}
 for property,value in pairs(properties) do self.saved.lighting[property]=Lighting[property]; Lighting[property]=value end
 local found={}
 for _,effect in ipairs(Lighting:GetChildren()) do
  local overrides=effects[effect.ClassName]
  if overrides then
   found[effect.ClassName]=true
   local original={}; self.saved.effects[effect]=original
   for property,value in pairs(overrides) do original[property]=effect[property]; effect[property]=value end
  end
 end
 for _,class in ipairs({"Atmosphere","BloomEffect","ColorCorrectionEffect"})do
  if not found[class]then
   local effect=Instance.new(class);effect.Name="MenuSunrise"..class
   for property,value in pairs(effects[class])do effect[property]=value end
   effect.Parent=Lighting;table.insert(self.created,effect)
  end
 end
 local marker=scene and scene:FindFirstChild("CameraAnchor")
 local valid=marker and marker:IsA("BasePart")
 self.base=if valid then marker.CFrame else CFrame.lookAt(Vector3.new(992,133.6,39),Vector3.new(992,134.3,-130))
 self.fov=if scene then scene:GetAttribute("MenuFOV") or 52 else 52
 self.time=0; self.pose=self.base
 if scene then
  for _,object in ipairs(scene:GetDescendants()) do
   if object:IsA("PointLight") and object.Parent.Name=="NyalaLampu" then table.insert(self.lights,{instance=object,brightness=object.Brightness}) end
   if object:IsA("BasePart") and object:GetAttribute("MenuMotionPivot") then
    table.insert(self.motions,{instance=object,original=object.CFrame,pivot=object:GetAttribute("MenuMotionPivot"),offset=object:GetAttribute("MenuMotionOffset"),amplitude=object:GetAttribute("MenuMotionAmplitude"),phase=object:GetAttribute("MenuMotionPhase"),speed=object:GetAttribute("MenuMotionSpeed")})
   end
  end
 end
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
 for _,key in ipairs({"frame","character","changed","viewport"}) do if self[key] then self[key]:Disconnect(); self[key]=nil end end
 self.viewportCamera=nil
 for property,value in pairs(self.saved.lighting) do Lighting[property]=value end
 for effect,original in pairs(self.saved.effects) do
  if effect.Parent then for property,value in pairs(original) do effect[property]=value end end
 end
 for _,light in ipairs(self.lights) do if light.instance.Parent then light.instance.Brightness=light.brightness end end
 for _,motion in ipairs(self.motions)do if motion.instance.Parent then motion.instance.CFrame=motion.original end end
 for _,effect in ipairs(self.created)do effect:Destroy()end
 table.clear(self.lights)
 table.clear(self.motions);table.clear(self.created)
 local camera=workspace.CurrentCamera
 if camera then
  camera.CameraType=Enum.CameraType.Custom; camera.FieldOfView=self.saved.fov
  local humanoid=self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid")
  if humanoid then camera.CameraSubject=humanoid end
 end
 self.saved=nil
end

return MenuCameraController
