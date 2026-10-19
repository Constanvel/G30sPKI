--!strict
return function()
 local Movement=require(script.Parent.Parent.MovementService)
 local Config=require(game.ReplicatedStorage.Shared.MovementConfig)
 local phase="exploring"
 local service=Movement.new(function() return phase=="exploring" end)
 -- A separate anchored fixture avoids changing the live player's character or runtime remote.
 local rig=Instance.new("Model");rig.Name="MovementValidationFixture"
 local root=Instance.new("Part");root.Name="HumanoidRootPart";root.Anchored=true;root.CFrame=CFrame.new(0,10000,0);root.Parent=rig
 local head=Instance.new("Part");head.Name="Head";head.Anchored=true;head.CFrame=root.CFrame*CFrame.new(0,2,0);head.Parent=rig
 local humanoid=Instance.new("Humanoid");humanoid.HipHeight=2;humanoid.Parent=rig
 rig.PrimaryPart=root;rig.Parent=workspace
 local player={Character=rig}
 local checks=0
 local function check(condition,message) assert(condition,message);checks+=1 end
 local ok,result=pcall(function()
  local originalSpeed,originalHeight=humanoid.WalkSpeed,humanoid.HipHeight
  check(service:bindCharacter(player,rig),"Fixture dapat diikat")
  check(humanoid.WalkSpeed==0 and humanoid.JumpHeight==0,"Karakter terkunci sebelum exploring")
  check(not service:handleRequest(player,"sprint",1,rig,true),"Input saat terkunci ditolak")
  service:setEnabled(player,true)
  check(service:handleRequest(player,"sprint",2,rig,true),"Sprint sah diterima")
  local record=service.records[player]
  check(not record.machine.sprint,"Perintah menunggu langkah simulasi")
  service:step(Config.ServerInterval)
  check(record.machine.sprint,"Langkah simulasi menerapkan sprint")
  check(not service:handleRequest(player,"sprint",2,rig,false),"Sequence duplikat ditolak")
  check(not service:handleRequest(player,"sprint",1,rig,false),"Sequence lama ditolak")
  check(not service:handleRequest(player,"jump",0/0,rig),"NaN ditolak")
  check(not service:handleRequest(player,"jump",math.huge,rig),"Infinity ditolak")
  check(not service:handleRequest(player,"jump",2.5,rig),"Sequence pecahan ditolak")
  check(not service:handleRequest(player,"speed",3,rig),"Aksi kecepatan client ditolak")
  check(not service:handleRequest(player,"sprint",3,rig,"true"),"Sprint memerlukan boolean")
  check(not service:handleRequest(player,"crouch",3,rig,"true"),"Crouch menolak payload bukan boolean")
  local obsolete=Instance.new("Model")
  check(not service:handleRequest(player,"jump",3,obsolete),"Karakter lama ditolak")
  check(record.sequence==2,"Karakter lama tidak meracuni sequence karakter aktif")
  player.Character=obsolete
  check(not service:handleRequest(player,"jump",4,rig),"Binding karakter yang sudah diganti ditolak")
  player.Character=rig;obsolete:Destroy()
  phase="dialogue"
  check(not service:handleRequest(player,"jump",5,rig),"Dialogue menolak aksi FPS")
  phase="error"
  service:setEnabled(player,true);service:step(Config.ServerInterval)
  check(not service:handleRequest(player,"crouch",6,rig),"Error menolak aksi FPS")
  check(humanoid.WalkSpeed==originalSpeed,"Error mempertahankan gerak dasar lama")
  phase="exploring";record.tokens=Config.InputBurst;record.tokenTime=os.clock()
  for sequence=7,6+Config.InputBurst do
   check(service:handleRequest(player,"release",sequence,rig),"Burst sah diterima")
  end
  record.tokens=0;record.tokenTime=os.clock()
  check(not service:handleRequest(player,"jump",30,rig),"Token bucket menolak banjir input")
  record.tokens=0;record.tokenTime=os.clock()-1
  check(service:handleRequest(player,"release",31,rig),"Token pulih dengan waktu")
  humanoid.Health=0
  check(not service:handleRequest(player,"jump",32,rig),"Karakter mati ditolak")
  humanoid.Health=100
  record.tokens=Config.InputBurst;record.tokenTime=os.clock()
  check(not service:handleRequest(player,"move",33,rig,Vector3.new(2,0,0)),"Input gerak melebihi satu ditolak")
  check(not service:handleRequest(player,"move",33,rig,Vector3.new(0,1,0)),"Input vertikal client ditolak")
  check(not service:handleRequest(player,"move",33,rig,Vector3.new(0/0,0,0)),"Input gerak NaN ditolak")
  check(service:handleRequest(player,"move",33,rig,Vector3.new(0,0,-1)),"Input arah sah diterima")
  service:step(Config.ServerInterval)
  check(record.machine.speed>0,"Server mulai bergerak dari input tanpa deadlock kecepatan nol")
  check(service:handleRequest(player,"move",34,rig,Vector3.zero),"Pelepasan gerak diterima")
  record.tokens=0;record.tokenTime=os.clock()
  check(service:handleRequest(player,"move",35,rig,Vector3.zero),"Stop tetap diterima saat token habis")
  service:step(.3)
  check(record.machine.speed==0,"Tanpa input server berhenti walau ada kecepatan lama")
  local target=CFrame.new(1000,10000,-1000)
  check(service:teleport(player,target),"Teleport server diterima")
  service:_validate(record,Config.ValidationInterval)
  check((root.Position-target.Position).Magnitude<.01,"Teleport server memperbarui baseline")
  root.CFrame+=Vector3.new(1000,0,0)
  service:_validate(record,Config.ValidationInterval)
  check((root.Position-target.Position).Magnitude<.01,"Lompatan posisi tak sah dikembalikan")
  local corrected=false
  for _=1,10 do
   local attempted=root.Position+Vector3.new(4.5,0,0);root.CFrame=CFrame.new(attempted)
   service:_validate(record,Config.ValidationInterval)
   if (root.Position-attempted).Magnitude>.1 then corrected=true;break end
  end
  check(corrected,"Slack posisi tidak dapat dipakai ulang untuk melaju terlalu cepat terus-menerus")
  check(record.travelBudget==0,"Rollback tidak memberikan slack gratis")
  record.machine.crouched=true;record.machine.wantsCrouch=true;record.stance=true
  require(game.ReplicatedStorage.Shared.MovementCollision).posture(record.profile,true,true)
  service:remove(player)
  check(humanoid.WalkSpeed==originalSpeed and humanoid.HipHeight==originalHeight,"Remove memulihkan kecepatan dan postur")
  check(rig:GetAttribute("FPSEnabled")==nil,"Remove membersihkan atribut FPS")
  return tostring(checks).." assertions PASS"
 end)
 local remote=service.remote
 service:destroy();rig:Destroy()
 assert(remote.Parent~=nil,"Destroy service tidak boleh menghapus remote global")
 assert(ok,result)
 return result
end
