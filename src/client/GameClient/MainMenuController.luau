--!strict
local SoundService=game:GetService("SoundService")
local GuiService=game:GetService("GuiService")
local ContextActionService=game:GetService("ContextActionService")
local View=require(script.Parent.MainMenuView)
local Animation=require(script.Parent.MenuAnimationController)
local Camera=require(script.Parent.MenuCameraController)
local Environment=require(script.Parent.MenuEnvironment)
local Menu={}
Menu.__index=Menu

function Menu.new(player,request)
 local self=setmetatable({player=player,request=request,visible=false,pending=false,connections={},handlers={},requestId=0,
  volumes={Master=0.6,Ambient=0.5,UI=0.5},reduced=false},Menu)
 self.view=View.new(player); self.animation=Animation.new(self.view); self.camera=Camera.new(player)
 local ok,scene=pcall(Environment.create)
 if ok then self.environment=scene else warn("Menu: latar gagal dibangun",scene) end
 self.groups={}
 for _,name in ipairs({"Master","Ambient","UI"}) do
  local group=Instance.new("SoundGroup"); group.Name=if name=="Master" then "MenuAudio" else name
  group.Volume=self.volumes[name]; group.Parent=if name=="Master" then SoundService else self.groups.Master
  self.groups[name]=group
 end
 local function bind(button,callback)
  self.handlers[button]=callback
  table.insert(self.connections,button.Activated:Connect(function() self:activate(button) end))
  local function feedback() self.animation:feedback(button,button:GetAttribute("PointerOver")==true or GuiService.SelectedObject==button) end
  table.insert(self.connections,button.MouseEnter:Connect(function() button:SetAttribute("PointerOver",true); feedback() end))
  table.insert(self.connections,button.MouseLeave:Connect(function() button:SetAttribute("PointerOver",false); feedback() end))
  table.insert(self.connections,button.SelectionGained:Connect(feedback))
  table.insert(self.connections,button.SelectionLost:Connect(feedback))
 end
 table.insert(self.connections,player.PlayerGui.ChildAdded:Connect(function(child)
  if child.Name=="TouchGui" and child:IsA("ScreenGui") and self.visible then child.Enabled=false end
 end))
 bind(self.view.navigation.Start,function() self:send(if self.state.loading then "ready" else "start","vs01") end)
 bind(self.view.navigation.Resume,function() self:send("resume") end)
 for _,name in ipairs({"Chapters","Archive","Settings","Credits"}) do bind(self.view.navigation[name],function() self:openPanel(name) end) end
 bind(self.view.back,function() self:openPanel(nil) end)
 bind(self.view.chapterStart,function() self:send("start","vs01") end)
 for _,name in ipairs({"Master","Ambient","UI"}) do
  local function adjust(delta)
   self.volumes[name]=math.round(math.clamp(self.volumes[name]+delta,0,1)*10)/10
   self.groups[name].Volume=self.volumes[name]; self:updateSettings()
  end
  bind(self.view.settings[name.."Minus"],function() adjust(-0.1) end)
  bind(self.view.settings[name.."Plus"],function() adjust(0.1) end)
 end
 bind(self.view.settings.Motion,function()
  self.reduced=not self.reduced; self.animation:cancel(); self.animation.reduced=self.reduced
  self.view.root.GroupTransparency=0; self.view.panel.GroupTransparency=0
  self.view.panel.Position=UDim2.fromScale(0.5,0.5); self.view.root.Position=UDim2.new()
  self.camera:setReduced(self.reduced); self:updateSettings()
 end)
 ContextActionService:BindActionAtPriority("MainMenuNavigation",function(_,input,key)
  if not self.visible then return Enum.ContextActionResult.Pass end
  if input~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Sink end
  if key.KeyCode==Enum.KeyCode.Escape or key.KeyCode==Enum.KeyCode.ButtonB then
   if self.panelName then self:openPanel(nil) end
  elseif key.KeyCode==Enum.KeyCode.Return or key.KeyCode==Enum.KeyCode.ButtonA then
   self:activate(self:selection())
  else
   local list=self:focusable()
   local index=table.find(list,GuiService.SelectedObject) or 0
   local backwards=key.KeyCode==Enum.KeyCode.Up or key.KeyCode==Enum.KeyCode.Left or key.KeyCode==Enum.KeyCode.DPadUp or key.KeyCode==Enum.KeyCode.DPadLeft
   if #list>0 then GuiService.SelectedObject=list[(index+(if backwards then -2 else 0))%#list+1] end
  end
  return Enum.ContextActionResult.Sink
 end,false,3100,Enum.KeyCode.Return,Enum.KeyCode.Up,Enum.KeyCode.Down,Enum.KeyCode.Left,Enum.KeyCode.Right,Enum.KeyCode.Escape,
  Enum.KeyCode.ButtonA,Enum.KeyCode.ButtonB,Enum.KeyCode.DPadUp,Enum.KeyCode.DPadDown,Enum.KeyCode.DPadLeft,Enum.KeyCode.DPadRight)
 self:updateSettings()
 return self
end

function Menu:activate(button)
 if not self.visible or self.pending or not button or button:GetAttribute("Available")==false then return end
 if not table.find(self:focusable(),button) then return end
 if self.handlers[button] then
  self.animation:feedback(button,true)
  self.handlers[button]()
 end
end

function Menu:focusable()
 local list={}
 if not self.panelName then
  for _,name in ipairs(self.view.order) do local b=self.view.navigation[name]; if b:GetAttribute("Available")~=false then table.insert(list,b) end end
 else
  table.insert(list,self.view.back)
  if self.panelName=="Chapters" then table.insert(list,self.view.chapterStart)
  elseif self.panelName=="Settings" then
   for _,name in ipairs({"MasterMinus","MasterPlus","AmbientMinus","AmbientPlus","UIMinus","UIPlus","Motion"}) do table.insert(list,self.view.settings[name]) end
  end
 end
 return list
end

function Menu:selection()
 local list=self:focusable()
 local selected=GuiService.SelectedObject
 return if table.find(list,selected) then selected else list[1]
end

function Menu:updateSettings()
 for name,value in pairs(self.volumes) do self.view.settings[name.."Value"].Text=tostring(math.round(value*100)).."%" end
 self.view.settings.Motion.Text="GERAKAN DIKURANGI  /  "..(if self.reduced then "AKTIF" else "NONAKTIF")
 self.view.gui:SetAttribute("ReducedMotion",self.reduced)
end

function Menu:openPanel(name)
 if self.pending then return end
 self.panelName=name; self.view.gui:SetAttribute("Panel",name or "Main")
 if name then for page,frame in pairs(self.view.pages) do frame.Visible=page==name end end
 self.view.content.CanvasPosition=Vector2.zero
 if name then self.view.panelTitle.Text=({Chapters="PILIH CHAPTER",Archive="ARSIP SEJARAH",Settings="PENGATURAN",Credits="KREDIT"})[name] or "" end
 self.animation:panel(name)
 if GuiService.SelectedObject then GuiService.SelectedObject=if name then self.view.back else self.view.navigation.Start end
end

function Menu:send(action,chapterId)
 if self.pending then return end
 self.pending=true; self.requestId+=1; local token=self.requestId
 self.view.gui:SetAttribute("Pending",true)
 self.view.status.Text="Menghubungkan ke chapter…"
 self.animation:tween(self.view.overlay,0.15,{BackgroundTransparency=0})
 local ok,sent=pcall(self.request,action,chapterId)
 if not ok or not sent then self:requestFailed("Koneksi belum tersedia. Pilih Mulai untuk mencoba lagi."); return end
 task.delay(8,function()
  if self.visible and self.pending and token==self.requestId then
   self:requestFailed("Belum menerima balasan. Coba lagi.")
   pcall(self.request,"ready")
  end
 end)
end

function Menu:requestFailed(message)
 self.pending=false; self.view.gui:SetAttribute("Pending",false)
 self.view.status.Text=message
 self.animation:tween(self.view.overlay,0.15,{BackgroundTransparency=1})
 if self.panelName then self:openPanel(nil) end
end

function Menu:show(state)
 self.state=state; self.pending=false; self.requestId+=1
 local touchGui=self.player.PlayerGui:FindFirstChild("TouchGui")
 if touchGui then touchGui.Enabled=false end
 self.view.gui:SetAttribute("Pending",false)
 self.view.navigation.Resume:SetAttribute("Available",state.hasCheckpoint==true)
 self.view.navigation.Resume.Selectable=state.hasCheckpoint==true
 self.view.navigation.Resume.Active=state.hasCheckpoint==true
 self.view.navigation.Resume.Text=if state.hasCheckpoint then "LANJUTKAN" else "LANJUTKAN · BELUM ADA"
 self.animation:feedback(self.view.navigation.Resume,false)
 self.view.navigation.Start.Text=if state.loading then "COBA HUBUNGKAN" else "MULAI"
 self.view.status.Text=if state.loading then "Menunggu server. Anda tetap dapat membuka panel menu."
  elseif state.hasCheckpoint then "Checkpoint sesi: objektif "..tostring(state.checkpointIndex).." / 3."
  else "Tujuh perspektif. Satu rangkaian sejarah."
 if self.visible then self.animation:tween(self.view.overlay,0.15,{BackgroundTransparency=1}); return end
 self.visible=true; self.panelName=nil; self.view.gui.Enabled=true; self.view.gui.Shade.Visible=true; self.view.gui:SetAttribute("Panel","Main")
 self.view:layout()
 if not self.camera:start(self.environment) then self.view.status.Text="Latar belum tersedia. Menu tetap dapat digunakan." end
 self.animation:intro()
end

function Menu:hide()
 if not self.visible then return end
 self.visible=false; self.pending=false; self.requestId+=1; local token=self.requestId
 self.camera:stop(); self.animation:cancel()
 if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(self.view.gui) then GuiService.SelectedObject=nil end
 self.view.root.Visible=false; self.view.panel.Visible=false
 self.view.gui.Shade.Visible=false; self.view.overlay.BackgroundTransparency=0
 self.animation:tween(self.view.overlay,if self.reduced then 0.08 else 0.25,{BackgroundTransparency=1})
 task.delay(0.26,function()
  if token==self.requestId then self.view.gui.Enabled=false; self.view.gui.Shade.Visible=true end
 end)
end

function Menu:isVisible() return self.visible end
function Menu:refreshCamera() self.camera:refresh() end
function Menu:destroy()
 self.visible=false; self.requestId+=1; self.camera:stop(); self.animation:cancel()
 ContextActionService:UnbindAction("MainMenuNavigation")
 for _,connection in ipairs(self.connections) do connection:Disconnect() end
 self.view.resize:Disconnect(); self.view.gui:Destroy()
 if self.environment then self.environment:Destroy() end
 self.groups.Master:Destroy()
end

return Menu
