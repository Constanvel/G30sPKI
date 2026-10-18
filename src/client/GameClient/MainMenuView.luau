--!strict
local View={}
local cream=Color3.fromRGB(224,218,201)
local muted=Color3.fromRGB(153,162,158)
local red=Color3.fromRGB(171,82,66)
local function text(parent,name,value,size,position,fontSize)
 local label=Instance.new("TextLabel")
 label.Name=name; label.Text=value; label.Size=size; label.Position=position
 label.BackgroundTransparency=1; label.TextColor3=cream; label.TextSize=fontSize or 16
 label.Font=Enum.Font.Gotham; label.TextXAlignment=Enum.TextXAlignment.Left
 label.TextYAlignment=Enum.TextYAlignment.Top; label.TextWrapped=true; label.Parent=parent
 return label
end
local function button(parent,name,value,size,position)
 local b=Instance.new("TextButton")
 b.Name=name; b.Text=value; b.Size=size; b.Position=position
 b.BackgroundColor3=Color3.fromRGB(62,63,54); b.BackgroundTransparency=1
 b.BorderSizePixel=0; b.AutoButtonColor=false; b.TextColor3=cream
 b.Font=Enum.Font.GothamMedium; b.TextSize=16; b.TextXAlignment=Enum.TextXAlignment.Left
 b.Selectable=true; b:SetAttribute("Available",true); b.Parent=parent
 local selection=Instance.new("Frame"); selection.Name="Focus"; selection.Size=UDim2.fromScale(1,1)
 selection.BackgroundTransparency=1; selection.BorderSizePixel=0; b.SelectionImageObject=selection; selection.Parent=b
 local padding=Instance.new("UIPadding"); padding.PaddingLeft=UDim.new(0,16); padding.PaddingRight=UDim.new(0,10); padding.Parent=b
 local indicator=Instance.new("Frame"); indicator.Name="Indicator"; indicator.BackgroundColor3=red
 indicator.BorderSizePixel=0; indicator.BackgroundTransparency=1; indicator.Size=UDim2.fromOffset(2,18)
 indicator.Position=UDim2.new(0,-12,0.5,-9); indicator.Parent=b
 return b
end

function View.new(player)
 local self={navigation={},pages={},settings={},order={"Start","Resume","Chapters","Archive","Settings","Credits"}}
 local gui=Instance.new("ScreenGui"); gui.Name="MainMenuGui"; gui.ResetOnSpawn=false
 gui.DisplayOrder=30; gui.ScreenInsets=Enum.ScreenInsets.DeviceSafeInsets
 gui.ClipToDeviceSafeArea=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.Enabled=false
 local shade=Instance.new("Frame"); shade.Name="Shade"; shade.Size=UDim2.fromScale(1,1)
 shade.BackgroundColor3=Color3.fromRGB(8,14,16); shade.BorderSizePixel=0; shade.Parent=gui
 local gradient=Instance.new("UIGradient")
 gradient.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.06),NumberSequenceKeypoint.new(0.4,0.26),NumberSequenceKeypoint.new(1,0.88)})
 gradient.Parent=shade
 local root=Instance.new("CanvasGroup"); root.Name="Root"; root.Size=UDim2.fromScale(1,1)
 root.BackgroundTransparency=1; root.Parent=gui; self.root=root
 local brand=Instance.new("CanvasGroup"); brand.Name="Brand"; brand.BackgroundTransparency=1; brand.Parent=root; self.brand=brand
 self.kicker=text(brand,"Kicker","JAKARTA  /  1965",UDim2.new(1,0,0,18),UDim2.new(),11); self.kicker.TextColor3=muted
 self.year=text(brand,"Year","1965",UDim2.new(1,0,0,140),UDim2.fromOffset(-4,22),130)
 self.year.Font=Enum.Font.Bodoni
 self.subtitle=text(brand,"Subtitle","TUJUH PERSPEKTIF",UDim2.new(1,0,0,28),UDim2.fromOffset(0,160),21)
 self.status=text(brand,"Status","Tujuh perspektif. Satu rangkaian sejarah.",UDim2.new(1,0,0,38),UDim2.fromOffset(0,197),13)
 self.status.TextColor3=muted
 local nav=Instance.new("ScrollingFrame"); nav.Name="Navigation"; nav.BackgroundTransparency=1
 nav.BorderSizePixel=0; nav.ScrollBarThickness=2; nav.ScrollBarImageColor3=muted
 nav.ScrollingDirection=Enum.ScrollingDirection.Y; nav.CanvasSize=UDim2.new(); nav.Selectable=false; nav.Parent=root; self.nav=nav
 local labels={Start="MULAI",Resume="LANJUTKAN",Chapters="PILIH CHAPTER",Archive="ARSIP SEJARAH",Settings="PENGATURAN",Credits="KREDIT"}
 for _,name in ipairs(self.order) do self.navigation[name]=button(nav,name,labels[name],UDim2.fromOffset(280,46),UDim2.new()) end
 self.meta=text(root,"Meta","PROTOTIPE VS01    /    LATAR REKONSTRUKSI ARTISTIK",UDim2.new(1,-60,0,18),UDim2.new(),10)
 self.meta.TextColor3=muted

 local panel=Instance.new("CanvasGroup"); panel.Name="Panel"; panel.AnchorPoint=Vector2.new(0.5,0.5)
 panel.Position=UDim2.fromScale(0.5,0.5); panel.Size=UDim2.fromScale(0.88,0.86)
 panel.BackgroundColor3=Color3.fromRGB(17,25,27); panel.BackgroundTransparency=0.04; panel.BorderSizePixel=0
 panel.Visible=false; panel.Parent=gui; self.panel=panel
 local limit=Instance.new("UISizeConstraint"); limit.MaxSize=Vector2.new(880,610); limit.Parent=panel
 local stroke=Instance.new("UIStroke"); stroke.Color=Color3.fromRGB(73,82,77); stroke.Transparency=0.4; stroke.Parent=panel
 text(panel,"Eyebrow","1965  /  TUJUH PERSPEKTIF",UDim2.new(1,-140,0,16),UDim2.fromOffset(22,16),10).TextColor3=muted
 self.panelTitle=text(panel,"Title","",UDim2.new(1,-150,0,36),UDim2.fromOffset(22,40),25)
 self.back=button(panel,"Back","← KEMBALI",UDim2.fromOffset(116,44),UDim2.new(1,-132,0,22))
 self.back.TextSize=12
 local divider=Instance.new("Frame"); divider.Size=UDim2.new(1,-44,0,1); divider.Position=UDim2.fromOffset(22,88)
 divider.BorderSizePixel=0; divider.BackgroundColor3=Color3.fromRGB(73,82,77); divider.Parent=panel
 local content=Instance.new("ScrollingFrame"); content.Name="Content"; content.Size=UDim2.new(1,-44,1,-118)
 content.Position=UDim2.fromOffset(22,101); content.BackgroundTransparency=1; content.BorderSizePixel=0
 content.AutomaticCanvasSize=Enum.AutomaticSize.Y; content.CanvasSize=UDim2.new(); content.ScrollBarThickness=3
 content.ScrollBarImageColor3=muted; content.ScrollingDirection=Enum.ScrollingDirection.Y; content.Selectable=false; content.Parent=panel; self.content=content
 local function page(name,height)
  local frame=Instance.new("Frame"); frame.Name=name; frame.Size=UDim2.new(1,-10,0,height)
  frame.BackgroundTransparency=1; frame.Visible=false; frame.Parent=content; self.pages[name]=frame; return frame
 end
 local chapters=page("Chapters",360)
 text(chapters,"Note","Satu chapter teknis tersedia. Naskah sejarah masih dalam peninjauan.",UDim2.new(1,0,0,48),UDim2.new(),15).TextColor3=muted
 self.chapterStart=button(chapters,"VS01","01  /  PENGENALAN AHMAD YANI",UDim2.new(1,0,0,64),UDim2.fromOffset(0,58))
 self.chapterStart.TextSize=14; self.chapterStart.TextWrapped=true; self.chapterStart.BackgroundTransparency=0.65
 text(chapters,"ChapterNote","VS01 · PROTOTIPE TEKNIS / DRAMATISASI",UDim2.new(1,-16,0,38),UDim2.fromOffset(16,130),11).TextColor3=muted
 text(chapters,"Locked","02—07  /  TERKUNCI\n\nEnam perspektif berikutnya belum diimplementasikan. Bab investigasi belum tersedia.",UDim2.new(1,0,0,130),UDim2.fromOffset(0,185),16).TextColor3=muted
 local archive=page("Archive",270)
 text(archive,"Index","INDEKS  /  00 SUMBER",UDim2.new(1,0,0,25),UDim2.new(),11).TextColor3=red
 text(archive,"Empty","Belum ada arsip yang disahkan.",UDim2.new(1,0,0,78),UDim2.fromOffset(0,48),24)
 text(archive,"Note","Sumber sejarah akan ditampilkan setelah ditinjau tim riset. Fakta, kesaksian, dan dramatisasi akan dibedakan. Tidak ada dokumen atau kutipan rekaan dalam arsip ini.",UDim2.new(1,0,0,120),UDim2.fromOffset(0,137),16).TextColor3=muted
 local settings=page("Settings",420)
 text(settings,"Note","Volume berlaku selama sesi ini. Audio belum tersedia; pilihan ini akan digunakan saat audio ditambahkan.",UDim2.new(1,0,0,62),UDim2.new(),14).TextColor3=muted
 for index,item in ipairs({{"Master","VOLUME UTAMA"},{"Ambient","AMBIENCE"},{"UI","EFEK MENU"}}) do
  local name,title=item[1],item[2]; local y=76+(index-1)*66
  local label=text(settings,name.."Label",title,UDim2.new(1,-166,0,44),UDim2.fromOffset(0,y+12),13)
  self.settings[name.."Label"]=label
  self.settings[name.."Minus"]=button(settings,name.."Minus","−",UDim2.fromOffset(44,44),UDim2.new(1,-156,0,y))
  local value=text(settings,name.."Value","",UDim2.fromOffset(56,44),UDim2.new(1,-112,0,y+12),14)
  value.TextXAlignment=Enum.TextXAlignment.Center; self.settings[name.."Value"]=value
  self.settings[name.."Plus"]=button(settings,name.."Plus","+",UDim2.fromOffset(44,44),UDim2.new(1,-52,0,y))
 end
 self.settings.Motion=button(settings,"Motion","GERAKAN DIKURANGI  /  NONAKTIF",UDim2.new(1,0,0,56),UDim2.fromOffset(0,284))
 self.settings.Motion.TextSize=13; self.settings.Motion.TextWrapped=true; self.settings.Motion.BackgroundTransparency=0.65
 text(settings,"MotionNote","Menghentikan gerak kamera menu dan menyederhanakan animasi antarmuka.",UDim2.new(1,0,0,55),UDim2.fromOffset(0,354),13).TextColor3=muted
 local credits=page("Credits",400)
 text(credits,"Team","TIM PENGEMBANG",UDim2.new(1,0,0,24),UDim2.new(),11).TextColor3=red
 text(credits,"Names","Reiner  /  Pemrograman & integrasi\nFahkri  /  Riset sejarah\nRama  /  Map & lingkungan\nRaja  /  UI & audio",UDim2.new(1,0,0,154),UDim2.fromOffset(0,40),16)
 text(credits,"Assets","ASET & CATATAN",UDim2.new(1,0,0,24),UDim2.fromOffset(0,221),11).TextColor3=red
 text(credits,"AssetNote","Geometri menu dibuat untuk proyek ini dari primitive Roblox. Tipografi memakai font bawaan Roblox. Belum ada audio, gambar arsip, atau model eksternal. Latar merupakan rekonstruksi artistik, bukan lokasi terverifikasi.",UDim2.new(1,0,0,142),UDim2.fromOffset(0,256),14).TextColor3=muted
 local overlay=Instance.new("Frame"); overlay.Name="Black"; overlay.Size=UDim2.fromScale(1,1)
 overlay.BackgroundColor3=Color3.new(); overlay.BorderSizePixel=0; overlay.BackgroundTransparency=1
 overlay.ZIndex=10; overlay.Active=false; overlay.Parent=gui; self.overlay=overlay
 self.gui=gui; gui.Parent=player.PlayerGui

 function self:layout()
  local w,h=root.AbsoluteSize.X,root.AbsoluteSize.Y
  if w<1 or h<1 then return end
  local compact=h<480 and w>h
  local margin=math.floor(w*(if compact then 0.055 else 0.075))
  local titleSize=if compact then math.clamp(h*0.22,54,82) else math.clamp(h*0.19,82,146)
  local brandY=if compact then 12 else math.floor(h*0.105)
  brand.Position=UDim2.fromOffset(margin,brandY); brand.Size=UDim2.new(1,-margin*2,0,titleSize+108)
  self.year.TextSize=titleSize; self.year.Position=UDim2.fromOffset(-3,18); self.year.Size=UDim2.new(1,0,0,titleSize+10)
  self.subtitle.TextSize=if compact then 16 else 21; self.subtitle.Position=UDim2.fromOffset(0,titleSize+23)
  self.status.Position=UDim2.fromOffset(0,titleSize+55); self.status.TextSize=if compact then 11 else 13
  local navY=if compact then math.floor(h*0.47) else math.floor(math.max(brandY+titleSize+111,h*0.46))
  local navW=if compact then math.min(560,w-margin*2) else math.min(360,w-margin*2)
  nav.Position=UDim2.fromOffset(margin,navY); nav.Size=UDim2.fromOffset(navW,math.max(44,h-navY-28))
  for i,name in ipairs(self.order) do
   local col=if compact then (i-1)%2 else 0
   local row=if compact then math.floor((i-1)/2) else i-1
   local width=if compact then (navW-12)/2 else navW
   local b=self.navigation[name]; b.Position=UDim2.fromOffset(col*(width+12),row*47)
   b.Size=UDim2.fromOffset(width,44); b.TextSize=if compact then 13 else 15
  end
  nav.CanvasSize=UDim2.fromOffset(0,if compact then 141 else 282)
  self.meta.Position=UDim2.fromOffset(margin,h-20); self.meta.Size=UDim2.new(1,-margin*2,0,18)
  self.meta.TextSize=if w<600 then 8 else 10
  self.panelTitle.TextSize=if w<450 then 19 else 25
  for _,name in ipairs({"Master","Ambient","UI"}) do self.settings[name.."Label"].TextSize=if w<450 then 10 else 13 end
 end
 self.resize=root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() self:layout() end)
 self:layout()
 return self
end

return View
