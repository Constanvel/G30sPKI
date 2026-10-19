--!strict
return function(player)
 local View=require(script.Parent.MainMenuView)
 local Animation=require(script.Parent.MenuAnimationController)
 local Menu=require(script.Parent.MainMenuController)
 local view=View.new(player)
 view.gui.Name="SubmenuQA";view.gui.Enabled=true
 local animation=Animation.new(view)
 local previous=game.GuiService.SelectedObject;game.GuiService.SelectedObject=nil
 local menu=setmetatable({view=view,animation=animation,visible=true,pending=false,reduced=false,
  volumes={Master=.6,Ambient=.5,UI=.5}},Menu)
 local checks=0
 local function check(value,message) assert(value,message);checks+=1 end
 local ok,message=pcall(function()
  check(view.panelFooter~=nil,"RED: submenu memerlukan footer terpadu")
  check(view.chapterStart.Emphasis.ApplyStrokeMode==Enum.ApplyStrokeMode.Border,"Sorotan fokus mengikuti bingkai chapter")
  for _,name in ipairs({"Master","Ambient","UI"}) do
   local slider=view.settings[name.."Slider"]
   check(slider.NextSelectionLeft==slider and slider.NextSelectionRight==slider,"Panah slider tidak memindahkan fokus: "..name)
  end
  for _,size in ipairs({Vector2.new(1000,700),Vector2.new(800,520),Vector2.new(360,560),Vector2.new(705,280)}) do
   view.root.Size=UDim2.fromOffset(size.X,size.Y);task.wait(.15)
   for _,name in ipairs({"Chapters","Archive","Settings","Credits"}) do
    menu:openPanel(name);task.wait(.5)
    check(view.pages[name]:IsA("CanvasGroup"),"Konten memerlukan layer reveal: "..name)
    check(view.panel.AbsoluteSize.X<=size.X-32 and view.panel.AbsoluteSize.Y<=size.Y-32,"Panel harus berada dalam area aman")
    local eyebrowEnd=view.eyebrow.Position.Y.Offset+view.eyebrow.Size.Y.Offset
    check(view.panelTitle.Position.Y.Offset-eyebrowEnd==(if size.Y<410 then 8 else 12),"Jarak label ke judul harus konsisten")
    check(view.content.Position.X.Offset==view.eyebrow.Position.X.Offset and view.panelTitle.Position.X.Offset==view.eyebrow.Position.X.Offset,"Satu grid header dan isi")
    check(view.content.AbsolutePosition.Y+view.content.AbsoluteSize.Y<=view.footerRule.AbsolutePosition.Y,"Scroll tidak bertabrakan dengan footer")
    if size.Y<410 then
     check(view.content.AbsoluteSize.Y>=96,"Header compact menyisakan ruang baca")
     if name=="Settings" then
      local handle=view.settings.MasterSlider.Track.Handle
      check(handle.AbsolutePosition.Y+handle.AbsoluteSize.Y<=view.content.AbsolutePosition.Y+view.content.AbsoluteSize.Y,"Slider pertama langsung terlihat")
     end
    end
    check(view.back.AbsolutePosition.Y>=view.footerRule.AbsolutePosition.Y and view.back.AbsoluteSize.Y>=44,"Kembali terintegrasi di footer dengan target sentuh")
    for _,label in ipairs(view.panel:GetDescendants()) do
     if (label:IsA("TextLabel") or label:IsA("TextButton")) and #label.Text>0 then
      local visible=true;local parent=label
      while parent~=view.gui do if parent:IsA("GuiObject") and not parent.Visible then visible=false;break end;parent=parent.Parent end
      if visible then check(label.TextFits,"Teks terpotong: "..name.."/"..label.Name.." pada "..tostring(size)) end
     end
    end
   end
  end
  view.root.Size=UDim2.fromOffset(1000,700);task.wait(.15)
  menu:openPanel(nil);task.wait(.5);menu:openPanel("Archive");task.wait(.11)
  check(view.panel.Visible and view.pages.Archive.GroupTransparency>.5,"Isi tidak muncul bersama permukaan panel")
  task.wait(.12)
  check(view.panelTitle.TextTransparency<view.pages.Archive.GroupTransparency,"Judul mendahului isi")
  menu:openPanel("Chapters");menu:openPanel(nil);menu:openPanel("Settings");task.wait(.55)
  check(view.panel.Visible and not view.root.Visible and view.pages.Settings.Visible and view.pages.Settings.GroupTransparency==0,"Transisi terakhir menang")
  check(view.eyebrow.TextTransparency==0 and view.back.TextTransparency==0,"Tidak ada lapisan tertinggal transparan")
  menu:openPanel(nil);task.wait(.1)
  check(view.panel.Visible and view.panel.GroupTransparency>0,"Panel menutup secara bertahap")
  task.wait(.4)
  check(view.root.Visible and not view.panel.Visible and view.year.TextTransparency==0,"Kembali tidak mengulang intro")
  animation.reduced=true;menu.reduced=true;menu:openPanel("Settings");task.wait(.15)
  check(view.panel.Position==UDim2.fromScale(.5,.5) and view.pages.Settings.Position==UDim2.new(),"Reduced motion tanpa slide")
  check(view.pages.Settings.GroupTransparency==0 and view.eyebrow.TextTransparency==0,"Reduced motion tanpa stagger tertunda")
 end)
 animation:destroy();view.resize:Disconnect();view.gui:Destroy();game.GuiService.SelectedObject=previous
 assert(ok,message)
 return tostring(checks).." submenu assertions PASS"
end
