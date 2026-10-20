--!strict
return function(player)
 assert(not player.PlayerGui.MainMenuGui.Enabled,"Run after MULAI")
 local Camera=require(script.Parent.MenuCameraController);local scene=workspace.MenuEnvironment
 local controller=Camera.new(player);local original=workspace.CurrentCamera;local fov=original.FieldOfView
 local before={};for _,key in ipairs({"ClockTime","GeographicLatitude","Brightness","Ambient","OutdoorAmbient","FogColor","FogStart","FogEnd","ExposureCompensation","EnvironmentDiffuseScale","EnvironmentSpecularScale","ShadowSoftness"})do before[key]=game.Lighting[key]end
 local effects={};for _,v in ipairs(game.Lighting:GetChildren())do
  local keys=({Atmosphere={"Density","Offset","Color","Decay","Haze","Glare"},BloomEffect={"Intensity","Threshold","Size"},ColorCorrectionEffect={"TintColor","Contrast","Saturation","Brightness"},Sky={"SunAngularSize"},DepthOfFieldEffect={"Enabled"},SunRaysEffect={"Enabled"}})[v.ClassName]
  if keys then effects[v]={};for _,key in ipairs(keys)do effects[v][key]=v[key]end end
 end
 local checks=0;local function check(v,m)assert(v,m);checks+=1 end
 local ok,message=pcall(function()
  local t30,t120=0,0;for _=1,420 do t30+=1/30 end;for _=1,1680 do t120+=1/120 end
  check((Camera.sample(t30).Position-Camera.sample(t120).Position).Magnitude<.00001,"Frame independent drift")
  check((Camera.sample(28).Position-Camera.sample(56).Position).Magnitude<.00001,"Closed 28 second drift cycle")
  check(Camera.sample(0)==CFrame.identity,"No opening snap")
  check(Camera.fieldOfView(16/9)==52,"Widescreen preserves the primary lens")
  check(Camera.fieldOfView(4/3)>52 and Camera.fieldOfView(9/16)>Camera.fieldOfView(4/3),"Narrow viewports preserve horizontal composition")
  check(controller:start(scene),"Camera starts with scene anchor")
  check(math.abs(original.FieldOfView-Camera.fieldOfView(original.ViewportSize.X/original.ViewportSize.Y))<.001 and game.Lighting.ClockTime>6.5 and game.Lighting.ClockTime<8,"Golden hour camera profile")
  check(game.Lighting.FogStart>=80 and game.Lighting.FogEnd>=300,"Readable atmospheric depth")
  check(game.Lighting.OutdoorAmbient.R>game.Lighting.OutdoorAmbient.B,"Warm morning ambient")
  local frame=controller.frame;local motion=controller.motions[1];local rest=motion.original
  check(#controller.motions>30 and #controller.motions<=70,"Single callback covers bounded ambient motion")
  controller:start(scene);check(controller.frame==frame,"Repeated start preserves one loop")
  task.wait(.7);check(motion.instance.CFrame~=rest,"Scene motion animates")
  controller:setReduced(true);local pose=original.CFrame;local frozen=motion.instance.CFrame
  check(not frame.Connected and controller.frame==nil,"Reduced motion disconnects updates")
  task.wait(.12);check(original.CFrame==pose and motion.instance.CFrame==frozen,"Reduced motion freezes camera and environment")
  controller:refresh();check(original.CFrame==pose,"Character refresh preserves framing")
  controller:setReduced(false);task.wait(.03);check((original.CFrame.Position-pose.Position).Magnitude<.03,"Drift resumes without snapping")
  controller:stop();check(motion.instance.CFrame==rest,"Stop restores decorative rest pose")
  check(controller.frame==nil and controller.viewport==nil and #controller.motions==0 and #controller.created==0,"Stop cleans loops and menu effects")
  for _,v in ipairs(game.Lighting:GetChildren())do check(not v.Name:match("^MenuSunrise"),"Created lighting cannot leak into lobby")end
  for _=1,3 do check(controller:start(scene),"Repeated lifecycle start");controller:stop()end
 end)
 controller:stop();assert(ok,message)
 check(original.CameraType==Enum.CameraType.Custom and original.FieldOfView==fov,"Gameplay camera restored")
 for key,value in pairs(before)do check(game.Lighting[key]==value,"Lighting restored: "..key)end
 for object,values in pairs(effects)do for key,value in pairs(values)do check(object[key]==value,"Effect restored: "..key)end end
 return tostring(checks).." camera assertions PASS"
end
