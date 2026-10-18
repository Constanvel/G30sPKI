-- LightingStyle is Studio-only; LocalScripts cannot write it.
assert(not game:GetService("RunService"):IsRunning(),"Run in Studio Edit mode")
game:GetService("Lighting").LightingStyle=Enum.LightingStyle.Realistic
return "Realistic renderer configured; save the place to retain this setting."
