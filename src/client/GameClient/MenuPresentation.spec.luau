--!strict
return function(player)
 local root, count = script.Parent, 0
 local function check(value,message) assert(value,message); count+=1 end
 check(root:FindFirstChild("MainMenuController")~=nil,"RED: MainMenuController belum tersedia")
 local gui = player.PlayerGui:FindFirstChild("MainMenuGui")
 check(gui~=nil and gui.Enabled,"Menu tampil saat startup")
 for _,name in ipairs({"Start","Resume","Chapters","Archive","Settings","Credits"}) do
  local button=gui.Root.Navigation:FindFirstChild(name)
  check(button and button:IsA("TextButton") and button.AbsoluteSize.Y>=44,"Navigasi/target sentuh tidak lengkap: "..name)
  check(button.TextFits,"Teks tombol terpotong: "..name)
 end
 check(gui.Root.Navigation.Resume:GetAttribute("Available")==false,"Resume awal harus nonaktif")
 check(gui.Panel.Content.Archive.Empty.Text:find("Belum ada")~=nil,"Arsip harus jujur kosong")
 check(gui.Panel.Content.Chapters.Locked.Text:find("TERKUNCI")~=nil,"POV berikutnya harus terkunci")
 check(gui.Panel.Content.Settings:FindFirstChild("Motion")~=nil,"Reduced motion harus tersedia")
 check(gui.Panel.Content.Settings:FindFirstChild("MasterMinus")~=nil,"Pengaturan volume harus tersedia")
 check(workspace.CurrentCamera.CameraType==Enum.CameraType.Scriptable,"Menu menggunakan kamera Scriptable")
 local viewport=workspace.CurrentCamera.ViewportSize
 for _,button in ipairs(gui.Root.Navigation:GetChildren()) do
  if button:IsA("TextButton") then
   local position,size=button.AbsolutePosition,button.AbsoluteSize
   check(position.X>=0 and position.Y>=0 and position.X+size.X<=viewport.X+1 and position.Y+size.Y<=viewport.Y+1,"Navigasi di luar viewport")
  end
 end
 return tostring(count).." assertions PASS"
end
