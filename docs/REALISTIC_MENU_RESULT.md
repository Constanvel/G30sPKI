# Latar menu 3D — 18 Oktober 2026

Permintaan terbaru menggantikan arahan PS1 primitive sebelumnya: memakai kualitas mesh bertekstur seperti proyek BARA 1946 milik pengguna. UI kiri, judul, navigasi, chapter dan seluruh source server gameplay dipertahankan.

## Hasil visual

- Menggunakan kembali rumah beranda, rumah kayu, pohon bercabang/bertajuk, pagar kayu, peti dan lentera BARA. Total scene akhir 189 BasePart, termasuk 84 MeshPart dan dua PointLight. Bukan primitive pohon/bambu berbentuk balok lagi.
- Rumah utama diarahkan menghadap kamera. Skala rumah/pohon, framing kamera dan vegetasi berlapis membuat ruang lebih terbaca. Perbukitan menutup horizon datar.
- Permukaan tanah memakai Terrain Ground/LeafyGrass, jalur melengkung dan clearing dengan transisi material. Rumput animasi dibatasi ke kejauhan agar sumur/fondasi tidak tertutup.
- Terrain interpolasi sempat menempatkan permukaan dua stud terlalu tinggi. Offset diperbaiki dan regression test raycast memastikan sumur tidak terkubur. Jalur Part awal yang tampak seperti pelat telah dihapus.
- Cahaya malam sejuk, dua lentera hangat, diffuse/specular terkontrol, bloom dan kabut tetap ringan. LightingStyle Realistic disetel dalam Studio Edit; LocalScript tidak memiliki capability menulis properti tersebut. Pengaturan lighting menu yang dapat ditulis runtime disimpan/dipulihkan saat handoff.
- Kredit diperbarui. Penataan Lubang Buaya tetap rekonstruksi artistik, bukan replika denah 1965; tidak menambah narasi, figur atau kekerasan.

## Aset dan pemulihan

Acuan diperiksa langsung dari D:/bara-1946/Place1.rbxl melalui sesi Studio terpisah baca-saja, kemudian ditutup. Dokumentasi dan manifest sumber diperiksa dari D:/Projects/BARA-1946. Proyek BARA tidak diedit.

MenuAssetData.luau menyimpan descriptor geometri/material/frame yang diambil dari:

- ServerStorage.BARA_AssetPrototypes.Tree_Approved dan Fence_Approved.
- Workspace.BARA_HouseRepair.Rumah.Rumah2 dan Rumah3.
- Lentera dan peti pada Workspace.BARA_ShowcaseEnvironment.

Pohon mentah BARA: 99155488246940; descriptor mempertahankan image daun yang sudah diperbaiki 91493091302289. Pagar mentah: 128387403175862; mesh post 78342716395273 dan texture 99155027776678 yang sudah diperbaiki dipertahankan. Aset sumber dicatat proyek BARA sebagai milik Constancexz, user 2691185458. Tidak melakukan generasi berbayar atau upload baru.

Hanya field geometri yang diserialisasikan; tidak menyalin Script, ModuleScript, Remote, Humanoid, prompt, tag atau referensi gameplay BARA. Penelusuran Creator Store awal tidak digunakan pada build akhir; staging dihapus.

Template mesh dibentuk melalui AssetService.CreateMeshPartAsync dalam client, per keluarga aset secara paralel dan dipakai ulang dalam sesi. Kegagalan membentuk template dibersihkan dan dilaporkan oleh handler menu yang sudah ada. Tidak ada model menu baru yang harus diimpor manual atau aset native tersembunyi yang diperlukan.

Terrain hanya ditulis pada client pada region x=880..1120, y=112..164, z=-172..76. Region dibaca sebelum modifikasi, kemudian material/occupancy dipulihkan saat scene Destroying. Scene terpisah dari Baseplate/greybox gameplay. Tidak mengubah Terrain server atau warna material global.

Renderer Realistic adalah pengaturan place bersama, sehingga juga memengaruhi rendering greybox; tidak mengubah logic atau physics gameplay. tools/ConfigureMenuRenderer.luau merekam langkah pemulihannya. Save place terbaru belum dikonfirmasi pada laporan ini; backup VS01 lama tetap baseline sebelum perubahan renderer.

## Validasi yang benar-benar dijalankan

- Client final: MenuPresentation 32, MenuInput 5, MenuAnimation 6, MenuEnvironment 105 dan MenuCamera 23 assertion lulus. Environment mencakup mesh/tekstur, budget, noncollision, raycast grounding dan perbandingan seluruh voxel material/occupancy sebelum/sesudah destroy. Camera mencakup reduced-motion, drift, refresh serta pemulihan rendering/camera.
- Server: MenuState 21 dan SceneValidation 12 assertion lulus. Total pass final yang dijalankan: 204 assertion. Foundation tidak diulang karena source gameplay tidak diubah.
- Seluruh 34 URI yang ditemukan ContentProvider pada scene akhir berstatus Success dalam Client Play.
- Klik nyata panel Pilih Chapter, Arsip Sejarah, Kredit dan Pengaturan, lalu Kembali. Reduced motion membekukan pose tanpa menyentak dan dapat dinyalakan/dimatikan.
- Mulai membuka intro, Enter masuk gameplay dengan kamera Custom dan WalkSpeed 16. Interaksi pertama, kembali ke menu dan Resume memulihkan objektif 2/3; dua interaksi berikutnya dan cinematic mencapai Akhir demo VS01 dengan kamera Custom.
- Capture native Studio diperiksa pada desktop serta simulator Samsung Galaxy A06 (viewport 705x338, safe area 705x280) dan iPhone 17 Pro (750x381, safe area 750x323), landscape. Keenam tombol TextFits, tinggi minimal 44 dan seluruh bounds berada dalam safe area. Simulator dikembalikan ke default.
- Client/server LogService pada sesi final tidak memuat MessageError. Percobaan sebelumnya menemukan capability error LightingStyle dan telah diperbaiki sebelum sesi final baru.
- Review source independen baca-saja tidak menemukan critical/important yang terkonfirmasi.

## Performa dan batas

Sampel awal 120 frame: mean 67,08 ms / p95 68,96 ms. Setelah menutup Studio referensi: mean 66,60 ms / p95 68,72 ms, sekitar 15 FPS. Pola mendekati cap background, tetapi penyebabnya belum terbukti; tidak mengklaim 60 FPS atau bahwa performa telah lolos target produksi.

MicroProfiler snapshot 64 frame diperiksa dengan LibMP lalu profiler dinonaktifkan. Scope CPU RunService.RenderStepped pada snapshot tersebut rata-rata sekitar 0,007 ms per kemunculan, waitOnGpu sekitar 1,86 ms per kemunculan. Ini scope engine yang inklusif, bukan biaya kamera saja atau pengukuran GPU penuh. GPU scopes tidak memberi dasar untuk menjamin throughput. Hasil ini menunjukkan callback bukan bukti sumber frame 66 ms, tetapi tidak membuktikan penyebab throttle.

Cache dingin internet, Android fisik, multiplayer dan akses URI pada experience yang dipublikasikan belum diuji. Bentuk mesh mengikuti BARA yang masih bergaya game; bukan klaim fotorealistik. Koneksi/izin CDN aset tetap diperlukan. Akurasi denah historis belum divalidasi. Tidak publish, commit atau push.

## File dan Git

Source berubah: MainMenuView.luau, MenuCameraController.luau, MenuCamera.spec.luau, MenuEnvironment.luau, MenuEnvironment.spec.luau. Baru: MenuAssetData.luau dan tools/ConfigureMenuRenderer.luau. README dan laporan ini menjelaskan dependensi serta batas hasil.

Branch feat/cinematic-main-menu; remote origin https://github.com/Constanvel/G30sPKI.git. Perintah opsional berikut hanya men-stage file pekerjaan ini:

```powershell
git add -- README.md src/client/GameClient/MainMenuView.luau src/client/GameClient/MenuCameraController.luau src/client/GameClient/MenuCamera.spec.luau src/client/GameClient/MenuEnvironment.luau src/client/GameClient/MenuEnvironment.spec.luau src/client/GameClient/MenuAssetData.luau tools/ConfigureMenuRenderer.luau docs/REALISTIC_MENU_RESULT.md docs/qa/realistic-menu-source-sync.json
git commit -m "feat: tingkatkan latar menu dengan mesh BARA dan terrain"
git push origin feat/cinematic-main-menu
```
