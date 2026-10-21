assert(not game:GetService("RunService"):IsRunning(),"Use Edit mode")
local lobby=workspace.EnamJamLobby
local library=game.ServerStorage.EnvironmentAssets.Bushes1949
local existing=lobby.RealisticEnvironment:FindFirstChild("Bushes1949")
if existing then
 assert(#existing:GetChildren()==65,"Incomplete existing bush installation")
 return "Bushes1949 already installed; no duplicates created"
end
local variants={"SemakRimbun_01","SemakLiar_02","SemakRenggang_03"}
for _,name in ipairs(variants)do assert(library:FindFirstChild(name),"Missing bush variant "..name)end
local old={};local garden=lobby.Atmosphere1949.Garden
for _,p in ipairs(garden:GetChildren())do if p:IsA("BasePart")and p.Name=="Shrub"then table.insert(old,p)end end
assert(#old==65,"Expected 65 original garden shrubs")
table.sort(old,function(a,b)if a.Position.X==b.Position.X then return a.Position.Z<b.Position.Z end;return a.Position.X<b.Position.X end)
local review=game.ServerStorage:FindFirstChild("BushSourceReview")or Instance.new("Folder")
review.Name="BushSourceReview"
assert(not review:FindFirstChild("ReplacedShrubs1949"),"Original shrub archive already exists")
local placed=Instance.new("Folder");placed.Name="Bushes1949"
local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include
params.FilterDescendantsInstances={lobby.Atmosphere1949.Courtyard.PackedEarth}
local ok,message=pcall(function()
 for i,original in ipairs(old)do
  local hit=workspace:Raycast(Vector3.new(original.Position.X,10,original.Position.Z),Vector3.new(0,-20,0),params)
  assert(hit,"No courtyard ground at shrub "..i)
  local template=library[variants[(i-1)%#variants+1]]
  local bush=template:Clone();bush.Name=string.format("GardenBush%02d",i)
  bush:SetAttribute("BushVariant",template.Name);bush:SetAttribute("PlacementId",i)
  bush:SetAttribute("OriginalPosition",original.Position)
  local width=math.clamp(math.max(original.Size.X,original.Size.Z)*.9,2.3,4.4)
  bush:ScaleTo(width/template:GetAttribute("FootprintStuds"))
  bush:PivotTo(CFrame.new(hit.Position)*CFrame.Angles(0,i*2.3999632297,0))
  local low,high=math.huge,-math.huge
  local p=bush.Geometry.LeavesAndTwigs
  for _,x in ipairs({-1,1})do for _,y in ipairs({-1,1})do for _,z in ipairs({-1,1})do
   local q=p.CFrame:PointToWorldSpace(p.Size*Vector3.new(x,y,z)/2);low=math.min(low,q.X);high=math.max(high,q.X)
  end end end
  -- Leave space inside the masonry fence, including after rotation.
  local shift=if high>65.8 then 65.8-high elseif low< -65.8 then -65.8-low else 0
  if shift~=0 then bush:PivotTo(bush:GetPivot()+Vector3.new(shift,0,0))end
  bush.Parent=placed
  if i%16==0 then task.wait()end
 end
end)
if not ok then placed:Destroy();error(message)end
review.Parent=game.ServerStorage
local archive=Instance.new("Folder");archive.Name="ReplacedShrubs1949"
for _,p in ipairs(old)do p.Parent=archive end
archive.Parent=review;placed.Parent=lobby.RealisticEnvironment
return "65 leaf-mesh shrubs installed; original spheres archived"
