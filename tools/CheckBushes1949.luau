local library=game.ServerStorage.EnvironmentAssets.Bushes1949
local lobby=workspace.EnamJamLobby
local placed=lobby.RealisticEnvironment.Bushes1949
local checks=0;local function check(value,message)assert(value,message);checks+=1 end
local function bounds(part)
 local low=Vector3.new(math.huge,math.huge,math.huge);local high=-low
 for _,x in ipairs({-1,1})do for _,y in ipairs({-1,1})do for _,z in ipairs({-1,1})do
  local q=part.CFrame:PointToWorldSpace(part.Size*Vector3.new(x,y,z)/2);low=low:Min(q);high=high:Max(q)
 end end end
 return low,high
end
check(#library:GetChildren()==3,"Three bush prefabs")
for _,bush in ipairs(library:GetChildren())do
 check(bush.PrimaryPart==bush.Pivot and bush:GetPivot()==CFrame.identity and bush:GetScale()==1,"Canonical ground pivot")
 local low,high=bounds(bush.Geometry.LeavesAndTwigs)
 check(math.abs(low.Y)<.01 and math.abs(high.Y-bush:GetAttribute("HeightStuds"))<.01,"Prefab grounded at declared height")
 check(math.abs(math.max(high.X-low.X,high.Z-low.Z)-4)<.01,"Canonical footprint")
 for _,scale in ipairs({.75,1,1.25})do
  local copy=bush:Clone();copy:ScaleTo(scale);copy:PivotTo(CFrame.new(3500,5,0)*CFrame.Angles(0,.83,0))
  local a,b=bounds(copy.Geometry.LeavesAndTwigs)
  check(math.abs(a.Y-5)<.01 and math.abs(b.Y-a.Y-bush:GetAttribute("HeightStuds")*scale)<.01,"Rotated/scaled bush stays grounded")
  copy:Destroy()
 end
end
check(#placed:GetChildren()==65,"65 replacement shrubs")
local archive=game.ServerStorage.BushSourceReview.ReplacedShrubs1949
check(#archive:GetChildren()==65,"65 original spheres archived")
check(not lobby.Atmosphere1949.Garden:FindFirstChild("Shrub"),"No spherical shrub remains")
local planters,leaves=0,0
for _,p in ipairs(lobby.Atmosphere1949.Garden:GetChildren())do if p.Name=="ClayPlanter"then planters+=1 elseif p.Name=="PlanterLeaf"then leaves+=1 end end
check(planters==6 and leaves==30,"Pot plants unchanged")
local ground=lobby.Atmosphere1949.Courtyard.PackedEarth
local y=ground.Position.Y+ground.Size.Y/2
local variants={};local meshes=0
for _,bush in ipairs(placed:GetChildren())do
 local variant=bush:GetAttribute("BushVariant");variants[variant]=(variants[variant]or 0)+1
 check(bush.ModelStreamingMode==Enum.ModelStreamingMode.Atomic and bush.PrimaryPart==bush.Pivot,"Complete bush streams with ground pivot")
 local p=bush.Geometry.LeavesAndTwigs;local a,b=bounds(p)
 check(math.abs(a.Y-y)<.02 and math.abs(bush:GetPivot().Y-y)<.01,"Placed bush grounded")
 check(a.X>= -65.81 and b.X<=65.81,"Leaves stay inside fence")
 local original=bush:GetAttribute("OriginalPosition")
 check(math.abs(bush:GetPivot().Z-original.Z)<.001 and math.abs(bush:GetPivot().X-original.X)<1.3,"Original planting area retained")
 local found=false;for _,old in ipairs(archive:GetChildren())do if (old.Position-original).Magnitude<.001 then found=true;break end end
 check(found,"Original position traceable to archive")
 local count=0
 for _,v in ipairs(bush:GetDescendants())do
  check(not v:IsA("LuaSourceContainer"),"No executable asset content")
  if v:IsA("BasePart")then check(v.Anchored and not v.CanCollide and not v.CanTouch and not v.CanQuery,"Decorative bush never blocks players or shots")end
  if v:IsA("MeshPart")then
   count+=1;meshes+=1
   local s=v:FindFirstChildOfClass("SurfaceAppearance")
   check(v.DoubleSided and s and s.AlphaMode==Enum.AlphaMode.Transparency and s.ColorMap~="","Double-sided alpha leaves")
   check(v.RenderFidelity==Enum.RenderFidelity.Automatic,"Automatic render fidelity")
  end
 end
 check(count==1,"One visual mesh per shrub")
end
for _,name in ipairs({"SemakRimbun_01","SemakLiar_02","SemakRenggang_03"})do check(variants[name]~=nil,"Each bush variant is present")end
return game.HttpService:JSONEncode({result="PASS",assertions=checks,placed=65,visualMeshes=meshes,variants=variants,archived=65})
