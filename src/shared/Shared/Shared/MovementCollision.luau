--!strict
local Collision={}
function Collision.capture(character,config)
 local h=character:FindFirstChildOfClass("Humanoid");local root=character:FindFirstChild("HumanoidRootPart")
 local head=character:FindFirstChild("Head")
 if not h or not root or not head then return nil end
 local profile={character=character,humanoid=h,root=root,head=head,config=config,
  hipHeight=h:GetAttribute("FPSStandingHipHeight") or h.HipHeight}
 local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Exclude;ray.FilterDescendantsInstances={character};ray.RespectCanCollide=true;ray.CollisionGroup=root.CollisionGroup
 local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.FilterDescendantsInstances={character};overlap.RespectCanCollide=true;overlap.CollisionGroup=root.CollisionGroup
 profile.ray=ray;profile.overlap=overlap
 return profile
end
function Collision.canStand(p)
 local delta=math.max(0,p.hipHeight-p.humanoid.HipHeight)
 if delta<.03 then return true end
 local top=p.head.Position.Y+p.head.Size.Y/2
 local width=math.max(p.root.Size.X,p.head.Size.X)*.9
 local depth=math.max(p.root.Size.Z,p.head.Size.Z)*.9
 local center=Vector3.new(p.root.Position.X,top+delta/2+.04,p.root.Position.Z)
 if #workspace:GetPartBoundsInBox(CFrame.new(center),Vector3.new(width,delta,depth),p.overlap)>0 then return false end
 return workspace:Blockcast(CFrame.new(p.root.Position.X,top-.03,p.root.Position.Z),Vector3.new(width,.08,depth),Vector3.new(0,delta+.08,0),p.ray)==nil
end
function Collision.ground(p)
 local leg=p.character:FindFirstChild("Left Leg")
 local distance=p.root.Size.Y/2+p.humanoid.HipHeight+(if leg then leg.Size.Y else 0)+1.2
 return workspace:Raycast(p.root.Position,Vector3.new(0,-math.max(2,distance),0),p.ray)
end
function Collision.blocked(p,direction,travel)
 if direction.Magnitude<.01 then return false end
 local hit=workspace:Blockcast(p.root.CFrame,p.root.Size*Vector3.new(.85,.7,.85),direction.Unit*(travel+p.config.SlideWallPadding),p.ray)
 return hit~=nil and hit.Normal.Y<p.config.SlideMinNormalY
end
function Collision.posture(p,crouched)
 p.humanoid.HipHeight=p.hipHeight-(if crouched then p.config.CrouchDrop else 0)
end
return Collision
