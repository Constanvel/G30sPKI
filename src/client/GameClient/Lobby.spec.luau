--!strict
return function(player)
 local Lobby=require(script.Parent.LobbyController)
 local Menu=require(script.Parent.MainMenuController)
 local View=require(script.Parent.MainMenuView)
 local Animation=require(script.Parent.MenuAnimationController)
 local previous=game.GuiService.SelectedObject;game.GuiService.SelectedObject=nil
 local sent={};local checks=0
 local function check(value,message) assert(value,message);checks+=1 end
 local lobby=Lobby.new(player,function(action,revision,value) table.insert(sent,{action=action,revision=revision,value=value});return true end)
 lobby.gui.Name="LobbyQA";lobby:setReduced(true)
 local view=View.new(player);view.gui.Name="LobbyMenuQA";view.gui.Enabled=true
 local animation=Animation.new(view)
 local menu=setmetatable({view=view,animation=animation,visible=true,lobbyActive=false,pending=false,reduced=false,volumes={Master=.6,Ambient=.5,UI=.5},requestId=0,camera={stop=function() error("Lobi tidak boleh menghentikan kamera menu") end}},Menu)
 local ok,message=pcall(function()
  menu:openPanel("Settings");task.wait(.5)
  check(view.panel.Visible and menu.panelName=="Settings" and view.root.GroupTransparency==1,"Fixture membuka Settings hingga menu utama selesai memudar")
  local generation=animation.generation
  menu:setLobbyActive(false)
  check(view.panel.Visible and menu.panelName=="Settings" and view.panel.GroupTransparency==0 and view.root.GroupTransparency==1 and animation.generation==generation,"Broadcast lobi pemain lain tidak menutup atau mengubah opacity Settings")
  menu:openPanel("Chapters");task.wait(.5)
  check(view.panel.Visible and menu.panelName=="Chapters" and view.root.GroupTransparency==1,"Fixture membuka Chapters sepenuhnya sebelum masuk lobi")
  menu.pending=true;menu.drag={}
  menu:setLobbyActive(true)
  check(menu.visible and menu.lobbyActive and not menu.pending and not view.root.Visible and not view.panel.Visible,"Lobi memakai kamera menu tanpa UI menu")
  check(menu.drag==nil and #menu:focusable()==0,"Lobi melepaskan drag dan fokus menu")
  menu:setLobbyActive(false)
  check(menu.visible and view.root.Visible and not menu.lobbyActive and view.root.GroupTransparency==0 and view.root.Position==UDim2.new(),"Keluar lobi dari Chapters mengembalikan menu yang terlihat pada posisi awal")
  local snapshot={joined=true,revision=10,hostUserId=player.UserId,capacity=4,phase="waiting",canStart=false,notice="",members={
   {userId=player.UserId,displayName="Pemain lokal",roleId=nil,ready=false},
   {userId=player.UserId+1,displayName="Pemain kedua",roleId="bima",ready=true},
  }}
  lobby:show(snapshot)
  check(lobby.visible and lobby.gui.Enabled and #lobby.memberRows==4,"Lobi menyediakan tepat empat slot")
  check(lobby.gui.ScreenInsets==Enum.ScreenInsets.CoreUISafeInsets,"Lobi memakai area aman CoreGui")
  check(lobby.roleButtons.bima:GetAttribute("Available")==false,"Peran pemain lain tidak dapat dipilih ulang")
  check(lobby.ready:GetAttribute("Available")==false and lobby.launch:GetAttribute("Available")==false,"Siap memerlukan peran dan mulai memerlukan semua siap")
  lobby:activate(lobby.roleButtons.bima);check(#sent==0,"Aktivasi peran yang ditempati tidak mengirim remote")
  lobby:activate(lobby.roleButtons.arga)
  check(sent[1].action=="role" and sent[1].revision==10 and sent[1].value=="arga","Pemilihan peran mengirim revisi server dan ID peran")
  snapshot=table.clone(snapshot);snapshot.revision=11;snapshot.members=table.clone(snapshot.members)
  snapshot.members[1]={userId=player.UserId,displayName="Pemain lokal",roleId="arga",ready=false}
  lobby:show(snapshot);lobby:activate(lobby.ready)
  check(sent[2].action=="ready" and sent[2].revision==11 and sent[2].value==true,"Siap mengirim boolean berdasarkan snapshot")
  snapshot=table.clone(snapshot);snapshot.revision=12;snapshot.canStart=true;snapshot.members=table.clone(snapshot.members)
  snapshot.members[1]=table.clone(snapshot.members[1]);snapshot.members[1].ready=true
  lobby:show(snapshot);lobby:activate(lobby.ready)
  check(sent[3].value==false,"Batal siap mengirim false")
  lobby:activate(lobby.launch);check(sent[4].action=="launch","Tuan rumah dapat mulai setelah server mengizinkan")
  local old=table.clone(snapshot);old.revision=11;old.canStart=false;lobby:show(old)
  check(lobby.snapshot.revision==12 and lobby.launch:GetAttribute("Available"),"Snapshot lama tidak menimpa state terbaru")
  snapshot=table.clone(snapshot);snapshot.revision=13;snapshot.hostUserId=player.UserId+1
  lobby:show(snapshot);check(not lobby.launch:GetAttribute("Available"),"Anggota bukan host tidak dapat mulai")
  for _,size in ipairs({Vector2.new(1000,700),Vector2.new(360,560),Vector2.new(705,280)}) do
   lobby.root.Size=UDim2.fromOffset(size.X,size.Y);task.wait(.1);lobby:layout();task.wait(.1)
   check(lobby.panel.AbsoluteSize.X<=size.X-32 and lobby.panel.AbsoluteSize.Y<=size.Y-32,"Lobi berada dalam batas aman viewport")
   check(lobby.content.AbsoluteSize.Y>=80,"Lobi pendek tetap menyisakan ruang scroll")
   for _,button in ipairs({lobby.ready,lobby.launch,lobby.leave,lobby.roleButtons.arga}) do
    check(button.AbsoluteSize.Y>=44 and button.TextFits,"Tombol lobi dapat disentuh dan dibaca")
   end
   for _,item in ipairs(lobby.panel:GetDescendants()) do
    if item:IsA("TextLabel") and item.TextTruncate==Enum.TextTruncate.None then check(item.TextFits,"Teks lobi terpotong: "..item.Name) end
   end
   lobby:reveal(lobby.roleButtons.damar)
   check(lobby.content.CanvasPosition.Y>0,"Fokus peran terakhir terlihat melalui scroll")
  end
  lobby:activate(lobby.leave);check(sent[#sent].action=="leave" and sent[#sent].revision==13,"Keluar mengirim revisi terbaru")
  snapshot=table.clone(snapshot);snapshot.revision=14;snapshot.joined=false;lobby:show(snapshot)
  check(not lobby.visible and not lobby.gui.Enabled and #lobby:focusable()==0,"Keluar lobi membersihkan UI dan fokus")
  lobby:activate(lobby.roleButtons.arga);check(sent[#sent].action=="leave","UI tersembunyi tidak mengirim tindakan")
 end)
 lobby:destroy();animation:destroy();view.resize:Disconnect();view.gui:Destroy();game.GuiService.SelectedObject=previous
 assert(ok,message)
 return tostring(checks).." lobby assertions PASS"
end
