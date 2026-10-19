--!strict
local TweenService=game:GetService("TweenService")
local Style=require(script.Parent.MenuStyle)
local Animation={}
Animation.__index=Animation
function Animation.new(view)
 local self=setmetatable({view=view,tweens={},targets={},generation=0,reduced=false},Animation)
 self.resize=view.root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
  self:later(0,function() self:marker(self.selectedNav or view.navigation.Start,true) end)
 end)
 return self
end

function Animation:tween(object,duration,values)
 local targets=self.targets[object]
 if not targets then targets={}; self.targets[object]=targets end
 for property in pairs(values) do if targets[property] then targets[property]:Cancel() end end
 local tween=TweenService:Create(object,TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),values)
 for property in pairs(values) do targets[property]=tween end
 self.tweens[tween]=true
 tween.Completed:Once(function()
  self.tweens[tween]=nil
  for property in pairs(values) do if targets[property]==tween then targets[property]=nil end end
 end)
 tween:Play(); return tween
end

function Animation:later(delay,callback)
 local token=self.generation
 task.delay(delay,function() if token==self.generation then callback() end end)
end

function Animation:marker(button,snap)
 if not button or button:GetAttribute("Available")==false then button=self.view.navigation.Start end
 local line=self.view.selectionMarker
 self:tween(line,if snap or self.reduced then 0 else .24,{Position=button.Position+UDim2.fromOffset(30,22)})
 if not snap then self:tween(line,if self.reduced then .08 else .18,{BackgroundTransparency=0}) end
end

function Animation:settlePanel()
 local view=self.view
 view.eyebrow.TextTransparency=0;view.panelTitle.TextTransparency=0;view.back.TextTransparency=0;view.panelFooter.TextTransparency=0
 view.panelRule.BackgroundTransparency=0;view.footerRule.BackgroundTransparency=0
 for _,page in pairs(view.pages) do page.GroupTransparency=0;page.Position=UDim2.new() end
end

function Animation:cancel(keepPose)
 self.generation+=1
 local active={}
 for tween in pairs(self.tweens) do table.insert(active,tween) end
 for _,tween in ipairs(active) do tween:Cancel() end
 table.clear(self.tweens); table.clear(self.targets)
 local view=self.view
 view.overlay.BackgroundTransparency=1; view.brand.GroupTransparency=0
 view.brandPadding.PaddingTop=UDim.new(); view.meta.TextTransparency=0
 for _,label in ipairs({view.kicker,view.year,view.subtitle,view.status}) do label.TextTransparency=0 end
 view.brandRule.BackgroundTransparency=0
 view.selectionMarker.BackgroundTransparency=0
 for _,button in pairs(view.navigation) do
  button.TextTransparency=0; button.Index.TextTransparency=0
  local note=button:FindFirstChild("StateNote");if note then note.TextTransparency=0 end
  button.Indicator.BackgroundTransparency=1
  button:FindFirstChildOfClass("UIPadding").PaddingLeft=UDim.new(0,button:GetAttribute("RestPadding")+(if button:GetAttribute("Highlighted") and not self.reduced then 4 else 0))
 end
 if not keepPose then
  view.root.Position=UDim2.new();view.panel.Position=UDim2.fromScale(.5,.5);self:settlePanel()
 end
end

function Animation:intro()
 self:cancel()
 local view=self.view
 view.root.Visible=true; view.root.GroupTransparency=0; view.panel.Visible=false
 view.overlay.BackgroundTransparency=0
 self:tween(view.overlay,if self.reduced then .08 else .85,{BackgroundTransparency=1})
 self.selectedNav=nil
 for _,button in pairs(view.navigation) do self:feedback(button,false) end
 self:marker(view.navigation.Start,true)
 if self.reduced then self:marker(view.navigation.Start,false);return end
 view.selectionMarker.BackgroundTransparency=1
 for _,label in ipairs({view.kicker,view.year,view.subtitle,view.status}) do label.TextTransparency=1 end
 view.brandRule.BackgroundTransparency=1;view.meta.TextTransparency=1
 view.brandPadding.PaddingTop=UDim.new(0,8)
 self:later(.16,function() self:tween(view.year,.75,{TextTransparency=0});self:tween(view.brandPadding,.75,{PaddingTop=UDim.new()}) end)
 self:later(.25,function() self:tween(view.kicker,.4,{TextTransparency=0}) end)
 self:later(.38,function() self:tween(view.subtitle,.48,{TextTransparency=0}) end)
 self:later(.48,function() self:tween(view.status,.48,{TextTransparency=0}) end)
 self:later(.6,function() self:tween(view.brandRule,.4,{BackgroundTransparency=0}) end)
 for i,name in ipairs(view.order) do
  local button=view.navigation[name]
  button.TextTransparency=1;button.Index.TextTransparency=1
  local note=button:FindFirstChild("StateNote");if note then note.TextTransparency=1 end
  local padding=button:FindFirstChildOfClass("UIPadding");local rest=button:GetAttribute("RestPadding")
  padding.PaddingLeft=UDim.new(0,rest-4)
  self:later(.6+(i-1)*.075,function()
   self:tween(button,.24,{TextTransparency=0});self:tween(button.Index,.24,{TextTransparency=0})
   if note then self:tween(note,.24,{TextTransparency=0}) end
   self:tween(padding,.24,{PaddingLeft=UDim.new(0,rest+(if button:GetAttribute("Highlighted") then 4 else 0))})
  end)
 end
 self:later(.95,function() self:tween(view.meta,.3,{TextTransparency=0}) end)
 self:later(1.05,function() self:marker(self.selectedNav or view.navigation.Start,false) end)
end

function Animation:panel(name)
 self:cancel(true)
 local view=self.view
 local opening=name~=nil
 local incoming=if opening then view.panel else view.root
 local outgoing=if view.root.Visible then view.root elseif view.panel.Visible then view.panel else nil
 local target=if opening then UDim2.fromScale(.5,.5) else UDim2.new()
 local fresh=incoming~=outgoing or self.panelPage~=name
 self.panelPage=name
 local function reveal()
  view.root.Visible=not opening; view.panel.Visible=opening
  if incoming~=outgoing then
   incoming.GroupTransparency=1
   incoming.Position=target+(if self.reduced then UDim2.new() else UDim2.fromOffset(0,if opening then 6 else 8))
  end
  self:tween(incoming,if self.reduced then .08 elseif opening then .30 else .18,{GroupTransparency=0,Position=target})
  if not opening then self:settlePanel();return end
  if self.reduced then self:settlePanel();return end
  local page=view.pages[name]
  if fresh then
   view.eyebrow.TextTransparency=1;view.panelTitle.TextTransparency=1;view.back.TextTransparency=1;view.panelFooter.TextTransparency=1
   view.panelRule.BackgroundTransparency=1;view.footerRule.BackgroundTransparency=1
   page.GroupTransparency=1;page.Position=UDim2.fromOffset(0,6)
  end
  self:later(.02,function()
   self:tween(view.eyebrow,.18,{TextTransparency=0});self:tween(view.panelTitle,.18,{TextTransparency=0})
  end)
  self:later(.06,function() self:tween(view.panelRule,.16,{BackgroundTransparency=0}) end)
  self:later(.10,function() self:tween(page,.22,{GroupTransparency=0,Position=UDim2.new()}) end)
  self:later(.16,function()
   self:tween(view.footerRule,.16,{BackgroundTransparency=0});self:tween(view.panelFooter,.16,{TextTransparency=0})
  end)
  self:later(.18,function() self:tween(view.back,.16,{TextTransparency=0}) end)
 end
 if outgoing and outgoing~=incoming then
  local duration=if self.reduced then .04 elseif outgoing==view.panel then .24 else .08
  if outgoing==view.panel and not self.reduced then
   for _,page in pairs(view.pages) do if page.Visible then self:tween(page,.16,{GroupTransparency=1,Position=UDim2.fromOffset(0,-4)}) end end
   self:tween(outgoing,duration,{GroupTransparency=1,Position=UDim2.fromScale(.5,.5)+UDim2.fromOffset(0,6)})
  else self:tween(outgoing,duration,{GroupTransparency=1}) end
  self:later(duration,reveal)
 else reveal() end
end

function Animation:feedback(button,selected)
 local available=button:GetAttribute("Available")~=false
 local highlighted=selected and available
 button:SetAttribute("Highlighted",highlighted)
 local slider=button:GetAttribute("SettingName")~=nil
 self:tween(button,.18,{BackgroundTransparency=if highlighted and not slider then .72 else button:GetAttribute("SurfaceAlpha") or 1,TextColor3=if not available then Style.muted elseif highlighted then Style.text else Style.text:Lerp(Style.secondary,.18)})
 if slider then
  self:tween(button.Track.Handle.FocusRing,.18,{Transparency=if highlighted then 0 else 1})
  self:tween(button.Track.Handle,.18,{BackgroundColor3=if highlighted then Style.accent else Style.text})
  return
 end
 local padding=button:FindFirstChildOfClass("UIPadding")
 local rest=button:GetAttribute("RestPadding") or 12
 if padding then self:tween(padding,.18,{PaddingLeft=UDim.new(0,rest+(if highlighted and not self.reduced and not button:GetAttribute("FixedText") then 4 else 0))}) end
 local index=button:FindFirstChild("Index")
 if index then self:tween(index,.18,{TextColor3=if highlighted then Style.accentText else Style.secondary}) end
 if button.Parent==self.view.nav then
  if highlighted then
   local previous=self.selectedNav;self.selectedNav=button
   if previous and previous~=button then self:feedback(previous,false) end
   self:marker(button,false)
  elseif self.selectedNav==button and not available then self.selectedNav=nil;self:marker(self.view.navigation.Start,false) end
 else
  local emphasis=button:FindFirstChild("Emphasis")
  if emphasis then self:tween(emphasis,.16,{Color=if highlighted then Style.accentText else Style.divider,Transparency=if highlighted then .1 else .7}) end
  local line=button:FindFirstChild("Indicator")
  if line then self:tween(line,.18,{BackgroundTransparency=if highlighted then 0 else 1,Size=UDim2.fromOffset(2,if highlighted then 24 else 10)}) end
 end
end

function Animation:press(button)
 self:feedback(button,true)
 if button:GetAttribute("SettingName") then return end
 self:tween(button,.09,{BackgroundTransparency=.52})
 self:later(.1,function() self:feedback(button,button:GetAttribute("Highlighted")==true) end)
end

function Animation:destroy()
 self:cancel();self.resize:Disconnect()
end

return Animation
