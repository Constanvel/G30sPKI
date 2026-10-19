--!strict
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Config=require(RS.Shared.MovementConfig)
local State=require(RS.Shared.MovementState)
local Collision=require(RS.Shared.MovementCollision)
local Movement={}
Movement.__index=Movement

local function finite(n)
 return typeof(n)=="number" and n==n and math.abs(n)<math.huge
end
local function horizontal(v) return Vector3.new(v.X,0,v.Z) end
local function finiteVector(v) return finite(v.X) and finite(v.Y) and finite(v.Z) end

function Movement.new(canAct)
 local folder=RS:FindFirstChild("Remotes")
 if not folder then folder=Instance.new("Folder");folder.Name="Remotes";folder.Parent=RS end
 local remote=folder:FindFirstChild("MovementEvent")
 if not remote then remote=Instance.new("RemoteEvent");remote.Name="MovementEvent";remote.Parent=folder end
 assert(remote:IsA("RemoteEvent"),"Remotes.MovementEvent harus berupa RemoteEvent")
 local self=setmetatable({records={},canAct=canAct,remote=remote,accumulator=0},Movement)
 self.remoteConnection=remote.OnServerEvent:Connect(function(player,action,sequence,character,down)
  self:handleRequest(player,action,sequence,character,down)
 end)
 self.heartbeat=RunService.Heartbeat:Connect(function(dt)
  self.accumulator+=dt
  if self.accumulator<Config.ServerInterval then return end
  local elapsed=self.accumulator;self.accumulator=0;self:step(elapsed)
 end)
 return self
end

function Movement:_send(player,r)
 if typeof(player)=="Instance" and player:IsA("Player") and player.Parent==Players then
  self.remote:FireClient(player,{character=r.profile.character,sequence=r.sequence,stateSnapshot=r.machine:snapshot(),
   slideDirection=r.slideDirection,serverTime=workspace:GetServerTimeNow()})
 end
 r.dirty=false
end
function Movement:_reject(player,r)
 local now=os.clock()
 if now-(r.lastCorrection or -math.huge)>=Config.CorrectionInterval then r.lastCorrection=now;self:_send(player,r) end
end

function Movement:bindCharacter(player,character)
 self:remove(player)
 local humanoid=character:FindFirstChildOfClass("Humanoid")
 if not humanoid or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then return false end
 local originalHipAttribute=humanoid:GetAttribute("FPSStandingHipHeight")
 humanoid:SetAttribute("FPSStandingHipHeight",humanoid.HipHeight)
 local profile=Collision.capture(character,Config)
 if not profile then humanoid:SetAttribute("FPSStandingHipHeight",originalHipAttribute);return false end
 local r={profile=profile,machine=State.new(Config),enabled=false,sequence=0,tokens=Config.InputBurst,
  tokenTime=os.clock(),pending={},moveIntent=Vector3.zero,slideDirection=Vector3.zero,stance=false,dirty=true,validationTime=0,
  lastPosition=profile.root.Position,lastSafe=character:GetPivot(),travelBudget=Config.PositionSlack,
  defaults={speed=humanoid.WalkSpeed,power=humanoid.JumpPower,height=humanoid.JumpHeight,
   usePower=humanoid.UseJumpPower,autoJump=humanoid.AutoJumpEnabled,rotate=humanoid.AutoRotate,hipAttribute=originalHipAttribute}}
 self.records[player]=r
 humanoid.UseJumpPower=false;humanoid.AutoJumpEnabled=false
 humanoid.WalkSpeed=0;humanoid.JumpHeight=0;humanoid.AutoRotate=false
 character:SetAttribute("FPSMovementState","Idle")
 character:SetAttribute("FPSCrouched",false);character:SetAttribute("FPSEnabled",false)
 self:_send(player,r)
 return true
end

function Movement:setEnabled(player,enabled)
 local r=self.records[player]
 if not r then return end
 enabled=enabled==true
 if r.enabled~=enabled then
  r.enabled=enabled;r.pending={};r.moveIntent=Vector3.zero;r.machine:command("release");r.dirty=true
 end
 local h=r.profile.humanoid
 if not enabled then h.WalkSpeed=0;h.JumpHeight=0;h.AutoRotate=false;h.Jump=false
 elseif not self.canAct(player) then
  h.WalkSpeed=r.defaults.speed;h.JumpHeight=Config.JumpHeight;h.AutoRotate=true
 end
 r.profile.character:SetAttribute("FPSEnabled",enabled)
end

function Movement:handleRequest(player,action,sequence,character,down)
 local r=self.records[player]
 if not r then return false end
 if character~=r.profile.character or player.Character~=character or not character.Parent then
  self:_reject(player,r);return false
 end
 local payload=action=="sprint" and typeof(down)=="boolean"
  or action=="move" and typeof(down)=="Vector3" and finiteVector(down) and down.Y==0 and down.Magnitude<=1.001
  or (action=="crouch" or action=="jump") and (down==nil or typeof(down)=="boolean")
  or action=="release" and down==nil
 if not payload or not finite(sequence) or sequence%1~=0 or sequence<=r.sequence or sequence>9007199254740991 then
  self:_reject(player,r);return false
 end
 r.sequence=sequence
 local now=os.clock()
 r.tokens=math.min(Config.InputBurst,r.tokens+(now-r.tokenTime)*Config.InputRate);r.tokenTime=now
 if action=="release" and r.enabled and self.canAct(player) then
  r.pending={};r.moveIntent=Vector3.zero;r.machine:command("release");r.dirty=true;return true
 end
 if action=="move" and down.Magnitude==0 and r.enabled and self.canAct(player) then
  r.moveIntent=Vector3.zero;r.dirty=true;return true
 end
 if r.tokens<1 then self:_reject(player,r);return false end
 r.tokens-=1
 if r.profile.humanoid.Health<=0 or not r.enabled or not self.canAct(player) then
  self:_reject(player,r);return false
 end
 if action=="move" then r.moveIntent=down;r.dirty=true;return true end
 table.insert(r.pending,{action=action,down=down});r.dirty=true
 return true
end

function Movement:teleport(player,cf)
 local r=self.records[player]
 if not r or typeof(cf)~="CFrame" or not finiteVector(cf.Position) then return false end
 r.profile.character:PivotTo(cf)
 r.profile.root.AssemblyLinearVelocity=Vector3.zero;r.profile.root.AssemblyAngularVelocity=Vector3.zero
 r.pending={};r.moveIntent=Vector3.zero;r.machine:command("release");r.machine.speed=0;r.slideDirection=Vector3.zero
 r.lastPosition=r.profile.root.Position;r.lastSafe=r.profile.character:GetPivot();r.travelBudget=Config.PositionSlack;r.validationTime=0;r.dirty=true
 return true
end

function Movement:_validate(r,dt)
 r.validationTime+=dt
 if r.validationTime<Config.ValidationInterval then return end
 local elapsed=r.validationTime;r.validationTime=0
 local root=r.profile.root
 local position,velocity=root.Position,root.AssemblyLinearVelocity
 local valid=finiteVector(position) and finiteVector(velocity)
 -- shortcut: conservative horizontal envelope; moving platforms and latency need multiplayer tuning.
 if valid and elapsed<=Config.ValidationMaxGap then
  r.travelBudget=math.min(Config.PositionSlack,r.travelBudget)+Config.ValidationSpeed*elapsed-horizontal(position-r.lastPosition).Magnitude
  valid=r.travelBudget>=0
   and horizontal(velocity).Magnitude<=Config.ValidationSpeed+Config.PositionSlack/elapsed
 elseif valid then r.travelBudget=Config.PositionSlack
 end
 if valid then r.lastPosition=position;r.lastSafe=r.profile.character:GetPivot()
 else
  r.profile.character:PivotTo(r.lastSafe);root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
  r.lastPosition=root.Position;r.travelBudget=0;r.pending={};r.moveIntent=Vector3.zero;r.machine:command("release");r.machine.speed=0;r.dirty=true
 end
end

function Movement:step(dt)
 for player,r in pairs(self.records) do
  local p=r.profile;local h=p.humanoid
  if player.Character~=p.character or not p.character.Parent or not h.Parent or not p.root.Parent or h.Health<=0 then
   r.pending={};r.machine:command("release");h.WalkSpeed=0;h.JumpHeight=0
   continue
  end
  self:_validate(r,dt)
  local active=r.enabled and self.canAct(player)
  local before=r.machine:snapshot()
  if active then for _,command in ipairs(r.pending) do r.machine:command(command.action,command.down) end
  else r.moveIntent=Vector3.zero;r.machine:command("release") end
  r.pending={}
  local velocity=p.root.AssemblyLinearVelocity
  local flatVelocity=horizontal(velocity)
  local look=horizontal(p.root.CFrame.LookVector)
  local motionDirection=if flatVelocity.Magnitude>.1 then flatVelocity.Unit else Vector3.zero
  local direction=if r.machine.slideLeft>0 then r.slideDirection else motionDirection
  local ground=Collision.ground(p)
  local grounded=h.FloorMaterial~=Enum.Material.Air
  local sensors={moving=active and r.moveIntent.Magnitude>.05,
   forward=r.moveIntent.Z<-.1,
   grounded=grounded,verticalSpeed=velocity.Y,actualSpeed=flatVelocity.Magnitude,
   canStand=Collision.canStand(p),blocked=Collision.blocked(p,direction,math.max(r.machine.speed,Config.SlideStartSpeed)*dt),
   slideAllowed=ground~=nil and ground.Normal.Y>=Config.SlideMinNormalY}
  local jump,started=r.machine:step(dt,sensors)
  if started then
   r.slideDirection=if flatVelocity.Magnitude>.1 then flatVelocity.Unit elseif look.Magnitude>.01 then look.Unit else Vector3.new(0,0,-1)
  end
  if r.stance~=r.machine.crouched then
   r.stance=r.machine.crouched;Collision.posture(p,r.stance,true)
  end
  if active then
   h.WalkSpeed=r.machine.speed;h.JumpHeight=Config.JumpHeight;h.AutoRotate=false
   if jump then h.Jump=true end
   if r.machine.state=="Sliding" then h:Move(r.slideDirection,false) end
  elseif r.enabled then h.WalkSpeed=r.defaults.speed;h.JumpHeight=Config.JumpHeight;h.AutoRotate=true
  else h.WalkSpeed=0;h.JumpHeight=0;h.AutoRotate=false;h.Jump=false end
  p.character:SetAttribute("FPSMovementState",r.machine.state)
  p.character:SetAttribute("FPSCrouched",r.machine.crouched)
  if r.dirty or before.state~=r.machine.state or before.crouched~=r.machine.crouched
   or before.speed~=r.machine.speed or before.sprint~=r.machine.sprint then self:_send(player,r) end
 end
end

function Movement:remove(player)
 local r=self.records[player]
 if not r then return end
 self.records[player]=nil
 local p=r.profile;local h=p.humanoid;local d=r.defaults
 if h.Parent then
  Collision.posture(p,false,true)
  h.WalkSpeed=d.speed;h.JumpPower=d.power;h.JumpHeight=d.height
  h.UseJumpPower=d.usePower;h.AutoJumpEnabled=d.autoJump;h.AutoRotate=d.rotate
  h:SetAttribute("FPSStandingHipHeight",d.hipAttribute)
 end
 if p.character.Parent then
  p.character:SetAttribute("FPSMovementState",nil);p.character:SetAttribute("FPSCrouched",nil);p.character:SetAttribute("FPSEnabled",nil)
 end
end

function Movement:destroy()
 self.remoteConnection:Disconnect();self.heartbeat:Disconnect()
 for player in pairs(self.records) do self:remove(player) end
end
return Movement
