--!strict
return function(player)
 local root, count = script.Parent, 0
 local function check(value,message) assert(value,message); count+=1 end
 check(root:FindFirstChild("MainMenuController")~=nil,"RED: MainMenuController belum tersedia")
 local gui = player.PlayerGui:FindFirstChild("MainMenuGui")
 check(gui~=nil and gui.Enabled,"Menu tampil saat startup")
 check(gui.Root.Brand.Kicker.Text:find("YOGYAKARTA",1,true)~=nil,"Label lokasi harus sesuai latar")
 check(gui.Root.Brand.Year.Text=="ENAM JAM" and gui.Root.Brand.Subtitle.Text=="1949","Identitas kampanye harus sesuai")
 check(gui.ScreenInsets==Enum.ScreenInsets.CoreUISafeInsets,"Menu harus menghormati area Roblox CoreGui")
 for _,name in ipairs({"Start","Resume","Chapters","Archive","Settings","Credits"}) do
  local button=gui.Root.Navigation:FindFirstChild(name)
  check(button and button:IsA("TextButton") and button.AbsoluteSize.Y>=44,"Navigasi/target sentuh tidak lengkap: "..name)
  check(button.TextFits,"Teks tombol terpotong: "..name)
 end
 check(gui.Root.Navigation.Resume:GetAttribute("Available")==false,"Resume awal harus nonaktif")
 check(gui.Panel.Content.Archive.Note.Text:find("FIKSI",1,true)~=nil,"Arsip harus membedakan adaptasi fiksi")
 check(gui.Panel.Content.Chapters.Prolog.Availability.Text=="PROLOG / TERSEDIA","Hanya prolog prototipe yang tersedia")
 check(gui.Panel.Content.Chapters.Planned6.Text=="DIRENCANAKAN","Epilog tidak boleh diklaim selesai")
 check(gui.Panel.Content.Settings:FindFirstChild("Motion")~=nil,"Reduced motion harus tersedia")
 check(gui.Panel.Content.Settings:FindFirstChild("MasterSlider")~=nil,"Pengaturan volume harus memakai slider")
 check(workspace.CurrentCamera.CameraType==Enum.CameraType.Scriptable,"Menu menggunakan kamera Scriptable")
 local viewport=workspace.CurrentCamera.ViewportSize
 check(gui.Root.AbsolutePosition.Y>=0,"Konten tidak boleh berada di atas area CoreGui")
 check(gui.Root.Brand.Year.TextFits and gui.Root.Brand.Subtitle.TextFits and gui.Root.Brand.Status.TextFits and gui.Root.Meta.TextFits,"Identitas atau teks sekunder terpotong")
 check(gui.Root.Brand.Status.AbsolutePosition.Y+gui.Root.Brand.Status.TextBounds.Y+6<=gui.Root.Navigation.AbsolutePosition.Y,"Tagline bertabrakan dengan navigasi")
 for _,button in ipairs(gui.Root.Navigation:GetChildren()) do
  if button:IsA("TextButton") then
   local position,size=button.AbsolutePosition,button.AbsoluteSize
   check(position.X>=0 and position.Y>=0 and position.X+size.X<=viewport.X+1 and position.Y+size.Y<=viewport.Y+1,"Navigasi di luar viewport")
  end
 end
 local fixture=require(root.MainMenuView).new(player)
 fixture.root.Size=UDim2.fromOffset(800,520); task.wait(0.1); fixture:layout()
 local last=fixture.navigation.Credits
 local fits=last.AbsolutePosition.Y+last.AbsoluteSize.Y<=fixture.nav.AbsolutePosition.Y+fixture.nav.AbsoluteSize.Y
 fixture.resize:Disconnect(); fixture.gui:Destroy()
 check(fits,"Jendela pendek harus menampilkan seluruh area tombol terakhir")
 return tostring(count).." assertions PASS"
end
