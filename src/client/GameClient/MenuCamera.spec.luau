--!strict
return function(player)
 assert(not player.PlayerGui.MainMenuGui.Enabled,"Jalankan sesudah MULAI, saat intro gameplay")
 local Camera=require(script.Parent.MenuCameraController)
 local camera=Camera.new(player)
 local original=workspace.CurrentCamera
 local before={fov=original.FieldOfView,time=game.Lighting.ClockTime,ambient=game.Lighting.Ambient,effects={}}
 for _,effect in ipairs(game.Lighting:GetChildren()) do
  if effect:IsA("Atmosphere") then before.effects[effect]={Density=effect.Density,Color=effect.Color,Haze=effect.Haze,Offset=effect.Offset,Decay=effect.Decay,Glare=effect.Glare}
  elseif effect:IsA("BloomEffect") then before.effects[effect]={Intensity=effect.Intensity,Threshold=effect.Threshold,Size=effect.Size}
  elseif effect:IsA("SunRaysEffect") then before.effects[effect]={Enabled=effect.Enabled} end
 end
 local checks=0
 local function check(value,message) assert(value,message); checks+=1 end
 local ok,message=pcall(function()
  check(camera:start(workspace.MenuEnvironment),"Kamera harus dapat dimulai")
  task.wait(1.1)
  local pose=original.CFrame
  camera:setReduced(true)
  check((pose.Position-original.CFrame.Position).Magnitude<0.001,"Reduced motion tidak boleh menyentak kamera ke anchor")
  task.wait(0.1)
  check(pose==original.CFrame,"Reduced motion harus membekukan pose terakhir")
  camera:refresh()
  check(pose==original.CFrame,"Refresh karakter tidak boleh mereset drift")
  camera:setReduced(false); task.wait(0.04)
  check((pose.Position-original.CFrame.Position).Magnitude<0.025,"Melanjutkan drift harus mulus")
  for effect in pairs(before.effects) do
   if effect:IsA("Atmosphere") then check(effect.Density<=0.25,"Fog menu harus terkendali")
   elseif effect:IsA("BloomEffect") then check(effect.Intensity<=0.2,"Bloom menu harus lembut") end
  end
 end)
 camera:stop()
 assert(ok,message)
 check(original.CameraType==Enum.CameraType.Custom and original.FieldOfView==before.fov,"Kamera gameplay dipulihkan")
 check(game.Lighting.ClockTime==before.time and game.Lighting.Ambient==before.ambient,"Pencahayaan dipulihkan")
 for effect,properties in pairs(before.effects) do for property,value in pairs(properties) do check(effect[property]==value,"Efek gameplay tidak dipulihkan: "..property) end end
 return tostring(checks).." camera assertions PASS"
end
