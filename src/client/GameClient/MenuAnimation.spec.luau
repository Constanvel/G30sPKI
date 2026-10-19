--!strict
return function()
 local View=require(script.Parent.MainMenuView)
 local Animation=require(script.Parent.MenuAnimationController)
 local view=View.new(game.Players.LocalPlayer)
 view.gui.Name="MenuMotionQA";view.gui.Enabled=true
 local animation=Animation.new(view)
 assert(view.selectionMarker,"RED: satu indikator navigasi bergerak diperlukan")
 assert(type(animation.press)=="function","RED: umpan balik klik belum tersedia")
 local b=view.navigation.Start
 local checks=2
 local function check(value,message) assert(value,message);checks+=1 end
 b.TextTransparency=1
 animation:tween(b,0.16,{TextTransparency=0})
 task.wait(0.03)
 animation:feedback(b,true)
 task.wait(0.22)
 local ok,message=pcall(function()
  check(b.TextTransparency<0.01,"Hover tidak boleh membatalkan reveal teks")
  animation:intro()
  check(view.year.TextTransparency==1 and b.Index.TextTransparency==1,"Judul dan nomor tersembunyi pada awal intro")
  task.wait(.3)
  check(view.year.TextTransparency<1 and view.subtitle.TextTransparency==1,"Judul muncul sebelum subjudul")
  task.wait(1.1)
  check(view.year.TextTransparency==0 and view.subtitle.TextTransparency==0 and view.navigation.Credits.Index.TextTransparency==0,"Reveal bertahap harus selesai")
  check(view.selectionMarker.BackgroundTransparency==0,"Indikator muncul setelah intro")
  local target=view.navigation.Credits
  animation:feedback(b,true);task.wait(.26)
  local old=view.selectionMarker.Position
  animation:feedback(target,true)
  check(view.selectionMarker.Position==old,"Retarget indikator tidak boleh langsung berpindah")
  task.wait(.1)
  local middle=view.selectionMarker.Position
  check(middle~=old and middle~=target.Position+UDim2.fromOffset(30,22),"Indikator melewati posisi antara")
  animation:feedback(view.navigation.Archive,true);animation:feedback(target,true);task.wait(.28)
  check(view.selectionMarker.Position==target.Position+UDim2.fromOffset(30,22),"Input cepat harus berakhir pada indikator terakhir")
  check(not b:GetAttribute("Highlighted") and target:GetAttribute("Highlighted"),"Satu baris aktif setelah pergantian pilihan")
  view.root.Size=UDim2.fromOffset(314,348);task.wait(.12)
  local oldColumn=target.Position.X.Offset
  view.root.Size=UDim2.fromOffset(300,238);task.wait(.12)
  check(target.Position.X.Offset~=oldColumn and view.selectionMarker.Position==target.Position+UDim2.fromOffset(30,22),"Indikator mengikuti pergantian kolom pada viewport pendek")
  view.root.Size=UDim2.fromScale(1,1);task.wait(.05)
  animation:press(target);task.wait(.05)
  check(target.BackgroundTransparency<.72,"Klik memberi respons segera")
  view.overlay.BackgroundTransparency=0.5
  animation:panel("Credits"); animation:panel(nil); animation:panel("Settings")
  task.wait(0.5)
  check(view.panel.Visible and not view.root.Visible and view.panel.GroupTransparency<0.01,"Klik terakhir harus menang")
  check(view.overlay.BackgroundTransparency==1,"Pergantian panel harus membersihkan overlay intro")
  animation:panel(nil);task.wait(.15)
  local position=view.root.Position
  animation:panel(nil)
  check(view.root.Position==position,"Transisi yang dialihkan tidak mereset posisi")
  task.wait(.3)
  check(view.year.TextTransparency==0 and view.navigation.Credits.Index.TextTransparency==0,"Kembali tidak mengulang intro")
  animation.reduced=true; animation:panel(nil); task.wait(0.14)
  check(view.root.Visible and view.root.Position==UDim2.new(),"Reduced motion tidak menyisakan slide")
  animation:feedback(target,true);task.wait(.02)
  check(view.selectionMarker.Position==target.Position+UDim2.fromOffset(30,22),"Reduced motion meniadakan perjalanan indikator")
  animation.reduced=false
  animation:feedback(b,true); animation:feedback(b,false); animation:feedback(b,true)
  task.wait(0.2)
  check(b:FindFirstChildOfClass("UIPadding").PaddingLeft.Offset>b:GetAttribute("RestPadding"),"Hover harus menggeser teks secara halus")
  b:SetAttribute("Available",false); animation:feedback(b,true); task.wait(0.2)
  check(b:FindFirstChildOfClass("UIPadding").PaddingLeft.Offset==b:GetAttribute("RestPadding") and b.Indicator.BackgroundTransparency==1,"Tombol nonaktif tidak boleh menunjukkan hover aktif")
  b:SetAttribute("Available",true);animation:feedback(b,true);animation:intro()
  check(not b:GetAttribute("Highlighted"),"Intro baru tidak membawa sorotan dari sesi sebelumnya")
  animation:cancel();task.wait(1.3)
  check(view.year.TextTransparency==0 and view.navigation.Credits.Index.TextTransparency==0 and next(animation.tweens)==nil,"Callback intro dibatalkan tanpa tween tersisa")
 end)
 animation:destroy();check(not animation.resize.Connected,"Koneksi animasi dibersihkan"); view.resize:Disconnect(); view.gui:Destroy()
 assert(ok,message)
 return tostring(checks).." animation assertions PASS"
end
