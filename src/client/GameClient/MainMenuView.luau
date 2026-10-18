--!strict
local GuiService=game:GetService("GuiService")
local Style=require(script.Parent.MenuStyle)
local View={}
local function text(parent,name,value,size,position,fontSize)
 local label=Instance.new("TextLabel")
 label.Name=name;label.Text=value;label.Size=size;label.Position=position
 label.BackgroundTransparency=1;label.TextColor3=Style.text;label.TextSize=fontSize or 16
 label.Font=Style.body;label.TextXAlignment=Enum.TextXAlignment.Left
 label.TextYAlignment=Enum.TextYAlignment.Top;label.TextWrapped=true;label.Parent=parent
 return label
end
local function rule(parent,name,position,size)
 local line=Instance.new("Frame");line.Name=name;line.Position=position;line.Size=size
 line.BackgroundColor3=Style.divider;line.BorderSizePixel=0;line.Parent=parent
 return line
end
local function button(parent,name,value,size,position,padding)
 local b=Instance.new("TextButton");b.Name=name;b.Text=value;b.Size=size;b.Position=position
 b.BackgroundColor3=Style.surface;b.BackgroundTransparency=1;b.BorderSizePixel=0
 b.AutoButtonColor=false;b.TextColor3=Style.text;b.Font=Style.control;b.TextSize=15
 b.TextXAlignment=Enum.TextXAlignment.Left;b.Selectable=true;b:SetAttribute("Available",true)
 b:SetAttribute("RestPadding",padding or 12);b.Parent=parent
 local selection=Instance.new("Frame");selection.Name="Focus";selection.BackgroundTransparency=1
 selection.Size=UDim2.fromScale(1,1);selection.BorderSizePixel=0;selection.Parent=b;b.SelectionImageObject=selection
 local inset=Instance.new("UIPadding");inset.PaddingLeft=UDim.new(0,padding or 12);inset.PaddingRight=UDim.new(0,8);inset.Parent=b
 local indicator=Instance.new("Frame");indicator.Name="Indicator";indicator.BackgroundColor3=Style.accent
 indicator.BackgroundTransparency=1;indicator.BorderSizePixel=0;indicator.Size=UDim2.fromOffset(2,10)
 indicator.AnchorPoint=Vector2.new(0,.5);indicator.Position=UDim2.new(0,0,.5,0);indicator.Parent=b
 return b
end

function View.new(player)
 local self={navigation={},pages={},settings={},order={"Start","Resume","Chapters","Archive","Settings","Credits"}}
 local gui=Instance.new("ScreenGui");gui.Name="MainMenuGui";gui.ResetOnSpawn=false
 gui.DisplayOrder=30;gui.ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets
 gui.ClipToDeviceSafeArea=true;gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.Enabled=false
 local shade=Instance.new("Frame");shade.Name="Shade";shade.Size=UDim2.fromScale(1,1)
 shade.BackgroundColor3=Style.background;shade.BorderSizePixel=0;shade.Parent=gui
 local gradient=Instance.new("UIGradient")
 gradient.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.12),NumberSequenceKeypoint.new(.38,.38),NumberSequenceKeypoint.new(.7,.85),NumberSequenceKeypoint.new(1,.95)})
 gradient.Parent=shade
 local root=Instance.new("CanvasGroup");root.Name="Root";root.Size=UDim2.fromScale(1,1)
 root.BackgroundTransparency=1;root.Parent=gui;self.root=root
 local brand=Instance.new("CanvasGroup");brand.Name="Brand";brand.BackgroundTransparency=1;brand.Parent=root;self.brand=brand
 self.brandPadding=Instance.new("UIPadding");self.brandPadding.Parent=brand
 self.kicker=text(brand,"Kicker","LUBANG BUAYA / JAKARTA",UDim2.new(1,0,0,18),UDim2.new(),11);self.kicker.TextColor3=Style.secondary
 self.year=text(brand,"Year","1965",UDim2.new(1,0,0,120),UDim2.fromOffset(-3,22),108);self.year.Font=Style.heading
 self.subtitle=text(brand,"Subtitle","TUJUH PERSPEKTIF",UDim2.new(1,0,0,28),UDim2.fromOffset(0,134),20)
 self.status=text(brand,"Status","Tujuh perspektif. Satu rangkaian sejarah.",UDim2.new(1,0,0,38),UDim2.fromOffset(0,170),14);self.status.TextColor3=Style.secondary
 self.brandRule=rule(brand,"EditorialRule",UDim2.fromOffset(0,215),UDim2.fromOffset(64,1))
 local nav=Instance.new("ScrollingFrame");nav.Name="Navigation";nav.BackgroundTransparency=1;nav.BorderSizePixel=0
 nav.ScrollBarThickness=2;nav.ScrollBarImageColor3=Style.secondary;nav.ScrollingDirection=Enum.ScrollingDirection.Y
 nav.CanvasSize=UDim2.new();nav.Selectable=false;nav.Parent=root;self.nav=nav
 local labels={Start="MULAI",Resume="LANJUTKAN",Chapters="PILIH CHAPTER",Archive="ARSIP SEJARAH",Settings="PENGATURAN",Credits="KREDIT"}
 for i,name in ipairs(self.order) do
  local b=button(nav,name,labels[name],UDim2.fromOffset(320,44),UDim2.new(),44)
  local index=text(b,"Index",string.format("%02d",i),UDim2.fromOffset(24,18),UDim2.new(0,-36,.5,-8),11)
  index.TextColor3=Style.secondary;index.Font=Enum.Font.RobotoMono
  self.navigation[name]=b
 end
 self.resumeNote=text(self.navigation.Resume,"StateNote","Belum ada",UDim2.fromOffset(82,16),UDim2.new(1,-90,.5,-7),11)
 self.resumeNote.TextColor3=Style.secondary;self.resumeNote.TextXAlignment=Enum.TextXAlignment.Right
 self.meta=text(root,"Meta","VS01 · PROTOTIPE / LATAR ARTISTIK",UDim2.new(1,-60,0,18),UDim2.new(),10);self.meta.TextColor3=Style.secondary

 local panel=Instance.new("CanvasGroup");panel.Name="Panel";panel.AnchorPoint=Vector2.new(.5,.5)
 panel.Position=UDim2.fromScale(.5,.5);panel.Size=UDim2.fromOffset(620,488)
 panel.BackgroundColor3=Style.background;panel.BackgroundTransparency=.02;panel.BorderSizePixel=0
 panel.Visible=false;panel.Parent=gui;self.panel=panel
 self.eyebrow=text(panel,"Eyebrow","PENGATURAN",UDim2.new(1,-160,0,18),UDim2.fromOffset(28,22),11);self.eyebrow.TextColor3=Style.accentText
 self.panelTitle=text(panel,"Title","Preferensi permainan",UDim2.new(1,-130,0,38),UDim2.fromOffset(28,44),30);self.panelTitle.Font=Style.heading
 self.back=button(panel,"Back","← Kembali",UDim2.fromOffset(100,44),UDim2.new(1,-118,0,14),8);self.back.TextSize=12
 self.panelRule=rule(panel,"HeaderRule",UDim2.fromOffset(28,92),UDim2.new(1,-56,0,1))
 local content=Instance.new("ScrollingFrame");content.Name="Content";content.BackgroundTransparency=1;content.BorderSizePixel=0
 content.AutomaticCanvasSize=Enum.AutomaticSize.Y;content.CanvasSize=UDim2.new();content.ScrollBarThickness=3
 content.ScrollBarImageColor3=Style.accent;content.ScrollingDirection=Enum.ScrollingDirection.Y;content.Selectable=false
 content.Parent=panel;self.content=content
 local function page(name,height)
  local frame=Instance.new("Frame");frame.Name=name;frame.Size=UDim2.new(1,-8,0,height)
  frame.BackgroundTransparency=1;frame.Visible=false;frame.Parent=content;self.pages[name]=frame;return frame
 end
 local chapters=page("Chapters",248)
 text(chapters,"Note","Satu chapter teknis tersedia. Naskah sejarah masih dalam peninjauan.",UDim2.new(1,0,0,44),UDim2.new(),14).TextColor3=Style.secondary
 self.chapterStart=button(chapters,"VS01","Pengenalan Ahmad Yani",UDim2.new(1,0,0,88),UDim2.fromOffset(0,56),64)
 self.chapterStart.TextYAlignment=Enum.TextYAlignment.Top;self.chapterStart.TextSize=17
 self.chapterStart:FindFirstChildOfClass("UIPadding").PaddingTop=UDim.new(0,16)
 local chapterIndex=text(self.chapterStart,"Number","01",UDim2.fromOffset(44,46),UDim2.fromOffset(-52,-4),34);chapterIndex.Font=Style.heading;chapterIndex.TextColor3=Style.accent
 text(self.chapterStart,"Description","VS01 · Prototipe teknis / dramatisasi",UDim2.new(1,0,0,32),UDim2.fromOffset(0,28),12).TextColor3=Style.secondary
 rule(chapters,"IndexRule",UDim2.fromOffset(0,156),UDim2.new(1,0,0,1))
 text(chapters,"Locked","02—07 / TERKUNCI\n\nEnam perspektif berikutnya belum diimplementasikan. Bab investigasi belum tersedia.",UDim2.new(1,0,0,72),UDim2.fromOffset(0,176),14).TextColor3=Style.secondary
 local archive=page("Archive",192)
 text(archive,"Index","INDEKS / 00 SUMBER",UDim2.new(1,0,0,20),UDim2.new(),11).TextColor3=Style.accentText
 local empty=text(archive,"Empty","Belum ada arsip yang disahkan.",UDim2.new(1,0,0,60),UDim2.fromOffset(0,30),25);empty.Font=Style.heading
 text(archive,"Note","Sumber sejarah akan ditampilkan setelah ditinjau tim riset. Fakta, kesaksian, dan dramatisasi akan dibedakan. Tidak ada dokumen atau kutipan rekaan dalam arsip ini.",UDim2.new(1,0,0,96),UDim2.fromOffset(0,98),14).TextColor3=Style.secondary
 local settings=page("Settings",348)
 text(settings,"AudioHeading","AUDIO",UDim2.new(1,0,0,18),UDim2.new(),11).TextColor3=Style.accentText
 text(settings,"Note","Berlaku selama sesi ini. Audio belum tersedia.",UDim2.new(1,0,0,24),UDim2.fromOffset(0,22),12).TextColor3=Style.secondary
 for i,item in ipairs({{"Master","Volume Utama"},{"Ambient","Ambience"},{"UI","Efek Menu"}}) do
  local name,title=item[1],item[2];local y=52+(i-1)*64
  self.settings[name.."Label"]=text(settings,name.."Label",title,UDim2.new(1,-64,0,20),UDim2.fromOffset(0,y),15)
  local value=text(settings,name.."Value","",UDim2.fromOffset(56,20),UDim2.new(1,-56,0,y),14)
  value.Font=Enum.Font.RobotoMono;value.TextXAlignment=Enum.TextXAlignment.Right;self.settings[name.."Value"]=value
  local slider=button(settings,name.."Slider","",UDim2.new(1,0,0,44),UDim2.fromOffset(0,y+16),0)
  slider:SetAttribute("SettingName",name);slider.Indicator.Visible=false
  local track=rule(slider,"Track",UDim2.new(0,6,.5,0),UDim2.new(1,-12,0,2))
  local fill=rule(track,"Fill",UDim2.new(),UDim2.fromScale(.5,1));fill.BackgroundColor3=Style.accent
  local handle=rule(track,"Handle",UDim2.fromScale(.5,.5),UDim2.fromOffset(12,12));handle.AnchorPoint=Vector2.new(.5,.5);handle.BackgroundColor3=Style.text
  local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(1,0);corner.Parent=handle
  local focus=Instance.new("UIStroke");focus.Name="FocusRing";focus.Color=Style.accent;focus.Thickness=2;focus.Transparency=1;focus.Parent=handle
  self.settings[name.."Slider"]=slider
 end
 text(settings,"AccessHeading","AKSESIBILITAS",UDim2.new(1,0,0,18),UDim2.fromOffset(0,254),11).TextColor3=Style.accentText
 local motion=button(settings,"Motion","Gerakan dikurangi",UDim2.new(1,0,0,48),UDim2.fromOffset(0,278),0);motion.TextSize=15;motion.Indicator.Visible=false;motion:SetAttribute("FixedText",true)
 local state=text(motion,"State","Nonaktif",UDim2.fromOffset(76,20),UDim2.new(1,-132,.5,-8),12);state.TextColor3=Style.secondary;state.TextXAlignment=Enum.TextXAlignment.Right
 local switch=rule(motion,"Switch",UDim2.new(1,-48,.5,-12),UDim2.fromOffset(44,24));switch.BackgroundColor3=Style.divider
 local rounding=Instance.new("UICorner");rounding.CornerRadius=UDim.new(1,0);rounding.Parent=switch
 local thumb=rule(switch,"Thumb",UDim2.fromOffset(3,3),UDim2.fromOffset(18,18));thumb.BackgroundColor3=Style.text
 local thumbCorner=Instance.new("UICorner");thumbCorner.CornerRadius=UDim.new(1,0);thumbCorner.Parent=thumb
 self.settings.Motion=motion
 text(settings,"MotionNote","Kamera stabil dan transisi antarmuka lebih sederhana.",UDim2.new(1,0,0,20),UDim2.fromOffset(0,328),12).TextColor3=Style.secondary
 local credits=page("Credits",220)
 text(credits,"Team","TIM PENGEMBANG",UDim2.new(1,0,0,18),UDim2.new(),11).TextColor3=Style.accentText
 text(credits,"Names","Reiner  /  Pemrograman & integrasi\nFahkri  /  Riset sejarah\nRama  /  Map & lingkungan\nRaja  /  UI & audio",UDim2.new(1,0,0,72),UDim2.fromOffset(0,28),15)
 text(credits,"Assets","ASET & CATATAN",UDim2.new(1,0,0,18),UDim2.fromOffset(0,124),11).TextColor3=Style.accentText
 text(credits,"AssetNote","Mesh rumah, pohon, pagar, peti dan lentera digunakan ulang dari proyek BARA 1946 milik Constancexz. Material dan font Roblox. Belum ada audio atau gambar arsip. Latar Lubang Buaya adalah rekonstruksi artistik, bukan replika denah 1965.",UDim2.new(1,0,0,64),UDim2.fromOffset(0,154),13).TextColor3=Style.secondary
 local overlay=Instance.new("Frame");overlay.Name="Black";overlay.Size=UDim2.fromScale(1,1)
 overlay.BackgroundColor3=Color3.new();overlay.BorderSizePixel=0;overlay.BackgroundTransparency=1
 overlay.ZIndex=10;overlay.Active=false;overlay.Parent=gui;self.overlay=overlay;self.gui=gui;gui.Parent=player.PlayerGui

 function self:layout()
  local w,h=root.AbsoluteSize.X,root.AbsoluteSize.Y;if w<1 or h<1 then return end
  local topLeft,bottomRight=GuiService:GetGuiInset()
  for _,background in ipairs({shade,overlay}) do background.Position=UDim2.fromOffset(-topLeft.X,-topLeft.Y);background.Size=UDim2.new(1,topLeft.X+bottomRight.X,1,topLeft.Y+bottomRight.Y) end
  local compact=h<590 and w>h
  local margin=math.floor(w*(if compact then .055 else .075))
  local titleSize=if compact then math.floor(math.clamp(h*.17,42,66)) else math.clamp(h*.19,76,128)
  local brandY=if compact then 4 else math.floor(h*.07)
  brand.Position=UDim2.fromOffset(margin,brandY);brand.Size=UDim2.new(1,-margin*2,0,titleSize+108)
  self.year.TextSize=titleSize;self.year.Position=UDim2.fromOffset(-3,18);self.year.Size=UDim2.new(1,0,0,titleSize+10)
  self.subtitle.TextSize=if compact then 15 else 20;self.subtitle.Position=UDim2.fromOffset(0,titleSize+24)
  self.status.Position=UDim2.fromOffset(0,titleSize+(if compact then 48 else 54));self.status.TextSize=if compact then 12 else 14
  self.brandRule.Position=UDim2.fromOffset(0,titleSize+102);self.brandRule.Visible=not compact
  local pitch=if compact then 44 else 48
  local total=if compact then 132 else 284
  local navY=if compact then math.floor(math.max(brandY+titleSize+70,h-total-26)) else math.floor(math.max(brandY+titleSize+126,h*.43))
  local navW=if compact then math.min(600,w-margin*2) else math.min(360,w-margin*2)
  nav.Position=UDim2.fromOffset(margin,navY);nav.Size=UDim2.fromOffset(navW,math.max(44,h-navY-26))
  for i,name in ipairs(self.order) do
   local col=if compact then (i-1)%2 else 0;local row=if compact then math.floor((i-1)/2) else i-1
   local width=if compact then (navW-16)/2 else navW
   local b=self.navigation[name];b.Position=UDim2.fromOffset(col*(width+16),row*pitch);b.Size=UDim2.fromOffset(width,44);b.TextSize=if compact then 13 else 15
  end
  nav.CanvasSize=UDim2.fromOffset(0,total)
  self.meta.Position=UDim2.fromOffset(margin,h-20);self.meta.Size=UDim2.new(1,-margin*2,0,18)
  local active="Settings";for name,frame in pairs(self.pages) do if frame.Visible then active=name;break end end
  local small=h<410;local narrow=w<440;local inset=if small then 20 else 28
  local height=({Settings=488,Chapters=380,Archive=326,Credits=if narrow then 400 else 352})[active]
  local header=if narrow then 120 elseif small then 76 else 108
  panel.Size=UDim2.fromOffset(math.min(620,w-32),math.min(height,h-24))
  self.eyebrow.Position=UDim2.fromOffset(inset,if small then 12 else 22)
  self.panelTitle.Position=UDim2.fromOffset(inset,if narrow then 58 elseif small then 30 else 44);self.panelTitle.TextSize=if narrow then 25 elseif small then 25 else 30
  self.panelTitle.Size=UDim2.new(1,if narrow then -inset*2 else -140,0,38)
  self.panelRule.Position=UDim2.fromOffset(inset,header-16);self.panelRule.Size=UDim2.new(1,-inset*2,0,1)
  content.Position=UDim2.fromOffset(inset,header);content.Size=UDim2.new(1,-inset*2,1,-header-24)
  self.back.Position=UDim2.new(1,-112,0,if small then 8 else 14)
  self.chapterStart.TextSize=if narrow then 14 else 17
  local motion=self.settings.Motion
  motion.TextYAlignment=if narrow then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
  motion:FindFirstChildOfClass("UIPadding").PaddingTop=UDim.new(0,if narrow then 6 else 0)
  motion.State.Position=if narrow then UDim2.fromOffset(0,23) else UDim2.new(1,-132,.5,-8)
  motion.State.TextXAlignment=if narrow then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right
  self.pages.Settings.MotionNote.Size=UDim2.new(1,0,0,if narrow then 40 else 20)
  self.pages.Settings.Size=UDim2.new(1,-8,0,if narrow then 368 else 348)
  self.pages.Credits.Size=UDim2.new(1,-8,0,if narrow then 256 else 220)
  self.pages.Credits.AssetNote.Size=UDim2.new(1,0,0,if narrow then 96 else 64)
 end
 self.resize=root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()self:layout()end);self:layout()
 return self
end
return View
