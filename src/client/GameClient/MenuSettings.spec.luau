--!strict
return function(player)
 local View=require(script.Parent.MainMenuView)
 local Menu=require(script.Parent.MainMenuController)
 local Animation=require(script.Parent.MenuAnimationController)
 local view=View.new(player)
 local animation=Animation.new(view)
 local menu=setmetatable({view=view,animation=animation,visible=true,pending=false,panelName="Settings",reduced=false,
  volumes={Master=.6,Ambient=.5,UI=.5},groups={Master={},Ambient={},UI={}}},Menu)
 local count=0
 local function check(value,message) assert(value,message);count+=1 end
 local ok,message=pcall(function()
  check(view.settings.MasterSlider~=nil,"RED: volume harus memakai slider")
  view.gui.Enabled=true;view.pages.Settings.Visible=true;view.panel.Visible=true
  view.root.Size=UDim2.fromOffset(1000,600);task.wait(.1);view:layout();task.wait(.1)
  check(view.panel.AbsoluteSize.X<=640 and view.panel.AbsoluteSize.Y<=568,"Panel settings mengikuti konten dan batas area aman")
  check(view.content.AbsoluteSize.Y>=view.pages.Settings.AbsoluteSize.Y,"Desktop tidak perlu scroll settings")
  menu:updateSettings()
  for _,name in ipairs({"Master","Ambient","UI"}) do
   local slider=view.settings[name.."Slider"]
   check(slider.AbsoluteSize.Y>=44 and slider:GetAttribute("SettingName")==name,"Slider harus dapat disentuh dan diidentifikasi")
   menu:setVolume(name,.25)
   check(menu.groups[name].Volume==.25 and view.settings[name.."Value"].Text=="25%","Slider harus memperbarui SoundGroup sesi dan label")
   menu:setVolume(name,2);check(menu.groups[name].Volume==1,"Volume maksimum wajib dibatasi")
   menu:setVolume(name,-2);check(menu.groups[name].Volume==0,"Volume minimum wajib dibatasi")
   check(menu:stepSlider(slider,1) and menu.volumes[name]==.1,"Panah kanan menambah volume fokus")
   local track=slider.Track
   menu:updateSliderInput(slider,track.AbsolutePosition.X+track.AbsoluteSize.X*.5)
   check(menu.volumes[name]==.5,"Titik tengah track harus menghasilkan 50 persen")
  end
  menu.panelName="Archive"
  check(not menu:stepSlider(view.settings.MasterSlider,1),"Panel tersembunyi tidak boleh menerima panah volume")
  menu:updateSliderInput(view.settings.MasterSlider,0)
  check(menu.volumes.Master==.5,"Drag tidak boleh mengubah panel tersembunyi")
  menu.reduced=true;menu:updateSettings();task.wait(.2)
  check(view.settings.Motion:GetAttribute("On")==true and view.settings.Motion.State.Text=="Aktif","Toggle wajib memiliki state terbaca")
  view.root.Size=UDim2.fromOffset(360,560);task.wait(.1);view:layout();task.wait(.1)
  check(view.panelTitle.TextFits,"Heading settings harus terbaca pada lebar sempit")
  local motion=view.settings.Motion
  local padding=motion:FindFirstChildOfClass("UIPadding").PaddingTop.Offset
  check(motion.State.AbsolutePosition.Y>=motion.AbsolutePosition.Y+padding+motion.TextBounds.Y,"State toggle tidak boleh bertabrakan dengan label")
  check(view.pages.Settings.MotionNote.TextFits,"Deskripsi aksesibilitas tidak boleh terpotong")
  check(view.nav.CanvasSize.Y.Offset>=284,"Navigasi portrait yang tinggi harus dapat digulir")
  for _,name in ipairs({"Chapters","Archive","Credits"}) do
   for other,frame in pairs(view.pages) do frame.Visible=other==name end
   view:layout();task.wait(.1)
   for _,label in ipairs(view.pages[name]:GetDescendants()) do
    if label:IsA("TextLabel") then check(label.TextFits,"Teks panel sempit terpotong: "..name.."/"..label.Name) end
   end
  end
 end)
 animation:destroy();view.resize:Disconnect();view.gui:Destroy()
 assert(ok,message)
 return tostring(count).." settings assertions PASS"
end
