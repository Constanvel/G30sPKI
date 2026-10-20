# Pemulihan menu awal — 20 Oktober 2026

Menu dan animasi lama masih tersedia. Penyebab menu tidak muncul ketika Play adalah mode EnamJamLobby yang baru: Bootstrap lama pada client dan server langsung return saat Config.Enabled true. Alur baru langsung membuat HUD briefing dan melewatkan menu sinematik.

Menu sinematik ENAM JAM kini dipasang di depan alur lobby baru. MULAI mengembalikan kamera ke karakter, mengaktifkan HUD lobby, dan memulihkan WalkSpeed, JumpPower, JumpHeight, AutoRotate, serta kontrol. Karakter dibatasi selama menu aktif; respawn ketika menu terbuka tetap terkunci sampai Mulai. Panggilan karakter ganda tidak menimpa nilai kontrol asli. Mode lobby baru tetap Enabled=true.

## Berkas pekerjaan ini

- src/client/GameClient/LobbyStartupMenu.luau: penghubung menu lama ke startup lobby baru.
- src/client/GameClient/LobbyStartupMenu.spec.luau: delapan assertion untuk lock/release, input berulang, dan callback karakter lama.
- src/enamjam/client/Lobby/Client.local.luau: salinan script client lobby aktif dengan dua baris integrasi startup. Native path: StarterPlayer.StarterPlayerScripts.EnamJamLobby.Client.
- docs/qa/startup-menu-restored.jpg: cuplikan Play setelah menu dipulihkan.

Script client sebelumnya dicadangkan lokal ke backups/enamjam-lobby-client-before-intro-20261020.luau. Tidak ada penghapusan, perubahan server, antrean, map, isi briefing, atau pengembalian alur prolog lama.

## Verifikasi

- Sebelum perbaikan, Play hanya memiliki EnamJamLobbyUI dan tidak memiliki MainMenuGui.
- Setelah perbaikan, Play menampilkan MainMenuGui; HUD lobby tersembunyi, kamera Scriptable, WalkSpeed 0.
- Klik Pengaturan, aktifkan reduced motion, lalu Kembali: berfungsi.
- Respawn ketika menu terbuka: menu tetap tampil dan karakter baru terkunci.
- Klik MULAI: menu nonaktif, HUD lobby aktif, kamera Custom dengan CameraSubject Humanoid; WalkSpeed 16, JumpPower 50, JumpHeight sekitar 7,2, AutoRotate true.
- LobbyStartupMenu.spec: 8 assertion lulus. MenuAnimation.spec: 24 assertion lulus. Tidak ada MessageError pada sesi alur terakhir.
- Isi dua modul dan client lobby di Studio cocok dengan salinan lokal. StarterGui.GameGui.Enabled tetap false di Edit. Studio dikembalikan ke Edit.
- git diff --check lulus. Branch feat/enam-jam-1949, origin https://github.com/Constanvel/G30sPKI.git. Tidak ada commit, push, atau Publish.

Modul baru dipasang langsung ke Studio karena file baru tidak muncul otomatis melalui Script Sync pada sesi ini. Salinan kode sudah disimpan lokal. Simpan place melalui File → Download a Copy… untuk menyimpan penambahan native bersama map lobby terbaru; tidak perlu Publish. Belum diuji pada ponsel fisik atau multiplayer bersamaan.

## Git opsional

Perintah berikut hanya untuk berkas pemulihan ini; salinan Client.local.luau juga menyimpan isi script lobby native yang sebelumnya belum ada di Git.

```powershell
git add -- src/client/GameClient/LobbyStartupMenu.luau src/client/GameClient/LobbyStartupMenu.spec.luau src/enamjam/client/Lobby/Client.local.luau docs/STARTUP_MENU_RESTORE.md docs/qa/startup-menu-restored.jpg
git diff --cached
git commit -m "fix: restore cinematic menu before lobby startup"
git push origin feat/enam-jam-1949
```
