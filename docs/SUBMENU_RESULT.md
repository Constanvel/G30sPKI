# Hasil redesign submenu

19 Oktober 2026. Baseline: `87041cca0e4d363ec97d88933cbdacce6d37fe8a`.

Empat submenu kini memakai bahasa visual editorial museum dengan susunan isi yang berbeda, header seragam, dan footer tetap di luar area gulir.

## Perubahan desain

- Chapters: entri unggulan dengan nomor 01, status tersedia, judul, deskripsi dan bingkai fokus; ringkasan 02–07 terkunci tetap terpisah.
- Archive: hitungan00 menjadi penanda komposisi, disandingkan dengan pesan kosong dan penjelasan. Tidak ditambahkan dokumen atau fakta rekaan.
- Settings: label, track dan persentase sejajar pada tiga kolom; layar sempit memakai baris bertumpuk. Bagian aksesibilitas memiliki pemisah dan helper text tersendiri.
- Credits: empat baris nama–peran dengan divider tipis, lalu bagian atribusi. Pada layar sempit nama dan peran ditumpuk. Lebar paragraf dibatasi 560 agar tidak menyisakan tahun sendirian di baris terakhir desktop.
- Kembali dipindahkan ke footer kiri dengan target 136×44. Metadata panel ditempatkan di kanan dan disembunyikan pada lebar sangat sempit; footer tidak ikut bergulir.

Lebar maksimum Chapters/Archive/Settings/Credits adalah 744/704/640/744. Tinggi mengikuti isi dan dibatasi tinggi area UI aman dikurangi 32. Font utama yang sudah dipilih tetap digunakan.

## Sistem jarak

Semua angka dalam piksel UI Roblox, relatif terhadap panel:

| Elemen | Normal | Layar pendek, tinggi di bawah 410 |
| --- | ---: | ---: |
| Inset horizontal | 32; 20 bila sempit | 20 |
| Label aksen, y / tinggi | 24 / 16 | 8 / 16 |
| Judul, y / tinggi | 52 / 38 | 32 / 28 |
| Jarak label ke judul | 12 | 8 |
| Divider header, y | 106 | 68 |
| Awal isi, y | 128 | 84 |
| Jarak divider ke isi | 22 | 16 |
| Tinggi footer | 64 | 56 |
| Jarak isi ke footer | 16 | 12 |

Judul 28 pada desktop dan 23 pada layar sempit/pendek. Label aksen memakai Roboto Mono 12; isi 14–16. Pada landscape pendek, catatan audio berada di baris judul bagian agar kontrol pertama langsung terlihat.

## Animasi dan interaksi

Permukaan panel masuk selama 0,30 detik dengan pergeseran 6 piksel. Header, divider, isi dan footer muncul dengan jeda 0,02/0,06/0,10/0,16–0,18 detik; reveal isi 0,22 detik. Penutupan panel 0,24 detik, dengan isi memudar dan bergeser 4 piksel lebih dahulu. Main navigation diredupkan sebelum panel masuk dan kembali tanpa intro ulang.

Tween menggunakan Quad Out dan dialihkan dari nilai yang sedang berjalan. Token pembatalan menjaga agar klik cepat tidak menjalankan callback transisi lama. Reduced motion memakai fade singkat tanpa slide atau stagger. Tidak ada loop RenderStepped baru.

Bingkai kartu chapter mendapat penekanan saat hover/fokus. Panah kiri/kanan pada slider mempertahankan fokus pada kontrol tersebut, sehingga mengubah volume alih-alih berpindah ke Kembali. Logika volume dan SoundGroup tidak diubah.

## Berkas

| Berkas | Tujuan |
| --- | --- |
| `src/client/GameClient/MainMenuView.luau` | Isi, grid, footer dan responsivitas submenu |
| `src/client/GameClient/MainMenuController.luau` | Label indeks dan metadata footer di openPanel |
| `src/client/GameClient/MenuAnimationController.luau` | Transisi berlapis dan penekanan submenu |
| `src/client/GameClient/SubmenuPresentation.spec.luau` | Regresi layout, fokus, transisi dan reduced motion |
| `src/client/GameClient/MenuSettings.spec.luau` | Menyesuaikan batas tinggi panel dengan desain |
| `src/client/GameClient/MenuAnimation.spec.luau` | Menyesuaikan waktu tunggu dengan durasi transisi |
| `docs/superpowers/plans/2026-10-19-submenu-editorial.md` | Rencana dan catatan keputusan |
| `docs/SUBMENU_RESULT.md` | Laporan ini |

## Pengujian

415 assertion lulus pada source final:

| Suite | Assertion |
| --- | ---: |
| SubmenuPresentation | 306 |
| MenuSettings | 48 |
| MenuAnimation | 24 |
| MenuInput | 5 |
| MenuPresentation | 32 |

Fixture 1000×700, 800×520, 360×560 dan 705×280 memeriksa keempat submenu: label–judul, grid kiri, ukuran panel, footer di luar scroll, TextFits, transisi berulang/terputus, urutan reveal dan reduced motion.

Input langsung Studio memverifikasi:

- Empat panel dan Kembali dapat dibuka/ditutup berulang.
- Hover/fokus chapter menyorot bingkai; entri VS01 memulai chapter. Sesudah intro, kamera Custom dan WalkSpeed 16 pulih; OpenMenu tetap menyediakan checkpoint sesi.
- Slider desktop mencapai 90 persen lewat drag; setelah release, menggerakkan pointer tidak mengubah nilai.
- Keyboard kiri/kanan menghasilkan 60→50→60 persen dengan fokus tetap pada MasterSlider.
- Toggle reduced motion membekukan kamera, menjaga lapisan panel tetap terlihat, lalu dapat dinonaktifkan kembali.
- Samsung Galaxy A06 landscape, viewport 705×338 / area UI 705×280: isi panel 96 piksel, slider pertama terlihat. Pengguliran mencapai toggle; Kembali tetap dapat diakses.
- iPhone 17 Pro landscape, viewport 750×381: isi Settings 139 piksel; judul, footer dan kontrol yang terlihat tidak terpotong.
- Screenshot desktop keempat panel dan tampilan mobile diperiksa. Jumlah instance MainMenuGui tetap 139 sebelum/sesudah rangkaian perangkat/panel; ini pemeriksaan terbatas, bukan bukti bebas kebocoran memori jangka panjang.

Log client/server yang diperiksa tidak mencatat MessageError. Review kode menemukan UIStroke kartu masih mengikuti glyph; mode Border sudah diperbaiki dan diuji. Review ulang tidak menemukan masalah tersisa.

## Batas lingkup dan pengujian

Blok pembentukan main menu serta perhitungan layout main menu identik dengan baseline. 19 source di luar perubahan memiliki Git blob yang sama, termasuk font global, kamera, environment, narasi dan seluruh server/shared. 25 source Studio cocok dengan lokal berdasarkan panjang byte dan dua fingerprint setelah normalisasi; metode ini bukan digest kriptografi. `git diff --check` lulus.

Belum diuji pada perangkat fisik atau sesi berjam-jam. Koordinat drag sintetis di simulator tidak cukup untuk mengesahkan persentase target sentuhan; drag/release presisi diverifikasi pada desktop. Tidak dilakukan benchmark FPS atau pengujian ulang seluruh chapter. Tidak ada perubahan map, lighting, terrain, model, save atau logika audio.

Studio dikembalikan ke mode Edit, simulator dimatikan. Belum commit, push atau Publish to Roblox.

## Git siap pakai

Branch dan origin sudah diperiksa. Jalankan dari `D:\1946-7-perspektif` setelah meninjau perubahan:

```powershell
git add -- src/client/GameClient/MainMenuView.luau src/client/GameClient/MainMenuController.luau src/client/GameClient/MenuAnimationController.luau src/client/GameClient/SubmenuPresentation.spec.luau src/client/GameClient/MenuSettings.spec.luau src/client/GameClient/MenuAnimation.spec.luau docs/superpowers/plans/2026-10-19-submenu-editorial.md docs/SUBMENU_RESULT.md
git commit -m "feat: refine editorial submenu layouts and transitions"
git push origin feat/cinematic-main-menu
```
