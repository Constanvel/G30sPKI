--!strict
return function()
 local Body=require(script.Parent.FirstPersonBody)
 local config=require(game.ReplicatedStorage.Shared.MovementConfig)
 local checks=0;local rigs={};local bodies={}
 local function check(ok,message)assert(ok,message);checks+=1 end
 local ok,result=pcall(function()
  for index,kind in ipairs({Enum.HumanoidRigType.R6,Enum.HumanoidRigType.R15})do
   local description=Instance.new("HumanoidDescription")
   local rig=game.Players:CreateHumanoidModelFromDescriptionAsync(description,kind);description:Destroy()
   table.insert(rigs,rig);rig.Name="FPSBodyFixture"..kind.Name
   for _,p in ipairs(rig:GetDescendants())do if p:IsA("BasePart")then p.Anchored=true end end
   rig:PivotTo(CFrame.new(index*100,12000,0));rig.Parent=workspace
   local body=Body.new(rig,config,true);table.insert(bodies,body)
   check(#body.joints>=4,kind.Name.." native joints found, including upgraded AnimationConstraint")
   local arm=rig:FindFirstChild("RightUpperArm") or rig:FindFirstChild("Right Arm")
   arm.LocalTransparencyModifier=.3;body.parts[arm]=.3
   body:visibility()
   check(rig.Head.LocalTransparencyModifier==1 and arm.LocalTransparencyModifier==0,kind.Name.." only head hidden; arms visible")
   local hat=Instance.new("Accessory");hat.Name="QAHat"
   local handle=Instance.new("Part");handle.Name="Handle";handle.Anchored=true;handle.Parent=hat
   local attachment=Instance.new("Attachment");attachment.Name="HatAttachment";attachment.Parent=handle
   local decoration=Instance.new("Part");decoration.Name="Decoration";decoration.Anchored=true;decoration.Parent=hat
   hat.Parent=rig;task.wait()
   body:visibility()
   check(handle.LocalTransparencyModifier==1,kind.Name.." newly loaded head accessory hidden")
   check(decoration.LocalTransparencyModifier==1,kind.Name.." multipart head accessory entirely hidden")
   local joint=body.joints[1].joint;local original=joint.Transform
   local baseRotation=body.joints[1].rotation
   for _=1,120 do body:prepare();body:step(1/60,"Idle",0,false,0,false) end
   local first=joint.Transform
   for _=1,120 do body:prepare();body:step(1/60,"Idle",0,false,0,true) end
   check(joint.Transform.Position.Magnitude<1 and joint.C0.Rotation==baseRotation,kind.Name.." pose does not change rig attachments or accumulate translation")
   for _,state in ipairs({"Walking","Sprinting","Crouching","Sliding","Jumping","Falling","Landing"})do
    body:prepare();body:step(.2,state,13,state=="Crouching" or state=="Sliding",-.8,false)
    check(joint.Transform.Position.X==joint.Transform.Position.X,kind.Name.." finite pose "..state)
   end
   body:visibility(arm.Position)
   check(arm.LocalTransparencyModifier==1,kind.Name.." geometry containing camera hidden locally")
   body:destroy();table.remove(bodies)
   check(math.abs(arm.LocalTransparencyModifier-.3)<.001 and rig.Head.LocalTransparencyModifier==0,kind.Name.." exit restores local visibility")
   local difference=original:ToObjectSpace(joint.Transform);local _,angle=difference:ToAxisAngle()
   check(difference.Position.Magnitude<.001 and math.abs(angle)<.001,kind.Name.." exit removes procedural offset")
   rig:Destroy();table.remove(rigs)
  end
  return tostring(checks).." visible body assertions PASS"
 end)
 for _,body in ipairs(bodies)do body:destroy()end
 for _,rig in ipairs(rigs)do rig:Destroy()end
 assert(ok,result);return result
end
