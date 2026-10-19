--!strict
local State={}
State.__index=State
function State.new(config)
 return setmetatable({config=config,time=0,state="Idle",speed=0,sprint=false,crouched=false,wantsCrouch=false,
  slideLeft=0,nextSlideAt=0,jumpUntil=-1,lastJump=-math.huge,airborne=false,landLeft=0,impact=0,landImpact=0,held={}},State)
end
function State:command(action,down)
 if action=="jump" or action=="crouch" then
  if down==false then self.held[action]=nil;return end
  if down==true then if self.held[action] then return end;self.held[action]=true end
 end
 if action=="sprint" then self.sprint=down==true
 elseif action=="crouch" then self.crouchQueued=true
 elseif action=="jump" then self.jumpQueued=true
 elseif action=="release" then
  self.sprint=false;self.crouchQueued=false;self.jumpQueued=false;self.jumpUntil=-1;self.slideLeft=0;self.wantsCrouch=false;self.held={}
 end
end
function State:step(dt,s)
 local c=self.config;self.time+=dt
 if self.jumpQueued then self.jumpUntil=self.time+c.JumpBuffer;self.jumpQueued=false end
 local started=false
 if self.crouchQueued then
  if not self.crouched and self.sprint and s.forward and s.moving and s.grounded and s.actualSpeed>=c.SlideMinSpeed
   and self.time>=self.nextSlideAt and not s.blocked and s.slideAllowed~=false then
   self.slideLeft=c.SlideDuration;self.nextSlideAt=self.time+c.SlideDuration+c.SlideCooldown;self.wantsCrouch=true;started=true
  else self.wantsCrouch=not self.wantsCrouch end
  self.crouchQueued=false
 end
 if not started then self.slideLeft=math.max(0,self.slideLeft-dt) end
 if not s.grounded or s.blocked or s.slideAllowed==false then self.slideLeft=0 end
 self.crouched=self.wantsCrouch or self.slideLeft>0 or (self.crouched and not s.canStand)
 local jump=self.jumpUntil>=self.time and s.grounded and s.canStand and self.time-self.lastJump>=c.JumpCooldown
 if jump then
  self.lastJump=self.time;self.jumpUntil=-1;self.slideLeft=0;self.wantsCrouch=false;self.crouched=false
 end
 local inAir=not s.grounded or jump or (self.time-self.lastJump<c.JumpGroundGrace and s.verticalSpeed>0)
 local landed=false
 if inAir then self.airborne=true;self.impact=math.max(self.impact,-s.verticalSpeed)
 elseif self.airborne then self.airborne=false;self.landLeft=c.LandingDuration;self.landImpact=self.impact;self.impact=0;landed=true end
 if not landed then self.landLeft=math.max(0,self.landLeft-dt) end
 if self.slideLeft>0 then self.state="Sliding"
 elseif inAir then self.state=if jump or s.verticalSpeed>=0 then "Jumping" else "Falling"
 elseif self.landLeft>0 then self.state="Landing"
 elseif self.crouched then self.state="Crouching"
 elseif s.moving then self.state=if self.sprint and s.forward then "Sprinting" else "Walking"
 else self.state="Idle" end
 local target=if not s.moving then 0 elseif self.crouched then c.CrouchSpeed elseif self.sprint and s.forward then c.SprintSpeed else c.WalkSpeed
 if self.slideLeft>0 then
  self.speed=c.SlideEndSpeed+(c.SlideStartSpeed-c.SlideEndSpeed)*self.slideLeft/c.SlideDuration
 else
  local delta=target-self.speed
  local limit=(if delta>0 then c.Acceleration else c.Deceleration)*dt
  self.speed+=math.clamp(delta,-limit,limit)
 end
 return jump,started
end
function State:snapshot()
 return {state=self.state,speed=self.speed,crouched=self.crouched,wantsCrouch=self.wantsCrouch,sprint=self.sprint,
  slideLeft=self.slideLeft,cooldown=math.max(0,self.nextSlideAt-self.time),airborne=self.airborne,landLeft=self.landLeft,landImpact=self.landImpact,
  impact=self.impact,jumpCooldown=math.max(0,self.config.JumpCooldown-(self.time-self.lastJump))}
end
function State:correct(s)
 self.state=s.state;self.speed=s.speed;self.crouched=s.crouched;self.wantsCrouch=s.wantsCrouch;self.sprint=s.sprint
 self.slideLeft=s.slideLeft;self.nextSlideAt=self.time+s.cooldown;self.airborne=s.airborne;self.landLeft=s.landLeft;self.landImpact=s.landImpact
 self.impact=s.impact or 0;self.lastJump=self.time-self.config.JumpCooldown+(s.jumpCooldown or 0)
end
return State
