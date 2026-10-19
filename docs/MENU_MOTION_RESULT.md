# Hasil polish animasi menu

Tanggal: 19 Oktober 2026. Baseline: `ab85ee3f4feb681eb73622a6f4bef4647b101c46`.

## Perubahan

- Fade dari hitam 0,85 detik; judul 0,75 detik dengan gerak naik 8 piksel, subjudul/tagline 0,48 detik, navigasi berselang 0,075 detik. Nomor dan status tombol ikut reveal. Rangkaian selesai sekitar 1,25 detik.
- Satu indikator navigasi berpindah selama 0,24 detik. Hover 0,18 detik dan respons klik 0,09 detik. Tween dialihkan dari posisi berjalan; sorotan lama dibersihkan saat menu dibuka kembali.
- Panel Settings, Chapters, Archive dan Credits menggunakan fade keluar 0,10 detik lalu fade/gerak naik 0,24 detik. Kembali tidak mengulang intro. Input cepat membatalkan callback transisi lama.
- Kamera mempertahankan anchor dan framing dengan lintasan tertutup 28 detik, amplitudo horizontal 0,38 stud dan rotasi di bawah 0,002 radian. Awal gerak masuk secara lembut selama 1,2 detik.
- Dua PointLight lentera yang sudah ada berubah intensitas secara sinusoidal maksimal 1,8 persen. Gerak kamera dan lampu memakai satu koneksi RenderStepped. Brightness asli dipulihkan ketika keluar menu.
- Reduced motion memakai fade singkat, menghilangkan perjalanan indikator dan slide panel, serta membekukan kamera/lentera pada keadaan terakhir. Koneksi dibersihkan saat controller dihentikan/dihancurkan.

Tata letak, font, konten sejarah, model, Terrain, nilai lighting, chapter, protokol request dan save tetap dipertahankan. Tidak ditambahkan partikel atau animasi foliage karena membutuhkan pekerjaan tambahan pada mesh tanpa manfaat yang sepadan untuk pass ini.

## Berkas berubah

| Berkas di `src/client/GameClient/` | Tujuan |
| --- | --- |
| `MenuAnimationController.luau` | Intro, indikator, hover/klik, transisi, pembatalan dan cleanup |
| `MenuCameraController.luau` | Lintasan kamera dan variasi lentera |
| `MainMenuView.luau` | Satu Frame indikator, tanpa perubahan layout |
| `MainMenuController.luau` | Menghubungkan respons klik dan cleanup animasi |
| `MenuAnimation.spec.luau` | Regresi animasi dan resize |
| `MenuCamera.spec.luau` | Kontinuitas, batas gerak, reduced motion dan restorasi |
| `MenuInput.spec.luau` | Penyesuaian fixture respons klik |
| `MenuSettings.spec.luau` | Cleanup koneksi pada fixture |

Dokumentasi: `README.md`, laporan ini, `docs/plans/2026-10-19-menu-motion.md`, dan `docs/qa/menu-motion-source-sync.json`.

## Pengujian langsung

134 assertion lulus pada kode final:

| Suite | Assertion |
| --- | ---: |
| MenuAnimation | 24 |
| MenuCamera | 34 |
| MenuSettings | 39 |
| MenuInput | 5 |
| MenuPresentation | 32 |

Pengujian mencakup urutan intro, opacity dan nomor navigasi, posisi antara indikator, retarget cepat, tombol nonaktif, klik, panel berulang, Kembali tanpa intro ulang, pembatalan callback dan cleanup. Regresi resize menguji root 314×348 menjadi 300×238: ukuran nav tetap 268×96, tetapi indikator tetap mengikuti perubahan kolom. Fixture diaktifkan agar ukuran turunan dihitung oleh renderer.

Input langsung Studio menguji hover cepat antarbaris, semua panel, Kembali, toggle reduced motion, Mulai, intro chapter, OpenMenu dan Lanjutkan. Kamera kembali ke Custom dengan subject Humanoid dan WalkSpeed 16 saat gameplay. Sesudah kembali dari gameplay, hanya baris yang terakhir dipilih disorot. Reduced motion menghasilkan delta posisi kamera nol dan brightness lampu tetap pada pengamatan 0,3 detik.

Beberapa sesi Stop/Play dijalankan. Pengamatan idle terakhir berlangsung 29,00 detik / 1.717 frame, mencakup satu siklus penuh. Langkah posisi terbesar 0,00408 stud; tidak ditemukan loncatan posisi pada sampel tersebut. Frame terlama selama pengamatan ini 59,34 ms, sehingga masih ada stall sesekali di Studio.

Tidak ada MessageError pada log client/server yang diperiksa. Review kode terpisah menemukan kasus resize di atas; perbaikannya sudah direview kembali tanpa temuan tersisa. Studio dikembalikan ke mode Edit dan simulasi perangkat dimatikan.

## Desktop dan mobile

| Tampilan | Viewport | Area UI aman | Hasil |
| --- | --- | --- | --- |
| Desktop | 1188×658,4 | CoreUISafeInsets | Navigasi dan panel terbaca |
| Samsung Galaxy A06, landscape | 705×338 | 705×280 | Enam target 44 piksel; teks muat |
| iPhone 17 Pro, landscape | 750×381 | 750×323 | Enam target 44 piksel; teks muat |

Screenshot Studio diperiksa untuk menu dan Settings. Settings di layar pendek memang bergulir; tombol Kembali tetap dapat diakses. Fokus Credits dipertahankan saat berpindah desktop → Samsung → iPhone → desktop dan indikator cocok dengan posisi baru pada setiap ukuran. Hover tidak dijadikan syarat pada perangkat sentuh; validasi resize memakai fokus navigasi. Orientasi game tetap landscape.

## Performa

Sampel RenderStepped pada desktop yang sama, masing-masing 120 frame sesudah startup:

| Pengukuran | Sebelum | Sesudah final |
| --- | ---: | ---: |
| Rata-rata | 18,61 ms | 16,67 ms |
| Persentil 95 | 37,38 ms | 18,23 ms |
| Maksimum | 51,99 ms | 19,62 ms |

Sampel ini tidak menunjukkan penurunan performa, tetapi cache, waktu pemanasan dan beban Studio tidak dikontrol sebagai benchmark laboratorium. Selisih tersebut tidak membuktikan kenaikan FPS akibat perubahan animasi.

MicroProfiler final menangkap 64 frame, ID 1–64 / absolute ID 47836–47899. Scope engine `RunService.RenderStepped` berisi 128 instance: rata-rata 0,0148 ms, maksimum 0,0467 ms. Ini scope gabungan, bukan biaya kamera saja atau total GPU. Snapshot dan iterator profiler dibersihkan sesudah digunakan.

## Sinkronisasi dan batas

24 source Studio cocok dengan source lokal berdasarkan panjang byte UTF-8 dan dua fingerprint setelah normalisasi BOM/CRLF/whitespace akhir. Metode ini bukan digest kriptografi; bukti tersimpan di `docs/qa/menu-motion-source-sync.json`. Git blob 16 source di luar perubahan tetap sama dengan baseline, termasuk lingkungan, narasi dan seluruh server/shared. `git diff --check` lulus.

Belum diuji: ponsel fisik, multitouch, sesi panjang berjam-jam, jaringan produksi, dan performa GPU pada perangkat kelas bawah. Skenario game di luar alur masuk/keluar menu tidak diuji ulang pada pass ini. Animasi hanya mengatur lentera yang sudah tersedia; tidak ditambahkan audio. Tidak ada commit, push atau Publish to Roblox.

## Perintah Git siap pakai

Branch diperiksa: `feat/cinematic-main-menu`. Origin: `https://github.com/Constanvel/G30sPKI.git`. Jalankan dari `D:\1946-7-perspektif` setelah meninjau perubahan:

```powershell
git add -- README.md docs/MENU_MOTION_RESULT.md docs/plans/2026-10-19-menu-motion.md docs/qa/menu-motion-source-sync.json src/client/GameClient/MainMenuController.luau src/client/GameClient/MainMenuView.luau src/client/GameClient/MenuAnimationController.luau src/client/GameClient/MenuCameraController.luau src/client/GameClient/MenuAnimation.spec.luau src/client/GameClient/MenuCamera.spec.luau src/client/GameClient/MenuInput.spec.luau src/client/GameClient/MenuSettings.spec.luau
git commit -m "feat: polish cinematic menu animations"
git push origin feat/cinematic-main-menu
```
