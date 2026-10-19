--!strict
local SoundService=game:GetService("SoundService")
local GuiService=game:GetService("GuiService")
local ContextActionService=game:GetService("ContextActionService")
local UserInputService=game:GetService("UserInputService")
local Style=require(script.Parent.MenuStyle)
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
  local slider=self.view.settings[name.."Slider"]
  bind(slider,function() end)
  table.insert(self.connections,slider.InputBegan:Connect(function(input)
   if not self.visible or self.pending or self.panelName~="Settings" or self.drag then return end
   if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
    self.drag={slider=slider,input=input};self:updateSliderInput(slider,input.Position.X)
   end
  end))
 end
 table.insert(self.connections,UserInputService.InputChanged:Connect(function(input)
  local drag=self.drag
  if drag and (input==drag.input or (drag.input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then
   self:updateSliderInput(drag.slider,input.Position.X)
  end
 end))
 table.insert(self.connections,UserInputService.InputEnded:Connect(function(input)
  if self.drag and input==self.drag.input then self.drag=nil end
 end))
 table.insert(self.connections,UserInputService.WindowFocusReleased:Connect(function() self.drag=nil end))
 -- CoreGui consumes arrow Begin events for selected GuiObjects before context actions.
 table.insert(self.connections,UserInputService.InputBegan:Connect(function(input)
  if UserInputService:GetFocusedTextBox() or GuiService.MenuIsOpen then return end
  local left=input.KeyCode==Enum.KeyCode.Left or input.KeyCode==Enum.KeyCode.DPadLeft
  local right=input.KeyCode==Enum.KeyCode.Right or input.KeyCode==Enum.KeyCode.DPadRight
  if left or right then self:stepSlider(GuiService.SelectedObject,if left then -1 else 1) end
 end))
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
   local right=key.KeyCode==Enum.KeyCode.Right or key.KeyCode==Enum.KeyCode.DPadRight
   local left=key.KeyCode==Enum.KeyCode.Left or key.KeyCode==Enum.KeyCode.DPadLeft
   local selected=GuiService.SelectedObject
   if (left or right) and self.panelName=="Settings" and selected and selected:GetAttribute("SettingName") then return Enum.ContextActionResult.Sink end
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
  self.animation:press(button)
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
   for _,name in ipairs({"MasterSlider","AmbientSlider","UISlider","Motion"}) do table.insert(list,self.view.settings[name]) end
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
 local duration=if self.reduced then 0 else .08
 for name,value in pairs(self.volumes) do
  self.view.settings[name.."Value"].Text=tostring(math.round(value*100)).."%"
  local track=self.view.settings[name.."Slider"].Track
  track.Fill.Size=UDim2.fromScale(value,1)
  track.Handle.Position=UDim2.fromScale(value,.5)
 end
 local motion=self.view.settings.Motion
 motion:SetAttribute("On",self.reduced);motion.State.Text=if self.reduced then "Aktif" else "Nonaktif"
 self.animation:tween(motion.Switch,duration,{BackgroundColor3=if self.reduced then Style.accent else Style.divider})
 self.animation:tween(motion.Switch.Thumb,duration,{Position=UDim2.fromOffset(if self.reduced then 23 else 3,3)})
 self.view.gui:SetAttribute("ReducedMotion",self.reduced)
end

function Menu:setVolume(name,value)
 self.volumes[name]=math.round(math.clamp(value,0,1)*100)/100
 self.groups[name].Volume=self.volumes[name]
 self:updateSettings()
end

function Menu:updateSliderInput(slider,x)
 if not self.visible or self.pending or self.panelName~="Settings" then return end
 local name=slider:GetAttribute("SettingName")
 local track=slider.Track
 if name and track.AbsoluteSize.X>0 then self:setVolume(name,(x-track.AbsolutePosition.X)/track.AbsoluteSize.X) end
end

function Menu:stepSlider(button,direction)
 if not self.visible or self.pending or self.panelName~="Settings" or not button then return false end
 local name=button:GetAttribute("SettingName")
 if not name or not self.volumes[name] then return false end
 self:setVolume(name,self.volumes[name]+direction*.1)
 return true
end

function Menu:openPanel(name)
 if self.pending then return end
 self.drag=nil
 self.panelName=name; self.view.gui:SetAttribute("Panel",name or "Main")
 if name then for page,frame in pairs(self.view.pages) do frame.Visible=page==name end end
 self.view.content.CanvasPosition=Vector2.zero
 if name then
  self.view.eyebrow.Text=({Chapters="03 / PILIH CHAPTER",Archive="04 / ARSIP SEJARAH",Settings="05 / PENGATURAN",Credits="06 / KREDIT"})[name] or ""
  self.view.panelTitle.Text=({Chapters="Tujuh perspektif",Archive="Koleksi sejarah",Settings="Preferensi permainan",Credits="Di balik cerita"})[name] or ""
  self.view.panelFooter.Text=self.view.pageMeta[name] or ""
 end
 self.view:layout()
 self.animation:panel(name)
 if name=="Settings" then self:updateSettings() end
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
 self.view.navigation.Resume.Text="LANJUTKAN"
 self.view.resumeNote.Visible=not state.hasCheckpoint
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
 self.visible=false; self.pending=false; self.drag=nil;self.requestId+=1; local token=self.requestId
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
 self.visible=false; self.drag=nil;self.requestId+=1; self.camera:stop(); self.animation:destroy()
 ContextActionService:UnbindAction("MainMenuNavigation")
 for _,connection in ipairs(self.connections) do connection:Disconnect() end
 self.view.resize:Disconnect(); self.view.gui:Destroy()
 if self.environment then self.environment:Destroy() end
 self.groups.Master:Destroy()
end

return Menu
