--!strict
local Body={}
Body.__index=Body
local function jointKind(joint)
 local name=joint.Name:gsub(" ","")
 if name:find("Shoulder") then return "shoulder",if name:find("Left") then -1 else 1 end
 if name:find("Elbow") then return "elbow",if name:find("Left") then -1 else 1 end
 if name:find("Hip") then return "hip",if name:find("Left") then -1 else 1 end
 if name:find("Knee") then return "knee",if name:find("Left") then -1 else 1 end
 if name:find("Ankle") then return "ankle",if name:find("Left") then -1 else 1 end
 if name=="Waist" or name=="RootJoint" then return "torso",0 end
 return nil,0
end
function Body.new(character,config,firstPerson)
 local self=setmetatable({character=character,config=config,firstPerson=firstPerson,parts={},joints={},weights={},phase=0,time=0},Body)
 self.head=character:FindFirstChild("Head");self.root=character:FindFirstChild("HumanoidRootPart")
 local humanoid=character:FindFirstChildOfClass("Humanoid")
 self.r6=humanoid and humanoid.RigType==Enum.HumanoidRigType.R6
 local function capture(obj)
  if firstPerson and obj:IsA("BasePart") and not obj:FindFirstAncestorOfClass("Tool") then
   self.parts[obj]=obj.LocalTransparencyModifier
  elseif obj:IsA("Motor6D") or obj:IsA("AnimationConstraint") then
   local kind,side=jointKind(obj)
   if kind then table.insert(self.joints,{joint=obj,kind=kind,side=side,rotation=obj.C0.Rotation}) end
  end
 end
 for _,obj in ipairs(character:GetDescendants())do capture(obj)end
 self.added=character.DescendantAdded:Connect(capture)
 return self
end
function Body:prepare()
 for _,entry in ipairs(self.joints)do
  local j=entry.joint
  if j.Parent and entry.applied and j.Transform==entry.applied then j.Transform=entry.base end
  entry.applied=nil
 end
end
function Body:visibility(position)
 if not self.firstPerson then return end
 for part in pairs(self.parts)do
  if not part.Parent then self.parts[part]=nil;continue end
  local hidden=part==self.head or part==self.root
  local accessory=part:FindFirstAncestorOfClass("Accessory")
  if accessory then
   local handle=accessory:FindFirstChild("Handle") or part
   for _,attachment in ipairs(handle:GetChildren())do
    if attachment:IsA("Attachment") and self.head and self.head:FindFirstChild(attachment.Name) then hidden=true;break end
   end
   local weld=handle:FindFirstChild("AccessoryWeld")
   if weld and weld:IsA("Weld") and (weld.Part0==self.head or weld.Part1==self.head) then hidden=true end
  end
  if position and not hidden then
   local relative=part.CFrame:PointToObjectSpace(position);local half=part.Size*.5+Vector3.new(.04,.04,.04)
   hidden=math.abs(relative.X)<half.X and math.abs(relative.Y)<half.Y and math.abs(relative.Z)<half.Z
  end
  part.LocalTransparencyModifier=if hidden then 1 else 0
 end
end
function Body:step(dt,state,speed,crouched,pitch,reduced)
 self.time+=dt;self.phase+=dt*speed*self.config.BobRate
 local alpha=1-math.exp(-self.config.BodyResponse*dt)
 for _,name in ipairs({"Sprinting","Sliding","Jumping","Falling","Landing","Crouching"})do
  local target=if name=="Crouching" then (if crouched then 1 else 0) else (if state==name then 1 else 0)
  self.weights[name]=(self.weights[name] or 0)+(target-(self.weights[name] or 0))*alpha
 end
 local w=self.weights;local c=self.config
 local motion=if reduced then 0 else 1
 local stride=math.sin(self.phase)*math.clamp(speed/c.WalkSpeed,0,1)*motion
 local breath=math.sin(self.time*1.8)*c.BodyBreath*motion
 for _,entry in ipairs(self.joints)do
  local j=entry.joint;if not j.Parent then continue end
  local x,y,z,dy=0,0,0,0
  if entry.kind=="shoulder" then
   if self.firstPerson then
    x=(if self.r6 then 1.5 else c.ArmReady)
      +stride*entry.side*(c.ArmSwing+w.Sprinting*c.SprintArmSwing)+breath+w.Jumping*.12-w.Landing*.12
    y=entry.side*c.ArmInward;z=-entry.side*(c.ArmBank+w.Sliding*.08)
   else x=stride*entry.side*.035*motion end
  elseif entry.kind=="elbow" and self.firstPerson then
   x=c.ElbowReady+w.Sprinting*.15-w.Sliding*.3+breath
  elseif entry.kind=="hip" then
   x=w.Crouching*c.CrouchHip+w.Sliding*(if entry.side<0 then .12 else -.08)+w.Jumping*.15
  elseif entry.kind=="knee" then
   x=w.Crouching*c.CrouchKnee-w.Sliding*(if entry.side<0 then .12 else -.08)-w.Jumping*.15
  elseif entry.kind=="ankle" then
   x=w.Crouching*c.CrouchAnkle
  elseif entry.kind=="torso" then
   x=-w.Sprinting*c.BodyLean-w.Crouching*.1-w.Sliding*.15+w.Landing*.04
   z=stride*.012*motion;dy=breath
  end
  local canonical=CFrame.new(0,dy,0)*CFrame.Angles(x,y,z)
  local offset=entry.rotation:Inverse()*canonical*entry.rotation
  local base=j.Transform
  -- Keep the actual avatar; only the local ready arms replace broad third-person arm swings.
  if self.firstPerson and (entry.kind=="shoulder" or entry.kind=="elbow") then
   entry.blend=(entry.blend or CFrame.identity):Lerp(offset,alpha)
   offset=entry.blend;base=CFrame.identity
  end
  entry.base=j.Transform;j.Transform=offset*base;entry.applied=j.Transform
 end
end
function Body:destroy()
 self.added:Disconnect();self:prepare()
 for part,value in pairs(self.parts)do if part.Parent then part.LocalTransparencyModifier=value end end
 self.parts={};self.joints={}
end
return Body
