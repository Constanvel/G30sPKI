--!strict
local AssetService=game:GetService("AssetService")
local assets=require(script.Parent.MenuAssetData)
local Environment={}
local origin=Vector3.new(1000,128,0)
local treeTemplate
local C={plaster=Color3.fromRGB(204,188,153),cream=Color3.fromRGB(222,211,181),stone=Color3.fromRGB(111,105,87),
 wood=Color3.fromRGB(78,58,39),timber=Color3.fromRGB(113,82,49),roof=Color3.fromRGB(122,66,43),
 green=Color3.fromRGB(76,91,72),iron=Color3.fromRGB(49,54,48),gold=Color3.fromRGB(162,130,70)}
local function safe(p)
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
end
local function treeSource()
 if treeTemplate then return treeTemplate end
 local model=Instance.new("Model");model.Name="BroadleafTemplate"
 local ok=pcall(function()
  for _,row in ipairs(assets.Tree.parts)do
   local p
   if row.mesh then
    p=AssetService:CreateMeshPartAsync(Content.fromUri(row.mesh),{CollisionFidelity=Enum.CollisionFidelity.Box,RenderFidelity=Enum.RenderFidelity.Automatic})
    p.TextureID=row.texture;p.DoubleSided=row.doubleSided
   else p=Instance.new("Part")end
   p.Name=row.name;p.Size=Vector3.new(unpack(row.size));p.CFrame=CFrame.new(unpack(row.cf))
   p.Color=Color3.new(unpack(row.color));p.Material=Enum.Material[row.material];p.Transparency=row.transparency;safe(p)
   if row.surface then local s=Instance.new("SurfaceAppearance");for k,v in pairs(row.surface)do s[k]=if k=="AlphaMode"then Enum.AlphaMode[v]else v end;s.Parent=p end
   p.Parent=model
  end
 end)
 if not ok then model:Destroy();return nil end
 model.WorldPivot=CFrame.identity;treeTemplate=model;return model
end

function Environment.create()
 local scene=Instance.new("Model");scene.Name="MenuEnvironment"
 scene:SetAttribute("Location","Yogyakarta, 1 Maret 1949");scene:SetAttribute("ArtisticReconstruction",true)
 scene:SetAttribute("VisualRevision","YOGYAKARTA-SUNRISE-02");scene:SetAttribute("MenuFOV",52)
 local function group(name,parent)local m=Instance.new("Model");m.Name=name;m.Parent=parent or scene;return m end
 local street=group("Street");local west=group("WestFrontages");local east=group("EastFrontages")
 local props=group("StreetProps");local greenery=group("Greenery");local distance=group("DistantCity");local fighters=group("Fighters")
 local function part(parent,name,size,cf,color,material,shape)
  local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=CFrame.new(origin)*cf
  p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;if shape then p.Shape=shape end
  safe(p);p.Parent=parent;return p
 end
 local function beam(parent,name,a,b,width,color,material)
  return part(parent,name,Vector3.new(width,width,(a-b).Magnitude),CFrame.lookAt((a+b)/2,b),color,material)
 end
 local function sign(parent,name,cf,size,text,color)
  local p=part(parent,name,size,cf,color or C.wood,Enum.Material.Wood)
  local gui=Instance.new("SurfaceGui");gui.Name="Lettering";gui.Face=Enum.NormalId.Front;gui.CanvasSize=Vector2.new(640,160)
  gui.LightInfluence=1;gui.Parent=p
  local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
  label.Font=Enum.Font.Antique;label.Text=text;label.TextSize=48;label.TextColor3=C.cream;label.TextWrapped=true;label.Parent=gui
  return p
 end
 local function motion(p,pivot,offset,amplitude,phase,speed)
  p:SetAttribute("MenuMotionPivot",CFrame.new(origin)*pivot);p:SetAttribute("MenuMotionOffset",offset)
  p:SetAttribute("MenuMotionAmplitude",amplitude);p:SetAttribute("MenuMotionPhase",phase);p:SetAttribute("MenuMotionSpeed",speed)
 end
 part(street,"Ground",Vector3.new(240,2,340),CFrame.new(8,-1,-75),Color3.fromRGB(112,107,85),Enum.Material.Ground)
 part(street,"MainRoad",Vector3.new(36,.16,242),CFrame.new(8,.03,-69),Color3.fromRGB(132,119,94),Enum.Material.Cobblestone)
 local random=Random.new(1949)
 for i=1,62 do
  local x=random:NextNumber(-8,24);local z=random:NextNumber(-178,45)
  part(street,"RoadAggregate",Vector3.new(random:NextNumber(.1,.45),.035,random:NextNumber(.2,.6)),CFrame.new(x,.135,z)*CFrame.Angles(0,random:NextNumber(0,6),0),Color3.fromRGB(118+i%4*4,108+i%3*4,87+i%5*3),Enum.Material.Slate).CastShadow=false
 end
 for _,x in ipairs({-14,30})do
  part(street,"Pavement",Vector3.new(7.5,.38,242),CFrame.new(x,.12,-69),Color3.fromRGB(126,121,103),Enum.Material.Brick)
  local inner=if x<0 then x+3.7 else x-3.7
  part(street,"Drain",Vector3.new(.42,.035,240),CFrame.new(inner,.13,-69),Color3.fromRGB(67,67,57),Enum.Material.Slate)
  for i=0,39 do part(street,"CurbStone",Vector3.new(.55,.44,5.8),CFrame.new(inner,.25,48-i*6),C.stone,Enum.Material.Concrete)end
 end
 local function roof(model,frame,w,d,h,tint,detailed)
  local rise=3;local half=d/2+.7;local angle=math.atan(rise/half);local length=math.sqrt(half*half+rise*rise)
  for _,side in ipairs({-1,1})do
   local panel=frame*CFrame.new(0,h+rise/2,side*half/2)*CFrame.Angles(side*angle,0,0)
   part(model,"ClayRoof",Vector3.new(w+1.6,.23,length),panel,tint,Enum.Material.Brick)
   if detailed then
    for row=-3,3 do part(model,"TileCourse",Vector3.new(w+1.65,.09,.1),panel*CFrame.new(0,.15,row*length/7),tint:Lerp(C.timber,.18),Enum.Material.Brick)end
    for col=-3,3 do part(model,"TileSeam",Vector3.new(.055,.035,length),panel*CFrame.new(col*w/7,.15,0),tint:Lerp(C.wood,.22),Enum.Material.Brick).CastShadow=false end
   end
  end
  part(model,"RidgeCap",Vector3.new(w+1.8,.32,.38),frame*CFrame.new(0,h+rise+.1,0),tint:Lerp(C.wood,.16),Enum.Material.Brick)
 end
 local function shop(parent,index,z,w,stories,tint,title,arcade)
  local side=if parent==west then -1 else 1
  local frame=CFrame.new(if side<0 then -23 else 39,0,z)*CFrame.Angles(0,side*math.pi/2,0)
  local model=group(string.format("Shop%02d",index),parent);model:SetAttribute("FictionalShop",true)
  local d=17;local h=stories*7.7;local front=-d/2
  part(model,"PlasterMass",Vector3.new(w,h,d),frame*CFrame.new(0,h/2+.3,0),tint,Enum.Material.Plaster)
  part(model,"StonePlinth",Vector3.new(w+.2,1,d+.25),frame*CFrame.new(0,.65,0),C.stone,Enum.Material.Slate)
  part(model,"Cornice",Vector3.new(w+.6,.35,.6),frame*CFrame.new(0,h-.05,front-.22),C.cream,Enum.Material.Plaster)
  for _,x in ipairs({-w/2+.3,w/2-.3})do
   part(model,"Pilaster",Vector3.new(.45,h,.4),frame*CFrame.new(x,h/2+.3,front-.2),C.cream,Enum.Material.Plaster)
   part(model,"Capital",Vector3.new(.85,.3,.7),frame*CFrame.new(x,h-.5,front-.3),C.cream,Enum.Material.Plaster)
  end
  local function opening(x,y,door)
   local height=if door then 5.4 else 3.8
   part(model,"WindowRecess",Vector3.new(3.2,height+.3,.15),frame*CFrame.new(x,y,front-.15),Color3.fromRGB(35,42,36),Enum.Material.Wood)
   for _,s in ipairs({-1,1})do
    part(model,"WoodenShutter",Vector3.new(1.42,height,.16),frame*CFrame.new(x+s*.76,y,front-.28),if door then C.wood else C.green,Enum.Material.Wood)
    part(model,"ShutterRail",Vector3.new(1.45,.12,.1),frame*CFrame.new(x+s*.76,y-height*.25,front-.4),C.timber,Enum.Material.Wood)
    part(model,"ShutterRail",Vector3.new(1.45,.12,.1),frame*CFrame.new(x+s*.76,y+height*.25,front-.4),C.timber,Enum.Material.Wood)
   end
   part(model,"Lintel",Vector3.new(3.55,.28,.38),frame*CFrame.new(x,y+height/2+.15,front-.25),C.cream,Enum.Material.Concrete)
   part(model,"Sill",Vector3.new(3.55,.2,.48),frame*CFrame.new(x,y-height/2-.1,front-.3),C.stone,Enum.Material.Concrete)
  end
  for _,x in ipairs({-w*.32,0,w*.32})do opening(x,3.2,true);if stories==2 then opening(x,11.4,false)end end
  if stories==2 then part(model,"StoreyBand",Vector3.new(w+.4,.35,.5),frame*CFrame.new(0,8.1,front-.22),C.cream,Enum.Material.Plaster)end
  local porch=frame*CFrame.new(0,7.15,front-2)
  local awningColor=if index%2==0 then C.green else Color3.fromRGB(144,116,77)
  part(model,"Awning",Vector3.new(w+.9,.16,4.7),porch*CFrame.Angles(-.14,0,0),awningColor,Enum.Material.Fabric)
  for col=-2,2 do part(model,"CanvasStripe",Vector3.new(.75,.025,4.72),porch*CFrame.Angles(-.14,0,0)*CFrame.new(col*w/5,.11,0),Color3.fromRGB(185,173,135),Enum.Material.Fabric).CastShadow=false end
  for _,x in ipairs({-w/2+.4,w/2-.4})do
   part(model,if arcade then "ArcadeColumn"else "VerandaPost",Vector3.new(if arcade then .6 else .18,6.8,if arcade then .6 else .18),frame*CFrame.new(x,3.4,front-3.8),if arcade then C.cream else C.wood,if arcade then Enum.Material.Plaster else Enum.Material.Wood)
  end
  if arcade then part(model,"ArcadeBeam",Vector3.new(w+.5,.65,.6),frame*CFrame.new(0,6.8,front-3.8),C.cream,Enum.Material.Plaster)end
  if z> -90 then sign(model,"ShopSign",frame*CFrame.new(0,6.1,front-.6),Vector3.new(math.min(w-1,12),1.15,.2),title)end
  roof(model,frame,w,d,h,if index%2==0 then C.roof else Color3.fromRGB(139,82,51),z> -70)
 end
 local shades={C.plaster,Color3.fromRGB(172,178,152),Color3.fromRGB(192,177,145),Color3.fromRGB(210,201,175)}
 local titles={"TOKO SINAR MATARAM","WAROENG RAKJAT","TOKO OBAT","KAIN & BATIK","KOPERASI","PEROESAHAN DAGANG"}
 for i,z in ipairs({20,-6,-32,-58,-84,-110})do
  shop(west,i,z,if i%2==0 then 21 else 23,if i==1 or i==4 then 1 else 2,shades[(i-1)%4+1],titles[i],i%2==0)
  shop(east,i,z-3,if i%2==0 then 23 else 21,if i==3 then 1 else 2,shades[(i+1)%4+1],titles[7-i],i%2~=0)
 end
 local landmark=group("TuguPalPutih");landmark:SetAttribute("StylizedLandmark",true)
 local t=CFrame.new(8,0,-137);local white=Color3.fromRGB(223,216,190)
 part(landmark,"TrafficIsland",Vector3.new(.45,17,17),t*CFrame.new(0,.2,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(153,144,119),Enum.Material.Cobblestone,Enum.PartType.Cylinder)
 for _,e in ipairs({{8,.6,.7},{6.6,.55,1.25},{5.6,1,2},{4.4,5.4,5.2},{5,.45,8.15},{3.5,.7,8.7}})do part(landmark,"Pedestal",Vector3.new(e[1],e[2],e[1]),t*CFrame.new(0,e[3],0),white,Enum.Material.Plaster)end
 for _,side in ipairs({-1,1})do
  part(landmark,"InscriptionPanel",Vector3.new(2,2.6,.035),t*CFrame.new(0,5.1,side*2.215),Color3.fromRGB(105,103,89),Enum.Material.Slate)
  part(landmark,"GoldBorder",Vector3.new(2.3,.12,.06),t*CFrame.new(0,6.55,side*2.25),C.gold,Enum.Material.Metal)
 end
 for i=0,15 do local width=3.15-i*.12;part(landmark,"TaperedShaft",Vector3.new(width,.86,width),t*CFrame.new(0,9.5+i*.85,0),white,Enum.Material.Plaster)end
 part(landmark,"Crown",Vector3.new(1.65,.4,1.65),t*CFrame.new(0,23.1,0),C.gold,Enum.Material.Metal)
 for i=0,4 do local width=1.3-i*.23;part(landmark,"Finial",Vector3.new(width,.45,width),t*CFrame.new(0,23.5+i*.4,0),C.gold,Enum.Material.Metal)end
 for _,x in ipairs({-6,6})do for _,z in ipairs({-6,6})do part(landmark,"Bollard",Vector3.new(.5,1.3,.5),t*CFrame.new(x,.8,z),C.stone,Enum.Material.Concrete)end end
 local function wheel(model,frame,z,r,wood)
  local center=Vector3.new(0,r,z)
  for i=0,11 do
   local a=i*math.pi/6;local b=(i+1)*math.pi/6
   local p1=center+Vector3.new(0,math.cos(a)*r,math.sin(a)*r);local p2=center+Vector3.new(0,math.cos(b)*r,math.sin(b)*r)
   part(model,"WheelRim",Vector3.new(.12,.12,(p1-p2).Magnitude+.04),frame*CFrame.lookAt((p1+p2)/2,p2),if wood then C.wood else C.iron,if wood then Enum.Material.Wood else Enum.Material.Metal).CastShadow=false
   if i%2==0 then part(model,"WheelSpoke",Vector3.new(.035,.035,r),frame*CFrame.lookAt(center+(p1-center)*.5,p1),C.stone,Enum.Material.Metal).CastShadow=false end
  end
 end
 local function bicycle(cf)
  local m=group("Bicycle",props);wheel(m,cf,-1.45,1.05,false);wheel(m,cf,1.45,1.05,false)
  local a=Vector3.new(0,1.05,-1.45);local b=Vector3.new(0,1.05,1.45);local c=Vector3.new(0,2.2,.55);local d=Vector3.new(0,2.35,-.95);local e=Vector3.new(0,1.15,.15)
  for _,edge in ipairs({{a,d},{d,c},{c,b},{b,e},{e,c},{e,a},{e,d}})do part(m,"CycleFrame",Vector3.new(.085,.085,(edge[1]-edge[2]).Magnitude),cf*CFrame.lookAt((edge[1]+edge[2])/2,edge[2]),C.iron,Enum.Material.Metal)end
  part(m,"Saddle",Vector3.new(.6,.12,.45),cf*CFrame.new(0,2.4,.55),C.wood,Enum.Material.Leather)
  part(m,"Handlebar",Vector3.new(.9,.08,.1),cf*CFrame.new(0,2.6,-.95),C.iron,Enum.Material.Metal)
  part(m,"RearRack",Vector3.new(.6,.07,1.1),cf*CFrame.new(0,1.9,1.45),C.iron,Enum.Material.Metal)
 end
 bicycle(CFrame.new(25.5,.3,-19)*CFrame.Angles(0,1.15,0));bicycle(CFrame.new(-8.8,.3,-2)*CFrame.Angles(0,-1.2,0))
 local cart=group("MarketCart",props);local cartFrame=CFrame.new(-9,.3,-16)*CFrame.Angles(0,-.22,0)
 for _,x in ipairs({-1.45,1.45})do wheel(cart,cartFrame*CFrame.new(x,0,0),0,1.15,true)end
 part(cart,"CartBed",Vector3.new(3,.22,4.1),cartFrame*CFrame.new(0,1.5,0),C.timber,Enum.Material.WoodPlanks)
 for _,x in ipairs({-1.4,1.4})do
  part(cart,"CartSide",Vector3.new(.14,1.4,4.1),cartFrame*CFrame.new(x,2.2,0),C.wood,Enum.Material.WoodPlanks)
  part(cart,"Handle",Vector3.new(.12,.12,3),cartFrame*CFrame.new(x,1.8,-3),C.timber,Enum.Material.Wood)
 end
 for _,x in ipairs({-1.5,1.5})do for _,z in ipairs({-1.8,1.8})do part(cart,"CanopyPost",Vector3.new(.12,4,.12),cartFrame*CFrame.new(x,3.5,z),C.wood,Enum.Material.Wood)end end
 part(cart,"CartCanopy",Vector3.new(3.6,.12,4.6),cartFrame*CFrame.new(0,5.4,0)*CFrame.Angles(0,0,.06),Color3.fromRGB(153,139,101),Enum.Material.Fabric)
 for i=1,7 do part(cart,"ProduceBasket",Vector3.new(.8,.65,.8),cartFrame*CFrame.new((i%3-1)*.85,2,-1.4+math.floor(i/3)*1.2),Color3.fromRGB(135,110,66),Enum.Material.Wood)end
 for _,e in ipairs({{29,0,-24},{30,0,-27},{-12,0,-71},{30,0,-80},{-11,0,29}})do
  local frame=CFrame.new(unpack(e));local crate=group("DeliveryCrate",props)
  part(crate,"PlankBox",Vector3.new(1.8,1.6,1.8),frame*CFrame.new(0,.8,0),C.timber,Enum.Material.WoodPlanks)
  for _,side in ipairs({-1,1})do part(crate,"CrateBrace",Vector3.new(.14,1.7,1.9),frame*CFrame.new(side*.6,.8,0),C.wood,Enum.Material.Wood)end
 end
 for _,x in ipairs({-12,29})do
  local poles={}
  for i,z in ipairs({25,-23,-71,-119})do
   local p=Vector3.new(x,20,z);table.insert(poles,p)
   part(props,"TelegraphPole",Vector3.new(.32,20,.32),CFrame.new(x,10,z),C.wood,Enum.Material.Wood)
   part(props,"Crossarm",Vector3.new(4.2,.18,.25),CFrame.new(p),C.timber,Enum.Material.Wood)
   for _,offset in ipairs({-1.5,0,1.5})do part(props,"PorcelainInsulator",Vector3.new(.18,.35,.18),CFrame.new(x+offset,20.2,z),C.cream,Enum.Material.SmoothPlastic)end
   if i>1 then
    for _,offset in ipairs({-1.5,1.5})do
     local last=poles[i-1]+Vector3.new(offset,.25,0)
     for segment=1,6 do
      local t0=segment/6;local nextPoint=poles[i-1]:Lerp(p,t0)+Vector3.new(offset,.25-math.sin(t0*math.pi)*1.15,0)
      beam(props,"OverheadWire",last,nextPoint,.045,C.iron,Enum.Material.Metal).CastShadow=false;last=nextPoint
     end
    end
   end
  end
 end
 for i,e in ipairs({{24,-14},{-11,-34},{29,-70}})do
  local pole=CFrame.new(e[1],0,e[2]);part(props,"Flagpole",Vector3.new(.12,10,.12),pole*CFrame.new(0,5,0),C.iron,Enum.Material.Metal)
  for strip=0,4 do
   local pivot=pole*CFrame.new(0,8.8,0);local offset=CFrame.new(.32+strip*.56,0,math.sin(strip*.7)*.12)
   for _,entry in ipairs({{.48,Color3.fromRGB(163,43,35)},{-.48,Color3.fromRGB(218,213,190)}})do
    local o=offset*CFrame.new(0,entry[1],0);local p=part(props,"IndonesianFlag",Vector3.new(.58,.96,.045),pivot*o,entry[2],Enum.Material.Fabric)
    motion(p,pivot,o,.025+strip*.008,i*.6+strip*.45,1.25)
   end
  end
 end
 local source=treeSource()
 for i,e in ipairs({{-32,26,35},{46,27,31},{-43,-58,28},{48,-83,27},{-25,-157,23},{38,-164,22}})do
  if source then local tree=source:Clone();tree.Name="BroadleafTree";tree:ScaleTo(e[3]/assets.Tree.size[2]);tree:PivotTo(CFrame.new(origin+Vector3.new(e[1],e[3]/2,e[2]))*CFrame.Angles(0,i*.81,0));tree.Parent=greenery
  else
   local tree=group("BroadleafTree",greenery);part(tree,"Trunk",Vector3.new(1.2,e[3]*.6,1.2),CFrame.new(e[1],e[3]*.3,e[2]),C.wood,Enum.Material.Wood)
   for j=1,5 do part(tree,"Canopy",Vector3.new(11,6,10),CFrame.new(e[1]+math.sin(j*2)*5,e[3]-.8*j,e[2]+math.cos(j*2)*4),C.green,Enum.Material.Grass,Enum.PartType.Ball)end
  end
 end
 for i=1,18 do
  local x=-70+(i-1)*9;local h=8+(i*7)%15;local z=-184-(i%3)*12
  part(distance,"DistantFacade",Vector3.new(9,h,12),CFrame.new(x,h/2,z),Color3.fromRGB(159+i%4*7,151+i%3*6,128+i%2*6),Enum.Material.Plaster).CastShadow=false
  part(distance,"DistantCornice",Vector3.new(9.5,.5,12.5),CFrame.new(x,h+.2,z),C.plaster,Enum.Material.Plaster).CastShadow=false
  for _,offset in ipairs({-2.5,2.5})do part(distance,"DistantWindow",Vector3.new(1.6,2.6,.1),CFrame.new(x+offset,h*.65,z+6.1),Color3.fromRGB(104,113,102),Enum.Material.Wood).CastShadow=false end
  roof(distance,CFrame.new(x,0,z),9,12,h,C.roof,false)
 end
 local function fighter(index,x,z,shirt,hat)
  local model=group(string.format("Fighter%02d",index),fighters);model:SetAttribute("DecorativeFighter",true)
  local root=CFrame.new(x,0,z)*CFrame.Angles(0,(index-2.5)*.025,0);model.WorldPivot=CFrame.new(origin)*root
  local skin=Color3.fromRGB(153+index*5,113+index*4,76+index*3)
  local function p(name,size,offset,color,mat,shape)return part(model,name,size,root*offset,color,mat,shape)end
  p("Tunic",Vector3.new(2.05,2.05,1.05),CFrame.new(0,3.65,0),shirt,Enum.Material.Fabric)
  p("Collar",Vector3.new(1.6,.2,1.14),CFrame.new(0,4.65,0),shirt:Lerp(C.wood,.12),Enum.Material.Fabric)
  p("Belt",Vector3.new(2.1,.24,1.1),CFrame.new(0,2.87,0),C.wood,Enum.Material.Leather)
  p("Neck",Vector3.new(.55,.45,.55),CFrame.new(0,4.95,0),skin)
  p("Head",Vector3.new(1.22,1.2,1.15),CFrame.new(0,5.65,0),skin,Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  if hat=="Peci"then p("Peci",Vector3.new(1.27,.5,1.15),CFrame.new(0,6.23,0),C.iron,Enum.Material.Fabric)
  elseif hat=="FieldCap"then
   p("FieldCap",Vector3.new(1.28,.44,1.24),CFrame.new(0,6.2,0),C.green,Enum.Material.Fabric)
   p("CapPeak",Vector3.new(1.3,.1,.62),CFrame.new(0,6.05,-.73),C.green,Enum.Material.Fabric)
  else
   p("Hair",Vector3.new(1.28,.6,1.2),CFrame.new(0,6.1,.03),Color3.fromRGB(37,34,27),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
   if hat=="Headband"then p("Headband",Vector3.new(1.3,.18,1.22),CFrame.new(0,5.97,0),C.cream,Enum.Material.Fabric)end
  end
  local bagTint=if index%2==0 then Color3.fromRGB(99,99,69)else Color3.fromRGB(109,84,49)
  p("Backpack",Vector3.new(1.32,1.45,.62),CFrame.new(.12,3.67,.79),bagTint,Enum.Material.Fabric)
  p("PackFlap",Vector3.new(1.4,.48,.72),CFrame.new(.12,4.2,.85),bagTint:Lerp(C.wood,.16),Enum.Material.Fabric)
  p("PackBuckle",Vector3.new(.14,.3,.06),CFrame.new(.12,4,1.23),C.gold,Enum.Material.Metal)
  for _,side in ipairs({-1,1})do
   p("ShoulderStrap",Vector3.new(.17,2,.1),CFrame.new(side*.65,3.75,.59)*CFrame.Angles(0,0,side*.13),C.wood,Enum.Material.Leather)
   p("BeltPouch",Vector3.new(.5,.6,.34),CFrame.new(side*.78,2.9,.66),C.wood,Enum.Material.Leather)
   local phase=(index-1)*1.3+(if side<0 then math.pi else 0)
   local hip=root*CFrame.new(side*.54,2.65,0);local legOffset=CFrame.new(0,-1.06,0)
   local leg=part(model,"TrouserLeg",Vector3.new(.85,2.1,.92),hip*legOffset,C.green:Lerp(C.wood,index*.08),Enum.Material.Fabric)
   motion(leg,hip,legOffset,.28,phase,1.4)
   local bootOffset=CFrame.new(0,-2.3,-.17);local boot=part(model,"Boot",Vector3.new(.9,.55,1.35),hip*bootOffset,C.iron,Enum.Material.Leather)
   motion(boot,hip,bootOffset,.28,phase,1.4)
   local shoulder=root*CFrame.new(side*1.34,4.42,0);local armOffset=CFrame.new(0,-.85,0)
   local arm=part(model,"Sleeve",Vector3.new(.67,1.7,.79),shoulder*armOffset,shirt,Enum.Material.Fabric);motion(arm,shoulder,armOffset,-.18,phase,1.4)
   local handOffset=CFrame.new(0,-1.85,0);local hand=part(model,"Hand",Vector3.new(.59,.45,.63),shoulder*handOffset,skin);motion(hand,shoulder,handOffset,-.18,phase,1.4)
  end
  local sling=root*CFrame.new(-.98,3.4,1.02)*CFrame.Angles(0,0,-.3)
  part(model,"SlungPropStock",Vector3.new(.28,1.3,.28),sling*CFrame.new(0,-.6,0),C.timber,Enum.Material.Wood)
  part(model,"SlungPropForepiece",Vector3.new(.2,1.2,.2),sling*CFrame.new(0,.65,0),C.wood,Enum.Material.Wood)
  part(model,"SlungPropBarrel",Vector3.new(.085,.95,.085),sling*CFrame.new(0,1.55,0),C.iron,Enum.Material.Metal)
 end
 fighter(1,-3.8,18.5,Color3.fromRGB(145,135,94),"FieldCap")
 fighter(2,-.4,16.8,Color3.fromRGB(184,173,135),"Hair")
 fighter(3,3,19.3,Color3.fromRGB(203,193,156),"Headband")
 fighter(4,6.4,17.7,Color3.fromRGB(157,155,113),"Peci")
 local anchor=part(scene,"CameraAnchor",Vector3.one,CFrame.lookAt(Vector3.new(-8,5.6,39),Vector3.new(-8,6.3,-130)),Color3.new())
 anchor.Transparency=1;anchor.CastShadow=false
 -- Face the street into the morning sun; motion metadata uses the same world transform.
 local rotation=CFrame.new(origin)*CFrame.Angles(0,-math.pi/2+.55,0)*CFrame.new(-origin)
 scene.WorldPivot=CFrame.new(origin);scene:PivotTo(CFrame.new(origin)*CFrame.Angles(0,-math.pi/2+.55,0))
 for _,p in ipairs(scene:GetDescendants())do if p:IsA("BasePart") and p:GetAttribute("MenuMotionPivot")then p:SetAttribute("MenuMotionPivot",rotation*p:GetAttribute("MenuMotionPivot"))end end
 scene.Parent=workspace
 return scene
end
return Environment
