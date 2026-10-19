--!strict
local GuiService=game:GetService("GuiService")
local ContextActionService=game:GetService("ContextActionService")
local UserInputService=game:GetService("UserInputService")
local Config=require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("GameConfig"))
local Style=require(script.Parent.MenuStyle)
local Animation=require(script.Parent.MenuAnimationController)
local Lobby={}
Lobby.__index=Lobby

local function label(parent,name,value,size)
 local item=Instance.new("TextLabel");item.Name=name;item.Text=value;item.TextSize=size or 15
 item.FontFace=Style.body;item.TextColor3=Style.text;item.BackgroundTransparency=1
 item.TextXAlignment=Enum.TextXAlignment.Left;item.TextYAlignment=Enum.TextYAlignment.Top
 item.TextWrapped=true;item.Parent=parent
 return item
end

function Lobby.new(player,callback)
 local self=setmetatable({player=player,callback=callback,visible=false,connections={},handlers={},roleButtons={},memberRows={},animation=Animation.new()},Lobby)
 local gui=Instance.new("ScreenGui");gui.Name="LobbyGui";gui.ResetOnSpawn=false;gui.DisplayOrder=35
 gui.ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets;gui.ClipToDeviceSafeArea=true;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.Enabled=false
 self.gui=gui
 local root=Instance.new("Frame");root.Name="Root";root.Size=UDim2.fromScale(1,1);root.BackgroundTransparency=1;root.Parent=gui;self.root=root
 local panel=Instance.new("CanvasGroup");panel.Name="Panel";panel.AnchorPoint=Vector2.new(.5,.5);panel.Position=UDim2.fromScale(.5,.5)
 panel.BackgroundColor3=Style.background;panel.BackgroundTransparency=.02;panel.BorderSizePixel=0;panel.Parent=root;self.panel=panel
 local edge=Instance.new("UIStroke");edge.Color=Style.divider;edge.Transparency=.5;edge.Parent=panel
 self.eyebrow=label(panel,"Eyebrow","ENAM JAM: 1949 / PROLOG",11);self.eyebrow.Font=Enum.Font.RobotoMono;self.eyebrow.TextColor3=Style.accentText
 self.title=label(panel,"Title","Lobi Prolog",28);self.title.FontFace=Style.heading
 self.subtitle=label(panel,"Subtitle","Kota yang Diduduki · 1–4 pemain",14);self.subtitle.TextColor3=Style.secondary
 local content=Instance.new("ScrollingFrame");content.Name="Content";content.BackgroundTransparency=1;content.BorderSizePixel=0
 content.ScrollBarThickness=3;content.ScrollBarImageColor3=Style.accent;content.ScrollingDirection=Enum.ScrollingDirection.Y
 content.CanvasSize=UDim2.new();content.Selectable=false;content.Parent=panel;self.content=content
 self.memberHeading=label(content,"MemberHeading","KELOMPOK / 0 DARI 4",12);self.memberHeading.Font=Enum.Font.RobotoMono;self.memberHeading.TextColor3=Style.accentText
 for i=1,4 do
  local row=Instance.new("Frame");row.Name="Member"..i;row.BackgroundColor3=Style.surface;row.BackgroundTransparency=.4;row.BorderSizePixel=0;row.Parent=content
  local name=label(row,"DisplayName","Menunggu pemain",16);name.TextWrapped=false;name.TextTruncate=Enum.TextTruncate.AtEnd
  local role=label(row,"Role","—",13);role.TextColor3=Style.secondary;role.TextWrapped=false;role.TextTruncate=Enum.TextTruncate.AtEnd
  local ready=label(row,"Ready","",11);ready.Font=Enum.Font.RobotoMono;ready.TextXAlignment=Enum.TextXAlignment.Right
  table.insert(self.memberRows,{root=row,name=name,role=role,ready=ready})
 end
 self.roleHeading=label(content,"RoleHeading","PILIH PERAN FIKSI",12);self.roleHeading.Font=Enum.Font.RobotoMono;self.roleHeading.TextColor3=Style.accentText
 local function button(parent,name,title,handler)
  local item=Instance.new("TextButton");item.Name=name;item.Text=title;item.TextSize=15;item.FontFace=Style.control
  item.BackgroundColor3=Style.surface;item.BackgroundTransparency=.7;item.BorderSizePixel=0;item.AutoButtonColor=false
  item.TextColor3=Style.text;item.Selectable=true;item:SetAttribute("Available",true);item.Parent=parent
  local stroke=Instance.new("UIStroke");stroke.Name="Emphasis";stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Color=Style.accentText;stroke.Transparency=.7;stroke.Parent=item
  local focus=Instance.new("Frame");focus.Name="Focus";focus.Size=UDim2.fromScale(1,1);focus.BackgroundTransparency=1;focus.Parent=item;item.SelectionImageObject=focus
  self.handlers[item]=handler
  table.insert(self.connections,item.Activated:Connect(function() self:activate(item) end))
  table.insert(self.connections,item.MouseEnter:Connect(function() item:SetAttribute("PointerOver",true);self:feedback(item) end))
  table.insert(self.connections,item.MouseLeave:Connect(function() item:SetAttribute("PointerOver",false);self:feedback(item) end))
  table.insert(self.connections,item.SelectionGained:Connect(function() self:feedback(item);self:reveal(item) end))
  table.insert(self.connections,item.SelectionLost:Connect(function() self:feedback(item) end))
  return item
 end
 for _,role in ipairs(Config.roles) do
  local item=button(content,role.id,"",function() self:send("role",role.id) end);self.roleButtons[role.id]=item
  local name=label(item,"Character",role.name,19);name.FontFace=Style.heading
  label(item,"Role",role.role,14).TextColor3=Style.accentText
  label(item,"Description",role.description,13).TextColor3=Style.secondary
  local state=label(item,"State","",11);state.TextXAlignment=Enum.TextXAlignment.Right;state.TextColor3=Style.accentText
 end
 self.notice=label(content,"Notice","Pilih peran, lalu tandai siap. Tuan rumah memulai prolog setelah semua pemain siap.",14);self.notice.TextColor3=Style.secondary
 self.ready=button(panel,"Ready","Siap",function() self:send("ready",not self:member().ready) end)
 self.launch=button(panel,"Launch","Mulai prolog",function() self:send("launch") end)
 self.leave=button(panel,"Leave","Tinggalkan",function() self:send("leave") end)
 self.resize=root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() self:layout() end)
 ContextActionService:BindActionAtPriority("LobbyNavigation",function(_,state,input)
  if not self.visible or UserInputService:GetFocusedTextBox() or GuiService.MenuIsOpen then return Enum.ContextActionResult.Pass end
  if state~=Enum.UserInputState.Begin then return Enum.ContextActionResult.Sink end
  if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB then self:activate(self.leave)
  elseif input.KeyCode==Enum.KeyCode.Return or input.KeyCode==Enum.KeyCode.ButtonA then self:activate(self:selection())
  else
   local list=self:focusable();local index=table.find(list,GuiService.SelectedObject) or 0
   local backwards=input.KeyCode==Enum.KeyCode.Up or input.KeyCode==Enum.KeyCode.Left or input.KeyCode==Enum.KeyCode.DPadUp or input.KeyCode==Enum.KeyCode.DPadLeft
   if #list>0 then GuiService.SelectedObject=list[(index+(if backwards then -2 else 0))%#list+1] end
  end
  return Enum.ContextActionResult.Sink
 end,false,3200,Enum.KeyCode.Return,Enum.KeyCode.Escape,Enum.KeyCode.Up,Enum.KeyCode.Down,Enum.KeyCode.Left,Enum.KeyCode.Right,
  Enum.KeyCode.ButtonA,Enum.KeyCode.ButtonB,Enum.KeyCode.DPadUp,Enum.KeyCode.DPadDown,Enum.KeyCode.DPadLeft,Enum.KeyCode.DPadRight)
 gui.Parent=player.PlayerGui;self:layout()
 return self
end

function Lobby:member()
 for _,member in ipairs(if self.snapshot then self.snapshot.members else {}) do if member.userId==self.player.UserId then return member end end
 return nil
end

function Lobby:feedback(button)
 local enabled=button:GetAttribute("Available")==true
 local selected=enabled and (button:GetAttribute("PointerOver")==true or GuiService.SelectedObject==button)
 self.animation:tween(button,if self.animation.reduced then 0 else .14,{BackgroundTransparency=if selected then .35 else .7})
 self.animation:tween(button.Emphasis,if self.animation.reduced then 0 else .14,{Transparency=if selected or button:GetAttribute("Chosen") then .1 else .7})
end

function Lobby:available(button,enabled)
 button:SetAttribute("Available",enabled);button.Active=enabled;button.Selectable=enabled
 button.TextColor3=if enabled then Style.text else Style.muted
 self:feedback(button)
end

function Lobby:focusable()
 local list={};if not self.visible then return list end
 for _,role in ipairs(Config.roles) do local button=self.roleButtons[role.id];if button:GetAttribute("Available") then table.insert(list,button) end end
 for _,button in ipairs({self.ready,self.launch,self.leave}) do if button:GetAttribute("Available") then table.insert(list,button) end end
 return list
end

function Lobby:selection()
 local list=self:focusable()
 return if table.find(list,GuiService.SelectedObject) then GuiService.SelectedObject else list[1]
end

function Lobby:reveal(button)
 if not button:IsDescendantOf(self.content) then return end
 local canvas=self.content.CanvasPosition.Y
 local top=button.AbsolutePosition.Y-self.content.AbsolutePosition.Y+canvas
 if top<canvas then canvas=top elseif top+button.AbsoluteSize.Y>canvas+self.content.AbsoluteSize.Y then canvas=top+button.AbsoluteSize.Y-self.content.AbsoluteSize.Y end
 self.content.CanvasPosition=Vector2.new(0,math.clamp(canvas,0,math.max(0,self.content.AbsoluteCanvasSize.Y-self.content.AbsoluteSize.Y)))
end

function Lobby:activate(button)
 if not self.visible or not button or not table.find(self:focusable(),button) then return end
 self.handlers[button]()
end

function Lobby:send(action,value)
 if not self.visible or not self.snapshot or not self.snapshot.joined then return end
 local ok,sent=pcall(self.callback,action,self.snapshot.revision,value)
 if not ok or sent==false then self.notice.Text="Koneksi lobi belum tersedia. Coba lagi." end
end

function Lobby:show(snapshot)
 if self.snapshot and snapshot.revision<self.snapshot.revision then return end
 self.snapshot=snapshot
 if not snapshot.joined or snapshot.phase~="waiting" then self:hide();return end
 local opening=not self.visible;self.visible=true;self.gui.Enabled=true
 local member=self:member();local occupied={};local roles={}
 for _,role in ipairs(Config.roles) do roles[role.id]=role end
 self.memberHeading.Text="KELOMPOK / "..tostring(#snapshot.members).." DARI 4"
 for i,row in ipairs(self.memberRows) do
  local entry=snapshot.members[i]
  row.name.Text=if entry then entry.displayName..(if entry.userId==snapshot.hostUserId then " · HOST" else "") else "Menunggu pemain"
  row.role.Text=if entry and roles[entry.roleId] then roles[entry.roleId].role else "Belum memilih peran"
  row.ready.Text=if entry then (if entry.ready then "SIAP" else "BELUM") else ""
  row.ready.TextColor3=if entry and entry.ready then Style.accentText else Style.secondary
  if entry and entry.roleId then occupied[entry.roleId]=entry.userId end
 end
 for _,role in ipairs(Config.roles) do
  local button=self.roleButtons[role.id];local chosen=member~=nil and member.roleId==role.id
  local taken=occupied[role.id]~=nil and occupied[role.id]~=self.player.UserId
  button:SetAttribute("Chosen",chosen);button.State.Text=if chosen then "PILIHANMU" elseif taken then "DIPILIH" else ""
  self:available(button,not taken and member~=nil)
  button.Character.TextColor3=if taken then Style.muted else Style.text
 end
 self.ready.Text=if member and member.ready then "Batal siap" else "Siap"
 self:available(self.ready,member~=nil and roles[member.roleId]~=nil)
 self:available(self.launch,member~=nil and snapshot.hostUserId==self.player.UserId and snapshot.canStart==true)
 self:available(self.leave,true)
 self.notice.Text=if snapshot.notice and snapshot.notice~="" then snapshot.notice else "Pilih peran, lalu tandai siap. Tuan rumah memulai prolog setelah semua pemain siap."
 self:layout()
 if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(self.gui) and not table.find(self:focusable(),GuiService.SelectedObject) then GuiService.SelectedObject=self:selection() end
 if opening then
  self.content.CanvasPosition=Vector2.zero;self.animation:cancel();self.panel.GroupTransparency=1
  self.animation:tween(self.panel,if self.animation.reduced then 0 else .2,{GroupTransparency=0})
 end
end

function Lobby:layout()
 local w,h=self.root.AbsoluteSize.X,self.root.AbsoluteSize.Y;if w<1 or h<1 then return end
 local width,height=math.min(920,w-32),math.min(650,h-32);local narrow=width<650;local small=height<360
 local inset=if width<440 then 16 else 28
 self.panel.Size=UDim2.fromOffset(width,height)
 self.eyebrow.Position=UDim2.fromOffset(inset,if small then 8 else 20);self.eyebrow.Size=UDim2.new(1,-inset*2,0,16)
 self.title.Position=UDim2.fromOffset(inset,if small then 28 else 44);self.title.Size=UDim2.new(1,-inset*2,0,34);self.title.TextSize=if small then 24 else 28
 self.subtitle.Position=UDim2.fromOffset(inset,if small then 62 else 82);self.subtitle.Size=UDim2.new(1,-inset*2,0,22)
 local contentY=if small then 92 else 122
 self.content.Position=UDim2.fromOffset(inset,contentY);self.content.Size=UDim2.new(1,-inset*2,1,-contentY-76)
 local bodyWidth=width-inset*2-8;local left=if narrow then bodyWidth else math.floor(bodyWidth*.43)
 self.memberHeading.Position=UDim2.new();self.memberHeading.Size=UDim2.fromOffset(left,20)
 for i,row in ipairs(self.memberRows) do
  row.root.Position=UDim2.fromOffset(0,30+(i-1)*64);row.root.Size=UDim2.fromOffset(left,56)
  row.name.Position=UDim2.fromOffset(12,8);row.name.Size=UDim2.new(1,-86,0,20)
  row.role.Position=UDim2.fromOffset(12,32);row.role.Size=UDim2.new(1,-24,0,18)
  row.ready.Position=UDim2.new(1,-68,0,10);row.ready.Size=UDim2.fromOffset(56,18)
 end
 local roleX,roleY=if narrow then 0 else left+24,if narrow then 304 else 0
 local roleWidth=bodyWidth-roleX
 self.roleHeading.Position=UDim2.fromOffset(roleX,roleY);self.roleHeading.Size=UDim2.fromOffset(roleWidth,20)
 for i,role in ipairs(Config.roles) do
  local button=self.roleButtons[role.id];button.Position=UDim2.fromOffset(roleX,roleY+30+(i-1)*112);button.Size=UDim2.fromOffset(roleWidth,104)
  button.Character.Position=UDim2.fromOffset(12,8);button.Character.Size=UDim2.new(1,-112,0,26)
  button.Role.Position=UDim2.fromOffset(12,36);button.Role.Size=UDim2.new(1,-24,0,22)
  button.Description.Position=UDim2.fromOffset(12,62);button.Description.Size=UDim2.new(1,-24,0,36)
  button.State.Position=UDim2.new(1,-100,0,14);button.State.Size=UDim2.fromOffset(88,18)
 end
 local noteY=roleY+30+#Config.roles*112+12
 self.notice.Position=UDim2.fromOffset(0,noteY);self.notice.Size=UDim2.fromOffset(bodyWidth,if narrow then 100 else 64)
 self.content.CanvasSize=UDim2.fromOffset(0,noteY+(if narrow then 108 else 72))
 local actionWidth=(width-inset*2-16)/3
 for i,button in ipairs({self.ready,self.launch,self.leave}) do
  button.Position=UDim2.new(0,inset+(i-1)*(actionWidth+8),1,-60);button.Size=UDim2.fromOffset(actionWidth,44);button.TextSize=if width<440 then 13 else 15
 end
end

function Lobby:setReduced(value)
 self.animation.reduced=value==true;self.animation:cancel();self.panel.GroupTransparency=0
end

function Lobby:hide()
 self.visible=false;self.animation:cancel();self.gui.Enabled=false
 if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(self.gui) then GuiService.SelectedObject=nil end
end

function Lobby:destroy()
 self:hide();ContextActionService:UnbindAction("LobbyNavigation");self.resize:Disconnect();self.animation:destroy()
 for _,connection in ipairs(self.connections) do connection:Disconnect() end
 self.gui:Destroy()
end

return Lobby
