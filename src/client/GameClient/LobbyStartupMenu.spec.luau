--!strict
return function()
 local Startup=require(script.Parent.LobbyStartupMenu)
 local character=Instance.new("Model");local h=Instance.new("Humanoid");h.Parent=character
 h.WalkSpeed=17;h.JumpPower=45;h.JumpHeight=6;h.AutoRotate=true
 local hides,unlocks=0,0
 local intro=setmetatable({active=true,player={Character=character},saved={},gui={Enabled=false},
  menu={hide=function()hides+=1 end},cinematic={setLocked=function(_,value)if not value then unlocks+=1 end end}},Startup)
 local count=0;local function check(value,message)assert(value,message);count+=1 end
 local ok,result=pcall(function()
  intro:lock(character)
  check(h.WalkSpeed==0 and h.JumpPower==0 and h.JumpHeight==0 and not h.AutoRotate,"Menu blocks movement while the cinematic camera owns the view")
  intro:lock(character)
  check(intro.saved[h].WalkSpeed==17,"Duplicate character callbacks preserve the original movement settings")
  intro:enter()
  check(not intro.active and intro.gui.Enabled and hides==1,"Mulai reveals the existing lobby once")
  check(h.WalkSpeed==17 and h.JumpPower==45 and h.JumpHeight==6 and h.AutoRotate,"Mulai restores the exact character settings")
  check(next(intro.saved)==nil and unlocks==1,"Menu releases its movement lock")
  intro:enter();check(hides==1 and unlocks==1,"Rapid repeated start does not duplicate transition")
  intro:lock(character);check(h.WalkSpeed==17,"Inactive intro cannot relock the lobby")
  intro.active=true;intro.player.Character=nil;intro:lock(character)
  check(h.WalkSpeed==17 and next(intro.saved)==nil,"Stale character callback cannot lock an old avatar")
  return tostring(count).." lobby startup assertions PASS"
 end)
 character:Destroy();assert(ok,result);return result
end
