# UI editorial arsip — 18 Oktober 2026

Redesign langsung pada menu 1965: Tujuh Perspektif mengikuti brief UI-only dan referensi pengaturan pengguna. Studio ditinggalkan pada panel Pengaturan dalam Play, dengan simulator kembali default. Tidak publish, commit atau push.

## Audit dan arah desain

UI sebelumnya menggunakan modal 880x610 yang sama untuk seluruh isi, jarak vertikal besar, label kontrol generik dan volume minus/persentase/plus. Tampilannya belum memiliki hubungan editorial yang kuat dengan judul dan setting cerita.

Desain baru memakai hierarki serif/sans yang terkontrol, indeks navigasi, warna arang/krem dan penanda tembaga. Panel tetap sederhana; tidak menambah dekorasi sejarah, arsip palsu, glassmorphism, gambar atau efek pada scene 3D.

| Token | Nilai / penggunaan |
| --- | --- |
| Background | #111412, permukaan panel |
| Surface | #1B201D, hover/fokus ringan |
| Text | #E8E1D1, judul/kontrol utama |
| Secondary | #A6A596, deskripsi/status |
| Muted | #777D75, tombol nonaktif |
| Divider | #41483F, track dan pemisah struktural |
| Accent | #A36D4B, slider/toggle/indikator |
| Accent text | #BE9170, teks kecil agar lebih terbaca |
| Heading | Bodoni, judul dan heading editorial |
| Body/control | Gotham/GothamMedium |
| Numeral | RobotoMono hanya indeks dan persentase |

Spasi memakai ritme 4/8/12/16/24/32 px dengan target input minimal 44 px. Lebar maksimum panel 620 px. Tinggi desktop: Settings 488, Chapters 380, Archive 326, Credits 352 px. Kredit menyesuaikan ke 400 px pada lebar sempit. Pengaturan desktop tidak perlu scroll: viewport konten 356 px, isi 348 px. Pada ponsel landscape yang pendek, konten bisa digulir; header dan Kembali tetap terlihat.

## Perubahan UI

- Brand 1965 dan komposisi kiri dipertahankan, dengan jarak judul/subjudul/tagline lebih rapat dan aturan editorial pendek yang membantu pengelompokan.
- Enam tujuan navigasi tetap sama. Indeks 01–06, hover/fokus tembaga dan state Lanjutkan dengan catatan Belum ada membuat fungsi lebih terbaca.
- Panel chapter menjadi indeks editorial; arsip menampilkan status kosong yang sudah ada; kredit dipadatkan berdasarkan TextBounds aktual. Isi sejarah, nama tim, tujuan dan status chapter tetap dipertahankan.
- Tiga slider memiliki label, persentase, track/fill/handle dan ring fokus. Drag mouse, input Touch, panah kiri/kanan dan D-pad terhubung ke SoundGroup sesi yang sama. Pointer beresolusi 1 persen, keyboard/D-pad bertahap 10 persen, dibatasi 0–100.
- Gerakan dikurangi memakai switch dengan label Aktif/Nonaktif. Fungsi existing menghentikan drift dan menyederhanakan animasi tetap dipakai; source kamera tidak diedit.
- Tween per properti dan generation guard yang sudah ada dipertahankan. Tidak menambah loop RenderStepped, blur, post-processing atau aset audio.
- Drag dilepas saat input berakhir, kehilangan fokus jendela, pindah panel, hide dan destroy. Pada panel yang tidak aktif, input slider ditolak.

## Pemeriksaan dan perbaikan

1. RED sebelum implementasi: pemeriksaan slider pada UI lama gagal karena MasterSlider belum tersedia.
2. Pengujian keyboard menemukan CoreGui mengonsumsi arrow Begin ketika GuiObject terpilih. Probe context action hanya menerima End/Cancel, sedangkan UserInputService menerima Left dengan gameProcessed=true. Slider kini menggunakan InputBegan terbatas pada fokus slider; context action tidak melakukan penyesuaian kedua. Kasus Back -> Right/Left tidak mengubah volume.
3. Regresi memperlihatkan panah juga memengaruhi volume ketika TextBox memiliki fokus. Guard GetFocusedTextBox/MenuIsOpen ditambahkan. Pengulangan native setelah perbaikan menunjukkan volume tidak berubah saat mengetik dan panah bekerja kembali setelah fokus teks dilepas. Perilaku InputBegan dan gameProcessed didokumentasikan di [referensi Roblox](https://create.roblox.com/docs/reference/engine/classes/UserInputService).
4. Review independen menemukan CanvasSize navigasi hilang pada jendela sempit. CanvasSize dipulihkan dan ditambahkan regresinya. Heading panel, pemisahan status toggle dan paragraf diperiksa pada fixture 360x560.

## Pengujian final

- MenuPresentation 32, MenuInput 5, MenuAnimation 6, MenuSettings 39 assertion lulus: total 82. Mencakup safe area, target 44 px, TextFits, keyboard/fokus panel, volume clamp/label/SoundGroup, mid-track, disabled/hidden input, toggle, layout sempit dan pembatalan tween/rapid panel.
- Klik nyata Pilih Chapter, Arsip Sejarah, Kredit, Pengaturan dan Kembali. Pemeriksaan desktop tidak menemukan label/tombol terpotong pada seluruh panel. Tinggi panel mengikuti isi; Settings tidak membutuhkan scroll desktop.
- Ketiga slider di-drag dari 10 ke 90 persen, dilepas lalu pointer dipindahkan kembali: nilai tetap 90 persen dan ketiga SoundGroup cocok. Nilai akhir dikembalikan menjadi 60/50/50 melalui slider. Tidak ada perubahan persistence; tetap selama sesi seperti sebelumnya.
- Panah keyboard mengubah Master 60 -> 40 melalui dua Left. D-pad Right menaikkan 10 persen. ButtonB mengembalikan panel ke menu. Pengujian dengan TextBox aktif memastikan panah tidak mengubah volume.
- Simulator Samsung Galaxy A06: viewport 705x338, area aman 705x280. iPhone 17 Pro: 750x381, area aman 750x323. Keenam tombol navigasi muat, TextFits dan target minimal 44 px. Header/back settings dan seluruh teks lolos TextFits. Settings menggunakan scroll pada tinggi tersebut.
- Pada A06, Down tiga kali dari Master memindahkan fokus ke Motion dan secara otomatis menggulir CanvasPosition ke 170. Seluruh tombol Motion berada dalam viewport konten. Enter menyalakan toggle; kamera stabil. Preferensi dapat dimatikan kembali. Ini uji input sintetis, bukan perangkat/gamepad fisik.
- Mulai dan tombol chapter VS01 sama-sama membuka intro. Enter masuk gameplay dengan kamera Custom dan WalkSpeed 16. Kembali ke menu menampilkan checkpoint, lalu Lanjutkan memulihkan kontrol gameplay. Tidak mengubah chapter/progression untuk pengujian.
- Log client/server pada sesi final bersih dari MessageError. Source delapan file UI dibandingkan langsung terhadap StarterPlayer server Play dan cocok setelah normalisasi BOM/CRLF. Enam belas source yang dilindungi cocok dengan Git HEAD 2200b02. Bukti: docs/qa/editorial-ui-source-sync.json.

## Scope dan file

Diubah: MainMenuView.luau, MainMenuController.luau, MenuAnimationController.luau, MenuPresentation.spec.luau, MenuInput.spec.luau, MenuAnimation.spec.luau. Ditambahkan: MenuStyle.luau dan MenuSettings.spec.luau. Dokumentasi: README, rencana UI, laporan ini dan bukti sinkronisasi.

MainMenuController berubah hanya pada presentasi/navigasi UI dan input slider. Hierarki SoundGroup, nilai sesi awal, audio playback/assets, penyimpanan, protocol chapter dan transisi gameplay tetap. Tidak ada perubahan pada MenuEnvironment, MenuAssetData, MenuCameraController, Bootstrap, Narrative/CinematicController, source server/shared, renderer, model, Terrain, lighting atau post-processing. Tidak perlu menyimpan perubahan native place baru untuk pass UI ini; seluruh tampilan dibentuk dari source Script Sync.

## Batas pengujian

Layar sentuh, multitouch dan controller fisik belum diuji. Jalur Touch memakai identitas InputObject yang sama agar jari kedua tidak mengambil alih drag, tetapi pengujian perangkat nyata tetap diperlukan. Portrait diperiksa sebagai fixture layout 360x560; konfigurasi orientasi game tidak diubah dan tetap mengikuti proyek. Tidak mengklaim aksesibilitas pembaca layar, multiplayer, performa HP atau hasil publikasi telah diuji.

## Git opsional

Branch diperiksa: feat/cinematic-main-menu. Remote origin: https://github.com/Constanvel/G30sPKI.git. Template hanya men-stage file pass UI ini:

```powershell
git add -- README.md src/client/GameClient/MainMenuView.luau src/client/GameClient/MainMenuController.luau src/client/GameClient/MenuAnimationController.luau src/client/GameClient/MenuStyle.luau src/client/GameClient/MenuPresentation.spec.luau src/client/GameClient/MenuInput.spec.luau src/client/GameClient/MenuAnimation.spec.luau src/client/GameClient/MenuSettings.spec.luau docs/superpowers/plans/2026-10-18-editorial-ui.md docs/EDITORIAL_UI_RESULT.md docs/qa/editorial-ui-source-sync.json
git commit -m "feat: redesign UI editorial dan slider pengaturan"
git push origin feat/cinematic-main-menu
```
