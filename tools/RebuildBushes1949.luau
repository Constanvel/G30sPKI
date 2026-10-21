-- Run in Studio Edit. Does not overwrite an existing library.
assert(not game:GetService("RunService"):IsRunning(),"Use Edit mode")
local libraryName="Bushes1949"
local data=game.HttpService:JSONDecode([==[
[
  {
    "surface": {
      "ColorMap": "rbxassetid://6995306226",
      "NormalMap": "",
      "RoughnessMap": "rbxassetid://5164022409",
      "AlphaMode": "Transparency",
      "MetalnessMap": ""
    },
    "color": [
      0.6392157077789307,
      0.6352941393852234,
      0.6470588445663452
    ],
    "cf": [
      0,
      1.4189162254333496,
      0,
      -0.994622528553009,
      -1.2609538413421717e-11,
      0.10356718301773071,
      8.194113790271906e-12,
      1,
      -4.305888978706207e-11,
      -0.1035671979188919,
      4.1978694825806073e-11,
      -0.9946224093437195
    ],
    "name": "SemakRimbun_01",
    "attributes": {
      "ArtisticAdaptation": true,
      "FootprintStuds": 4,
      "Source": "Creator Store 7990107300 / Qalus",
      "HeightStuds": 2.837832564463849
    },
    "size": [
      3.5182745456695557,
      2.837832450866699,
      3.6552789211273193
    ],
    "material": "Plastic",
    "mesh": "rbxassetid://3098951439",
    "texture": ""
  },
  {
    "surface": {
      "ColorMap": "rbxassetid://5638514330",
      "NormalMap": "",
      "RoughnessMap": "rbxassetid://5164022409",
      "AlphaMode": "Transparency",
      "MetalnessMap": ""
    },
    "color": [
      0.6392157077789307,
      0.6352941393852234,
      0.6470588445663452
    ],
    "cf": [
      0,
      1.482333779335022,
      0,
      -0.994622528553009,
      -9.851201885485716e-14,
      0.10356718301773071,
      6.401652076276285e-14,
      1,
      -3.3639757646142243e-13,
      -0.1035671979188919,
      3.2795855332660995e-13,
      -0.9946224093437195
    ],
    "name": "SemakLiar_02",
    "attributes": {
      "ArtisticAdaptation": true,
      "FootprintStuds": 4,
      "Source": "Creator Store 7990107300 / Qalus",
      "HeightStuds": 2.9646674531074346
    },
    "size": [
      3.593492269515991,
      2.964667558670044,
      3.647446393966675
    ],
    "material": "Plastic",
    "mesh": "rbxassetid://5638510861",
    "texture": ""
  },
  {
    "surface": {
      "ColorMap": "rbxassetid://5638514330",
      "NormalMap": "",
      "RoughnessMap": "rbxassetid://5164022409",
      "AlphaMode": "Transparency",
      "MetalnessMap": ""
    },
    "color": [
      0.6392157077789307,
      0.6352941393852234,
      0.6470588445663452
    ],
    "cf": [
      0,
      1.3825265169143677,
      0,
      -0.10356718301773071,
      8.424590371017629e-14,
      -0.994622528553009,
      2.0020705200022443e-13,
      1,
      -1.0554836898154368e-13,
      0.9946224093437195,
      2.1006177212175986e-13,
      -0.1035671979188919
    ],
    "name": "SemakRenggang_03",
    "attributes": {
      "ArtisticAdaptation": true,
      "FootprintStuds": 4,
      "Source": "Creator Store 7990107300 / Qalus",
      "HeightStuds": 2.765053127157118
    },
    "size": [
      2.4201745986938477,
      2.7650530338287354,
      3.769619941711426
    ],
    "material": "Plastic",
    "mesh": "rbxassetid://5638516110",
    "texture": ""
  }
]
]==])
local root=game.ServerStorage:FindFirstChild("EnvironmentAssets")or Instance.new("Folder")
root.Name="EnvironmentAssets";root.Parent=game.ServerStorage
assert(not root:FindFirstChild(libraryName),"Bush library already exists")
local library=Instance.new("Folder");library.Name=libraryName
local ok,message=pcall(function()
 for _,row in ipairs(data)do
  local bush=Instance.new("Model");bush.Name=row.name;bush.ModelStreamingMode=Enum.ModelStreamingMode.Atomic;bush.Parent=library
  local geometry=Instance.new("Model");geometry.Name="Geometry";geometry.Parent=bush
  local p=game.AssetService:CreateMeshPartAsync(Content.fromUri(row.mesh),{CollisionFidelity=Enum.CollisionFidelity.Box,RenderFidelity=Enum.RenderFidelity.Automatic})
  p.Name="LeavesAndTwigs";p.Size=Vector3.new(unpack(row.size));p.CFrame=CFrame.new(unpack(row.cf))
  p.TextureID=row.texture;p.Color=Color3.new(unpack(row.color));p.Material=Enum.Material[row.material]
  p.DoubleSided=true;p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.CanTouch=false
  local surface=Instance.new("SurfaceAppearance")
  for key,value in pairs(row.surface)do surface[key]=if key=="AlphaMode"then Enum.AlphaMode[value]else value end
  surface.Parent=p;p.Parent=geometry
  local pivot=Instance.new("Part");pivot.Name="Pivot";pivot.Size=Vector3.new(.1,.1,.1);pivot.CFrame=CFrame.identity
  pivot.Transparency=1;pivot.Anchored=true;pivot.CanCollide=false;pivot.CanQuery=false;pivot.CanTouch=false;pivot.CastShadow=false
  pivot.Parent=bush;bush.PrimaryPart=pivot;bush.WorldPivot=CFrame.identity
  for key,value in pairs(row.attributes)do bush:SetAttribute(key,value)end
 end
end)
if not ok then library:Destroy();error(message)end
library.Parent=root
return library:GetFullName()
