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
 local plaster=Color3.fromRGB(119,120,105)
 local roof=Color3.fromRGB(71,48,39)
 local wood=Color3.fromRGB(38,39,34)
 local warm=Color3.fromRGB(205,161,99)
 part("Ground",Vector3.new(200,1,420),Vector3.new(0,-0.7,-85),Color3.fromRGB(26,36,31))
 part("Street",Vector3.new(19,0.2,380),Vector3.new(0,0,-75),Color3.fromRGB(53,59,59))
 for _,side in ipairs({-1,1}) do
  part("Gutter",Vector3.new(1.5,0.1,380),Vector3.new(side*10,0.1,-75),Color3.fromRGB(19,25,24))
  part("Footpath",Vector3.new(4,0.4,360),Vector3.new(side*12.5,0.2,-75),Color3.fromRGB(69,68,58))
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
 house(28,-38,Color3.fromRGB(106,115,106))
 house(-28,-20,Color3.fromRGB(126,120,104))
 house(-28,-67,Color3.fromRGB(96,107,101))
 for _,x in ipairs({-28,28}) do
  part("DistantHouse",Vector3.new(20,7,18),Vector3.new(x,3.8,-112),Color3.fromRGB(65,78,78))
  for _,side in ipairs({-1,1}) do
   local tile=part("DistantRoof",Vector3.new(12,0.7,21),Vector3.new(x+side*5.3,9.5,-112),Color3.fromRGB(55,49,46))
   tile.CFrame*=CFrame.Angles(0,0,math.rad(-side*23))
  end
 end
 part("PorchStep",Vector3.new(3,0.35,6),Vector3.new(16.6,0.45,2),Color3.fromRGB(90,91,80))
 part("TimberBenchSeat",Vector3.new(1.6,0.25,5),Vector3.new(16.7,1.5,7),wood)
 part("TimberBenchBack",Vector3.new(0.2,1.1,5),Vector3.new(17.3,2.05,7),wood)
 for _,z in ipairs({5.1,8.9}) do part("BenchLeg",Vector3.new(1.2,1.2,0.3),Vector3.new(16.7,0.85,z),wood) end
 for _,z in ipairs({-6,12}) do
  local pot=part("ClayPlanter",Vector3.new(1.6,1.5,1.5),Vector3.new(16.8,1.1,z),Color3.fromRGB(112,76,57))
  pot.Shape=Enum.PartType.Cylinder; pot.CFrame*=CFrame.Angles(0,0,math.pi/2)
  for i=-1,1 do
   local leaf=part("PlanterLeaf",Vector3.new(0.18,2,0.55),Vector3.new(16.8+i*0.35,2.25,z),Color3.fromRGB(45,70,48))
   leaf.CFrame*=CFrame.Angles(0,math.rad(i*40),math.rad(i*28))
  end
 end
 for _,z in ipairs({-4,-54}) do part("TimberUtilityPole",Vector3.new(0.35,13,0.35),Vector3.new(-14,6.7,z),wood) end
 local cablePoints={Vector3.new(-14,13.2,-4),Vector3.new(-14,12.3,-21),Vector3.new(-14,12.3,-37),Vector3.new(-14,13.2,-54)}
 for i=1,#cablePoints-1 do
  local a,b=cablePoints[i],cablePoints[i+1]
  local cable=part("OverheadCable",Vector3.new(0.06,0.06,(b-a).Magnitude),(a+b)/2,wood)
  cable.CFrame=CFrame.lookAt(origin+(a+b)/2,origin+b)
 end
 for _,z in ipairs({20,-25,-70}) do
  local side=if z==-25 then -1 else 1
  local x=side*13
  part("StreetLamp",Vector3.new(0.4,13,0.4),Vector3.new(x,6.7,z),wood)
  part("LampArm",Vector3.new(3.5,0.3,0.35),Vector3.new(x-side*1.5,13,z),wood)
  local bulb=part("WarmLamp",Vector3.new(1.2,0.25,0.8),Vector3.new(x-side*3,12.7,z),warm,Enum.Material.Neon)
  local light=Instance.new("PointLight")
  light.Color=warm; light.Brightness=1.1; light.Range=28; light.Shadows=false; light.Parent=bulb
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
