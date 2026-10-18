--!strict
return function()
 local Environment=require(script.Parent.MenuEnvironment)
 local region=Region3.new(Vector3.new(880,112,-172),Vector3.new(1120,164,76)):ExpandToGrid(4)
 local materials,occupancy=workspace.Terrain:ReadVoxels(region,4)
 local scene=Environment.create()
 local count=0
 local function check(value,message) assert(value,message); count+=1 end
 local ok,message=pcall(function()
  check(scene:GetAttribute("Location")=="Lubang Buaya","RED: latar belum menyebut Lubang Buaya")
  check(scene:GetAttribute("ArtisticReconstruction")==true,"Latar harus ditandai rekonstruksi artistik")
  check(not scene:FindFirstChild("Street") and not scene:FindFirstChild("Footpath"),"Jalan suburban lama tidak boleh tersisa")
  check(not scene:FindFirstChild("PlasterHouse",true),"Deretan rumah lama tidak boleh tersisa")
  check(scene:FindFirstChild("DirtPath")~=nil,"Jalur tanah harus tersedia")
  check(scene:FindFirstChild("WellZone")~=nil,"Petunjuk zona penting harus tersedia")
  check(scene:FindFirstChild("TimberHut")~=nil,"Bangunan sederhana harus tersedia")
  check(scene:FindFirstChild("BroadleafTree",true)~=nil,"Pohon bertekstur harus tersedia")
  check(scene:GetAttribute("VisualRevision")=="BARA-mesh-01","Latar harus memakai revisi mesh BARA")
  local parts,lights,prompts,actors,unsafe,emitters,meshes=0,0,0,0,0,0,0
  for _,object in ipairs(scene:GetDescendants()) do
   if object:IsA("BasePart") then
    parts+=1
    if object:IsA("MeshPart") then meshes+=1; check(object.MeshId~="" and object.TextureID~="","Mesh harus memiliki geometri dan tekstur") end
    if not object.Anchored or object.CanCollide or object.CanTouch or object.CanQuery then unsafe+=1 end
   elseif object:IsA("PointLight") then lights+=1; check(not object.Shadows,"Lampu menu tidak membutuhkan shadow")
   elseif object:IsA("ProximityPrompt") then prompts+=1
   elseif object:IsA("Humanoid") then actors+=1
   elseif object:IsA("ParticleEmitter") then emitters+=1 end
  end
  check(parts<=300 and meshes>=60 and meshes<=100,"Anggaran mesh bertekstur menu terlampaui/tidak lengkap")
  check(lights<=2,"Jangan menambah banyak sumber cahaya")
  check(prompts==0 and actors==0,"Latar tidak boleh menjadi adegan interaktif/figur manusia")
  check(unsafe==0,"Latar dekoratif harus terisolasi dari collision/query gameplay")
  check(emitters==0,"Tidak perlu partikel untuk adegan ini")
  check(scene.Ground.Material==Enum.Material.Ground,"Tanah wajib memakai material bertekstur")
  task.wait(.25)
  local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include;params.FilterDescendantsInstances={workspace.Terrain}
  local hit=workspace:Raycast(Vector3.new(1018,160,-13),Vector3.new(0,-60,0),params)
  check(hit and math.abs(hit.Position.Y-128)<.5,"Terrain tidak boleh mengubur sumur atau fondasi bangunan")
  check(scene.CameraAnchor:IsA("BasePart") and scene.CameraAnchor.Transparency==1,"Marker kamera wajib valid dan tersembunyi")
  local baseplate=workspace:FindFirstChild("Baseplate")
  check(not baseplate or scene.Ground.Position.Y-scene.Ground.Size.Y/2>baseplate.Position.Y+baseplate.Size.Y/2,"Baseplate gameplay tidak boleh menutupi tanah latar")
 end)
 scene:Destroy()
 task.wait()
 local restoredMaterials,restoredOccupancy=workspace.Terrain:ReadVoxels(region,4)
 local restored=true
 for x,column in ipairs(materials) do
  for y,row in ipairs(column) do for z,value in ipairs(row) do
   if value~=restoredMaterials[x][y][z] or occupancy[x][y][z]~=restoredOccupancy[x][y][z] then restored=false end
  end end
 end
 check(restored,"Region Terrain harus dipulihkan persis setelah scene dihancurkan")
 assert(ok,message)
 return tostring(count).." environment assertions PASS"
end
