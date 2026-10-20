local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local shared=RS:WaitForChild("EnamJamLobby")
if not require(shared:WaitForChild("Config")).Enabled then return end
local remote=shared:WaitForChild("Event")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="EnamJamLobbyUI";gui.ResetOnSpawn=false;gui.DisplayOrder=25;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=player:WaitForChild("PlayerGui")
local startup=require(player.PlayerScripts:WaitForChild("GameClient"):WaitForChild("LobbyStartupMenu")).new(player,gui)
script.Destroying:Connect(function()startup:destroy()end)
local colors={dark=Color3.fromRGB(25,30,25),paper=Color3.fromRGB(234,226,205),muted=Color3.fromRGB(174,180,161),accent=Color3.fromRGB(190,145,85)}
local function make(class,parent,props)
 local obj=Instance.new(class)
 for k,v in pairs(props or {}) do obj[k]=v end
 obj.Parent=parent;return obj
end
local function panel(name,pos,size,anchor)
 local f=make("Frame",gui,{Name=name,Position=pos,Size=size,AnchorPoint=anchor or Vector2.zero,BackgroundColor3=colors.dark,BorderSizePixel=0})
 make("UICorner",f,{CornerRadius=UDim.new(0,5)})
 make("UIStroke",f,{Color=colors.accent,Transparency=0.45,Thickness=1})
 return f
end
local function label(parent,name,text,pos,size,textSize,color)
 return make("TextLabel",parent,{Name=name,Text=text,Position=pos,Size=size,BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=textSize or 14,TextColor3=color or colors.paper,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center})
end
local function button(parent,name,text,pos,size)
 local b=make("TextButton",parent,{Name=name,Text=text,Position=pos,Size=size,BackgroundColor3=colors.accent,TextColor3=colors.dark,Font=Enum.Font.GothamBold,TextSize=14,BorderSizePixel=0,AutoButtonColor=true})
 make("UICorner",b,{CornerRadius=UDim.new(0,4)})
 return b
end
local guide=panel("BriefingGuide",UDim2.new(0,16,0,16),UDim2.new(0.34,0,0,125))
make("UISizeConstraint",guide,{MinSize=Vector2.new(210,125),MaxSize=Vector2.new(360,125)})
label(guide,"Title","ENAM JAM / 1949",UDim2.fromOffset(16,8),UDim2.new(1,-32,0,24),17,colors.accent).Font=Enum.Font.GothamBold
label(guide,"Section","POS PERSIAPAN · YOGYAKARTA",UDim2.fromOffset(16,33),UDim2.new(1,-32,0,18),10,colors.muted)
local taskLabel=label(guide,"Task","01 / 03   Baca dokumen di meja.",UDim2.fromOffset(16,56),UDim2.new(1,-32,0,54),14)
local queuePanel=panel("QueuePanel",UDim2.new(0.5,0,1,-20),UDim2.new(0.9,0,0,126),Vector2.new(0.5,1))
make("UISizeConstraint",queuePanel,{MaxSize=Vector2.new(460,126)})
queuePanel.Visible=false
local queueTitle=label(queuePanel,"Title","POS KEBERANGKATAN",UDim2.fromOffset(16,8),UDim2.new(1,-32,0,24),12,colors.accent)
local queueText=label(queuePanel,"Countdown","",UDim2.fromOffset(16,32),UDim2.new(1,-32,0,34),19)
local leave=button(queuePanel,"Leave","Keluar Antrean",UDim2.new(0,16,1,-46),UDim2.new(1,-32,0,34))
leave.Activated:Connect(function() remote:FireServer("leave") end)
local toast=panel("Notice",UDim2.new(0.5,0,0,155),UDim2.new(0.88,0,0,60),Vector2.new(0.5,0))
make("UISizeConstraint",toast,{MaxSize=Vector2.new(560,60)})
local toastText=label(toast,"Message","",UDim2.fromOffset(14,4),UDim2.new(1,-28,1,-8),14)
toast.Visible=false
local toastRevision=0
local function notify(message)
 if message=="" then return end
 toastRevision+=1;local revision=toastRevision
 toastText.Text=message;toast.Visible=true
 task.delay(5,function() if toastRevision==revision then toast.Visible=false end end)
end
local testPanel=panel("TestPanel",UDim2.new(0.5,0,1,-20),UDim2.new(0.9,0,0,145),Vector2.new(0.5,1))
make("UISizeConstraint",testPanel,{MaxSize=Vector2.new(540,145)})
label(testPanel,"Title","AREA UJI / SIMULASI LOKAL",UDim2.fromOffset(16,8),UDim2.new(1,-32,0,24),13,colors.accent)
label(testPanel,"Description","Map permainan sedang dikembangkan. Perpindahan ini belum memakai teleport antartempat.",UDim2.fromOffset(16,36),UDim2.new(1,-32,0,50),14)
button(testPanel,"Return","Kembali ke Lobby",UDim2.new(0,16,1,-45),UDim2.new(1,-32,0,33)).Activated:Connect(function() remote:FireServer("return") end)
testPanel.Visible=false
local shade=make("Frame",gui,{Name="StoryShade",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(),BackgroundTransparency=0.3,Visible=false,Active=true,ZIndex=5})
local card=make("Frame",shade,{Name="StoryCard",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(0.9,0.83),BackgroundColor3=colors.paper,BorderSizePixel=0,ZIndex=6})
make("UISizeConstraint",card,{MaxSize=Vector2.new(640,520)})
label(card,"Overline","ARSIP LAPANGAN · ENAM JAM 1949",UDim2.fromOffset(24,14),UDim2.new(1,-48,0,26),11,Color3.fromRGB(115,80,40)).ZIndex=7
local storyTitle=label(card,"Title","",UDim2.fromOffset(24,44),UDim2.new(1,-48,0,40),24,colors.dark);storyTitle.ZIndex=7;storyTitle.Font=Enum.Font.GothamBold
local scroll=make("ScrollingFrame",card,{Name="ReadingArea",Position=UDim2.fromOffset(24,96),Size=UDim2.new(1,-48,1,-170),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ZIndex=7})
local storyText=label(scroll,"Body","",UDim2.fromOffset(0,0),UDim2.new(1,-12,0,0),16,colors.dark)
storyText.AutomaticSize=Enum.AutomaticSize.Y;storyText.TextYAlignment=Enum.TextYAlignment.Top;storyText.ZIndex=8;storyText.LineHeight=1.3
local close=button(card,"Close","Selesai Membaca",UDim2.new(0,24,1,-55),UDim2.new(1,-48,0,38));close.ZIndex=8
local openedStory
close.Activated:Connect(function()
 shade.Visible=false
 if openedStory then remote:FireServer("storyClosed",openedStory);openedStory=nil end
end)
local queueSnapshot
local steps={"01 / 03   Baca dokumen di meja.","02 / 03   Periksa radio di dalam rumah.","03 / 03   Baca papan briefing.","Briefing selesai. Pilih salah satu dari lima pos di luar rumah."}
remote.OnClientEvent:Connect(function(kind,data)
 if kind=="queue" then
  queueSnapshot=data or nil;queuePanel.Visible=data~=false and data~=nil
 elseif kind=="briefing" then taskLabel.Text=steps[math.clamp(data,1,4)]
 elseif kind=="story" then
  openedStory=data.id;storyTitle.Text=data.title;storyText.Text=data.text;scroll.CanvasPosition=Vector2.zero;shade.Visible=true
 elseif kind=="test" then
  queueSnapshot=nil;queuePanel.Visible=false;testPanel.Visible=true;notify(data)
 elseif kind=="returned" then testPanel.Visible=false;queueSnapshot=nil;queuePanel.Visible=false;notify(data)
 elseif kind=="departing" then queuePanel.Visible=false;notify(data)
 elseif kind=="notice" or kind=="error" then notify(data)
 end
end)
RunService.RenderStepped:Connect(function()
 if queueSnapshot then
  queueTitle.Text=string.format("POS %02d  /  %d DARI %d PEMAIN",queueSnapshot.index,queueSnapshot.count,queueSnapshot.capacity)
  local remaining=math.max(0,math.ceil((queueSnapshot.deadline or workspace:GetServerTimeNow())-workspace:GetServerTimeNow()))
  queueText.Text=queueSnapshot.locked and "Menyiapkan keberangkatan…" or string.format("Berangkat dalam %02d detik",remaining)
  leave.Visible=not queueSnapshot.locked
 end
end)
remote:FireServer("ready")
