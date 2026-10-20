# Background menu ENAM JAM: 1949 — revisi realism 03

20 Oktober 2026. Revisi ini menghapus empat figur dekoratif dan memperinci background yang sudah ada. UI, posisi kamera utama, lobby, movement, senjata, dan konten sejarah tidak diubah.

## Perubahan

- Menghapus group Fighters, builder figur, perlengkapan figur dan animasi langkahnya.
- Fasad mendapat variasi ketinggian, shutter terbuka, kaca/mullion, kisi kayu, balkon besi pada sebagian bangunan, gagang pintu, plester aus, dan bata terbuka dekat dasar.
- Atap mendapat channel genteng berbentuk silinder, fascia dan variasi warna halus. Detail bangunan jauh disederhanakan.
- Jalan menggunakan material Asphalt matte dengan bahu tanah terputus, kerikil sedikit, serta grill drainase.
- Pencahayaan pagi memakai fill lebih netral, kabut lebih ringan dan bloom rendah. Grade menu tidak lagi bergantung pada ColorCorrection lobby yang sedang nonaktif.
- Listener Lighting.Changed menjaga profil menu saat replikasi Lighting startup tiba terlambat. Listener dilepas sebelum lighting awal dikembalikan saat menu ditutup.
- Gerakan bendera dan drift kamera tetap memakai satu callback kamera. Reduced motion tetap tersedia.

Scene merupakan rekonstruksi artistik Yogyakarta 1949, bukan denah atau material jalan yang telah diverifikasi secara historis. Nama toko fiktif. Tidak menambah aset marketplace atau dependency. Pohon memakai manifest BARA yang sudah ada.

## Sumber dan hierarchy

- src/client/GameClient/MenuEnvironment.luau
- src/client/GameClient/MenuCameraController.luau
- src/client/GameClient/MenuEnvironment.spec.luau
- src/client/GameClient/MenuCamera.spec.luau

Workspace.MenuEnvironment dibuat ulang pada client ketika menu masuk. Isinya Street, WestFrontages, EastFrontages, TuguPalPutih, StreetProps, Greenery, DistantCity, CameraAnchor. Tidak ada Fighters.

Origin tetap (1000,128,0). CameraAnchor lokal tetap (-8,5.6,39) menuju (-8,6.3,-130), lalu seluruh scene diputar sekitar -58,49 derajat. FOV dasar 52 derajat dan penyesuaian aspect ratio tetap sama. Builder tidak menulis Terrain.

## Profil lighting aktif

| Properti | Nilai |
|---|---|
| ClockTime / GeographicLatitude | 7.05 / -7.8 |
| Brightness / ExposureCompensation | 2.7 / 0.12 |
| Ambient / OutdoorAmbient | RGB 127,132,137 / 155,151,138 |
| FogStart / FogEnd | 90 / 360 |
| Atmosphere Density / Haze | 0.24 / 1.6 |
| Atmosphere Color / Decay | RGB 249,229,196 / 174,181,183 |
| Bloom Intensity / Threshold | 0.07 / 2.5 |
| ColorCorrection Tint | RGB 255,246,229 |
| ShadowSoftness | 0.8 |

Semua properti/effect yang dimiliki controller dipulihkan saat menu selesai. Pengaturan ini art direction, bukan simulasi tanggal sejarah.

## Pengujian final

144 assertion lulus di client Studio: 61 environment, 59 kamera, 24 animasi UI.

- Tidak ada figur dekoratif, Humanoid, script di scene, part fisik aktif, emitter atau local light.
- 1.895 BasePart, termasuk 18 MeshPart pohon; budget 1.900 part tetap lulus.
- Hanya 30 part bendera dianimasikan, turun dari 62 sebelumnya.
- Terrain pada region tes sama sebelum/sesudah create-destroy.
- Kamera konsisten pada sampel 30/120 Hz; reduced motion membekukan kamera/dekorasi; start berulang tidak menggandakan loop.
- Tes menyuntikkan ClockTime 14.5 saat menu aktif: profil pagi kembali dengan benar.
- Tombol MULAI asli membuka EnamJamLobbyUI, menu nonaktif, kamera Custom. Lighting kemudian mengikuti profil lobby 6.65; grade menu dihapus.
- Tidak ada MessageError dalam log client sesi final. Warning CorePackages Roblox mengenai FoundationProvider tetap muncul.
- Cuplikan visual diambil pada viewport Studio sekitar 1188 x 658. UI tidak dimodifikasi.
- Empat source lokal dan Edit Studio cocok setelah normalisasi akhir baris.
- Studio dikembalikan ke Edit. Tidak ada scene/harness QA yang ditambahkan ke Edit Workspace.

Bukti visual: [menu terbaru](qa/yogyakarta-realism-menu.jpg). [Data QA](qa/yogyakarta-realism-tests.json). Bukti sunrise 02 terdahulu tetap merupakan riwayat, bukan hasil revisi ini.

Cadangan source lokal/native sebelum revisi: backups/menu-realism-before-20261020/.

## Batas

Belum diuji di perangkat ponsel fisik, multiplayer, atau sesi panjang. Material masih memakai material bawaan Roblox; pepohonan dan siluet jauh tetap bergaya low-poly. Tidak mengklaim fotorealisme atau replika jalan 1949. Tidak ada benchmark FPS perangkat baru.

Source sudah diterapkan di Studio. Simpan place melalui File → Download a Copy… ke checkpoint baru agar perubahan source native tersimpan juga. Tidak dilakukan commit, push, atau Publish.

## Git opsional

Branch: feat/enam-jam-1949. Remote: https://github.com/Constanvel/G30sPKI.git. Berkas perubahan lain yang sudah ada tidak termasuk pekerjaan ini.

```powershell
git add -- src/client/GameClient/MenuEnvironment.luau src/client/GameClient/MenuCameraController.luau src/client/GameClient/MenuEnvironment.spec.luau src/client/GameClient/MenuCamera.spec.luau docs/YOGYAKARTA_MENU_ENVIRONMENT.md docs/qa/yogyakarta-realism-menu.jpg docs/qa/yogyakarta-realism-tests.json
git diff --cached
git commit -m "refine menu environment and remove decorative fighters"
git push origin feat/enam-jam-1949
```
