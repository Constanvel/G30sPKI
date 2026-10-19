--!strict
return function(player)
 local root = script.Parent.Parent
 assert(root:FindFirstChild("ChapterService"), "RED: ChapterService belum diimplementasikan")
 assert(root:FindFirstChild("InteractionService"), "RED: InteractionService belum diimplementasikan")
 local ChapterService = require(root.ChapterService)
 local InteractionService = require(root.InteractionService)
 local chapter = { id = "test", objectives = {{id="document"},{id="radio"},{id="briefing"}} }
 local service = ChapterService.new(chapter)
 assert(player and player.Character, "Pengujian memerlukan pemain nyata dalam Play mode")
 local scene = Instance.new("Model")
 scene.Name = "PrologTestScene"
 scene.Parent = workspace
 local character = player.Character
 local humanoid = character:FindFirstChildOfClass("Humanoid")
 local characterRoot = character:FindFirstChild("HumanoidRootPart")
 assert(humanoid and characterRoot,"Karakter pengujian belum siap")
 local originalCFrame, originalAnchored = characterRoot.CFrame, characterRoot.Anchored
 characterRoot.Anchored = true
 characterRoot.Position = Vector3.new(1000,100,1000)
 local part = Instance.new("Part")
 part.Anchored = true
 part.Position = Vector3.new(1004,100,1000)
 part:SetAttribute("InteractionId", "document")
 part.Parent = scene
 local prompt = Instance.new("ProximityPrompt")
 prompt.MaxActivationDistance = 8
 prompt.Parent = part
 local checks = 0
 local function check(condition, message)
  assert(condition, message)
  checks += 1
 end
 local ok, result = pcall(function()
  service:reset(player)
  local title = service:snapshot(player)
  check(title.phase == "title", "Reset harus membuka title card")
  check(not service:interact(player,"document"), "Interaksi saat title harus ditolak")
  check(not service:acknowledge(player,title.revision+1), "Revision salah harus ditolak")
  check(service:acknowledge(player,title.revision), "Title dapat dilanjutkan")
  check(not service:interact(player,"radio"), "Objektif kedua tidak boleh didahului")
  check(InteractionService.isAllowed(player,prompt,scene,"document"), "Interaksi dekat dan sah harus diterima")
  check(not InteractionService.isAllowed(player,prompt,scene,"radio"), "ID objek salah harus ditolak")
  prompt.Enabled = false
  check(not InteractionService.isAllowed(player,prompt,scene,"document"), "Prompt nonaktif harus ditolak")
  prompt.Enabled = true
  characterRoot.Position = Vector3.new(1020,100,1000)
  check(not InteractionService.isAllowed(player,prompt,scene,"document"), "Pemain jauh harus ditolak")
  characterRoot.Position = Vector3.new(1000,100,1000)
  local foreignScene = Instance.new("Model")
  check(not InteractionService.isAllowed(player,prompt,foreignScene,"document"), "Objek di luar scene aktif harus ditolak")
  foreignScene:Destroy()
  local blocker = Instance.new("Part")
  blocker.Size = Vector3.new(1,6,6)
  blocker.Position = Vector3.new(1002,100,1000)
  blocker.Anchored = true
  blocker.Parent = scene
  check(not InteractionService.isAllowed(player,prompt,scene,"document"), "Interaksi menembus tembok harus ditolak")
  blocker:Destroy()
  check(not InteractionService.isAllowed(player,"document",scene,"document"), "Payload bukan instance harus ditolak")
  check(service:interact(player,"document"), "Objektif pertama diterima")
  check(not service:interact(player,"document"), "Duplikasi tidak boleh menambah progres")
  local dialogue = service:snapshot(player)
  check(dialogue.phase == "dialogue" and dialogue.objectiveIndex == 1, "Narasi menahan objektif pertama")
  check(service:acknowledge(player,dialogue.revision), "Narasi dapat diselesaikan")
  check(not service:acknowledge(player,dialogue.revision), "Acknowledgement duplikat ditolak")
  for _,id in ipairs({"radio","briefing"}) do
   check(service:interact(player,id), "Urutan objektif sah ditolak")
   check(service:acknowledge(player,service:snapshot(player).revision), "Narasi objektif ditolak")
  end
  local closing = service:snapshot(player)
  check(closing.phase == "cinematic", "Tiga objektif harus menuju cutscene")
  check(not service:acknowledge(player,closing.revision), "Client tidak boleh menyelesaikan cutscene lewat continue")
  check(service:finishCinematic(player,closing.revision), "Server dapat menyelesaikan cutscene")
  check(service:snapshot(player).phase == "completed", "Penutup harus tercapai")
  local stale = service:snapshot(player).revision
  service:reset(player)
  check(not service:acknowledge(player,stale), "Callback sebelum reset harus ditolak")
  check(service:snapshot(player).objectiveIndex == 1, "Reset harus kembali ke awal chapter")
  service:fail(player,"Scene uji tidak lengkap")
  local failed=service:snapshot(player)
  check(failed.phase=="error" and failed.error=="Scene uji tidak lengkap","Kegagalan scene harus ditampilkan")
  check(not service:finishCinematic(player,failed.revision),"Kegagalan aset tidak boleh menyelesaikan chapter")
  check(not service:interact(player,"document"),"Interaksi saat error harus ditolak")
  service:reset(player)
  check(service:snapshot(player).phase=="title","Chapter dapat dimulai ulang setelah error")
  service:remove(player)
  check(service:snapshot(player) == nil, "Progres pemain keluar harus dibersihkan")
  humanoid.Health = 0
  check(not InteractionService.isAllowed(player,prompt,scene,"document"), "Karakter mati harus ditolak")
  return checks
 end)
 scene:Destroy()
 characterRoot.CFrame, characterRoot.Anchored = originalCFrame, originalAnchored
 assert(ok, tostring(result))
 return tostring(result) .. " assertions PASS"
end
