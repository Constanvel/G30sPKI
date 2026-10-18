# Polish menu utama — 18 Oktober 2026

Scope: pertahankan judul serif, navigasi, komposisi jalan malam dan arsitektur menu. Hanya presentasi client yang berubah; server, chapter, naskah sejarah dan aset VS01 tidak diedit.

Inspeksi awal: Atmosphere dan Bloom bawaan sudah ada. FogStart/FogEnd tidak cukup untuk mengendalikan Atmosphere, Bloom.Intensity1 membuat lampu/jendela berpendar kuat. ScreenInsets.DeviceSafeInsets menempatkan root di atas inset CoreGui58px; layout compact perlu dihitung dari ruang yang benar-benar aman. Reduced motion dan refresh kamera semula mereset pose ke anchor, menimbulkan sentakan kecil.

Rencana: atur Lighting/Atmosphere/Bloom secara lokal dan simpan/pulihkan semua nilai; tingkatkan kontras dan spacing dengan CoreUISafeInsets; hover berupa pergeseran padding6px dan garis tipis; intro pendek dengan offset6px; pertahankan pose drift saat pause/refresh; tambah bangku kayu, pot dan kabel utilitas generik sebagai rekonstruksi artistik tanpa klaim lokasi autentik. Tidak menambah post-effect, sumber cahaya atau per-frame UI update.

TDD: sebelum perubahan, tes gagal pada CoreUISafeInsets, hover tidak bergerak dan reduced motion menyentak pose. Hasil akhir akan dicatat setelah Play dan pemeriksaan beberapa viewport.

## Hasil implementasi

- Cahaya ambient biru dingin dinaikkan secukupnya, warna jalan/fasad diperjelas, Atmosphere.Density0,23/Haze1,2 dan Bloom.Intensity0,12 diterapkan lokal. SunRays dinonaktifkan hanya selama menu. Semua nilai Lighting, Atmosphere, Bloom dan SunRays asli dipulihkan sesudah masuk gameplay.
- Serif1965 dan komposisi kiri dipertahankan. Subtitle, tagline, metadata dan teks tombol lebih terbaca. Gradien gelap lebih terbuka di tengah/kanan tanpa menghilangkan kontras teks kiri.
- ScreenInsets.CoreUISafeInsets menjaga konten di bawah CoreGui. Mask latar dan fade tetap menutup seluruh viewport, termasuk area di belakang top bar. Layout memakai tinggi area aman; jendela pendek beralih dua kolom. Target sentuh tetap minimal44px.
- Hover/fokus menggunakan garis2px yang memanjang secara halus, perubahan warna dan pergeseran padding6px. Pointer dan fokus keyboard dihitung bersama agar MouseLeave tidak mematikan fokus aktif. Tombol nonaktif tidak bergeser atau menampilkan indikator aktif.
- Intro judul memakai fade dan offset6px, diikuti stagger ringan tombol. Animasi lama dibatalkan per properti. Reduced motion meniadakan translasi antarmuka dan membekukan pose kamera terakhir; refresh/respawn tidak mereset drift.
- Tambahan lingkungan: bangku kayu, dua pot tanaman, tiang/kabel utilitas sederhana dan siluet dua rumah jauh. Ground/jalan diperpanjang untuk mengurangi tepi panggung yang tampak di horizon. Ini objek generik untuk rekonstruksi artistik, tanpa klaim lokasi atau detail sejarah terverifikasi.

## Berkas berubah

| Berkas client | Perubahan |
| --- | --- |
| MainMenuView.luau | Kontras, spacing, CoreGui safe areas, latar penuh dan layout pendek |
| MenuAnimationController.luau | Reveal judul, stagger, hover bergeser dan garis fokus |
| MenuCameraController.luau | Tone atmosfer lokal, pemulihan efek dan kontinuitas pose |
| MenuEnvironment.luau | Keterbacaan material dan properti lingkungan ringan |
| MainMenuController.luau | Gabungan state hover/fokus; judul panel bertahan selama fade keluar |
| MenuPresentation.spec.luau | Safe area, keterbacaan, jarak tagline dan jendela pendek |
| MenuAnimation.spec.luau | Hover cepat dan disabled state |
| MenuCamera.spec.luau | Baru: reduced motion, refresh, resume drift dan pemulihan efek |

Semua berkas tersebut ada di src/client/GameClient. Dokumentasi ini dan docs/qa/main-menu-polish-source-sync.json juga ditambahkan. Source server/shared, Bootstrap gameplay, chapter dan naskah tidak berubah.

## Bukti pengujian

| Tes | Hasil |
| --- | --- |
| Foundation.spec | 33 assertion PASS |
| SceneValidation.spec | 12 assertion PASS |
| MenuState.spec | 21 assertion PASS |
| MenuPresentation.spec | 31 assertion PASS |
| MenuAnimation.spec | 6 assertion PASS |
| MenuInput.spec | 5 assertion PASS |
| MenuCamera.spec, dijalankan pada intro gameplay | 19 assertion PASS |
| Total | 127 assertion PASS |
| Semua panel + Kembali | PASS melalui pointer desktop dan A06 landscape |
| Settings scroll pada A06 | Tombol reduced motion dan catatannya dapat dicapai; Back tetap terlihat |
| Hover cepat antar tujuh target | Padding akhir22px dan garis24px pada target terakhir; disabled tetap16px |
| Input panel cepat | Berakhir pada panel terakhir yang menerima input, tanpa tween tertinggal |
| Pilih Chapter → VS01 | Membuka intro gameplay |
| Kontrol gameplay | WalkSpeed16, kamera Custom; W300ms menggerakkan karakter sekitar4,8stud |
| Satu alur VS01 lengkap | Tiga interaksi, cutscene dan penutup selesai; Bloom1 dan Atmosphere.Density0,3 asli kembali |
| Respawn saat menu | Tetap Scriptable dan WalkSpeed0; langkah posisi kamera terbesar sekitar0,0188stud pada sampel6detik, di bawah batas0,025stud |
| Log sesi final | Tidak ada MessageError client/server |
| Source Sync | 20/20 source disk cocok dengan Studio, setelah normalisasi CRLF/LF |

Tes baru direproduksi RED sebelum koreksi, termasuk pergeseran kamera ke anchor saat reduced motion diaktifkan. Pemeriksaan jendela pendek juga awalnya gagal: tombol terakhir berakhir pada525px sementara viewport navigasi berakhir496px. Sesudah ambang layout disesuaikan berdasarkan ruang aman, pemeriksaan800×520 lulus.

## Viewport dan performa

| Pemeriksaan | Viewport kamera | Area aman GUI | Hasil |
| --- | --- | --- | --- |
| Desktop Studio | 1188×658 | 1188×600 | Komposisi vertikal, semua panel dan teks diperiksa |
| Galaxy A06 landscape | 705×338 | 705×280 | Enam tombol274×44, dua kolom; TextFits seluruh panel true |
| iPhone17Pro landscape, notch | 750×381 | 750×323 | TextFits/navigasi/safe area lulus; screenshot diperiksa |
| Fixture jendela pendek | 800×520 | 800×520 | Area tombol Kredit sepenuhnya masuk viewport navigasi |

Kicker/subtitle/tagline/metadata diperiksa melalui TextFits dan posisi aktual. Pada A06, metadata berakhir278px dari tinggi aman280px; tombol terakhir berakhir256px. Root GUI berada di0,0 relatif area CoreGui, sebelumnya berada di0,-58.

Lingkungan berubah dari131 menjadi155 instance. Jumlah PointLight tetap3, semuanya tanpa shadow. Tidak ada efek/render callback baru; hanya satu RenderStepped kamera selama menu aktif dan reduced motion nonaktif. Sampel120frame desktop: rata-rata16,67ms dan p95 sekitar18,66ms. Ini diagnostik Studio, bukan benchmark GPU/ponsel atau jaminan FPS perangkat fisik.

Screenshot pemeriksaan ditampilkan dalam chat: Menu_Polish_Before_PC, Menu_Polish_After_PC, Menu_Polish_A06, Menu_Polish_iPhone_Notch, Menu_Polish_Mobile_Settings_Scroll dan Menu_Polish_Final_PC. Tidak diekspor menjadi berkas gambar di Git.

## Batas dan status akhir

Studio dikembalikan ke mode Edit dan viewport default. Tidak ada commit/push/publish otomatis dan cadangan RBXL tidak ditimpa. Menu terbaru tetap berasal dari source Script Sync; checkpoint RBXL lama sendirian tidak memuat perubahan ini.

Belum diuji: Galaxy A07 fisik, sentuh/gamepad fisik, portrait setelah polish, Luau type-check terpisah dan MicroProfiler. Tidak ada aset audio baru dalam scope polish ini. Keaslian objek tertentu tidak diklaim; latar tetap rekonstruksi artistik. Review dilakukan lewat inspeksi source dan QA pada sesi ini, tanpa reviewer independen baru.
