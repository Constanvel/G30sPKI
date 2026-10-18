--!strict
return function()
 local Environment=require(script.Parent.MenuEnvironment)
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
  check(scene:FindFirstChild("BambooStem",true)~=nil,"Vegetasi pembatas komposisi harus tersedia")
  local parts,lights,prompts,actors,unsafe,emitters=0,0,0,0,0,0
  for _,object in ipairs(scene:GetDescendants()) do
   if object:IsA("BasePart") then
    parts+=1
    if not object.Anchored or object.CanCollide or object.CanTouch or object.CanQuery then unsafe+=1 end
   elseif object:IsA("PointLight") then lights+=1; check(not object.Shadows,"Lampu menu tidak membutuhkan shadow")
   elseif object:IsA("ProximityPrompt") then prompts+=1
   elseif object:IsA("Humanoid") then actors+=1
   elseif object:IsA("ParticleEmitter") then emitters+=1 end
  end
  check(parts<=180,"Anggaran geometri menu terlampaui")
  check(lights<=2,"Jangan menambah banyak sumber cahaya")
  check(prompts==0 and actors==0,"Latar tidak boleh menjadi adegan interaktif/figur manusia")
  check(unsafe==0,"Latar dekoratif harus terisolasi dari collision/query gameplay")
  check(emitters==0,"Tidak perlu partikel untuk adegan ini")
  check(scene.CameraAnchor:IsA("BasePart") and scene.CameraAnchor.Transparency==1,"Marker kamera wajib valid dan tersembunyi")
  local baseplate=workspace:FindFirstChild("Baseplate")
  check(not baseplate or scene.Ground.Position.Y-scene.Ground.Size.Y/2>baseplate.Position.Y+baseplate.Size.Y/2,"Baseplate gameplay tidak boleh menutupi tanah latar")
 end)
 scene:Destroy()
 assert(ok,message)
 return tostring(count).." environment assertions PASS"
end
