--!strict
return function()
 local Config=require(game.ReplicatedStorage.Shared.MovementConfig)
 local State=require(game.ReplicatedStorage.Shared.MovementState)
 local count=0
 local function check(condition,message) assert(condition,message);count+=1 end
 local function near(actual,expected,message) check(math.abs(actual-expected)<1e-6,message..": "..tostring(actual)) end
 local function sensors(changes)
  local result={moving=false,forward=false,grounded=true,actualSpeed=0,verticalSpeed=0,canStand=true,blocked=false,slideAllowed=true}
  for key,value in pairs(changes or {}) do result[key]=value end
  return result
 end
 local standing=sensors()
 local running=sensors({moving=true,forward=true,actualSpeed=Config.SprintSpeed})
 local function advance(state,duration,dt,input)
  local elapsed=0
  while elapsed<duration-1e-9 do
   local delta=math.min(dt,duration-elapsed)
   state:step(delta,input);elapsed+=delta
  end
 end
 local function slide()
  local state=State.new(Config)
  state:command("sprint",true);state:command("crouch",true)
  local jump,started=state:step(0,running)
  check(started and not jump and state.state=="Sliding","Sprint maju memulai slide")
  return state
 end

 local state=State.new(Config)
 state:step(1/60,standing)
 check(state.state=="Idle" and state.speed==0,"Diam memakai Idle")
 state:step(.1,sensors({moving=true}))
 check(state.state=="Walking","Gerak biasa memakai Walking")
 near(state.speed,Config.Acceleration*.1,"Akselerasi dibatasi waktu")
 state:command("sprint",true);state:step(.1,running)
 check(state.state=="Sprinting","Sprint maju memakai Sprinting")
 state:step(.5,sensors({moving=true,forward=false}))
 check(state.state=="Walking","Sprint samping atau mundur memakai Walking")
 near(state.speed,Config.WalkSpeed,"Sprint samping tidak mempercepat jalan")
 state:command("sprint",false);state:command("crouch",false);state:step(0,standing)
 check(not state.crouched,"Keyup crouch tidak mengaktifkan jongkok")
 state:command("crouch",true);state:step(0,standing)
 check(state.state=="Crouching" and state.crouched,"Crouch memakai Crouching")
 state:command("sprint",true);state:step(.5,running)
 near(state.speed,Config.CrouchSpeed,"Sprint tidak menimpa kecepatan crouch")
 state:command("sprint",false)
 state:command("crouch",true);state:step(0,standing)
 check(state.crouched,"Keydown crouch berulang tidak toggle kembali")
 state:command("crouch",false);state:command("crouch",true)
 state:step(.1,sensors({canStand=false}))
 check(state.crouched and state.state=="Crouching","Plafon menahan percobaan berdiri")
 state:command("release",false);state:step(.1,sensors({canStand=false}))
 check(state.crouched,"Release fokus tidak memaksa berdiri di bawah plafon")
 state:step(.1,standing)
 check(not state.crouched,"Berdiri diperbolehkan setelah plafon bebas")

 for _,override in ipairs({
  {grounded=false},{moving=false},{forward=false},{actualSpeed=Config.SlideMinSpeed-.01},
  {blocked=true},{slideAllowed=false},
 }) do
  local input=table.clone(running)
  for key,value in pairs(override) do input[key]=value end
  local invalid=State.new(Config)
  invalid:command("sprint",true);invalid:command("crouch",true)
  local _,started=invalid:step(0,input)
  check(not started and invalid.state~="Sliding","Syarat slide tidak lengkap ditolak")
 end
 local noSprint=State.new(Config)
 noSprint:command("crouch",true)
 local _,noSprintStarted=noSprint:step(0,running)
 check(not noSprintStarted,"Slide memerlukan tombol sprint")
 local minimum=State.new(Config)
 minimum:command("sprint",true);minimum:command("crouch",true)
 local _,atMinimum=minimum:step(0,sensors({moving=true,forward=true,actualSpeed=Config.SlideMinSpeed}))
 check(atMinimum,"Kecepatan tepat batas minimum dapat slide")
 for _,reason in ipairs({{grounded=false},{blocked=true},{slideAllowed=false}}) do
  local interrupted=slide()
  local input=table.clone(running)
  for key,value in pairs(reason) do input[key]=value end
  interrupted:step(1/60,input)
  check(interrupted.slideLeft==0 and interrupted.state~="Sliding","Slide berhenti saat tanah atau lintasan tidak aman")
 end

 for _,dt in ipairs({1/30,1/60,1/120,.2}) do
  local timed=State.new(Config)
  timed:command("sprint",true)
  advance(timed,.1,dt,running)
  near(timed.speed,math.min(Config.Acceleration*.1,Config.SprintSpeed),"Akselerasi bebas frame rate")
  advance(timed,.9,dt,running)
  near(timed.speed,Config.SprintSpeed,"Kecepatan sprint stabil")
  advance(timed,1,dt,standing)
  near(timed.speed,0,"Deselerasi berhenti tanpa kecepatan negatif")

  local sliding=slide()
  near(sliding.speed,Config.SlideStartSpeed,"Slide mulai pada kecepatan konfigurasi")
  advance(sliding,Config.SlideDuration/2,dt,running)
  near(sliding.speed,(Config.SlideStartSpeed+Config.SlideEndSpeed)/2,"Peluruhan slide bebas frame rate")
  advance(sliding,Config.SlideDuration/2+1e-7,dt,running)
  check(sliding.state=="Crouching" and sliding.slideLeft==0,"Durasi slide berakhir dalam detik")
  near(sliding:snapshot().cooldown,Config.SlideCooldown-1e-7,"Cooldown dimulai sesudah durasi slide")
  sliding:command("crouch",false);sliding:command("crouch",true);sliding:step(0,running)
  check(not sliding.crouched,"Crouch dapat dilepas sesudah slide")
  sliding:command("crouch",false);sliding:command("crouch",true)
  local _,early=sliding:step(0,running)
  check(not early,"Slide berulang sebelum cooldown ditolak")
  sliding:command("crouch",false);sliding:command("crouch",true);sliding:step(0,running)
  advance(sliding,Config.SlideCooldown+.001,dt,running)
  check(sliding.state~="Sliding","Menahan tombol tidak mengulang slide saat cooldown habis")
  sliding:command("crouch",false);sliding:command("crouch",true)
  local _,ready=sliding:step(0,running)
  check(ready,"Slide baru diterima sesudah cooldown dan edge baru")

  local landing=State.new(Config)
  landing:step(dt,sensors({grounded=false,verticalSpeed=-30}))
  check(landing.state=="Falling","Kecepatan vertikal negatif memakai Falling")
  landing:step(dt,standing)
  check(landing.state=="Landing","Pendaratan terlihat meski frame hitch")
  near(landing.landImpact,30,"Pendaratan merekam kecepatan benturan")
  advance(landing,Config.LandingDuration/2,dt,standing)
  check(landing.state=="Landing","Landing bertahan setengah durasi")
  advance(landing,Config.LandingDuration/2+1e-7,dt,standing)
  check(landing.state=="Idle","Landing berakhir berdasarkan detik")
 end

 local jumping=State.new(Config)
 jumping:command("jump",false)
 local keyupJump=jumping:step(0,standing)
 check(not keyupJump,"Keyup jump tidak melompat")
 jumping:command("jump",true)
 local firstJump=jumping:step(0,standing)
 check(firstJump and jumping.state=="Jumping","Edge jump menghasilkan satu lompatan")
 jumping:command("jump",true)
 local repeatedJump=jumping:step(Config.JumpCooldown+.01,standing)
 check(not repeatedJump,"Keydown jump berulang tidak menghasilkan chaining")
 jumping:command("jump",false);jumping:command("jump",true)
 local secondJump=jumping:step(0,standing)
 check(secondJump,"Edge jump baru diterima sesudah cooldown")
 jumping:command("jump",false);jumping:command("jump",true)
 local cooldownJump=jumping:step(0,standing)
 check(not cooldownJump,"Jump sebelum cooldown ditolak")
 advance(jumping,Config.JumpCooldown+.01,1/60,standing)
 check(jumping.lastJump==Config.JumpCooldown+.01,"Buffer kadaluarsa tidak melompat otomatis")
 local ceiling=State.new(Config)
 ceiling:command("jump",true)
 local ceilingJump=ceiling:step(0,sensors({canStand=false}))
 check(not ceilingJump,"Jump ditolak di bawah plafon")
 local airborne=State.new(Config)
 airborne:command("jump",true)
 local airJump=airborne:step(0,sensors({grounded=false,verticalSpeed=3}))
 check(not airJump and airborne.state=="Jumping","Udara naik tidak menerima lompatan kedua")
 airborne:step(Config.JumpBuffer+.01,sensors({grounded=false,verticalSpeed=-3}))
 local rebound=airborne:step(0,standing)
 check(not rebound,"Input jump lama tidak memantul saat menyentuh tanah")
 local cancelled=slide()
 cancelled:command("release",false)
 local releaseJump=cancelled:step(0,standing)
 check(not releaseJump and not cancelled.sprint and cancelled.slideLeft==0,"Release membuang input tertahan dan slide")
 local slideJump=slide()
 slideJump:command("jump",true)
 local jumpedFromSlide=slideJump:step(1/60,running)
 check(jumpedFromSlide and slideJump.state=="Jumping" and slideJump.slideLeft==0,"Jump mengakhiri slide aktif")
 local hitchJump=State.new(Config)
 hitchJump:command("jump",true)
 local queuedAfterHitch=hitchJump:step(.2,standing)
 check(queuedAfterHitch,"Input baru tidak hilang sebelum step pertama saat hitch")

 local source=slide()
 advance(source,.2,1/60,running)
 local snapshot=source:snapshot()
 local copy=State.new(Config)
 advance(copy,5,.2,standing)
 copy:correct(snapshot)
 for key,value in pairs(snapshot) do
  local actual=copy:snapshot()[key]
  if type(value)=="number" then near(actual,value,"Koreksi snapshot mempertahankan "..key)
  else check(actual==value,"Koreksi snapshot mempertahankan "..key) end
 end
 source:step(.05,running);copy:step(.05,running)
 near(copy.speed,source.speed,"Rekonsiliasi melanjutkan kecepatan slide yang sama")
 near(copy:snapshot().cooldown,source:snapshot().cooldown,"Rekonsiliasi memakai cooldown relatif")
 snapshot.speed=999
 check(source.speed~=999,"Snapshot tidak mengubah state sumber")
 return tostring(count).." assertions PASS"
end
