--!strict
assert(game.PlaceId == 97995024632294,"Hanya untuk target 1965: Tujuh Perspektif")
assert(not workspace:FindFirstChild("ActiveScene"),"ActiveScene sudah ada; tidak ditimpa")
assert(not game.StarterGui:FindFirstChild("GameGui"),"GameGui sudah ada; tidak ditimpa")
local scene = Instance.new("Model")
scene.Name = "ActiveScene"
scene:SetAttribute("VS01Generated",true)
local function part(name,size,position,color,parent)
 local object=Instance.new("Part")
 object.Name=name; object.Size=size; object.Position=position
 object.Anchored=true; object.Color=color; object.Material=Enum.Material.SmoothPlastic
 object.TopSurface=Enum.SurfaceType.Smooth; object.BottomSurface=Enum.SurfaceType.Smooth
 object.Parent=parent or scene
 return object
end
local sand=Color3.fromRGB(177,164,139)
local wood=Color3.fromRGB(93,70,51)
part("Floor",Vector3.new(32,1,40),Vector3.new(0,0,-40),Color3.fromRGB(116,107,91))
part("BackWall",Vector3.new(32,10,1),Vector3.new(0,5.5,-60),sand)
part("LeftWall",Vector3.new(1,10,40),Vector3.new(-16,5.5,-40),sand)
part("RightWall",Vector3.new(1,10,40),Vector3.new(16,5.5,-40),sand)
part("EntryLeft",Vector3.new(13,10,1),Vector3.new(-9.5,5.5,-20),sand)
part("EntryRight",Vector3.new(13,10,1),Vector3.new(9.5,5.5,-20),sand)
part("DoorLintel",Vector3.new(6,2,1),Vector3.new(0,9.5,-20),sand)
for _,x in ipairs({-8,8}) do
 part("WindowFrame",Vector3.new(0.2,4.6,7),Vector3.new(x*1.98,6,-43),wood)
 part("WindowGlass",Vector3.new(0.24,3.8,6.2),Vector3.new(x*1.98,6,-43),Color3.fromRGB(133,157,160))
end
local function desk(name,x,z)
 part(name.."Top",Vector3.new(7,0.5,4),Vector3.new(x,3,-z),wood)
 for _,dx in ipairs({-2.8,2.8}) do
  for _,dz in ipairs({-1.3,1.3}) do part(name.."Leg",Vector3.new(0.4,2.5,0.4),Vector3.new(x+dx,1.5,-z+dz),wood) end
 end
end
desk("ReadingDesk",-8,33)
desk("RadioDesk",8,44)
local card=part("ProfileCard",Vector3.new(3,0.2,2),Vector3.new(-8,3.4,-33),Color3.fromRGB(223,213,184))
local radio=part("Radio",Vector3.new(4,2.5,2),Vector3.new(8,4.5,-44),wood)
part("RadioFace",Vector3.new(3.5,1.7,0.1),Vector3.new(8,4.5,-42.96),Color3.fromRGB(43,43,39),radio)
local board=part("ContextBoard",Vector3.new(8,5,0.3),Vector3.new(0,5.5,-58.9),Color3.fromRGB(49,61,54))
local sign=Instance.new("SurfaceGui")
sign.Face=Enum.NormalId.Back; sign.CanvasSize=Vector2.new(600,350); sign.Parent=board
local boardText=Instance.new("TextLabel")
boardText.Size=UDim2.fromScale(1,1); boardText.BackgroundTransparency=1
boardText.Text="PAPAN KONTEKS\n\nPROTOTIPE TEKNIS\n\nFAKTA · KESAKSIAN · DRAMATISASI"
boardText.TextColor3=Color3.fromRGB(232,224,199); boardText.TextSize=30
boardText.Font=Enum.Font.Gotham; boardText.TextWrapped=true; boardText.Parent=sign
local function interact(object,id,title)
 object:SetAttribute("InteractionId",id)
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="Interact"; prompt.ObjectText=title; prompt.ActionText="Periksa"
 prompt.KeyboardKeyCode=Enum.KeyCode.E; prompt.MaxActivationDistance=8
 prompt.HoldDuration=0; prompt.RequiresLineOfSight=true; prompt.ClickablePrompt=true
 prompt.Parent=object
end
interact(card,"profile","Kartu pengenalan")
interact(radio,"radio","Radio placeholder")
interact(board,"context","Papan konteks")
local function marker(name,cframe)
 local object=part(name,Vector3.new(1,1,1),cframe.Position,Color3.new())
 object.CFrame=cframe; object.Transparency=1; object.CanCollide=false; object.CanQuery=false; object.CanTouch=false
 return object
end
marker("SpawnMarker",CFrame.lookAt(Vector3.new(0,4,-25),Vector3.new(0,4,-45)))
marker("CameraStart",CFrame.lookAt(Vector3.new(11,8,-25),Vector3.new(0,3,-44)))
marker("CameraEnd",CFrame.lookAt(Vector3.new(-11,8,-52),Vector3.new(4,4,-39)))
scene.Parent=workspace
local scenes=game.ServerStorage:FindFirstChild("Scenes") or Instance.new("Folder")
scenes.Name="Scenes"; scenes.Parent=game.ServerStorage
assert(not scenes:FindFirstChild("AhmadYaniHouse"),"Template sudah ada; tidak ditimpa")
local template=scene:Clone(); template.Name="AhmadYaniHouse"; template.Parent=scenes
local remotes=game.ReplicatedStorage:FindFirstChild("Remotes") or Instance.new("Folder")
remotes.Name="Remotes"; remotes.Parent=game.ReplicatedStorage
assert(not remotes:FindFirstChild("NarrativeEvent"),"Remote sudah ada; tidak ditimpa")
local remote=Instance.new("RemoteEvent"); remote.Name="NarrativeEvent"; remote.Parent=remotes

local gui=Instance.new("ScreenGui")
gui.Name="GameGui"; gui.Enabled=false; gui.ResetOnSpawn=false; gui.ScreenInsets=Enum.ScreenInsets.DeviceSafeInsets
gui.ClipToDeviceSafeArea=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local paper=Color3.fromRGB(225,217,194)
local ink=Color3.fromRGB(37,40,36)
local function label(name,parent,size,position,text,fontSize)
 local object=Instance.new("TextLabel")
 object.Name=name; object.Size=size; object.Position=position
 object.BackgroundTransparency=1; object.Text=text; object.TextColor3=ink
 object.TextSize=fontSize; object.Font=Enum.Font.Gotham; object.TextWrapped=true
 object.TextXAlignment=Enum.TextXAlignment.Left; object.TextYAlignment=Enum.TextYAlignment.Top
 object.Parent=parent; return object
end
local header=Instance.new("Frame")
header.Name="Header"; header.Size=UDim2.new(0.82,0,0,86); header.Position=UDim2.fromOffset(12,12)
header.BackgroundColor3=paper; header.BorderSizePixel=0; header.Parent=gui
header.Visible=false
local headerLimit=Instance.new("UISizeConstraint"); headerLimit.MaxSize=Vector2.new(620,86); headerLimit.Parent=header
label("Badge",header,UDim2.new(1,-24,0,18),UDim2.fromOffset(12,8),"VS01 · PROTOTIPE TEKNIS / DRAMATISASI",12)
label("Objective",header,UDim2.new(1,-24,0,46),UDim2.fromOffset(12,32),"Memuat objektif…",17)
local cardGui=Instance.new("Frame")
cardGui.Name="Card"; cardGui.AnchorPoint=Vector2.new(0.5,0.5)
cardGui.Position=UDim2.fromScale(0.5,0.5); cardGui.Size=UDim2.fromScale(0.91,0.9)
cardGui.BackgroundColor3=paper; cardGui.BorderSizePixel=0; cardGui.Parent=gui
local cardLimit=Instance.new("UISizeConstraint"); cardLimit.MaxSize=Vector2.new(740,440); cardLimit.Parent=cardGui
label("Title",cardGui,UDim2.new(1,-32,0,46),UDim2.fromOffset(16,12),"Memuat VS01…",23)
label("Category",cardGui,UDim2.new(1,-32,0,20),UDim2.fromOffset(16,60),"DRAMATISASI · KONTEN UJI TEKNIS",12)
local reading=Instance.new("ScrollingFrame")
reading.Name="Reading"; reading.Position=UDim2.fromOffset(16,87); reading.Size=UDim2.new(1,-32,1,-155)
reading.BackgroundTransparency=1; reading.BorderSizePixel=0; reading.ScrollBarThickness=5
reading.CanvasSize=UDim2.new(); reading.AutomaticCanvasSize=Enum.AutomaticSize.Y; reading.ScrollingDirection=Enum.ScrollingDirection.Y
reading.Parent=cardGui
local body=label("Body",reading,UDim2.new(1,-12,0,0),UDim2.new(),"Menyiapkan prototype…",18)
body.AutomaticSize=Enum.AutomaticSize.Y
local advance=Instance.new("TextButton")
advance.Name="Advance"; advance.AnchorPoint=Vector2.new(1,1); advance.Position=UDim2.new(1,-16,1,-14)
advance.Size=UDim2.fromOffset(150,44); advance.BackgroundColor3=ink
advance.TextColor3=paper; advance.Font=Enum.Font.GothamMedium; advance.TextSize=18; advance.Text="Lanjut"
advance.BorderSizePixel=0; advance.Parent=cardGui
label("KeyboardHint",cardGui,UDim2.new(1,-196,0,36),UDim2.new(0,16,1,-54),"Enter / Spasi\natau tombol sentuh",12)
local fade=Instance.new("Frame")
fade.Name="Fade"; fade.Size=UDim2.fromScale(1,1); fade.BackgroundColor3=Color3.new()
fade.BackgroundTransparency=1; fade.BorderSizePixel=0; fade.ZIndex=10; fade.Active=false; fade.Parent=gui
gui.Parent=game.StarterGui
game.StarterGui.ScreenOrientation=Enum.ScreenOrientation.LandscapeSensor
game.StarterPlayer.LoadCharacterAppearance=false
workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(24,26,-9),Vector3.new(0,3,-40))
local prompts=0
for _,object in ipairs(scene:GetDescendants()) do if object:IsA("ProximityPrompt") then prompts+=1 end end
assert(prompts==3 and scene.SpawnMarker and scene.CameraStart and scene.CameraEnd,"Scene tidak lengkap")
assert(gui.Card.Advance.Size.Y.Offset>=44,"Target sentuh terlalu kecil")
return "VS01 greybox, template, tiga prompt, marker, remote dan GameGui siap."
