--!strict
return function(player)
 assert(not player.PlayerGui.MainMenuGui.Enabled,"Jalankan sesudah MULAI, saat intro gameplay")
 local Camera=require(script.Parent.MenuCameraController)
 local camera=Camera.new(player)
 local original=workspace.CurrentCamera
 local before={fov=original.FieldOfView,effects={}}
 local restored={}
 for _,key in ipairs({"LightingStyle","ClockTime","Brightness","Ambient","OutdoorAmbient","FogColor","FogStart","FogEnd","ExposureCompensation","EnvironmentDiffuseScale","EnvironmentSpecularScale","ShadowSoftness"}) do restored[key]=game.Lighting[key] end
 for _,effect in ipairs(game.Lighting:GetChildren()) do
  if effect:IsA("Atmosphere") then before.effects[effect]={Density=effect.Density,Color=effect.Color,Haze=effect.Haze,Offset=effect.Offset,Decay=effect.Decay,Glare=effect.Glare}
  elseif effect:IsA("BloomEffect") then before.effects[effect]={Intensity=effect.Intensity,Threshold=effect.Threshold,Size=effect.Size}
  elseif effect:IsA("SunRaysEffect") then before.effects[effect]={Enabled=effect.Enabled} end
 end
 local checks=0
 local function check(value,message) assert(value,message); checks+=1 end
 local ok,message=pcall(function()
  local time30,time120=0,0
  for _=1,420 do time30+=1/30 end;for _=1,1680 do time120+=1/120 end
  check((Camera.sample(time30).Position-Camera.sample(time120).Position).Magnitude<.00001,"Lintasan sama pada 30 dan 120 Hz")
  check((Camera.sample(28).Position-Camera.sample(56).Position).Magnitude<.00001,"Siklus kamera tertutup setiap 28 detik")
  local maxMove,maxAngle=0,0
  for t=0,56,.1 do
   local pose=Camera.sample(t);maxMove=math.max(maxMove,pose.Position.Magnitude)
   local _,angle=pose:ToAxisAngle();maxAngle=math.max(maxAngle,math.abs(angle))
  end
  check(maxMove<.45 and maxAngle<.002,"Gerak dan rotasi tetap sangat kecil")
  check(Camera.sample(0)==CFrame.new(),"Kamera mulai tepat pada framing asli")
  check(camera:start(workspace.MenuEnvironment),"Kamera harus dapat dimulai")
  check(game.Lighting.ClockTime>=5 and game.Lighting.ClockTime<6,"Menu harus berlatar menjelang fajar")
  check(game.Lighting.FogStart>=50 and game.Lighting.FogEnd>=220,"Kabut tidak boleh menutupi fasad terdekat")
  check(game.Lighting.Ambient.B>game.Lighting.Ambient.R,"Cahaya fajar harus tetap sejuk di luar lentera")
  local frame=camera.frame
  camera:start(workspace.MenuEnvironment)
  check(camera.frame==frame and #camera.lights==2,"Start berulang tidak menggandakan loop atau lampu")
  task.wait(1.1)
  local light=camera.lights[1]
  check(math.abs(light.instance.Brightness-light.brightness)<light.brightness*.02 and light.instance.Brightness~=light.brightness,"Variasi lentera lembut dan terbatas")
  local pose=original.CFrame
  camera:setReduced(true)
  local brightness=light.instance.Brightness
  check(not frame.Connected and camera.frame==nil,"Reduced motion menghentikan pembaruan frame")
  check((pose.Position-original.CFrame.Position).Magnitude<0.001,"Reduced motion tidak boleh menyentak kamera ke anchor")
  task.wait(0.1)
  check(light.instance.Brightness==brightness,"Reduced motion membekukan ambience")
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
 check(camera.frame==nil and camera.character==nil and camera.changed==nil and #camera.lights==0,"Semua koneksi kamera dan referensi lampu dibersihkan")
 for _,object in ipairs(workspace.MenuEnvironment:GetDescendants()) do
  if object:IsA("PointLight") and object.Parent.Name=="NyalaLampu" then check(math.abs(object.Brightness-1.65)<.0001,"Brightness asli dipulihkan") end
 end
 for key,value in pairs(restored) do check(game.Lighting[key]==value,"Pengaturan rendering tidak dipulihkan: "..key) end
 for effect,properties in pairs(before.effects) do for property,value in pairs(properties) do check(effect[property]==value,"Efek gameplay tidak dipulihkan: "..property) end end
 return tostring(checks).." camera assertions PASS"
end
