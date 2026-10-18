--!strict
local MenuEnvironment = {}

function MenuEnvironment.create()
 local scene=Instance.new("Model")
 scene.Name="MenuEnvironment"
 scene:SetAttribute("Location","Lubang Buaya")
 scene:SetAttribute("ArtisticReconstruction",true)
 local origin=Vector3.new(1000,128,0)
 local earth=Color3.fromRGB(82,88,65)
 local soil=Color3.fromRGB(91,85,62)
 local wood=Color3.fromRGB(75,64,47)
 local foliage=Color3.fromRGB(48,65,45)
 local warm=Color3.fromRGB(214,165,96)
 local function part(name,size,position,color,parent,className)
  local object=Instance.new(className or "Part")
  object.Name=name; object.Size=size; object.Position=origin+position
  object.Color=color; object.Material=Enum.Material.SmoothPlastic
  object.Anchored=true; object.CanCollide=false; object.CanTouch=false; object.CanQuery=false
  object.CastShadow=false; object.TopSurface=Enum.SurfaceType.Smooth; object.BottomSurface=Enum.SurfaceType.Smooth
  object.Parent=parent or scene
  return object
 end
 part("Ground",Vector3.new(240,1,440),Vector3.new(0,-0.6,-90),earth)
 local clearing=part("ClearingSoil",Vector3.new(0.16,47,43),Vector3.new(23,-0.1,-26),soil)
 clearing.Shape=Enum.PartType.Cylinder; clearing.CFrame*=CFrame.Angles(0,0,math.pi/2)
 for i,position in ipairs({Vector3.new(-38,-0.9,-30),Vector3.new(54,-0.8,-62),Vector3.new(-20,-0.5,-110),Vector3.new(34,-0.6,-145)}) do
  local bank=part("EarthBank",Vector3.new(34,2.2,44),position,earth,nil,"WedgePart")
  bank.CFrame*=CFrame.Angles(0,math.rad(i*39),0)
 end
 local route={Vector3.new(1,-0.06,55),Vector3.new(4,-0.06,15),Vector3.new(10,-0.06,-7),Vector3.new(16,-0.06,-31),Vector3.new(21,-0.06,-72)}
 for i=1,#route-1 do
  local a,b=route[i],route[i+1]
  local path=part("DirtPath",Vector3.new(9-i*0.8,0.12,(b-a).Magnitude+1),(a+b)/2,Color3.fromRGB(108,94,65))
  path.CFrame=CFrame.lookAt(origin+(a+b)/2,origin+b)
 end
 local function shelter(name,x,z,width,depth)
  local model=Instance.new("Model"); model.Name=name; model.Parent=scene
  part("Floor",Vector3.new(width,0.3,depth),Vector3.new(x,0.05,z),wood,model)
  part("RearWall",Vector3.new(width,5.6,0.3),Vector3.new(x,2.9,z-depth/2),Color3.fromRGB(84,80,62),model)
  for _,side in ipairs({-1,1}) do
   part("SideWall",Vector3.new(0.3,5.6,depth),Vector3.new(x+side*width/2,2.9,z),Color3.fromRGB(83,79,62),model)
   part("FrontWall",Vector3.new((width-3.5)/2,5.6,0.3),Vector3.new(x+side*(width+3.5)/4,2.9,z+depth/2),Color3.fromRGB(97,89,67),model)
   local roof=part("TileRoof",Vector3.new(width*0.58,0.45,depth+2),Vector3.new(x+side*width*0.24,6.8,z),Color3.fromRGB(67,51,36),model)
   roof.CFrame*=CFrame.Angles(0,0,math.rad(-side*25))
  end
  part("DoorLintel",Vector3.new(3.5,0.8,0.4),Vector3.new(x,5.3,z+depth/2),wood,model)
 end
 shelter("TimberHut",39,-36,15,12)
 shelter("FieldShelter",-24,-80,10,8)

 local zone=Instance.new("Model"); zone.Name="WellZone"; zone.Parent=scene
 zone:SetAttribute("ArtisticHint",true)
 local center=Vector3.new(22,0,-24)
 local dark=part("WellInterior",Vector3.new(0.08,3.15,3.15),center+Vector3.new(0,0.03,0),Color3.fromRGB(16,21,18),zone)
 dark.Shape=Enum.PartType.Cylinder; dark.CFrame*=CFrame.Angles(0,0,math.pi/2)
 for i=0,11 do
  local angle=i*math.pi/6
  local rim=part("LowMasonryRim",Vector3.new(0.55,0.65,1.05),center+Vector3.new(math.cos(angle)*1.9,0.35,math.sin(angle)*1.9),Color3.fromRGB(92,88,69),zone)
  rim.CFrame*=CFrame.Angles(0,-angle,0)
 end
 local function fence(a,b)
  local count=math.ceil((b-a).Magnitude/5)
  for i=0,count do part("FencePost",Vector3.new(0.23,2.3,0.23),a:Lerp(b,i/count)+Vector3.new(0,1.05,0),wood) end
  for _,y in ipairs({0.7,1.6}) do
   local rail=part("FenceRail",Vector3.new(0.15,0.18,(b-a).Magnitude),(a+b)/2+Vector3.new(0,y,0),wood)
   rail.CFrame=CFrame.lookAt(rail.Position,origin+b+Vector3.new(0,y,0))
  end
 end
 fence(Vector3.new(28,0,-13),Vector3.new(40,0,-13))
 fence(Vector3.new(40,0,-13),Vector3.new(40,0,-43))
 fence(Vector3.new(-25,0,-32),Vector3.new(-29,0,-61))

 for i,position in ipairs({Vector3.new(-24,0,-16),Vector3.new(-36,0,-53),Vector3.new(43,0,-60),Vector3.new(6,0,-109),Vector3.new(36,0,-100),Vector3.new(-15,0,-120),Vector3.new(48,0,-14)}) do
  part("TreeTrunk",Vector3.new(0.8,12,0.8),position+Vector3.new(0,5.7,0),wood)
  for layer=1,3 do
   local crown=part("TreeCrown",Vector3.new(9-layer,4.5,8-layer),position+Vector3.new((layer-2)*1.5,10+layer*1.6,0),foliage,nil,"WedgePart")
   crown.CFrame*=CFrame.Angles(0,math.rad(i*31+layer*70),math.rad((layer-2)*10))
  end
 end
 for _,position in ipairs({Vector3.new(30,0,12),Vector3.new(-18,0,-8),Vector3.new(47,0,-38)}) do
  for i=-1,1 do
   local stem=part("BambooStem",Vector3.new(0.18,11+i,0.18),position+Vector3.new(i*0.65,5.2,0),Color3.fromRGB(53,65,41))
   stem.CFrame*=CFrame.Angles(0,0,math.rad(i*4))
   for _,side in ipairs({-1,1}) do
    local leaf=part("BambooLeaf",Vector3.new(0.14,0.8,4.7),position+Vector3.new(i*0.7+side*0.8,8+i*0.6,side),foliage,nil,"WedgePart")
    leaf.CFrame*=CFrame.Angles(math.rad(side*19),math.rad(side*48+i*20),math.rad(side*16))
   end
  end
 end
 for i,position in ipairs({Vector3.new(-7,0,16),Vector3.new(13,0,6),Vector3.new(-9,0,-24),Vector3.new(31,0,-3),Vector3.new(9,0,-47),Vector3.new(28,0,-59)}) do
  for _,side in ipairs({-1,1}) do
   local grass=part("GrassClump",Vector3.new(0.15,1.4,1.2),position+Vector3.new(side*0.25,0.35,0),Color3.fromRGB(53,73,45),nil,"WedgePart")
   grass.CFrame*=CFrame.Angles(0,math.rad(i*47),math.rad(side*22))
  end
 end
 for _,position in ipairs({Vector3.new(14,3.4,-10),Vector3.new(33,3.8,-28)}) do
  part("LanternPost",Vector3.new(0.28,position.Y,0.28),Vector3.new(position.X,position.Y/2,position.Z),wood)
  for _,dy in ipairs({-0.45,0.45}) do part("LanternCap",Vector3.new(0.9,0.12,0.9),position+Vector3.new(0,dy,0),wood) end
  for _,dx in ipairs({-0.35,0.35}) do part("LanternFrame",Vector3.new(0.08,0.9,0.08),position+Vector3.new(dx,0,0),wood) end
  local glow=part("LanternGlow",Vector3.new(0.25,0.42,0.25),position,warm)
  glow.Material=Enum.Material.Neon
  local light=Instance.new("PointLight")
  light.Color=warm; light.Brightness=1.3; light.Range=24; light.Shadows=false; light.Parent=glow
 end
 local anchor=part("CameraAnchor",Vector3.one,Vector3.new(5,7.2,40),Color3.new())
 anchor.Transparency=1
 anchor.CFrame=CFrame.lookAt(origin+Vector3.new(5,7.2,40),origin+Vector3.new(10,2.3,-30))
 scene.Parent=workspace
 return scene
end

return MenuEnvironment
