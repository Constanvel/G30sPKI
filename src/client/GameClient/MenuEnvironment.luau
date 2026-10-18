--!strict
local AssetService=game:GetService("AssetService")
local assets=require(script.Parent.MenuAssetData)
local MenuEnvironment={}
local templates={}
local origin=Vector3.new(1000,128,0)

local function decorate(object)
 object.Anchored=true; object.CanCollide=false; object.CanTouch=false; object.CanQuery=false
 object.CastShadow=true
end

local function template(name)
 if templates[name] then return templates[name] end
 local model=Instance.new("Model"); model.Name=name
 local ok,message=pcall(function()
  for _,row in ipairs(assets[name].parts) do
   local object
   if row.mesh then
    object=AssetService:CreateMeshPartAsync(Content.fromUri(row.mesh),{CollisionFidelity=Enum.CollisionFidelity.Box,RenderFidelity=Enum.RenderFidelity.Automatic})
    object.TextureID=row.texture; object.DoubleSided=row.doubleSided
   else object=Instance.new("Part") end
   object.Name=row.name; object.Size=Vector3.new(unpack(row.size)); object.CFrame=CFrame.new(unpack(row.cf))
   object.Color=Color3.new(unpack(row.color)); object.Material=Enum.Material[row.material]
   object.Transparency=row.transparency; decorate(object)
   if row.surface then
    local surface=Instance.new("SurfaceAppearance")
    for key,value in pairs(row.surface) do surface[key]=if key=="AlphaMode" then Enum.AlphaMode[value] else value end
    surface.Parent=object
   end
   object.Parent=model
  end
 end)
 if not ok then model:Destroy(); error("Menu asset "..name..": "..tostring(message)) end
 model.WorldPivot=CFrame.identity
 templates[name]=model
 return model
end

function MenuEnvironment.create()
 -- Load reusable geometry before parenting a scene; failed assets leave no partial world.
 local pending,failures=6,{}
 for _,name in ipairs({"Tree","Cottage","TimberHut","Fence","Lantern","Crate"}) do
  task.spawn(function()
   local ok,message=pcall(template,name)
   if not ok then table.insert(failures,tostring(message)) end
   pending-=1
  end)
 end
 while pending>0 do task.wait() end
 assert(#failures==0,table.concat(failures,"; "))
 local scene=Instance.new("Model"); scene.Name="MenuEnvironment"
 scene:SetAttribute("Location","Lubang Buaya"); scene:SetAttribute("ArtisticReconstruction",true)
 scene:SetAttribute("VisualRevision","BARA-mesh-01")
 local function part(name,size,position,color,material,parent)
  local p=Instance.new("Part"); p.Name=name; p.Size=size; p.Position=origin+position
  p.Color=color; p.Material=material; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
  decorate(p); p.Parent=parent or scene
  return p
 end
 local function fitted(name,label,position,height,yaw)
  local m=templates[name]:Clone(); m.Name=label
  local scale=height/assets[name].size[2]
  m:ScaleTo(scale); m:PivotTo(CFrame.new(origin+position+Vector3.new(0,height/2,0))*CFrame.Angles(0,math.rad(yaw or 0),0))
  m.Parent=scene
  return m
 end
 local ground=Color3.fromRGB(74,78,54)
 local soil=Color3.fromRGB(106,94,72)
 local groundMarker=part("Ground",Vector3.new(250,3,310),Vector3.new(0,-1.6,-75),ground,Enum.Material.Ground)
 groundMarker.Transparency=1
 -- A hidden marker keeps the scene contract; the visible path is blended Terrain.
 local path=part("DirtPath",Vector3.one,Vector3.new(8,-2,0),soil,Enum.Material.Ground)
 path.Transparency=1
 local random=Random.new(1965)
 fitted("Cottage","TimberHut",Vector3.new(30,0,-28),12,188)
 fitted("TimberHut","FieldShelter",Vector3.new(-25,0,-64),10.2,-12)
 fitted("Crate","TimberCrate",Vector3.new(23,0,-18),1.4,18)
 fitted("Crate","TimberCrate",Vector3.new(24.6,0,-18.4),1.1,-8)
 for i=0,3 do fitted("Fence","TimberFence",Vector3.new(34+i*3.2,0,-13),2.5,0) end
 for i=0,3 do fitted("Fence","TimberFence",Vector3.new(46.5,0,-16-i*3.2),2.5,90) end

 local zone=Instance.new("Model"); zone.Name="WellZone"; zone.Parent=scene; zone:SetAttribute("ArtisticHint",true)
 local center=Vector3.new(18,0,-13)
 local inside=part("WellInterior",Vector3.new(.1,3.5,3.5),center+Vector3.new(0,-.02,0),Color3.fromRGB(12,15,14),Enum.Material.Slate,zone)
 inside.Shape=Enum.PartType.Cylinder; inside.CFrame*=CFrame.Angles(0,0,math.pi/2)
 for row=0,1 do for i=0,23 do
  local a=(i+row*.5)*math.pi/12
  local rim=part("MasonryRim",Vector3.new(.4,.33,.5),center+Vector3.new(math.cos(a)*1.9,.16+row*.33,math.sin(a)*1.9),Color3.fromRGB(106+i%3*4,101+i%3*3,87),Enum.Material.Brick,zone)
  rim.CFrame*=CFrame.Angles(0,-a,0)
 end end

 for i,e in ipairs({{-22,-13,26},{-36,-39,30},{49,-6,28},{52,-43,32},{-5,-55,25},{13,-65,28},{35,-63,27},{-38,-83,28},{-12,-92,30},{18,-99,32},{47,-101,29},{69,-77,32},{-55,-5,27},{65,20,28}}) do
  fitted("Tree","BroadleafTree",Vector3.new(e[1],-.2,e[2]),e[3],i*43)
 end
 for i=1,38 do
  local z=random:NextNumber(-55,30)
  local side=if i%2==0 then 1 else -1
  local x=8+side*random:NextNumber(7,25)
  local rock=part("ScatteredStone",Vector3.new(random:NextNumber(.25,.7),random:NextNumber(.12,.35),random:NextNumber(.3,.85)),Vector3.new(x,.01,z),Color3.fromRGB(99,99,83),Enum.Material.Slate)
  rock.Shape=Enum.PartType.Ball;rock.CFrame*=CFrame.Angles(0,random:NextNumber(0,math.pi),.1)
 end
 for _,p in ipairs({Vector3.new(13,0,-2),Vector3.new(34,0,-19)}) do
  local lamp=fitted("Lantern","OilLantern",p,5.5,0)
  local glow=lamp:FindFirstChild("NyalaLampu",true)
  assert(glow,"Lentera BARA kehilangan nyala")
  local light=Instance.new("PointLight");light.Color=Color3.fromRGB(255,207,143)
  light.Brightness=1.65;light.Range=22;light.Shadows=false;light.Parent=glow
 end
 local anchor=part("CameraAnchor",Vector3.one,Vector3.new(2,6.6,27),Color3.new(),Enum.Material.SmoothPlastic)
 anchor.Transparency=1;anchor.CastShadow=false
 anchor.CFrame=CFrame.lookAt(origin+Vector3.new(2,6.6,27),origin+Vector3.new(11,5.4,-27))
 local terrain=workspace.Terrain
 local region=Region3.new(origin+Vector3.new(-120,-16,-172),origin+Vector3.new(120,36,76)):ExpandToGrid(4)
 local oldMaterials,oldOccupancy=terrain:ReadVoxels(region,4)
 local materials,occupancy={},{}
 local minimum=region.CFrame.Position-region.Size/2
 for x=1,region.Size.X/4 do
  materials[x]={};occupancy[x]={}
  for y=1,region.Size.Y/4 do
   materials[x][y]={};occupancy[x][y]={}
   for z=1,region.Size.Z/4 do
    local px=minimum.X+(x-.5)*4-origin.X
    local pz=minimum.Z+(z-.5)*4-origin.Z
    local py=minimum.Y+(y-1)*4
    local side=math.max(math.abs(px)-48,0)
    local back=math.max(-pz-66,0)
    -- Terrain interpolates its surface half a voxel above the occupancy transition.
    local height=origin.Y-2+math.noise(px*.035,pz*.035)*.7+math.min(26,side*side*.009+back*back*.003)
    local roadX=6+math.sin((37-pz)/2.15*.075)*9
    local clearing=((px-25)/25)^2+((pz+24)/25)^2<1
    local distantGrass=pz< -48 and math.noise(px*.12,pz*.12)>.12
    occupancy[x][y][z]=math.clamp((height-py)/4,0,1)
    materials[x][y][z]=if occupancy[x][y][z]==0 then Enum.Material.Air elseif math.abs(px-roadX)<5 or clearing then Enum.Material.Ground elseif distantGrass then Enum.Material.Grass else Enum.Material.LeafyGrass
   end
  end
  if x%10==0 then task.wait() end
 end
 -- The isolated client region is restored exactly when the decorative scene is destroyed.
 scene.Destroying:Connect(function() terrain:WriteVoxels(region,4,oldMaterials,oldOccupancy) end)
 local ok,message=pcall(function() terrain:WriteVoxels(region,4,materials,occupancy) end)
 if not ok then scene:Destroy();error(message) end
 scene.Parent=workspace
 return scene
end

return MenuEnvironment
