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
 scene:SetAttribute("Location","Yogyakarta, 1 Maret 1949"); scene:SetAttribute("ArtisticReconstruction",true)
 scene:SetAttribute("FictionalMeetingPlace",true); scene:SetAttribute("VisualRevision","ENAM-JAM-YOGYA-01")
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
 local function frontage(label,position,height,yaw,color)
  local house=fitted("Cottage",label,position,height,yaw)
  local scale=height/12
  local frame=CFrame.new(origin+position)*CFrame.Angles(0,math.rad(yaw),0)
  local function detail(name,size,offset,tint,material)
   local object=part(name,size*scale,Vector3.zero,tint,material,house)
   object.CFrame=frame*CFrame.new(offset*scale)
   return object
  end
  local wood=Color3.fromRGB(67,57,42)
  local shutter=Color3.fromRGB(63,79,70)
  detail("StonePlinth",Vector3.new(17.5,.5,17.5),Vector3.new(0,.15,0),Color3.fromRGB(113,110,99),Enum.Material.Cobblestone)
  detail("PlasterFacade",Vector3.new(14.2,6.6,.3),Vector3.new(0,4.5,-4.03),color,Enum.Material.Plaster)
  detail("FacadeBase",Vector3.new(14.4,1.2,.4),Vector3.new(0,.8,-4.1),Color3.fromRGB(103,103,91),Enum.Material.Brick)
  detail("WoodenDoor",Vector3.new(2.6,5.3,.15),Vector3.new(0,3.15,-4.25),wood,Enum.Material.Wood)
  detail("DoorLintel",Vector3.new(3.15,.24,.35),Vector3.new(0,5.9,-4.3),wood,Enum.Material.Wood)
  for _,x in ipairs({-6.7,6.7}) do
   detail("PlasterPilaster",Vector3.new(.32,7.5,.4),Vector3.new(x,4.2,-4.27),color,Enum.Material.Plaster)
  end
  for _,x in ipairs({-4.6,4.6}) do
   for _,side in ipairs({-1,1}) do detail("WoodenShutter",Vector3.new(1.55,3.1,.18),Vector3.new(x+side*.8,4.6,-4.3),shutter,Enum.Material.Wood) end
   for row=0,2 do detail("ShutterRail",Vector3.new(3.2,.12,.12),Vector3.new(x,3.6+row, -4.43),wood,Enum.Material.Wood) end
   detail("WindowSill",Vector3.new(3.6,.18,.45),Vector3.new(x,2.95,-4.32),Color3.fromRGB(149,145,126),Enum.Material.Concrete)
  end
  return house,frame,scale
 end
 local ground=Color3.fromRGB(105,101,83)
 local soil=Color3.fromRGB(106,94,72)
 local groundMarker=part("Ground",Vector3.new(250,3,310),Vector3.new(0,-1.6,-75),ground,Enum.Material.Ground)
 groundMarker.Transparency=1
 -- Hidden markers keep the scene contract; the visible street uses blended Terrain.
 local path=part("DirtPath",Vector3.one,Vector3.new(8,-2,0),soil,Enum.Material.Ground)
 path.Transparency=1
 -- A fictional kampung street, not a replica of a historical meeting place or map.
 local meeting,meetingFrame,meetingScale=frontage("MeetingPost",Vector3.new(27,0,-16),13,90,Color3.fromRGB(181,173,145))
 meeting:SetAttribute("FictionalMeetingPlace",true)
 frontage("StreetHouse",Vector3.new(29,0,-50),12,90,Color3.fromRGB(164,169,150))
 frontage("StreetHouse",Vector3.new(31,0,-85),11.5,90,Color3.fromRGB(185,172,149))
 frontage("StreetHouse",Vector3.new(-17,0,-24),12,-90,Color3.fromRGB(165,161,138))
 frontage("StreetHouse",Vector3.new(-15,0,-57),11.5,-90,Color3.fromRGB(185,177,153))
 frontage("StreetHouse",Vector3.new(9,0,-122),12,180,Color3.fromRGB(172,172,151))
 fitted("TimberHut","DeliveryShed",Vector3.new(-13,0,-88),10.5,-90)
 for _,entry in ipairs({{16,-11,1.7},{17.7,-12,1.2},{16.6,-14,1.5},{21,-31,1.4},{22.5,-31.4,1.1},{-7,-51,1.5},{-7,-54,1.1},{20,-76,1.4}}) do
  fitted("Crate","DeliveryCrate",Vector3.new(entry[1],0,entry[2]),entry[3],18)
 end
 for i=0,3 do fitted("Fence","CourtyardFence",Vector3.new(18+i*2.5,0,-2),2.2,0) end
 for _,entry in ipairs({{14,4},{15.5,-37},{17,-69},{18,-102},{-6.5,-9},{-5,-43},{-3.5,-75},{-2,-106}}) do
  part("LowStreetWall",Vector3.new(.55,1.6,12),Vector3.new(entry[1],.8,entry[2]),Color3.fromRGB(128,122,105),Enum.Material.Brick)
 end
 local function meetingProp(name,size,position,color,material)
  local object=part(name,size*meetingScale,Vector3.zero,color,material,meeting)
  object.CFrame=meetingFrame*CFrame.new(position*meetingScale)
  return object
 end
 local wood=Color3.fromRGB(82,57,36)
 meetingProp("DispatchTable",Vector3.new(3.3,.22,1.7),Vector3.new(-4,2.1,-7.2),wood,Enum.Material.Wood)
 for _,x in ipairs({-5.35,-2.65}) do for _,z in ipairs({-7.8,-6.6}) do
  meetingProp("TableLeg",Vector3.new(.18,2,.18),Vector3.new(x,1,z),wood,Enum.Material.Wood)
 end end
 local radio=Instance.new("Model"); radio.Name="WoodenRadio"; radio.Parent=meeting
 local function radioPart(name,size,position,color,material)
  local object=meetingProp(name,size,position,color,material); object.Parent=radio
  return object
 end
 radioPart("RadioCabinet",Vector3.new(2.5,1.45,.9),Vector3.new(-4,2.94,-7.2),wood,Enum.Material.Wood)
 radioPart("RadioSpeaker",Vector3.new(1.2,1.1,.04),Vector3.new(-4.5,2.94,-7.68),Color3.fromRGB(34,34,30),Enum.Material.Fabric)
 radioPart("TuningDial",Vector3.new(.75,.3,.04),Vector3.new(-3.35,3.2,-7.68),Color3.fromRGB(168,154,107),Enum.Material.SmoothPlastic)
 for _,x in ipairs({-3.6,-3.1}) do radioPart("RadioKnob",Vector3.new(.18,.18,.1),Vector3.new(x,2.64,-7.72),Color3.fromRGB(37,34,27),Enum.Material.Metal) end
 for row=0,2 do radioPart("SpeakerSlat",Vector3.new(1.2,.07,.06),Vector3.new(-4.5,2.6+row*.32,-7.72),wood,Enum.Material.Wood) end
 local sign=meetingProp("MeetingSign",Vector3.new(6,.85,.18),Vector3.new(0,6.9,-4.4),wood,Enum.Material.Wood)
 local surface=Instance.new("SurfaceGui"); surface.Name="PeriodSign"; surface.Face=Enum.NormalId.Front; surface.CanvasSize=Vector2.new(480,68); surface.Parent=sign
 local text=Instance.new("TextLabel"); text.Size=UDim2.fromScale(1,1); text.BackgroundTransparency=1; text.Font=Enum.Font.Antique
 text.Text="POS PERTEMUAN"; text.TextSize=42; text.TextColor3=Color3.fromRGB(213,202,164); text.Parent=surface
 for i,e in ipairs({{-34,-105,20},{-16,-136,22},{14,-148,21},{37,-132,22},{50,-96,20},{47,-54,19}}) do
  fitted("Tree","BroadleafTree",Vector3.new(e[1],-.2,e[2]),e[3],i*43)
 end
 for _,p in ipairs({Vector3.new(14,0,-9),Vector3.new(8,0,-55)}) do
  local lamp=fitted("Lantern","OilLantern",p,5.5,0)
  local glow=lamp:FindFirstChild("NyalaLampu",true)
  assert(glow,"Lentera BARA kehilangan nyala")
  local light=Instance.new("PointLight");light.Color=Color3.fromRGB(255,207,143)
  light.Brightness=1.65;light.Range=22;light.Shadows=false;light.Parent=glow
 end
 local anchor=part("CameraAnchor",Vector3.one,Vector3.new(1,6.4,25),Color3.new(),Enum.Material.SmoothPlastic)
 anchor.Transparency=1;anchor.CastShadow=false
 anchor.CFrame=CFrame.lookAt(origin+Vector3.new(1,6.4,25),origin+Vector3.new(9,5,-34))
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
    -- Terrain interpolates its surface half a voxel above the occupancy transition.
    local height=origin.Y-2+math.noise(px*.035,pz*.035)*.16
    local roadDistance=math.abs(px-(3+(30-pz)*.045))
    local distantGrass=math.abs(px)>40 and pz< -75
    occupancy[x][y][z]=math.clamp((height-py)/4,0,1)
    materials[x][y][z]=if occupancy[x][y][z]==0 then Enum.Material.Air elseif roadDistance<6.8 then Enum.Material.Ground elseif roadDistance<10 then Enum.Material.Cobblestone elseif distantGrass then Enum.Material.Grass else Enum.Material.Ground
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
