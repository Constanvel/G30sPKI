--!strict
return function(player)
 local Menu=require(script.Parent.MainMenuController)
 assert(type(Menu.selection)=="function","RED: pemilihan keyboard belum dibatasi panel aktif")
 local gui=player.PlayerGui.MainMenuGui
 local previous=game.GuiService.SelectedObject
 local fired=0
 local view={gui=gui,back=gui.Panel.Back,chapterStart=gui.Panel.Content.Chapters.VS01,navigation={},settings={},order={"Start","Resume","Chapters","Archive","Settings","Credits"}}
 for _,name in ipairs(view.order) do view.navigation[name]=gui.Root.Navigation[name] end
 for _,name in ipairs({"MasterSlider","AmbientSlider","UISlider","Motion"}) do view.settings[name]=gui.Panel.Content.Settings[name] end
 local menu=setmetatable({visible=true,pending=false,panelName="Archive",view=view,handlers={[view.navigation.Start]=function() fired+=1 end},animation={press=function() end}},Menu)
 local ok,message=pcall(function()
  game.GuiService.SelectedObject=nil
  assert(menu:selection()==view.back,"Panel tanpa fokus harus memilih Kembali")
  game.GuiService.SelectedObject=view.navigation.Start
  assert(menu:selection()==view.back,"Fokus pada tombol tersembunyi harus diabaikan")
  menu:activate(view.navigation.Start)
  assert(fired==0,"Tombol Start tersembunyi tidak boleh menghapus checkpoint")
  menu.panelName="Settings"; game.GuiService.SelectedObject=view.settings.MasterSlider
  assert(menu:selection()==view.settings.MasterSlider,"Pilihan slider yang sah tetap bekerja")
  menu.panelName=nil; game.GuiService.SelectedObject=nil
  assert(menu:selection()==view.navigation.Start,"Menu utama tanpa fokus memilih Mulai")
 end)
 game.GuiService.SelectedObject=previous
 assert(ok,message)
 return "5 input assertions PASS"
end
