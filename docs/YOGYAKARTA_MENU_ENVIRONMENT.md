# Background menu — ENAM JAM: 1949

20 Oktober 2026. Environment sudah terpasang di Studio dan dipakai oleh menu awal. UI, flow Mulai, lobby, gameplay, dan konten sejarah tetap memakai implementasi sebelumnya. Tidak ada commit, push, atau Publish.

## Hasil build

Jalan kota tua memanjang menuju tugu putih, dua deret toko dengan plester, pilaster, jendela kayu, arcade, kanopi kain dan atap genteng. Komposisi memiliki empat pejuang dari belakang di kanan bawah, gerobak pasar dan sepeda di tepi jalan, kabel melengkung, peti, pohon dan bendera merah putih. Latar jauh memakai volume sederhana dengan jendela serta siluet atap.

Scene adalah rekonstruksi artistik. Nama toko dan figur adalah fiktif. Bentuk tugu mengambil arah visual Pal Putih, bukan replika berskala atau denah jalan Yogyakarta yang telah diverifikasi untuk 1949. Referensi pengguna dipakai untuk suasana dan komposisi; tidak disalin satu banding satu.

Rujukan tambahan: [foto Tugu koleksi Wereldmuseum/Tropenmuseum, sekitar 1920](https://commons.wikimedia.org/wiki/File:COLLECTIE_TROPENMUSEUM_De_Toegoe_of_Witte_Paal_in_Jogjakarta_TMnr_60007932.jpg). Foto tidak diimpor sebagai texture atau matte. Mesh pohon memakai manifest BARA yang sudah ada dalam proyek; fasad, properti, landmark dan figur adalah geometri yang dibuat dalam builder ini. Material memakai Roblox.

## Hierarchy

Model dibuat pada client saat menu dimuat; sumber geometri tetap dapat diedit melalui builder. Lokasi terpisah dari lobby gameplay, dengan origin (1000,128,0).

```text
Workspace
  MenuEnvironment
    Street             Ground, MainRoad, Pavement, Drain, CurbStone
    WestFrontages      Shop01 ... Shop06
    EastFrontages      Shop01 ... Shop06
    TuguPalPutih       Pedestal, TaperedShaft, Crown, Finial
    StreetProps        Bicycle, MarketCart, TelegraphPole, OverheadWire,
                       IndonesianFlag, DeliveryCrate
    Greenery           BroadleafTree
    DistantCity        DistantFacade, DistantWindow, ClayRoof
    Fighters           Fighter01 ... Fighter04
    CameraAnchor
```

Saat menu ditutup, kamera berhenti memperbarui scene dan pose dekoratif dikembalikan. Builder tidak menulis voxel Terrain. Semua part dekoratif di-anchor, CanCollide/CanTouch/CanQuery false. Figur tidak memiliki Humanoid, script, Tool atau AI.

## Kamera dan lighting

CameraAnchor menentukan sudut utama. Sebelum rotasi seluruh scene, posisi lokalnya (-8,5.6,39), menghadap (-8,6.3,-130). Scene diputar sekitar -58,49° pada Y untuk menghadap cahaya pagi. Posisi world anchor sekitar (962.57,133.60,13.56), arah (0.8525,0.00414,-0.5227).

Lensa utama 52° vertikal pada 16:9. Pada area lebih sempit, FOV diperlebar dengan batas 115° agar keempat figur lebih terjaga dalam frame. Angle utama tetap sama. Komposisi sengaja menyediakan area kiri untuk UI yang sudah ada.

| Pengaturan menu | Nilai |
|---|---|
| LightingStyle | Realistic yang sudah digunakan place |
| ClockTime | 6.65, sekitar 06:39 pada jam visual Roblox |
| GeographicLatitude | -7.8 |
| Brightness / ExposureCompensation | 3 / 0.28 |
| Ambient | RGB 146,129,105 |
| OutdoorAmbient | RGB 166,146,116 |
| FogStart / FogEnd | 90 / 325 |
| Atmosphere Density / Haze | 0.28 / 2.1 |
| Atmosphere Color | RGB 255,222,176 |
| Bloom Intensity / Threshold | 0.07 / 2.5 |
| Color grade Tint / Contrast | RGB 255,224,181 / 0.035 |
| SunAngularSize | 6 |

Depth of field dan sun rays dinonaktifkan selama menu. Semua properti/effect yang diganti disimpan dan dipulihkan saat Mulai. ColorCorrection khusus menu yang dibuat oleh controller dihapus ketika menu ditutup. Parameter ini adalah art direction visual, bukan simulasi matahari pada tanggal sejarah tertentu.

## Ambient motion dan optimasi

- Drift kamera 28 detik, amplitudo sangat kecil dan berbasis waktu.
- Langkah figur serta gerak strip bendera dihitung dari pivot tetap, tanpa penumpukan transformasi.
- Reduced motion membekukan kamera dan dekorasi sekaligus.
- 1.765 part, termasuk 18 MeshPart pohon. Tidak ada Humanoid, emitter, atau local light.
- Hanya 62 part memiliki pembaruan animasi dalam satu callback yang sudah digunakan kamera. Tidak ada loop per figur atau per UI.
- Detail genteng lebih banyak pada bangunan dekat; background kota lebih ringan. Semua roda/properti tidak ikut simulasi fisika.

## Berkas yang berubah

- src/client/GameClient/MenuEnvironment.luau — builder baru.
- src/client/GameClient/MenuCameraController.luau — sunrise profile, animasi deklaratif, FOV adaptif dan cleanup.
- src/client/GameClient/MenuEnvironment.spec.luau — kontrak environment baru.
- src/client/GameClient/MenuCamera.spec.luau — framing, motion, reduced motion, pemulihan lighting/sky/effect dan lifecycle.
- docs/superpowers/plans/2026-10-20-yogyakarta-menu-environment.md — rencana dan batas lingkup.

Source lokal dan source Edit Studio untuk keempat module cocok setelah normalisasi akhir baris. Cadangan source lama lokal/native ada di backups/menu-environment-before-20261020/. Berkas lain yang sudah berubah sebelum pekerjaan ini tidak dimasukkan ke scope.

## Pengujian

175 assertion lulus pada source final: 100 environment, 51 kamera, 24 animasi UI yang sudah ada. Sesi Play terakhir tidak mencatat MessageError.

- Scene create/destroy tidak mengubah voxel Terrain yang diperiksa.
- Empat figur dekoratif, 12 toko, tugu, properti, batas part/mesh/motion dan isolasi collision diverifikasi.
- Drift konsisten pada sampel 30 dan 120 Hz; start berulang tidak menambah callback.
- Reduced motion membekukan pose, kemudian drift dapat dilanjutkan tanpa snap. Stop mengembalikan pose dan seluruh parameter lighting/effect/sky yang disimpan.
- Masuk lewat tombol MULAI asli berhasil menuju lobby baru. Kamera Custom, ClockTime kembali 14.5, dan grade menu tidak tertinggal.
- Proyeksi pusat kepala empat figur diperiksa pada 1920×1080, 1440×1080 dan 390×844. Ini pemeriksaan matematis framing, bukan playtest fisik semua ukuran layar.
- Sampel 180 RenderStepped memiliki delta rata-rata sekitar 6.05 ms pada sesi Studio ini. Sampel singkat ini tidak mengukur biaya eksklusif scene dan bukan jaminan FPS untuk perangkat lain.
- Review source independen tidak menemukan blocker. Studio kembali ke Edit; tidak ada scene atau harness QA tertinggal di Workspace/StarterPlayer.

Bukti: [menu dengan UI](qa/yogyakarta-menu.jpg), [environment tanpa UI untuk inspeksi](qa/yogyakarta-environment.jpg), [data pengujian](qa/yogyakarta-environment-tests.json). UI hanya disembunyikan sementara saat mengambil cuplikan environment dan tidak diubah pada source.

## Polish berikutnya dan batas

Tekstur cat aus, variasi fasad lebih jauh, animasi jalan authored, dan ambience audio dapat memperkuat hasil ini. Figur saat ini memakai gerak prosedural di tempat untuk komposisi menu.

Belum diuji pada ponsel kelas rendah, multiplayer bersamaan, atau sesi panjang. Tampilan fallback jika mesh pohon gagal dimuat dan penumpukan beberapa effect sejenis dari perubahan place lain belum diuji secara paksa. Profil utama diverifikasi dengan satu client Studio.

Simpan place lewat File → Download a Copy… agar source Studio ikut tersimpan pada checkpoint terbaru; tidak perlu Publish. Model scene dihasilkan ulang dari builder pada Play.

## Git opsional

Branch feat/enam-jam-1949, origin https://github.com/Constanvel/G30sPKI.git. Perintah berikut hanya men-stage pekerjaan environment ini.

```powershell
git add -- src/client/GameClient/MenuEnvironment.luau src/client/GameClient/MenuCameraController.luau src/client/GameClient/MenuEnvironment.spec.luau src/client/GameClient/MenuCamera.spec.luau docs/superpowers/plans/2026-10-20-yogyakarta-menu-environment.md docs/YOGYAKARTA_MENU_ENVIRONMENT.md docs/qa/yogyakarta-menu.jpg docs/qa/yogyakarta-environment.jpg docs/qa/yogyakarta-environment-tests.json
git diff --cached
git commit -m "feat: build Yogyakarta sunrise menu environment"
git push origin feat/enam-jam-1949
```
