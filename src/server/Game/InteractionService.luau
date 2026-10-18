--!strict
local Players = game:GetService("Players")
local InteractionService = {}

function InteractionService.sceneError(scene, chapter)
 if not scene or not scene:IsA("Model") then return "Area demo tidak tersedia." end
 for _,name in ipairs({"SpawnMarker","CameraStart","CameraEnd"}) do
  local marker = scene:FindFirstChild(name)
  if not marker or not marker:IsA("BasePart") then return "Marker wajib tidak tersedia: " .. name end
 end
 local counts = {}
 for _,object in ipairs(scene:GetDescendants()) do
  if object:IsA("ProximityPrompt") and object.Parent and object.Parent:IsA("BasePart") then
   local id = object.Parent:GetAttribute("InteractionId")
   if typeof(id) == "string" then counts[id] = (counts[id] or 0) + 1 end
  end
 end
 for _,objective in ipairs(chapter.objectives) do
  if counts[objective.id] ~= 1 then return "Target interaksi hilang atau ganda: " .. objective.id end
 end
 return nil
end

function InteractionService.isAllowed(player, prompt, scene, expectedId)
 if typeof(player) ~= "Instance" or not player:IsA("Player") or player.Parent ~= Players then return false end
 if typeof(prompt) ~= "Instance" or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return false end
 if typeof(expectedId) ~= "string" or not prompt:IsDescendantOf(scene) then return false end
 local target = prompt.Parent
 if not target or not target:IsA("BasePart") or target:GetAttribute("InteractionId") ~= expectedId then return false end
 local character = player.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 local root = character and character:FindFirstChild("HumanoidRootPart")
 if not humanoid or humanoid.Health <= 0 or not root or not root:IsA("BasePart") then return false end
 local direction = target.Position - root.Position
 if not (direction.Magnitude <= math.min(prompt.MaxActivationDistance, 8)) then return false end
 local raycastParams = RaycastParams.new()
 raycastParams.FilterType = Enum.RaycastFilterType.Exclude
 raycastParams.FilterDescendantsInstances = {character}
 local hit = workspace:Raycast(root.Position, direction, raycastParams)
 return hit == nil or hit.Instance == target or hit.Instance:IsDescendantOf(target)
end

return InteractionService
