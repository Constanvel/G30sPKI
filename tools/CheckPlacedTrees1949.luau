local lobby=workspace.EnamJamLobby
local trees=lobby.RealisticEnvironment.Trees1949
local checks=0;local function check(value,message)assert(value,message);checks+=1 end
check(#trees:GetChildren()==8,"Eight courtyard trees")
check(#game.ReplicatedStorage.EnvironmentAssets.Trees1949:GetChildren()==3,"All three templates replicate to menu")
local variants={};local meshes,colliders=0,0
local ground=lobby.Atmosphere1949.Courtyard.PackedEarth
local groundY=ground.Position.Y+ground.Size.Y/2
local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={trees,ground};params.RespectCanCollide=true
for _,tree in ipairs(trees:GetChildren())do
 local variant=tree:GetAttribute("TreeVariant");variants[variant]=(variants[variant]or 0)+1
 check(tree.ModelStreamingMode==Enum.ModelStreamingMode.Atomic,"Whole tree streams together")
 check(math.abs(tree:GetPivot().Y-groundY)<.01,"Tree pivot rests on courtyard surface")
 local minY=math.huge
 for _,p in ipairs(tree.Geometry:GetChildren())do
  for _,x in ipairs({-1,1})do for _,y in ipairs({-1,1})do for _,z in ipairs({-1,1})do
   minY=math.min(minY,p.CFrame:PointToWorldSpace(p.Size*Vector3.new(x,y,z)/2).Y)
  end end end
 end
 check(math.abs(minY-groundY)<.02,"Tree visual bounds touch courtyard ground")
 check(#workspace:GetPartsInPart(tree.Collision.TrunkCollider,params)==0,"Trunk does not overlap walls, buildings, or props")
 local count=0
 for _,p in ipairs(tree:GetDescendants())do
  check(not p:IsA("LuaSourceContainer"),"No runtime script in placed tree")
  if p:IsA("BasePart")then
   check(p.Anchored and not p.CanTouch,"Static placed tree")
   if p:IsA("MeshPart")then
    meshes+=1;check(not p.CanCollide and not p.CanQuery,"Foliage never blocks navigation or queries")
   elseif p.CanCollide then count+=1;colliders+=1 end
  end
 end
 check(count==1,"Only trunk collider is physical")
end
for _,name in ipairs({"TropisRindang_01","TropisRamping_02","TropisRenggang_03"})do check(variants[name]~=nil,"All tree variants present")end
check(not lobby.Atmosphere1949.Garden:FindFirstChild("TreeTrunk") and not lobby.Atmosphere1949.Garden:FindFirstChild("Canopy"),"Old nearby tree parts archived")
local bushes=lobby.RealisticEnvironment:FindFirstChild("Bushes1949")
check((lobby.Atmosphere1949.Garden:FindFirstChild("Shrub")~=nil or (bushes and #bushes:GetChildren()==65))and lobby.Atmosphere1949.Garden:FindFirstChild("ClayPlanter")~=nil,"Garden shrubs or replacement bushes and planters retained")
return game.HttpService:JSONEncode({result="PASS",assertions=checks,trees=8,visualMeshes=meshes,colliders=colliders,variants=variants})
