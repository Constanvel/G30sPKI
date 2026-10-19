--!strict
return function()
 local Controller=require(script.Parent.MovementController)
 local cfg=require(game.ReplicatedStorage.Shared.MovementConfig)
 local checks=0
 local function check(ok,message) assert(ok,message);checks+=1 end
 local added,removing,received=Instance.new("BindableEvent"),Instance.new("BindableEvent"),Instance.new("BindableEvent")
 local rig=Instance.new("Model");rig.Name="FPSClientFixture"
 for _,entry in ipairs({{"HumanoidRootPart",Vector3.new(0,10000,0)},{"Head",Vector3.new(0,10002,0)}}) do
  local p=Instance.new("Part");p.Name=entry[1];p.Anchored=true;p.Position=entry[2];p.Parent=rig
 end
 local humanoid=Instance.new("Humanoid");humanoid.Parent=rig;rig.PrimaryPart=rig.HumanoidRootPart;rig.Parent=workspace
 local scripts=Instance.new("Folder")
 local attrs={}
 local fake={PlayerScripts=scripts,Character=rig,CharacterAdded=added.Event,CharacterRemoving=removing.Event,
  CameraMode=Enum.CameraMode.Classic,CameraMinZoomDistance=.5,CameraMaxZoomDistance=128,
  SetAttribute=function(_,k,v)attrs[k]=v end}
 local sent={}
 local remote={OnClientEvent=received.Event,FireServer=function(_,...)table.insert(sent,{...})end}
 local camera=workspace.CurrentCamera;local original={cf=camera.CFrame,fov=camera.FieldOfView,kind=camera.CameraType,subject=camera.CameraSubject}
 local mouse={behavior=game.UserInputService.MouseBehavior,sensitivity=game.UserInputService.MouseDeltaSensitivity,icon=game.UserInputService.MouseIconEnabled}
 local controller=Controller.new(fake,remote)
 local connectionCount=#controller.connections
 local ok,result=pcall(function()
  controller:setEnabled(true)
  check(controller.enabled and fake.CameraMode==Enum.CameraMode.LockFirstPerson,"FPS aktif dengan mode first person")
  local connection=controller.physicsConnection
  controller:setEnabled(true)
  check(controller.physicsConnection==connection,"Enable berulang tidak menggandakan loop")
  check(rig.Head.LocalTransparencyModifier==1,"Kepala lokal tersembunyi dari kamera FPS")
  controller:input("",Enum.UserInputState.Begin,{KeyCode=Enum.KeyCode.W})
  controller:input("",Enum.UserInputState.Begin,{KeyCode=Enum.KeyCode.D})
  controller:physics(1/60)
  check(math.abs(controller.inputVector.Magnitude-1)<.00001,"Diagonal dinormalisasi")
  controller:cameraStep(1/60)
  check(humanoid.MoveDirection.Magnitude>.99,"Driver mengirim gerak setelah callback input bawaan")
  local count=#sent
  controller:input("",Enum.UserInputState.Begin,{KeyCode=Enum.KeyCode.C})
  controller:input("",Enum.UserInputState.Begin,{KeyCode=Enum.KeyCode.LeftControl})
  check(#sent==count+1,"Dua tombol crouch bersamaan tidak men-toggle dua kali")
  controller:input("",Enum.UserInputState.End,{KeyCode=Enum.KeyCode.C})
  controller:input("",Enum.UserInputState.End,{KeyCode=Enum.KeyCode.LeftControl})
  count=#sent;controller:input("",Enum.UserInputState.Begin,{KeyCode=Enum.KeyCode.Space})
  controller:input("",Enum.UserInputState.Begin,{KeyCode=Enum.KeyCode.Space})
  check(#sent==count+1,"Space tertahan tidak mengantre lompat berulang")
  controller.mouseDelta=Vector2.new(100,10000);controller:cameraStep(1/60)
  check(controller.pitch==-cfg.MaxPitch and math.abs(controller.yaw+100*cfg.MouseRadiansPerPixel)<.00001,"Mouse segera mengubah arah dan pitch dibatasi")
  local yaw=controller.yaw;controller:cameraStep(1/60)
  check(controller.yaw==yaw,"Offset rotasi tidak menumpuk tanpa input")
  local fovs={}
  for _,hz in ipairs({30,60,120}) do
   camera.FieldOfView=cfg.WalkFOV;controller.machine.state="Sprinting"
   for _=1,hz do controller:cameraStep(1/hz) end
   fovs[hz]=camera.FieldOfView
  end
  check(math.abs(fovs[30]-fovs[120])<.0001,"Interpolasi FOV stabil pada 30/120Hz")
  controller.reduced=true;controller.machine.state="Sliding";controller:cameraStep(1)
  check(math.abs(camera.FieldOfView-cfg.WalkFOV)<.001 and math.abs(controller.roll)<.001,"Reduced motion meniadakan sway dan FOV sprint")
  controller:setSprint(true);controller:setSuspended(true)
  check(not controller.machine.sprint and next(controller.keys)==nil,"Focus loss membuang input tertahan")
  controller:physics(.016)
  check(humanoid.MoveDirection.Magnitude==0,"Suspend tidak mendorong karakter ke arah pandang")
  controller:setSuspended(false)
  controller:physics(.016)
  controller:cameraStep(.016)
  check(humanoid.MoveDirection.Magnitude==0,"Tanpa tombol gerak karakter tidak berjalan sendiri")
  controller:setMoveVector(Vector3.new(20,5,-20));controller:physics(.016)
  check(controller.inputVector.Y==0 and math.abs(controller.inputVector.Magnitude-1)<.001,"Interface platform lain membatasi input gerak")
  controller:setMoveVector(nil);check(controller.externalMove==nil,"Input eksternal bisa dikembalikan ke keyboard")
  controller:send("crouch");local actionSequence=controller.sequence
  controller:send("move",Vector3.new(0,0,-1));controller:send("move",Vector3.new(0,0,-1))
  local correction=controller.machine:snapshot();correction.speed=4
  controller:reconcile({character=rig,sequence=actionSequence,stateSnapshot=correction})
  check(controller.machine.speed==4,"Heartbeat arah tidak membuang koreksi aksi yang terlambat")
  local old=controller.machine.speed
  controller:reconcile({character=rig,sequence=actionSequence-1,stateSnapshot={speed=999}})
  check(controller.machine.speed==old,"Koreksi lama tidak menimpa prediksi baru")
  controller:setEnabled(false)
  check(not controller.enabled and controller.physicsConnection==nil,"Disable melepas physics loop")
  check(rig.Head.LocalTransparencyModifier==0 and fake.CameraMode==Enum.CameraMode.Classic,"Disable memulihkan transparansi dan mode kamera")
  check(camera.FieldOfView==original.fov and camera.CameraType==original.kind,"FOV dan pemilik kamera dipulihkan")
  check(game.UserInputService.MouseDeltaSensitivity==mouse.sensitivity and game.UserInputService.MouseIconEnabled==mouse.icon,"Pengaturan mouse dipulihkan")
  controller:setEnabled(true);removing:Fire();task.wait()
  check(not controller.enabled and controller.physicsConnection==nil,"CharacterRemoving melepas controller lama")
  added:Fire(rig);task.wait()
  check(controller.enabled and controller.physicsConnection~=nil,"CharacterAdded memasang ulang satu controller")
  controller:setEnabled(false)
  for _=1,10 do controller:setEnabled(true);controller:setEnabled(false) end
  check(controller.physicsConnection==nil and #controller.connections==connectionCount,"Siklus aktivasi tidak menambah koneksi")
  return tostring(checks).." client movement assertions PASS"
 end)
 controller:destroy();rig:Destroy();scripts:Destroy();added:Destroy();removing:Destroy();received:Destroy()
 camera.CFrame=original.cf;camera.FieldOfView=original.fov;camera.CameraType=original.kind;camera.CameraSubject=original.subject
 game.UserInputService.MouseBehavior=mouse.behavior;game.UserInputService.MouseIconEnabled=mouse.icon
 assert(ok,result)
 return result
end
