--!strict
return function()
 local Environment=require(script.Parent.MenuEnvironment)
 local region=Region3.new(Vector3.new(880,112,-212),Vector3.new(1120,164,76)):ExpandToGrid(4)
 local materials,occupancy=workspace.Terrain:ReadVoxels(region,4)
 local scene=Environment.create();local checks=0
 local function check(value,message)assert(value,message);checks+=1 end
 local ok,message=pcall(function()
  check(scene:GetAttribute("Location")=="Yogyakarta, 1 Maret 1949","Yogyakarta 1949 identity")
  check(scene:GetAttribute("ArtisticReconstruction")==true,"Scene must be marked artistic")
  check(scene:GetAttribute("VisualRevision")=="YOGYAKARTA-REALISM-03","Sunrise scene revision")
  for _,name in ipairs({"Street","WestFrontages","EastFrontages","TuguPalPutih","StreetProps","Greenery","DistantCity","CameraAnchor"})do check(scene:FindFirstChild(name)~=nil,"Missing scene group "..name)end
  check(not scene:FindFirstChild("Fighters") and not scene:FindFirstChild("Fighter01",true),"Decorative people must be removed")
  check(#scene.WestFrontages:GetChildren()==6 and #scene.EastFrontages:GetChildren()==6,"Twelve modular frontages")
  check(scene:FindFirstChild("WoodenShutter",true) and scene:FindFirstChild("ShopSign",true) and scene:FindFirstChild("ClayRoof",true),"Layered historic shopfront details")
  check(scene:FindFirstChild("WindowGlass",true) and scene:FindFirstChild("LouverSlat",true) and scene:FindFirstChild("BalconyRail",true),"Varied open shutters and facade depth")
  check(scene:FindFirstChild("WornPlaster",true) and scene:FindFirstChild("RoadShoulder",true),"Surface wear and road edges")
  check(scene.Street.MainRoad.Size.Z>200 and scene.Street.MainRoad.Size.X>=30,"Strong road perspective")
  check(scene.TuguPalPutih:GetAttribute("StylizedLandmark")==true,"Tugu must not claim a precise historical replica")
  for _,name in ipairs({"Bicycle","MarketCart","TelegraphPole","OverheadWire","IndonesianFlag","DeliveryCrate"})do check(scene:FindFirstChild(name,true)~=nil,"Missing period prop "..name)end
  local parts,meshes,motions,unsafe,humanoids,scripts,particles,lights=0,0,0,0,0,0,0,0
  for _,v in ipairs(scene:GetDescendants())do
   assert(not v:GetAttribute("DecorativeFighter"),"No decorative actor remains")
   if v:IsA("BasePart")then
    parts+=1;if v:IsA("MeshPart")then meshes+=1 end
    if not v.Anchored or v.CanCollide or v.CanTouch or v.CanQuery then unsafe+=1 end
    if v:GetAttribute("MenuMotionPivot")then motions+=1;check(typeof(v:GetAttribute("MenuMotionOffset"))=="CFrame","Motion offset must be captured")end
   elseif v:IsA("Humanoid")then humanoids+=1 elseif v:IsA("LuaSourceContainer")then scripts+=1
   elseif v:IsA("ParticleEmitter")then particles+=1 elseif v:IsA("Light")then lights+=1 end
  end
  check(parts<=1900 and meshes<=24,"Static scene part/mesh budget")
  check(motions==30,"Bounded ambient animation")
  check(unsafe==0 and humanoids==0 and scripts==0,"Scene cannot participate in gameplay or run actors")
  check(particles==0 and lights==0,"Sunrise uses no emitters or local lights")
  check(scene.CameraAnchor.Transparency==1 and scene:GetAttribute("MenuFOV")==52,"Main camera contract")
  check(not scene:FindFirstChild("MeetingPost") and not scene:FindFirstChild("WellZone"),"Old composition removed")
 end)
 scene:Destroy()
 local afterM,afterO=workspace.Terrain:ReadVoxels(region,4);local same=true
 for x,column in ipairs(materials)do for y,row in ipairs(column)do for z,value in ipairs(row)do if value~=afterM[x][y][z] or occupancy[x][y][z]~=afterO[x][y][z]then same=false end end end end
 check(same,"Environment create/destroy must not alter terrain")
 assert(ok,message);return tostring(checks).." environment assertions PASS"
end
