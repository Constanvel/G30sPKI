--!strict
return function()
 local InteractionService=require(script.Parent.Parent.InteractionService)
 assert(type(InteractionService.sceneError)=="function","RED: validasi kelengkapan scene belum tersedia")
 local chapter={objectives={{id="document"},{id="radio"},{id="briefing"}}}
 local scene=Instance.new("Model")
 local markers={}
 for _,name in ipairs({"SpawnMarker","CameraStart","CameraEnd"}) do
  local marker=Instance.new("Part");marker.Name=name;marker.Parent=scene;markers[name]=marker
 end
 for _,objective in ipairs(chapter.objectives) do
  local part=Instance.new("Part");part.Name=objective.id;part:SetAttribute("InteractionId",objective.id);part.Parent=scene
  local prompt=Instance.new("ProximityPrompt");prompt.Name="Interact";prompt.Parent=part
 end
 local checks=0
 local function check(condition,message) assert(condition,message);checks+=1 end
 local ok,result=pcall(function()
  check(InteractionService.sceneError(nil,chapter)~=nil,"Scene hilang harus ditolak")
  check(InteractionService.sceneError(scene,chapter)==nil,"Scene lengkap tidak boleh ditolak")
  for _,name in ipairs({"SpawnMarker","CameraStart","CameraEnd"}) do
   markers[name].Parent=nil
   check(InteractionService.sceneError(scene,chapter)~=nil,"Marker wajib hilang harus ditolak: "..name)
   local wrong=Instance.new("Folder");wrong.Name=name;wrong.Parent=scene
   check(InteractionService.sceneError(scene,chapter)~=nil,"Marker bukan BasePart harus ditolak")
   wrong:Destroy();markers[name].Parent=scene
  end
  for _,id in ipairs({"document","radio","briefing"}) do
   local target=scene:FindFirstChild(id);target.Parent=nil
   check(InteractionService.sceneError(scene,chapter)~=nil,"Objek wajib hilang harus ditolak: "..id)
   target.Parent=scene
  end
  local duplicate=scene.document:Clone();duplicate.Parent=scene
  check(InteractionService.sceneError(scene,chapter)~=nil,"ID interaksi ganda harus ditolak")
  duplicate:Destroy()
  return checks
 end)
 scene:Destroy()
 assert(ok,tostring(result))
 return tostring(result).." scene assertions PASS"
end
