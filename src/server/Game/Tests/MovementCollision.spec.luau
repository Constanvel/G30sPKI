--!strict
return function()
 local Collision=require(game.ReplicatedStorage.Shared.MovementCollision)
 local Config=require(game.ReplicatedStorage.Shared.MovementConfig)
 local container=Instance.new("Folder");container.Name="FPSCollisionFixture";container.Parent=workspace
 local checks=0
 local function check(ok,message)assert(ok,message);checks+=1 end
 local function part(name,size,cf,parent)
  local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.Parent=parent;return p
 end
 local ok,result=pcall(function()
  for index,kind in ipairs({Enum.HumanoidRigType.R6,Enum.HumanoidRigType.R15}) do
   local rig=game.Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"),kind)
   rig.Name=kind.Name;rig.Parent=container
   for _,p in ipairs(rig:GetDescendants())do if p:IsA("BasePart")then p.Anchored=true end end
   rig:PivotTo(CFrame.new(index*100,10000,0))
   local profile=Collision.capture(rig,Config);assert(profile)
   local hip=profile.humanoid.HipHeight
   Collision.posture(profile,true,true);rig:PivotTo(rig:GetPivot()-Vector3.new(0,Config.CrouchDrop,0))
   check(math.abs(profile.humanoid.HipHeight-(hip-Config.CrouchDrop))<.001,kind.Name.." collider height lowered")
   check(Collision.canStand(profile),kind.Name.." clear overhead permits stand")
   local top=profile.head.Position.Y+profile.head.Size.Y/2
   local roof=part("Ceiling",Vector3.new(8,.2,8),CFrame.new(profile.root.Position.X,top+.35,profile.root.Position.Z),container)
   check(not Collision.canStand(profile),kind.Name.." ceiling prevents stand")
   roof.CanCollide=false
   check(Collision.canStand(profile),kind.Name.." noncollidable decoration ignored")
   roof:Destroy()
   local wall=part("Wall",Vector3.new(8,8,.5),profile.root.CFrame*CFrame.new(0,0,-3),container)
   check(Collision.blocked(profile,profile.root.CFrame.LookVector,4),kind.Name.." wall blocks slide sweep")
   wall:Destroy()
   local floor=part("Slope",Vector3.new(20,.3,20),CFrame.new(profile.root.Position-Vector3.new(0,profile.root.Size.Y/2+profile.humanoid.HipHeight+.3,0))*CFrame.Angles(math.rad(20),0,0),container)
   local ground=Collision.ground(profile)
   check(ground~=nil and ground.Normal.Y>Config.SlideMinNormalY and ground.Normal.Y<.99,kind.Name.." slope normal detected")
   floor:Destroy();Collision.posture(profile,false,true)
   check(profile.humanoid.HipHeight==hip,kind.Name.." standing restores height")
   rig:Destroy()
  end
  return tostring(checks).." native collision assertions PASS"
 end)
 container:Destroy();assert(ok,result);return result
end
