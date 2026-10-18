--!strict
return function()
 local View=require(script.Parent.MainMenuView)
 local Animation=require(script.Parent.MenuAnimationController)
 local view=View.new(game.Players.LocalPlayer)
 local animation=Animation.new(view)
 local b=view.navigation.Start
 b.TextTransparency=1
 animation:tween(b,0.16,{TextTransparency=0})
 task.wait(0.03)
 animation:feedback(b,true)
 task.wait(0.22)
 local ok,message=pcall(function()
  assert(b.TextTransparency<0.01,"Hover tidak boleh membatalkan reveal teks")
  view.overlay.BackgroundTransparency=0.5
  animation:panel("Credits"); animation:panel(nil); animation:panel("Settings")
  task.wait(0.4)
  assert(view.panel.Visible and not view.root.Visible and view.panel.GroupTransparency<0.01,"Klik terakhir harus menang")
  assert(view.overlay.BackgroundTransparency==1,"Pergantian panel harus membersihkan overlay intro")
  animation.reduced=true; animation:panel(nil); task.wait(0.14)
  assert(view.root.Visible and view.root.Position==UDim2.new(),"Reduced motion tidak menyisakan slide")
 end)
 animation:cancel(); view.resize:Disconnect(); view.gui:Destroy()
 assert(ok,message)
 return "4 animation assertions PASS"
end
