--!strict
local MenuEnvironment = {}

function MenuEnvironment.create()
 local scene = Instance.new("Model")
 scene.Name = "MenuEnvironment"
 scene:SetAttribute("ArtisticReconstruction",true)
 local origin = Vector3.new(1000,0,0)
 local function part(name,size,position,color,material)
  local p=Instance.new("Part")
  p.Name=name; p.Size=size; p.Position=origin+position
  p.Anchored=true; p.CanCollide=false; p.CanTouch=false
  p.CanQuery=false; p.CastShadow=false; p.Material=material or Enum.Material.SmoothPlastic
  p.Color=color; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
  p.Parent=scene; return p
 end
 local plaster=Color3.fromRGB(104,105,91)
 local roof=Color3.fromRGB(71,48,39)
 local wood=Color3.fromRGB(38,39,34)
 local warm=Color3.fromRGB(225,162,78)
 part("Ground",Vector3.new(180,1,250),Vector3.new(0,-0.7,-35),Color3.fromRGB(26,36,31))
 part("Street",Vector3.new(19,0.2,240),Vector3.new(0,0,-35),Color3.fromRGB(38,42,40))
 for _,side in ipairs({-1,1}) do
  part("Gutter",Vector3.new(1.5,0.1,240),Vector3.new(side*10,0.1,-35),Color3.fromRGB(19,25,24))
  part("Footpath",Vector3.new(4,0.4,220),Vector3.new(side*12.5,0.2,-35),Color3.fromRGB(69,68,58))
 end
 local function house(x,z,shade)
  part("PlasterHouse",Vector3.new(20,9,20),Vector3.new(x,4.8,z),shade)
  for _,sign in ipairs({-1,1}) do
   local tile=part("TileRoof",Vector3.new(12.5,0.8,24),Vector3.new(x+sign*5.5,11.3,z),roof)
   tile.CFrame*=CFrame.Angles(0,0,math.rad(-sign*23))
  end
  part("RoofRidge",Vector3.new(0.8,0.8,24),Vector3.new(x,13.6,z),roof)
  local face=x-math.sign(x)*10.1
  part("WoodDoor",Vector3.new(0.2,6.5,3.2),Vector3.new(face,3.5,z),wood)
  for _,dz in ipairs({-6,6}) do
   part("WindowFrame",Vector3.new(0.35,4,4.2),Vector3.new(face,5.3,z+dz),wood)
   part("WindowLight",Vector3.new(0.38,3.2,3.4),Vector3.new(face,5.3,z+dz),warm,Enum.Material.Neon)
   part("WindowCross",Vector3.new(0.4,3.4,0.18),Vector3.new(face,5.3,z+dz),wood)
   part("WindowCross",Vector3.new(0.4,0.18,3.5),Vector3.new(face,5.3,z+dz),wood)
  end
  local fenceX=x-math.sign(x)*13
  for dz=-13,13,2.6 do part("FencePicket",Vector3.new(0.35,2.8,0.7),Vector3.new(fenceX,1.7,z+dz),wood) end
  part("FenceRail",Vector3.new(0.4,0.3,28),Vector3.new(fenceX,2.2,z),wood)
 end
 house(28,2,plaster)
 house(28,-38,Color3.fromRGB(93,100,90))
 house(-28,-20,Color3.fromRGB(114,108,90))
 house(-28,-67,Color3.fromRGB(82,91,82))
 for _,z in ipairs({20,-25,-70}) do
  local side=if z==-25 then -1 else 1
  local x=side*13
  part("StreetLamp",Vector3.new(0.4,13,0.4),Vector3.new(x,6.7,z),wood)
  part("LampArm",Vector3.new(3.5,0.3,0.35),Vector3.new(x-side*1.5,13,z),wood)
  local bulb=part("WarmLamp",Vector3.new(1.2,0.25,0.8),Vector3.new(x-side*3,12.7,z),warm,Enum.Material.Neon)
  local light=Instance.new("PointLight")
  light.Color=warm; light.Brightness=1.4; light.Range=24; light.Shadows=false; light.Parent=bulb
 end
 for _,position in ipairs({Vector3.new(18,0,30),Vector3.new(-19,0,-42),Vector3.new(22,0,-82)}) do
  part("TreeTrunk",Vector3.new(1.4,14,1.4),position+Vector3.new(0,7,0),wood)
  for i=1,3 do
   local leaf=part("AngularCanopy",Vector3.new(11,5,10),position+Vector3.new((i-2)*3,13+i*1.8,0),Color3.fromRGB(24+i*3,39+i*2,31))
   leaf.CFrame*=CFrame.Angles(0,math.rad(i*24),math.rad(i*8))
  end
 end
 local anchor=part("CameraAnchor",Vector3.one,Vector3.new(5,6.7,42),Color3.new())
 anchor.Transparency=1
 anchor.CFrame=CFrame.lookAt(origin+Vector3.new(5,6.7,42),origin+Vector3.new(5,5,-38))
 scene.Parent=workspace
 return scene
end

return MenuEnvironment
