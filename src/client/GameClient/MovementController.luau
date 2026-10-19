--!strict
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local GuiService=game:GetService("GuiService")
local shared=game.ReplicatedStorage:WaitForChild("Shared")
local Config=require(shared.MovementConfig)
local State=require(shared.MovementState)
local Collision=require(shared.MovementCollision)
local Body=require(script.Parent.FirstPersonBody)
local Movement={}
Movement.__index=Movement
local serial=0
function Movement.new(player,remote)
 serial+=1
 local self=setmetatable({player=player,remote=remote,sequence=0,enabled=false,connections={},keys={},name="FPSMovement"..serial,
  generation=0,reduced=false,alt=false,suspended=false,focused=true},Movement)
 local playerModule=player.PlayerScripts:FindFirstChild("PlayerModule")
 if playerModule then local ok,controls=pcall(function()return require(playerModule):GetControls()end);if ok then self.controls=controls end end
 table.insert(self.connections,remote.OnClientEvent:Connect(function(snapshot) self:reconcile(snapshot) end))
 table.insert(self.connections,UIS.InputChanged:Connect(function(input)
  if self.enabled and not self.suspended and not self.alt and input.UserInputType==Enum.UserInputType.MouseMovement then
   self.mouseDelta+=Vector2.new(input.Delta.X,input.Delta.Y)
  end
 end))
 table.insert(self.connections,player.CharacterAdded:Connect(function(character)
  if self.desired then
   local desired=self.desired
   self:setEnabled(false)
   self.desired=desired
   local generation=self.generation
   task.spawn(function()
    character:WaitForChild("HumanoidRootPart",10)
    if self.generation==generation and self.desired and player.Character==character then self:setEnabled(true) end
   end)
  end
 end))
 table.insert(self.connections,player.CharacterRemoving:Connect(function() if self.enabled then local desired=self.desired;self:setEnabled(false);self.desired=desired end end))
 table.insert(self.connections,UIS.WindowFocusReleased:Connect(function() self.focused=false;self:setSuspended(true) end))
 table.insert(self.connections,UIS.WindowFocused:Connect(function() self.focused=true;self:setSuspended(GuiService.MenuIsOpen or UIS:GetFocusedTextBox()~=nil) end))
 table.insert(self.connections,GuiService.MenuOpened:Connect(function()self:setSuspended(true)end))
 table.insert(self.connections,GuiService.MenuClosed:Connect(function()self:setSuspended(not self.focused or UIS:GetFocusedTextBox()~=nil)end))
 table.insert(self.connections,UIS.TextBoxFocused:Connect(function()self:setSuspended(true)end))
 table.insert(self.connections,UIS.TextBoxFocusReleased:Connect(function()self:setSuspended(not self.focused or GuiService.MenuIsOpen)end))
 return self
end
function Movement:send(action,down)
 if not self.profile then return end
 self.sequence+=1
 if action~="move" then self.stateSequence=self.sequence end
 self.remote:FireServer(action,self.sequence,self.profile.character,down)
end
function Movement:setSprint(down)
 if not self.enabled or self.suspended then return end
 self.machine:command("sprint",down);self:send("sprint",down)
end
function Movement:toggleCrouch()
 if not self.enabled or self.suspended then return end
 self.machine:command("crouch");self:send("crouch")
end
function Movement:jump()
 if not self.enabled or self.suspended then return end
 self.machine:command("jump");self:send("jump")
end
function Movement:setSuspended(value)
 self.suspended=value
 if not self.enabled then return end
 if value then
  self.keys={};self.alt=false;self.machine:command("release");self:send("release")
  self.driveDirection=Vector3.zero;self.jumpRequested=false;self.externalMove=nil
  self.profile.humanoid:Move(Vector3.zero,false)
  self.mouseDelta=Vector2.zero
 end
 self.player:SetAttribute("LocalMovementPaused",value)
end
function Movement:setMoveVector(direction)
 if direction==nil then self.externalMove=nil;return end
 if typeof(direction)~="Vector3" then return end
 if direction.X~=direction.X or direction.Z~=direction.Z or math.abs(direction.X)==math.huge or math.abs(direction.Z)==math.huge then return end
 local flat=Vector3.new(direction.X,0,direction.Z)
 self.externalMove=if flat.Magnitude>1 then flat.Unit else flat
end
function Movement:input(_,state,input)
 if not self.enabled then return Enum.ContextActionResult.Pass end
 local key=input.KeyCode
 if state==Enum.UserInputState.End or state==Enum.UserInputState.Cancel then
  self.keys[key]=nil
  if key==Enum.KeyCode.LeftShift then self:setSprint(false) end
  if key==Enum.KeyCode.LeftAlt then self.alt=false end
  return Enum.ContextActionResult.Sink
 end
 if state~=Enum.UserInputState.Begin or self.suspended or UIS:GetFocusedTextBox() or GuiService.MenuIsOpen then return Enum.ContextActionResult.Pass end
 if self.keys[key] then return Enum.ContextActionResult.Sink end
 local crouchHeld=self.keys[Enum.KeyCode.C] or self.keys[Enum.KeyCode.LeftControl]
 self.keys[key]=true
 if key==Enum.KeyCode.LeftShift then self:setSprint(true)
 elseif key==Enum.KeyCode.C or key==Enum.KeyCode.LeftControl then if not crouchHeld then self:toggleCrouch() end
 elseif key==Enum.KeyCode.Space then self:jump()
 elseif key==Enum.KeyCode.LeftAlt then self.alt=true end
 return Enum.ContextActionResult.Sink
end
function Movement:reconcile(snapshot)
 if not self.enabled or typeof(snapshot)~="table" or snapshot.character~=self.profile.character
  or typeof(snapshot.sequence)~="number" or snapshot.sequence<(self.stateSequence or 0)
  or snapshot.sequence<(self.acknowledged or 0) or typeof(snapshot.stateSnapshot)~="table" then return end
 if typeof(snapshot.serverTime)=="number" and snapshot.serverTime<(self.snapshotTime or 0) then return end
 self.acknowledged=snapshot.sequence;self.snapshotTime=snapshot.serverTime
 local state=table.clone(snapshot.stateSnapshot)
 local age=if typeof(snapshot.serverTime)=="number" then math.clamp(workspace:GetServerTimeNow()-snapshot.serverTime,0,Config.ValidationMaxGap) else 0
 for _,key in ipairs({"slideLeft","cooldown","landLeft","jumpCooldown"}) do
  if typeof(state[key])=="number" then state[key]=math.max(0,state[key]-age) end
 end
 self.machine:correct(state)
 if typeof(snapshot.slideDirection)=="Vector3" then self.slideDirection=snapshot.slideDirection end
end
function Movement:physics(dt)
 local p=self.profile
 if not self.enabled or not p or p.humanoid.Health<=0 or not p.root.Parent then return end
 local input=self.externalMove or Vector3.new((if self.keys[Enum.KeyCode.D] then 1 else 0)-(if self.keys[Enum.KeyCode.A] then 1 else 0),0,
  (if self.keys[Enum.KeyCode.S] then 1 else 0)-(if self.keys[Enum.KeyCode.W] then 1 else 0))
 if self.suspended then input=Vector3.zero end
 if input.Magnitude>1 then input=input.Unit end
 self.inputVector=input
 self.moveClock=(self.moveClock or 0)+dt
 if input~=self.sentMove or (input.Magnitude>0 and self.moveClock>=Config.CorrectionInterval) then
  self:send("move",input);self.sentMove=input;self.moveClock=0
 end
 local velocity=p.root.AssemblyLinearVelocity
 local horizontal=Vector3.new(velocity.X,0,velocity.Z)
 local direction=CFrame.Angles(0,self.yaw,0):VectorToWorldSpace(input)
 local slideDir=self.slideDirection or (if direction.Magnitude>.01 then direction else Vector3.new(p.root.CFrame.LookVector.X,0,p.root.CFrame.LookVector.Z))
 local ground=Collision.ground(p)
 local grounded=p.humanoid.FloorMaterial~=Enum.Material.Air and velocity.Y<3
 local blocked=Collision.blocked(p,slideDir,math.max(self.machine.speed,Config.SlideStartSpeed)*dt)
 local jump,started=self.machine:step(dt,{moving=input.Magnitude>.05,forward=input.Z<-.1,grounded=grounded,
  actualSpeed=horizontal.Magnitude,verticalSpeed=velocity.Y,canStand=Collision.canStand(p),blocked=blocked,
  slideAllowed=not ground or ground.Normal.Y>=Config.SlideMinNormalY})
 if started then self.slideDirection=Vector3.new(direction.X,0,direction.Z).Unit end
 if self.posture~=self.machine.crouched then
  self.posture=self.machine.crouched;Collision.posture(p,self.posture,false);self.heightTransition=Config.CrouchTransition*2
 end
 p.humanoid.WalkSpeed=self.machine.speed
 if self.machine.state=="Sliding" then
  local move=self.slideDirection or direction
  if ground then move=move-ground.Normal*move:Dot(ground.Normal);if move.Magnitude>.01 then move=move.Unit end end
  self.driveDirection=move
  p.root.AssemblyLinearVelocity=Vector3.new(move.X*self.machine.speed,velocity.Y,move.Z*self.machine.speed)
  p.humanoid.AutoRotate=false
 else
  self.driveDirection=direction
  local facing=CFrame.Angles(0,self.yaw,0)
  if p.root.CFrame.LookVector:Dot(facing.LookVector)<.99999 then
   p.root.CFrame=CFrame.new(p.root.Position)*facing
   p.root.AssemblyLinearVelocity=velocity
  end
 end
 p.humanoid.AutoRotate=false
 if jump then self.jumpRequested=true end
 self.player:SetAttribute("LocalMovementState",self.machine.state)
 self.body:step(dt,self.machine.state,self.machine.speed,self.machine.crouched,self.pitch,self.reduced)
 for player,body in pairs(self.peerBodies)do
  if player.Character~=body.character or not body.character.Parent or not body.character:GetAttribute("FPSEnabled") then body:destroy();self.peerBodies[player]=nil end
 end
 for _,player in ipairs(Players:GetPlayers())do
  local character=player.Character
  if player~=self.player and character and character:GetAttribute("FPSEnabled") and character:FindFirstChild("HumanoidRootPart") then
   local body=self.peerBodies[player]
   if not body then body=Body.new(character,Config,false);self.peerBodies[player]=body end
   local v=character.HumanoidRootPart.AssemblyLinearVelocity
   body:step(dt,character:GetAttribute("FPSMovementState") or "Idle",Vector3.new(v.X,0,v.Z).Magnitude,character:GetAttribute("FPSCrouched")==true,0,false)
  end
 end
end
function Movement:cameraStep(dt)
 if not self.enabled or not self.profile or not self.profile.head.Parent then return end
 -- Apply after Roblox's input callback, which can otherwise clear Humanoid movement.
 self.profile.humanoid.WalkSpeed=self.machine.speed
 self.profile.humanoid:Move(if self.suspended then Vector3.zero else self.driveDirection or Vector3.zero,false)
 if self.jumpRequested then self.profile.humanoid.Jump=true;self.jumpRequested=false end
 local camera=workspace.CurrentCamera;if not camera then return end
 if camera~=self.camera then self.camera=camera;self.cameraFOV=camera.FieldOfView end
 self.yaw-=self.mouseDelta.X*Config.MouseRadiansPerPixel*Config.MouseSensitivity
 self.pitch=math.clamp(self.pitch-self.mouseDelta.Y*Config.MouseRadiansPerPixel*Config.MouseSensitivity,-Config.MaxPitch,Config.MaxPitch)
 self.mouseDelta=Vector2.zero
 camera.CameraType=Enum.CameraType.Scriptable
 local c=Config;local machine=self.machine;local alpha=1-math.exp(-c.CameraResponse*dt)
 local targetFOV=if self.reduced then c.WalkFOV elseif machine.state=="Sliding" then c.SlideFOV elseif machine.state=="Sprinting" then c.SprintFOV else c.WalkFOV
 camera.FieldOfView+=(targetFOV-camera.FieldOfView)*(1-math.exp(-c.FOVResponse*dt))
 local moving=machine.state=="Walking" or machine.state=="Sprinting"
 self.bobPhase+=dt*machine.speed*c.BobRate
 local amplitude=if self.reduced or not moving then 0 elseif machine.state=="Sprinting" then c.SprintBob else c.WalkBob
 self.bob+=(math.sin(self.bobPhase)*amplitude-self.bob)*alpha
 local roll=if self.reduced then 0 else -(self.inputVector or Vector3.zero).X*math.rad(c.SwayDegrees)
 self.roll+=(roll-self.roll)*alpha
 local landing=if self.reduced or machine.landLeft<=0 then 0 else -math.sin(math.pi*machine.landLeft/c.LandingDuration)*c.LandingAmplitude*math.clamp(machine.landImpact/35,0,1)
 local facing=CFrame.Angles(0,self.yaw,0)
 local from=self.profile.root.Position+Vector3.new(0,self.eyeHeight+c.EyeLift,0)
 local forward=c.EyeForward+(self.eyeForward-c.EyeForward)*math.clamp(-self.pitch/.9,0,1)
 local base=CFrame.new(from+facing.LookVector*forward)*facing*CFrame.Angles(self.pitch,0,0)
 local y=base.Position.Y
 if self.eyeY and (self.heightTransition or 0)>0 then
  self.eyeY+=(y-self.eyeY)*(1-math.exp(-3*dt/c.CrouchTransition));y=self.eyeY;self.heightTransition=math.max(0,self.heightTransition-dt)
 else self.eyeY=y end
 local desired=base.Position+Vector3.new(0,y-base.Position.Y+self.bob+landing,0)
 local delta=desired-from
 if delta.Magnitude>.001 then
  local hit=workspace:Spherecast(from,c.CameraRadius,delta,self.profile.ray)
  if hit then desired=from+delta.Unit*math.max(0,hit.Distance-.03) end
 end
 camera.CFrame=CFrame.new(desired)*base.Rotation*CFrame.Angles(0,0,self.roll)
 self.body:visibility(desired)
 UIS.MouseBehavior=if self.alt or self.suspended then Enum.MouseBehavior.Default else Enum.MouseBehavior.LockCenter
 UIS.MouseIconEnabled=self.alt or self.suspended
end
function Movement:setEnabled(value,reduced)
 if value and self.enabled and self.profile and self.profile.character~=self.player.Character then self:setEnabled(false) end
 self.desired=value
 if reduced~=nil then self.reduced=reduced end
 if self.enabled==value and (not value or (self.profile and self.profile.character==self.player.Character)) then return end
 self.generation+=1
 if not value then
  if not self.enabled then return end
  self:send("release");self.enabled=false
  CAS:UnbindAction(self.name);RunService:UnbindFromRenderStep(self.name)
  if self.physicsConnection then self.physicsConnection:Disconnect();self.physicsConnection=nil end
  if self.death then self.death:Disconnect();self.death=nil end
  if self.animationConnection then self.animationConnection:Disconnect();self.animationConnection=nil end
  if self.body then self.body:destroy();self.body=nil end
  for _,body in pairs(self.peerBodies or {})do body:destroy()end;self.peerBodies={}
  if self.profile and self.profile.humanoid.Parent then
   self.profile.humanoid:Move(Vector3.zero,false)
   if Collision.canStand(self.profile) then Collision.posture(self.profile,false,false) end
  end
  if self.defaults then
   self.player.CameraMode=self.defaults.mode;self.player.CameraMinZoomDistance=self.defaults.min;self.player.CameraMaxZoomDistance=self.defaults.max
   UIS.MouseDeltaSensitivity=self.defaults.sensitivity
   UIS.MouseBehavior=if self.defaults.mouse==Enum.MouseBehavior.LockCenter then Enum.MouseBehavior.Default else self.defaults.mouse
   UIS.MouseIconEnabled=true
  end
  if self.camera and self.camera.Parent then
   self.camera.FieldOfView=self.cameraFOV;self.camera.CameraType=self.defaults.cameraType;self.camera.CameraSubject=self.defaults.subject
  end
  if self.controls and self.defaults.controlsEnabled~=false then self.controls:Enable() end
  self.keys={};self.profile=nil;self.externalMove=nil
  self.player:SetAttribute("LocalMovementState",nil)
  self.player:SetAttribute("LocalMovementPaused",nil)
  return
 end
 local profile=self.player.Character and Collision.capture(self.player.Character,Config)
 if not profile or profile.humanoid.Health<=0 then return end
 self.profile=profile;self.enabled=true;self.machine=State.new(Config)
 self.machine.crouched=self.player.Character:GetAttribute("FPSCrouched")==true;self.machine.wantsCrouch=self.machine.crouched;self.posture=self.machine.crouched
 local currentCamera=workspace.CurrentCamera
 self.defaults={mode=self.player.CameraMode,min=self.player.CameraMinZoomDistance,max=self.player.CameraMaxZoomDistance,
  sensitivity=UIS.MouseDeltaSensitivity,mouse=UIS.MouseBehavior,icon=UIS.MouseIconEnabled,
  cameraType=if currentCamera then currentCamera.CameraType else Enum.CameraType.Custom,subject=if currentCamera then currentCamera.CameraSubject else profile.humanoid,
  controlsEnabled=self.controls and self.controls.controlsEnabled}
 if self.controls then self.controls:Disable() end
 self.camera=workspace.CurrentCamera;self.cameraFOV=if self.camera then self.camera.FieldOfView else Config.WalkFOV
 self.player.CameraMode=Enum.CameraMode.LockFirstPerson;UIS.MouseDeltaSensitivity=1
 self.bob=0;self.roll=0;self.bobPhase=0;self.eyeY=nil;self.heightTransition=0;self.inputVector=Vector3.zero;self.slideDirection=nil;self.alt=false;self.keys={}
 self.mouseDelta=Vector2.zero;self.pitch=0;self.sentMove=nil;self.moveClock=0;self.driveDirection=Vector3.zero;self.jumpRequested=false
 local look=profile.root.CFrame.LookVector;self.yaw=math.atan2(-look.X,-look.Z)
 self.eyeHeight=profile.head.Position.Y-profile.root.Position.Y
 local torso=profile.character:FindFirstChild("UpperTorso") or profile.character:FindFirstChild("Torso")
 self.eyeForward=math.max(Config.EyeForward,if torso then torso.Size.Z*.5+.12 else 0)
 self.body=Body.new(profile.character,Config,true);self.body:visibility();self.peerBodies={}
 self.suspended=false
 self.death=profile.humanoid.Died:Connect(function() self:setEnabled(false) end)
 CAS:BindActionAtPriority(self.name,function(...)return self:input(...)end,false,3100,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.LeftShift,Enum.KeyCode.C,Enum.KeyCode.LeftControl,Enum.KeyCode.Space,Enum.KeyCode.LeftAlt)
 self.physicsConnection=RunService.PreSimulation:Connect(function(dt)self:physics(dt)end)
 self.animationConnection=RunService.PreAnimation:Connect(function()
  if self.body then self.body:prepare()end
  for _,body in pairs(self.peerBodies)do body:prepare()end
 end)
 RunService:BindToRenderStep(self.name,Enum.RenderPriority.Camera.Value+1,function(dt)self:cameraStep(dt)end)
 self:setSuspended(not self.focused or GuiService.MenuIsOpen or UIS:GetFocusedTextBox()~=nil)
 if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then self:setSprint(true) end
 self.keys[Enum.KeyCode.Space]=UIS:IsKeyDown(Enum.KeyCode.Space)
end
function Movement:destroy()
 self:setEnabled(false)
 for _,connection in ipairs(self.connections) do connection:Disconnect() end
 self.connections={}
end
return Movement
