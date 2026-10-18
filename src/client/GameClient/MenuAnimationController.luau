--!strict
local TweenService=game:GetService("TweenService")
local Animation={}
Animation.__index=Animation
function Animation.new(view) return setmetatable({view=view,tweens={},targets={},generation=0,reduced=false},Animation) end

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

function Animation:cancel()
 self.generation+=1
 local active={}
 for tween in pairs(self.tweens) do table.insert(active,tween) end
 for _,tween in ipairs(active) do tween:Cancel() end
 table.clear(self.tweens); table.clear(self.targets)
 self.view.overlay.BackgroundTransparency=1
 self.view.brand.GroupTransparency=0
 if self.view.brandPadding then self.view.brandPadding.PaddingTop=UDim.new() end
 self.view.meta.TextTransparency=0
 for _,button in pairs(self.view.navigation) do
  button.TextTransparency=0
  local padding=button:FindFirstChildOfClass("UIPadding")
  if padding then padding.PaddingLeft=UDim.new(0,16) end
 end
end

function Animation:intro()
 self:cancel()
 local view,token=self.view,self.generation
 view.root.Visible=true; view.root.GroupTransparency=0; view.panel.Visible=false
 view.overlay.BackgroundTransparency=0
 self:tween(view.overlay,if self.reduced then 0.08 else 0.6,{BackgroundTransparency=1})
 if self.reduced then return end
 view.brand.GroupTransparency=1; view.meta.TextTransparency=1
 if view.brandPadding then view.brandPadding.PaddingTop=UDim.new(0,6); self:tween(view.brandPadding,0.7,{PaddingTop=UDim.new()}) end
 self:tween(view.brand,0.7,{GroupTransparency=0})
 for i,name in ipairs(view.order) do
  local button=view.navigation[name]; button.TextTransparency=1
  local padding=button:FindFirstChildOfClass("UIPadding")
  if padding then padding.PaddingLeft=UDim.new(0,10) end
  task.delay(0.12+i*0.055,function()
   if token==self.generation then
    self:tween(button,0.28,{TextTransparency=0})
    if padding then self:tween(padding,0.28,{PaddingLeft=UDim.new(0,if button:GetAttribute("Highlighted") then 22 else 16)}) end
   end
  end)
 end
 task.delay(0.6,function() if token==self.generation then self:tween(view.meta,0.4,{TextTransparency=0}) end end)
end

function Animation:panel(name)
 self:cancel()
 local view,token=self.view,self.generation
 local opening=name~=nil
 local incoming=if opening then view.panel else view.root
 local outgoing=if view.root.Visible then view.root elseif view.panel.Visible then view.panel else nil
 view.root.Position=UDim2.new(); view.panel.Position=UDim2.fromScale(0.5,0.5)
 local function reveal()
  if token~=self.generation then return end
  view.root.Visible=not opening; view.panel.Visible=opening
  incoming.GroupTransparency=1
  local target=incoming.Position
  if not self.reduced then incoming.Position=target+UDim2.fromOffset(8,0) end
  self:tween(incoming,if self.reduced then 0.08 else 0.22,{GroupTransparency=0,Position=target})
 end
 if outgoing and outgoing~=incoming then
  local duration=if self.reduced then 0.04 else 0.1
  self:tween(outgoing,duration,{GroupTransparency=1})
  task.delay(duration,reveal)
 else reveal() end
end

function Animation:feedback(button,selected)
 local available=button:GetAttribute("Available")~=false
 button:SetAttribute("Highlighted",selected and available)
 self:tween(button,0.16,{BackgroundTransparency=if selected and available then 0.78 else 1,TextColor3=if not available then Color3.fromRGB(143,153,149) elseif selected then Color3.fromRGB(255,239,206) else Color3.fromRGB(232,226,208)})
 local padding=button:FindFirstChildOfClass("UIPadding")
 if padding then self:tween(padding,0.16,{PaddingLeft=UDim.new(0,if selected and available and not self.reduced then 22 else 16)}) end
 local line=button:FindFirstChild("Indicator")
 if line then self:tween(line,0.16,{BackgroundTransparency=if selected and available then 0 else 1,Size=UDim2.fromOffset(2,if selected and available then 24 else 10)}) end
end

return Animation
