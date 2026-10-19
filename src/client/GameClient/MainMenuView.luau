--!strict
local GuiService=game:GetService("GuiService")
local Style=require(script.Parent.MenuStyle)
local View={}
local function text(parent,name,value,size,position,fontSize)
 local label=Instance.new("TextLabel")
 label.Name=name;label.Text=value;label.Size=size;label.Position=position
 label.BackgroundTransparency=1;label.TextColor3=Style.text;label.TextSize=fontSize or 16
 label.FontFace=Style.body;label.TextXAlignment=Enum.TextXAlignment.Left
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
 b.AutoButtonColor=false;b.TextColor3=Style.text;b.FontFace=Style.control;b.TextSize=15
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
 self.kicker=text(brand,"Kicker","LUBANG BUAYA / JAKARTA",UDim2.new(1,0,0,18),UDim2.new(),12);self.kicker.TextColor3=Style.secondary
 self.year=text(brand,"Year","1965",UDim2.new(1,0,0,120),UDim2.fromOffset(-3,22),108);self.year.FontFace=Style.heading
 self.subtitle=text(brand,"Subtitle","TUJUH PERSPEKTIF",UDim2.new(1,0,0,28),UDim2.fromOffset(0,134),20)
 self.subtitle.FontFace=Style.control
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
 self.selectionMarker=rule(nav,"SelectionMarker",UDim2.fromOffset(30,22),UDim2.fromOffset(2,24))
 self.selectionMarker.AnchorPoint=Vector2.new(0,.5);self.selectionMarker.BackgroundColor3=Style.accent
 self.selectionMarker.BackgroundTransparency=1;self.selectionMarker.ZIndex=2
 self.resumeNote=text(self.navigation.Resume,"StateNote","Belum ada",UDim2.fromOffset(82,16),UDim2.new(1,-90,.5,-7),11)
 self.resumeNote.TextColor3=Style.secondary;self.resumeNote.TextXAlignment=Enum.TextXAlignment.Right
 self.meta=text(root,"Meta","VS01 · PROTOTIPE / LATAR ARTISTIK",UDim2.new(1,-60,0,18),UDim2.new(),11);self.meta.TextColor3=Style.secondary

 local panel=Instance.new("CanvasGroup");panel.Name="Panel";panel.AnchorPoint=Vector2.new(.5,.5)
 panel.Position=UDim2.fromScale(.5,.5);panel.Size=UDim2.fromOffset(640,568)
 panel.BackgroundColor3=Style.background;panel.BackgroundTransparency=.02;panel.BorderSizePixel=0
 panel.Visible=false;panel.Parent=gui;self.panel=panel
 local edge=Instance.new("UIStroke");edge.Color=Style.divider;edge.Transparency=.6;edge.Parent=panel
 local function section(parent,name,value,y)
  local label=text(parent,name,value,UDim2.new(1,0,0,18),UDim2.fromOffset(0,y),12)
  label.Font=Enum.Font.RobotoMono;label.TextColor3=Style.accentText;return label
 end
 self.eyebrow=section(panel,"Eyebrow","05 / PENGATURAN",24)
 self.panelTitle=text(panel,"Title","Preferensi permainan",UDim2.new(1,-64,0,38),UDim2.fromOffset(32,52),28);self.panelTitle.FontFace=Style.heading
 self.panelRule=rule(panel,"HeaderRule",UDim2.fromOffset(32,106),UDim2.new(1,-64,0,1))
 self.footerRule=rule(panel,"FooterRule",UDim2.new(0,32,1,-64),UDim2.new(1,-64,0,1))
 self.back=button(panel,"Back","← Kembali",UDim2.fromOffset(136,44),UDim2.new(0,24,1,-56),20);self.back.TextSize=15
 self.back:SetAttribute("FixedText",true);self.back.Indicator.Position=UDim2.new(0,-12,.5,0)
 self.panelFooter=text(panel,"Footer","PREFERENSI SESI",UDim2.new(1,-220,0,18),UDim2.new(0,188,1,-40),11)
 self.panelFooter.Font=Enum.Font.RobotoMono;self.panelFooter.TextColor3=Style.secondary;self.panelFooter.TextXAlignment=Enum.TextXAlignment.Right
 self.pageMeta={Chapters="01 / 07 TERSEDIA",Archive="00 SUMBER DISAHKAN",Settings="PREFERENSI SESI",Credits="TIM & ATRIBUSI"}
 local content=Instance.new("ScrollingFrame");content.Name="Content";content.BackgroundTransparency=1;content.BorderSizePixel=0
 content.AutomaticCanvasSize=Enum.AutomaticSize.Y;content.CanvasSize=UDim2.new();content.ScrollBarThickness=3
 content.ScrollBarImageColor3=Style.accent;content.ScrollingDirection=Enum.ScrollingDirection.Y;content.Selectable=false
 content.Parent=panel;self.content=content
 local function page(name,height)
  local frame=Instance.new("CanvasGroup");frame.Name=name;frame.Size=UDim2.new(1,-8,0,height)
  frame.BackgroundTransparency=1;frame.Visible=false;frame.Parent=content;self.pages[name]=frame;return frame
 end
 local chapters=page("Chapters",312)
 text(chapters,"Note","Satu chapter teknis tersedia. Naskah sejarah masih dalam peninjauan.",UDim2.new(1,0,0,44),UDim2.new(),16).TextColor3=Style.secondary
 self.chapterStart=button(chapters,"VS01","Pengenalan Ahmad Yani",UDim2.new(1,0,0,144),UDim2.fromOffset(0,56),84)
 self.chapterStart.TextYAlignment=Enum.TextYAlignment.Top;self.chapterStart.TextWrapped=true;self.chapterStart.FontFace=Style.heading
 self.chapterStart:SetAttribute("FixedText",true);self.chapterStart:SetAttribute("SurfaceAlpha",.88);self.chapterStart.BackgroundTransparency=.88
 self.chapterStart:FindFirstChildOfClass("UIPadding").PaddingTop=UDim.new(0,48)
 self.chapterStart.Indicator.Visible=false
 local emphasis=Instance.new("UIStroke");emphasis.Name="Emphasis";emphasis.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;emphasis.Color=Style.divider;emphasis.Transparency=.7;emphasis.Parent=self.chapterStart
 local chapterIndex=text(self.chapterStart,"Number","01",UDim2.fromOffset(48,46),UDim2.fromOffset(-68,-40),36);chapterIndex.FontFace=Style.heading;chapterIndex.TextColor3=Style.accentText
 rule(self.chapterStart,"NumberRule",UDim2.fromOffset(-20,-32),UDim2.fromOffset(1,112))
 local availability=text(self.chapterStart,"Availability","TERSEDIA / VS01",UDim2.new(1,0,0,18),UDim2.fromOffset(0,-32),12);availability.Font=Enum.Font.RobotoMono;availability.TextColor3=Style.accentText
 text(self.chapterStart,"Description","VS01 · Prototipe teknis / dramatisasi",UDim2.new(1,0,0,36),UDim2.fromOffset(0,48),14).TextColor3=Style.secondary
 rule(chapters,"IndexRule",UDim2.fromOffset(0,216),UDim2.new(1,0,0,1))
 text(chapters,"Locked","02—07 / TERKUNCI\n\nEnam perspektif berikutnya belum diimplementasikan. Bab investigasi belum tersedia.",UDim2.new(1,0,0,80),UDim2.fromOffset(0,232),15).TextColor3=Style.secondary
 local archive=page("Archive",252)
 section(archive,"Index","INDEKS / 00 SUMBER",0)
 local count=text(archive,"Count","00",UDim2.fromOffset(96,80),UDim2.fromOffset(0,44),58);count.FontFace=Style.heading;count.TextColor3=Style.secondary
 local empty=text(archive,"Empty","Belum ada arsip yang disahkan.",UDim2.new(1,-112,0,72),UDim2.fromOffset(112,48),24);empty.FontFace=Style.heading
 local archiveNote=text(archive,"Note","Sumber sejarah akan ditampilkan setelah ditinjau tim riset. Fakta, kesaksian, dan dramatisasi akan dibedakan. Tidak ada dokumen atau kutipan rekaan dalam arsip ini.",UDim2.new(1,-112,0,112),UDim2.fromOffset(112,132),16);archiveNote.TextColor3=Style.secondary;archiveNote.LineHeight=1.15
 local settings=page("Settings",360)
 section(settings,"AudioHeading","01 / AUDIO",0)
 text(settings,"Note","Berlaku selama sesi ini. Audio belum tersedia.",UDim2.new(1,0,0,24),UDim2.fromOffset(0,24),14).TextColor3=Style.secondary
 for _,item in ipairs({{"Master","Volume Utama"},{"Ambient","Ambience"},{"UI","Efek Menu"}}) do
  local name,title=item[1],item[2]
  self.settings[name.."Label"]=text(settings,name.."Label",title,UDim2.fromOffset(140,22),UDim2.new(),16)
  local value=text(settings,name.."Value","",UDim2.fromOffset(52,22),UDim2.new(),14)
  value.Font=Enum.Font.RobotoMono;value.TextXAlignment=Enum.TextXAlignment.Right;self.settings[name.."Value"]=value
  local slider=button(settings,name.."Slider","",UDim2.new(1,-220,0,44),UDim2.new(),0)
  slider:SetAttribute("SettingName",name);slider.Indicator.Visible=false
  slider.NextSelectionLeft=slider;slider.NextSelectionRight=slider
  local track=rule(slider,"Track",UDim2.new(0,6,.5,0),UDim2.new(1,-12,0,2))
  local fill=rule(track,"Fill",UDim2.new(),UDim2.fromScale(.5,1));fill.BackgroundColor3=Style.accent
  local handle=rule(track,"Handle",UDim2.fromScale(.5,.5),UDim2.fromOffset(12,12));handle.AnchorPoint=Vector2.new(.5,.5);handle.BackgroundColor3=Style.text
  local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(1,0);corner.Parent=handle
  local focus=Instance.new("UIStroke");focus.Name="FocusRing";focus.Color=Style.accent;focus.Thickness=2;focus.Transparency=1;focus.Parent=handle
  self.settings[name.."Slider"]=slider
 end
 rule(settings,"AccessRule",UDim2.fromOffset(0,232),UDim2.new(1,0,0,1))
 section(settings,"AccessHeading","02 / AKSESIBILITAS",252)
 local motion=button(settings,"Motion","Gerakan dikurangi",UDim2.new(1,0,0,48),UDim2.fromOffset(0,276),0);motion.TextSize=16;motion.Indicator.Visible=false;motion:SetAttribute("FixedText",true)
 local state=text(motion,"State","Nonaktif",UDim2.fromOffset(76,20),UDim2.new(1,-132,.5,-8),14);state.TextColor3=Style.secondary;state.TextXAlignment=Enum.TextXAlignment.Right
 local switch=rule(motion,"Switch",UDim2.new(1,-48,.5,-12),UDim2.fromOffset(44,24));switch.BackgroundColor3=Style.divider
 local rounding=Instance.new("UICorner");rounding.CornerRadius=UDim.new(1,0);rounding.Parent=switch
 local thumb=rule(switch,"Thumb",UDim2.fromOffset(3,3),UDim2.fromOffset(18,18));thumb.BackgroundColor3=Style.text
 local thumbCorner=Instance.new("UICorner");thumbCorner.CornerRadius=UDim.new(1,0);thumbCorner.Parent=thumb
 self.settings.Motion=motion
 text(settings,"MotionNote","Kamera stabil dan transisi antarmuka lebih sederhana.",UDim2.new(1,0,0,28),UDim2.fromOffset(0,332),14).TextColor3=Style.secondary
 local credits=page("Credits",344)
 section(credits,"Team","TIM PENGEMBANG",0)
 self.creditRows={}
 for i,item in ipairs({{"Reiner","Pemrograman & integrasi"},{"Fahkri","Riset sejarah"},{"Rama","Map & lingkungan"},{"Raja","UI & audio"}}) do
  local y=36+(i-1)*42
  local name=text(credits,"Name"..i,item[1],UDim2.fromOffset(144,26),UDim2.fromOffset(0,y),19);name.FontFace=Style.heading
  local role=text(credits,"Role"..i,item[2],UDim2.new(1,-176,0,24),UDim2.fromOffset(176,y+3),16);role.TextColor3=Style.secondary
  local line=rule(credits,"RowRule"..i,UDim2.fromOffset(0,y+32),UDim2.new(1,0,0,1));line.BackgroundTransparency=.5
  self.creditRows[i]={name=name,role=role,line=line}
 end
 section(credits,"Assets","ASET & CATATAN",232)
 local assetNote=text(credits,"AssetNote","Mesh rumah, pohon, pagar, peti dan lentera digunakan ulang dari proyek BARA 1946 milik Constancexz. Material dan font Roblox. Belum ada audio atau gambar arsip. Latar Lubang Buaya adalah rekonstruksi artistik, bukan replika denah 1965.",UDim2.new(1,0,0,84),UDim2.fromOffset(0,260),16)
 assetNote.TextColor3=Style.secondary;assetNote.LineHeight=1.15
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
  self.subtitle.TextSize=if compact then 16 else 22;self.subtitle.Position=UDim2.fromOffset(0,titleSize+24)
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
   local b=self.navigation[name];b.Position=UDim2.fromOffset(col*(width+16),row*pitch);b.Size=UDim2.fromOffset(width,44);b.TextSize=if compact then 16 else 18
  end
  nav.CanvasSize=UDim2.fromOffset(0,total)
  self.meta.Position=UDim2.fromOffset(margin,h-20);self.meta.Size=UDim2.new(1,-margin*2,0,18)
  local active="Settings";for name,frame in pairs(self.pages) do if frame.Visible then active=name;break end end
  local width=math.min(({Settings=640,Chapters=744,Archive=704,Credits=744})[active],w-32)
  local small=h<410;local narrow=width<440;local stacked=width<540
  local inset=if narrow or small then 20 else 32
  local header=if small then 84 else 128;local footer=if small then 56 else 64;local bodyGap=if small then 12 else 16
  local inline=small and not stacked;local settingsShift=if inline then 24 else 0
  local heights={Settings=if stacked then 456 else 360-settingsShift,Chapters=312,Archive=if narrow then 308 else 252,Credits=if stacked then 480 else 344}
  for name,height in pairs(heights) do self.pages[name].Size=UDim2.new(1,-8,0,height) end
  panel.Size=UDim2.fromOffset(width,math.min(header+heights[active]+footer+bodyGap,h-32))
  self.eyebrow.Position=UDim2.fromOffset(inset,if small then 8 else 24);self.eyebrow.Size=UDim2.new(1,-inset*2,0,16)
  self.panelTitle.Position=UDim2.fromOffset(inset,if small then 32 else 52);self.panelTitle.TextSize=if narrow or small then 23 else 28
  self.panelTitle.Size=UDim2.new(1,-inset*2,0,if small then 28 else 38)
  self.panelRule.Position=UDim2.fromOffset(inset,if small then 68 else 106);self.panelRule.Size=UDim2.new(1,-inset*2,0,1)
  content.Position=UDim2.fromOffset(inset,header);content.Size=UDim2.new(1,-inset*2,1,-header-footer-bodyGap)
  self.footerRule.Position=UDim2.new(0,inset,1,-footer);self.footerRule.Size=UDim2.new(1,-inset*2,0,1)
  self.back.Position=UDim2.new(0,inset-8,1,-footer+8)
  self.panelFooter.Position=UDim2.new(0,188,1,if small then -36 else -40);self.panelFooter.Size=UDim2.new(1,-188-inset,0,18);self.panelFooter.Visible=width>=480
  self.chapterStart.TextSize=if narrow then 18 else 22
  local archivePage=self.pages.Archive
  archivePage.Count.TextSize=if narrow then 42 else 58
  archivePage.Empty.Position=if narrow then UDim2.fromOffset(0,104) else UDim2.fromOffset(112,48)
  archivePage.Empty.Size=UDim2.new(1,if narrow then 0 else -112,0,72);archivePage.Empty.TextSize=if narrow then 22 else 24
  archivePage.Note.Position=if narrow then UDim2.fromOffset(0,188) else UDim2.fromOffset(112,132)
  archivePage.Note.Size=UDim2.new(1,if narrow then 0 else -112,0,if narrow then 120 else 112)
  for i,name in ipairs({"Master","Ambient","UI"}) do
   local y=56-settingsShift+(i-1)*(if stacked then 80 else 56)
   local label,value,slider=self.settings[name.."Label"],self.settings[name.."Value"],self.settings[name.."Slider"]
   label.Position=UDim2.fromOffset(0,y+(if stacked then 0 else 12));label.Size=UDim2.new(1,if stacked then -64 else -220,0,22)
   value.Position=UDim2.new(1,-52,0,y+(if stacked then 0 else 12))
   slider.Position=UDim2.fromOffset(if stacked then 0 else 156,y+(if stacked then 20 else 0));slider.Size=UDim2.new(1,if stacked then 0 else -220,0,44)
  end
  local settingsPage=self.pages.Settings
  settingsPage.Note.Position=UDim2.fromOffset(if inline then 128 else 0,if inline then 0 else 24);settingsPage.Note.Size=UDim2.new(1,if inline then -128 else 0,0,24)
  settingsPage.AccessRule.Position=UDim2.fromOffset(0,(if stacked then 296 else 232)-settingsShift)
  settingsPage.AccessHeading.Position=UDim2.fromOffset(0,(if stacked then 316 else 252)-settingsShift)
  local motion=self.settings.Motion
  motion.Position=UDim2.fromOffset(0,(if stacked then 344 else 276)-settingsShift);motion.Size=UDim2.new(1,0,0,if narrow then 56 else 48)
  motion.TextYAlignment=if narrow then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
  motion:FindFirstChildOfClass("UIPadding").PaddingTop=UDim.new(0,if narrow then 4 else 0)
  motion.State.Position=if narrow then UDim2.fromOffset(0,28) else UDim2.new(1,-132,.5,-8)
  motion.State.TextXAlignment=if narrow then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right
  settingsPage.MotionNote.Position=UDim2.fromOffset(0,(if stacked then 410 else 332)-settingsShift);settingsPage.MotionNote.Size=UDim2.new(1,0,0,if stacked then 46 else 28)
  for i,row in ipairs(self.creditRows) do
   local y=36+(i-1)*(if stacked then 58 else 42)
   row.name.Position=UDim2.fromOffset(0,y)
   row.role.Position=UDim2.fromOffset(if stacked then 0 else 176,y+(if stacked then 25 else 3));row.role.Size=UDim2.new(1,if stacked then 0 else -176,0,24)
   row.line.Position=UDim2.fromOffset(0,y+(if stacked then 51 else 32))
  end
  self.pages.Credits.Assets.Position=UDim2.fromOffset(0,if stacked then 296 else 232)
  self.pages.Credits.AssetNote.Position=UDim2.fromOffset(0,if stacked then 324 else 260);self.pages.Credits.AssetNote.Size=UDim2.fromOffset(math.min(560,width-inset*2-8),if stacked then 156 else 84)
 end
 self.resize=root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()self:layout()end);self:layout()
 return self
end
return View
