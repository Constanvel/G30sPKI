# Semak — ENAM JAM: 1949

Tiga prefab semak berdaun untuk taman, tepi pagar, dan halaman. Seluruhnya sudah dipasang menggantikan 65 bola Shrub di lobi.

| Prefab | Bentuk | Lebar dasar | Tinggi dasar | Mesh visual |
| --- | --- | ---: | ---: | ---: |
| SemakRimbun_01 | Daun kecil rapat, siluet tidak beraturan | 4 stud | 2,84 stud | 1 |
| SemakLiar_02 | Daun lebar dan ranting terlihat | 4 stud | 2,96 stud | 1 |
| SemakRenggang_03 | Cabang lebih terbuka dan rendah | 4 stud | 2,77 stud | 1 |

## Menggunakan aset

- Library: `ServerStorage.EnvironmentAssets.Bushes1949`.
- Penempatan aktif: `Workspace.EnamJamLobby.RealisticEnvironment.Bushes1949`.
- Duplikasikan model lengkap ke Workspace, lalu gunakan Move, Rotate, dan Scale pada model. Pivot berada di dasar semak. Ukuran tabel adalah skala awal 1.
- Hierarchy setiap prefab: `Geometry/LeavesAndTwigs` dan `Pivot`. Model menggunakan Atomic streaming, mesh memakai RenderFidelity Automatic, daun DoubleSided dan SurfaceAppearance AlphaMode Transparency.
- Seluruh part anchored, tanpa collision/query/touch. Semak merupakan dekorasi dan tidak menghentikan pergerakan atau raycast senjata. Tidak ada script, lampu, atau animasi per-frame di dalam prefab.

Rotasi dan skala di map bervariasi. Setiap semak mengikuti tanah PackedEarth. Bounds daun diberi ruang di sisi dalam pagar. Area tanam asal dipertahankan dengan pergeseran kecil ke dalam bila daun akan melewati batas pagar.

`ClayPlanter` (6) dan `PlanterLeaf` (30) tidak diubah. Seluruh 65 Shrub asli dipindahkan ke `ServerStorage.BushSourceReview.ReplacedShrubs1949`. Pohon dan bangunan tetap dipertahankan.

## Sumber

Mesh diadaptasi dari [Foliage Pack (Realistic) - Tree Bush Grass oleh Qalus](https://create.roblox.com/store/asset/7990107300), aset gratis Creator Store. Ini adaptasi aset yang sudah ada, bukan mesh original buatan proyek. Tidak mengklaim spesies atau penanaman tertentu telah diverifikasi untuk Yogyakarta tahun 1949.

- SemakRimbun_01: mesh `3098951439`, color map `6995306226`.
- SemakLiar_02: mesh `5638510861`, color map `5638514330`.
- SemakRenggang_03: mesh `5638516110`, color map `5638514330`.

Import sumber diperiksa dan tidak mengandung script. Prefab produk dibangun hanya dari mesh dan SurfaceAppearance, sehingga tidak membawa constraint atau konten executable dari model sumber. Tekstur tetap merujuk Roblox asset ID; izin/pemuatan pada experience lain perlu diperiksa.

## Source, pemulihan, dan pengujian

- `manifest.json`: data mesh, tekstur, transform, ukuran, dan atribut prefab pada skala 1.
- `placements.json`: snapshot posisi/ukuran/CFrame semak asli serta transform/varian/skala seluruh semak terpasang.
- `tools/RebuildBushes1949.luau`: rekonstruksi library di Studio Edit tanpa membutuhkan model sumber; menolak menimpa library yang sudah ada.
- `tools/PlaceBushes1949.luau`: menempatkan 65 clone dari susunan Garden asli, lalu mengarsipkan bola lama. Pemanggilan ulang tidak menggandakan penempatan. Tool ini khusus map dengan 65 Shrub dan PackedEarth datar; pergeseran batas pagar perlu raycast ulang bila kelak diterapkan pada tanah miring.
- `tools/CheckBushes1949.luau`: 936 assertion lulus untuk pivot, ukuran, grounding, streaming, daun, collision, batas pagar, arsip, dan tanaman pot. Hasil rekonstruksi juga diuji dengan pemeriksaan yang sama.
- `tools/CheckPlacedTrees1949.luau`: diperbarui agar menerima semak baru; 207 assertion pohon tetap lulus.
- Saat Play, seluruh 65 semak hadir; 130 instance mesh/surface selesai preload tanpa kegagalan. Tombol MULAI dan kamera tetap bekerja, tanpa MessageError client pada sesi uji.

Bukti: `docs/qa/bushes1949-tests.json` dan `docs/qa/bushes1949-installed.jpg`.

Simpan checkpoint melalui File → Download a Copy…, misalnya `backups/enam-jam-1949-bushes-installed.rbxl`. Script Sync tidak menyimpan objek mesh/map native. Untuk rollback, keluarkan folder penempatan Bushes1949, lalu pindahkan kembali part dalam ReplacedShrubs1949 ke Garden.

Belum diuji pada ponsel fisik, multiplayer, cache kosong, atau experience yang dipublikasikan. Satu mesh per semak dan Automatic rendering tidak membuktikan target FPS tertentu. Tidak dilakukan commit, push, atau Publish Experience.

## Git opsional

Branch: `feat/enam-jam-1949`. Remote: `https://github.com/Constanvel/G30sPKI.git`. Perintah hanya mencakup berkas tugas semak:

```powershell
git add -- assets/bushes1949/README.md assets/bushes1949/manifest.json assets/bushes1949/placements.json tools/RebuildBushes1949.luau tools/PlaceBushes1949.luau tools/CheckBushes1949.luau tools/CheckPlacedTrees1949.luau docs/qa/bushes1949-tests.json docs/qa/bushes1949-installed.jpg
git diff --cached
git commit -m "Replace spherical shrubs with three leaf-mesh bush variants"
git push origin feat/enam-jam-1949
```
