# FPS dan visible body — ENAM JAM: 1949

Implementasi 19 Oktober 2026. Perubahan mencakup permintaan advanced movement dan tindak lanjut true first-person dengan tubuh terlihat. Tidak mengubah map permanen, menu, senjata, combat, misi atau konten sejarah. Belum commit, push, atau publish.

## Hasil

- WASD dan diagonal ternormalisasi; percepatan/perlambatan memakai delta time.
- Shift sprint ke depan; C/Ctrl toggle crouch; crouch ketika sprint memicu slide pendek dengan cooldown. Space lompat sekali per penekanan. Alt melepas kursor untuk tombol MENU.
- Humanoid tetap menangani physics dan collision. HipHeight turun saat crouch; overlap/blockcast mencegah berdiri atau melompat di bawah plafon. Slide melakukan sweep dinding dan memeriksa normal permukaan.
- Delapan state: Idle, Walking, Sprinting, Crouching, Sliding, Jumping, Falling, Landing. Input dan kamera hanya dimiliki FPS saat fase exploring; narasi dan cutscene mengambil kembali kendali lewat Bootstrap yang sama.
- Kamera first person memakai yaw/pitch langsung, FOV eksponensial, bob/sway ringan, respons landing dan transisi tinggi crouch. Posisi mata mengikuti root agar animasi kepala tidak menggoyang kamera. Spherecast membatasi offset mata dekat geometri.
- Tubuh menggunakan karakter asli. Kepala dan seluruh bagian aksesori kepala disembunyikan hanya secara lokal; torso, lengan, tangan, kaki dan pakaian tubuh tetap terlihat. Bagian yang tepat berisi posisi kamera disembunyikan lokal untuk menghindari tampilan dari dalam mesh.
- Pose tangan siaga, napas, langkah, sprint, crouch, slide serta jump/landing ditambahkan secara prosedural. Animasi bawaan tetap menjadi dasar untuk kaki dan tubuh. Mendukung Motor6D dan AnimationConstraint tanpa mengedit RigAttachment/C0. Offset dibersihkan sebelum Animator lalu diterapkan saat PreSimulation; tidak ditumpuk tanpa batas.
- Peer pose membaca state/crouch dari atribut server. Efek kamera dan visibilitas first person tidak direplikasi ke pemain lain.
- Input berhenti/focus loss/chat/menu membersihkan input, arah gerak dan antrean jump. Respawn, keluar FPS dan aktivasi berulang melepas callback, mengembalikan transparansi, pose, FOV, mode kamera dan kursor.
- Server memeriksa karakter aktif, fase, health, sequence, tipe/ukuran arah input, token bucket, cooldown, clearance dan batas perpindahan horizontal kumulatif. Client tidak mengirim angka kecepatan atau posisi. Teleport resmi memperbarui baseline; koreksi pelanggaran tidak memberikan slack baru. Ini perlindungan dasar, bukan sistem anti-cheat menyeluruh.

## Berkas

| Berkas | Peran |
| --- | --- |
| src/shared/Shared/Shared/MovementConfig.luau | Seluruh parameter movement, kamera dan pose utama |
| src/shared/Shared/Shared/MovementState.luau | Transisi state dan timer bersama |
| src/shared/Shared/Shared/MovementCollision.luau | Clearance, ground/slope, sweep, tinggi collider |
| src/client/GameClient/MovementController.luau | Input, prediksi, kamera, lifecycle, integrasi body/peer |
| src/client/GameClient/FirstPersonBody.luau | Visibilitas avatar asli dan pose prosedural |
| src/server/Game/MovementService.luau | Input server, posture/state replication, validasi perpindahan |
| src/client/GameClient/Bootstrap.local.luau | Handoff kontrol FPS sesuai fase existing |
| src/server/Game/Bootstrap.server.luau | Binding karakter, phase lock dan teleport resmi |
| src/client/GameClient/MovementController.spec.luau | Pengujian input/kamera/lifecycle |
| src/client/GameClient/FirstPersonBody.spec.luau | Pengujian rig, aksesori, pose dan pemulihan visibility |
| src/server/Game/Tests/MovementState.spec.luau | Pengujian state dan time-step |
| src/server/Game/Tests/MovementValidation.spec.luau | Pengujian batas kepercayaan client/server |
| src/server/Game/Tests/MovementCollision.spec.luau | Fixture geometri native R6/R15 |

Perubahan avatar lobby, README dan draft src/enamjam yang sudah ada sebelum tugas ini dipertahankan; bukan bagian commit FPS.

## Parameter awal

| Parameter | Nilai |
| --- | --- |
| Walk / sprint / crouch | 13 / 20 / 6 stud per detik |
| Acceleration / deceleration | 95 / 120 stud per detik kuadrat |
| Jump height / cooldown / buffer | 3,8 stud / 0,25 dtk / 0,10 dtk |
| Crouch drop / transisi | 1,1 stud / 0,20 dtk |
| Slide speed awal → akhir | 24 → 8 stud per detik |
| Slide duration / cooldown setelah slide | 0,65 / 1,1 dtk |
| FOV walk / sprint / slide | 72 / 78 / 76 derajat |
| Sensitivitas mouse | 1; 0,0025 radian per pixel sebelum multiplier |
| Bob walk / sprint; sway | 0,025 / 0,04 stud; 0,22 derajat |
| Offset mata depan / atas | 0,25 / 0,10 stud; maju sesuai tebal torso saat melihat ke bawah |
| Blend pose | Respons eksponensial 14 |
| Shoulder / elbow ready | 1,15 / 0,65 radian |
| Hip / knee / ankle crouch | 1,05 / -2,1 / 1,05 radian |
| Server simulation / input heartbeat | 20 / sampai 10 Hz di arah gerak tetap |
| Input rate / burst | 24 per detik / 12 |

Pengaturan Gerakan dikurangi yang sudah ada meniadakan bob, sway, perubahan FOV sprint, serta napas/ayunan tambahan. Perubahan postur fungsional tetap aktif. API untuk kontrol platform lain: setMoveVector, setSprint, toggleCrouch, jump, setSuspended; UI mobile belum ditambahkan.

## Bukti QA

Hasil numerik dan status akhir tersimpan di docs/qa/fps-movement-tests.json. Capture native Studio: [depan](qa/fps-body-front.jpg) dan [melihat ke bawah](qa/fps-body-down.jpg).

244 assertion FPS lulus: state 125, validasi server 50, collision 14, controller 25, visible body 30. Regresi lulus: lobby server 36, scene 12, lobby client 225 dan avatar/loadout 248. Seluruh 13 sumber Luau task ini cocok antara disk dan Studio setelah normalisasi newline. Studio selesai dalam mode Edit, GameGui template nonaktif dan tidak ada fixture/script QA sementara tersisa.

Sampel final 1.200 frame selama 39,91 detik mengukur gabungan callback physics dan kamera: CPU median 0,391 ms, P95 0,600 ms, maksimum 1,328 ms. Ini bukan biaya seluruh frame atau benchmark multiplayer. Sampel awal sebelum penyesuaian driver lebih ringan; angka final di atas yang dipakai untuk laporan.

Suite native mencakup state pada 30/60/120 Hz serta hitch, diagonal, input bersamaan/berulang, cooldown, snapshot terlambat, rate limit, input nonfinite, karakter lama/mati, teleport/rollback, clearance R6/R15, aksesori kepala multipart, cleanup Transform dan visibility, aktivasi berulang serta CharacterRemoving/Added. Regresi lobby, avatar/loadout dan scene juga diperiksa.

Uji Play satu client menunjukkan: berjalan pada 13 stud/detik dan berhenti setelah key-up; sprint/slide teramati di client dan server; slide pulih ke crouch; plafon menahan stand/jump; dinding tidak ditembus; berjalan menaiki ramp 12 derajat; jump naik lalu mendarat tanpa autojump selama Space ditahan; respawn memulihkan first person dan visible body; MENU mengembalikan kepala/transparansi dan kursor. Fixture geometri dan script QA hanya dibuat selama Play dan dibuang ketika berhenti.

Catatan penting pengujian: VirtualInput dari koneksi Studio tidak menjaga fokus window. Smoke test input memakai LocalScript QA sementara yang membebaskan suspend khusus sesi uji. Pengujian unit tetap memeriksa jalur suspend asli. Pose lihat-ke-bawah pada capture menggunakan pitch deterministik di harness. Alur fase sebagian diuji dengan tombol dan sebagian dengan request yang melewati remote/validasi asli. Harness tidak disertakan dalam sumber produksi.

Audit native menemukan PlayerModule tidak ada di PlayerScripts pada sesi ini. Selain itu, Humanoid:Move di PreSimulation dapat ditimpa callback input Roblox. Driver menerapkan Move/Jump lewat satu callback kamera existing setelah input/camera, sementara state, collider dan pose dihitung di physics. Ini diverifikasi dengan perpindahan/velocity nyata, bukan atribut state saja.

## Batas dan tuning berikutnya

- Belum menjalankan sesi 2/4 client, simulasi latensi jaringan nyata, perangkat fisik, pembatasan FPS rendering 30/120, atau soak test berjam-jam. Uji time-step adalah simulasi state, bukan klaim render stabil pada semua hardware. Biaya callback satu client di scene prototipe tidak mewakili seluruh frame atau map final.
- Movement/state dapat berbeda sesaat selama prediksi dan replikasi. Nilai validasi horizontal, lag allowance dan koreksi perlu dikalibrasi pada server multiplayer dan platform bergerak sebelum rilis.
- Belum ada asset animasi khusus FPS/crouch/slide atau foot IK. Fallback menggunakan animasi Roblox dan pose prosedural. Rig gameplay saat ini putih karena setup lama memakai LoadCharacterAppearance=false; pengaturan appearance dipertahankan. Avatar proporsi ekstrem dan semua bundle/aksesori belum diuji.
- Arah dihitung pada langkah physics lalu diterapkan pada render berikutnya; nilai rasa kontrol saat perubahan arah cepat perlu dinilai manual, terutama pada 30 FPS. Tidak ada animasi senjata atau viewmodel baru.
- Untuk mengurangi cakupan tangan di layar, turunkan ArmReady atau ArmInward sedikit; sesuaikan ElbowReady bersama-sama. Untuk lebih tenang, kecilkan ArmSwing, SprintArmSwing dan BodyBreath. Ganti fallback dengan asset animasi milik proyek setelah tersedia.
- Mulai tuning movement dari sprint 18–20, slide 0,55–0,65 dtk dan bob yang sudah kecil. Ubah satu parameter lalu uji keyboard/mouse nyata; jangan menaikkan validasi hanya untuk menyembunyikan koreksi yang belum dipahami.

Dasar teknis: [AnimationConstraint](https://create.roblox.com/docs/reference/engine/classes/AnimationConstraint), [Humanoid HipHeight](https://create.roblox.com/docs/reference/engine/classes/Humanoid#HipHeight), [WorldRoot Blockcast](https://create.roblox.com/docs/reference/engine/classes/WorldRoot#Blockcast), [RenderPriority](https://create.roblox.com/docs/reference/engine/enums/RenderPriority).

## Git opsional

Branch: feat/enam-jam-1949. Remote: https://github.com/Constanvel/G30sPKI.git. Belum menjalankan perintah berikut. Stage hanya task ini, jangan memakai git add . karena ada perubahan avatar lobby yang sudah ada.

```powershell
git add -- src/client/GameClient/Bootstrap.local.luau src/server/Game/Bootstrap.server.luau src/client/GameClient/MovementController.luau src/client/GameClient/MovementController.spec.luau src/client/GameClient/FirstPersonBody.luau src/client/GameClient/FirstPersonBody.spec.luau src/server/Game/MovementService.luau src/server/Game/Tests/MovementState.spec.luau src/server/Game/Tests/MovementValidation.spec.luau src/server/Game/Tests/MovementCollision.spec.luau src/shared/Shared/Shared/MovementConfig.luau src/shared/Shared/Shared/MovementState.luau src/shared/Shared/Shared/MovementCollision.luau docs/FPS_MOVEMENT_RESULT.md docs/qa/fps-movement-tests.json docs/qa/fps-body-front.jpg docs/qa/fps-body-down.jpg docs/superpowers/plans/2026-10-19-fps-movement.md
git diff --cached --stat
git commit -m "feat: add FPS movement and visible body controller"
git push origin feat/enam-jam-1949
```

Kode tersimpan melalui Script Sync. Tidak memerlukan ekspor place baru untuk perubahan source saja; Studio dikembalikan ke Edit setelah pemeriksaan akhir.
