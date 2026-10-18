# Hasil implementasi menu sinematik

Tanggal: 18 Oktober 2026, Asia/Jakarta. Target: 1965: Tujuh Perspektif, Place ID 97995024632294.
Branch: feat/cinematic-main-menu. Baseline: a61189f. Tidak ada commit, push, atau publish yang dilakukan oleh agent.

## Hasil

Menu sudah terpasang di source dan Roblox Studio melalui Script Sync. Tampilan memakai judul serif krem, indikator merah redup, jalan perumahan low-poly, genteng, pagar, jendela hangat, pohon bersudut, lampu jalan dan kabut ringan. Latar diberi label rekonstruksi artistik; tidak diklaim sebagai lokasi sejarah autentik.

Opening memakai fade latar, reveal judul, stagger enam tombol dan metadata selama sekitar satu detik. Tween diatur per properti agar hover tidak membatalkan reveal teks; pergantian panel membatalkan animasi lama, fade keluar lalu slide/fade masuk. Klik terakhir menjadi tujuan akhir. Reduced motion mematikan drift kamera dan menyederhanakan transisi.

| Navigasi | Perilaku |
| --- | --- |
| MULAI | Request server untuk memulai VS01 baru; membuka intro chapter |
| LANJUTKAN | Aktif hanya bila checkpoint sesi tersedia; kembali ke awal objektif aktif |
| PILIH CHAPTER | VS01 dapat dijalankan; POV 02–07 ditandai terkunci, investigasi belum tersedia |
| ARSIP SEJARAH | Empty state tanpa dokumen, kutipan, atau sumber rekaan |
| PENGATURAN | Volume utama, ambience, efek menu dan reduced motion; berlaku selama sesi |
| KREDIT | Reiner, Fahkri, Rama, Raja sesuai handover; kredit geometri dan font bawaan |

Tombol MENU pada gameplay membekukan progres di server. LANJUTKAN tidak menawarkan save permanen: keluar dari server menghapus checkpoint. Ketika cutscene dijeda melalui menu, lanjutkan mengulang objektif terakhir, bukan melompati sisa cutscene. Setelah demo selesai, LANJUTKAN nonaktif.

## Berkas

| Berkas | Tanggung jawab |
| --- | --- |
| src/client/GameClient/MainMenuController.luau | Navigasi, fokus input, request/retry, pengaturan volume dan reduced motion, lifecycle |
| src/client/GameClient/MainMenuView.luau | GUI runtime, panel dan tata letak responsif |
| src/client/GameClient/MenuAnimationController.luau | Tween per properti, intro, transisi dan hover/fokus |
| src/client/GameClient/MenuCameraController.luau | Kamera menu, drift berbasis dt, simpan/pulihkan Lighting/FOV/subject |
| src/client/GameClient/MenuEnvironment.luau | Latar lokal terisolasi dari ActiveScene, 131 instance |
| src/client/GameClient/Bootstrap.local.luau | Handoff menu/gameplay, tombol MENU, loading koneksi dan input narasi |
| src/server/Game/ChapterService.luau | Fase menu, checkpoint sesi, validasi revision dan chapter |
| src/server/Game/Bootstrap.server.luau | Routing remote, server movement lock, spawn/respawn dan timer cutscene |
| src/server/Game/Tests/MenuState.spec.luau | 21 assertion state/progres |
| src/client/GameClient/MenuPresentation.spec.luau | 26 assertion struktur, unavailable state, viewport dan kamera |
| src/client/GameClient/MenuAnimation.spec.luau | 4 assertion konflik tween, klik cepat, overlay dan reduced motion |
| src/client/GameClient/MenuInput.spec.luau | 5 assertion input panel aktif dan perlindungan checkpoint |
| docs/qa/main-menu-source-sync.json | 19 perbandingan source disk–Studio, semuanya cocok |

README serta desain/rencana menu diperbarui. Scene VS01, template, naskah chapter, aset lama, dan cadangan RBXL tidak diubah. Hash checkpoint final VS01 tetap 6FD2ABD3941A06985EC99431846100D51D67A0EF66DF4DC9E9A2923CDB40BC5A.

## Pengujian

| Pemeriksaan | Hasil |
| --- | --- |
| Foundation.spec | 33 assertion PASS |
| SceneValidation.spec | 12 assertion PASS |
| MenuState.spec | 21 assertion PASS |
| MenuPresentation.spec | 26 assertion PASS |
| MenuAnimation.spec | 4 assertion PASS |
| MenuInput.spec | 5 assertion PASS |
| Total suite final | 101 assertion PASS |
| Dua putaran PC pada kode final state/input | Selesai tiga narasi → cutscene → penutup → ulang; kamera kembali Custom, FOV70, ClockTime14.5 |
| Empat panel + Kembali | Dibuka/ditutup melalui pointer desktop dan emulator landscape |
| Pilih chapter → VS01 | Benar-benar membuka intro gameplay |
| LANJUTKAN objektif kedua | Memulihkan objektif radio; progres tidak dibuat-buat |
| Buka MENU saat cutscene | Tetap di menu sesudah timer lama enam detik; kamera Scriptable |
| Respawn di menu | Menu dan kamera bertahan; karakter baru hidup dengan WalkSpeed0 |
| Reduced motion | Kamera tetap identik pada sampel dua waktu |
| Volume | Tombol minus mengubah label60%→50% dan SoundGroup.Volume0.6→0.5 |
| Scene gameplay hilang lalu MULAI | Kartu error jelas, kamera Custom; scene runtime dipulihkan sesudah pengujian |
| Remotes hilang saat startup | Menu tampil sebelum timeout, panel arsip tetap dapat dibuka; joystick menu tersembunyi |
| Enter tanpa fokus di panel arsip | Kembali ke menu; checkpoint nyata tetap tersedia, tidak memulai chapter tersembunyi |
| Log sesi final | Client dan server tidak memuat MessageError |
| Source final | 19/19 cocok antara disk dan Studio, CRLF/LF dinormalisasi dalam pembandingan |
| Git diff --check | Tidak ada kesalahan whitespace; Git memberi pemberitahuan konversi LF→CRLF |

TDD: MenuState pertama gagal karena enterMenu belum tersedia, kemudian21 PASS. MenuPresentation pertama gagal karena controller belum tersedia, kemudian26 PASS. Regresi animasi mereproduksi hover yang membatalkan reveal teks, kemudian4 PASS setelah tween dipisahkan per properti dan overlay dibersihkan. Regresi input panel gagal sebelum fungsi selection tersedia, lalu5 PASS; reproduksi langsung Enter tanpa fokus juga berubah dari chapter dimulai secara salah menjadi Kembali tanpa menghapus progres.

Sebagian pemanggilan tes awal dilakukan sebelum file baru selesai disebarkan Script Sync dan menghasilkan missing/empty module. Pengujian definitif dilakukan ulang setelah source native tersedia; hasil final bukan diambil dari pemanggilan yang gagal tersebut.

## Responsivitas dan performa

PC viewport sekitar1188×658. Emulator Galaxy A06 memakai preset800×360; viewport landscape sekitar705×338, target navigasi44px tinggi dan kontrol volume44×44. Semua panel ditinjau melalui screenshot; TextFits true untuk judul, tombol kembali dan isi panel.

Game tetap LandscapeSensor. Sebagai stress test saja, orientasi PlayerGui di sesi runtime diubah sementara ke Sensor dan emulator diputar portrait, viewport359×718. Navigasi berubah satu kolom; TextFits semua halaman dan tombol kembali lulus. Pemeriksaan panel portrait memakai pilihan keyboard karena pointer virtual setelah pergantian orientasi tidak konsisten. Ini tidak membuktikan sentuh fisik atau pointer portrait telah lulus.

Sampel120 RenderStepped pada emulator portrait: rata-rata16,67ms, p95 sekitar18,58ms. Ini pengamatan Studio pada komputer pengembangan, bukan benchmark GPU, MicroProfiler, atau jaminan FPS Galaxy A07. Satu callback kamera berjalan hanya selama menu aktif dan motion normal; reduced motion memutus callback itu. Tidak ada particle emitter atau post-processing tambahan.

Screenshot pemeriksaan ditampilkan di chat: MainMenu_Final_PC, Menu_A06_Landscape, Menu_A06_Settings, Menu_A06_Portrait_Stress. Screenshot tool tidak diekspor menjadi file di repositori.

## Review dan keputusan

Satu reviewer independen menemukan P2: Enter tanpa fokus pada panel memakai fallback MULAI tersembunyi dan dapat menghapus checkpoint. Masalah direproduksi, diperbaiki dalam satu tahap, serta dibuktikan dengan lima assertion input dan uji langsung. Tidak ada re-review kedua.

Keputusan implementasi:

- Tetap pada folder Script Sync aktif dengan branch fitur terpisah. Memindahkan checkout akan memerlukan rebind semua root; biaya pilihan ini adalah isolasi folder tidak tersedia.
- Brief user meminta inspeksi lalu implementasi langsung; tidak ditambah gate persetujuan desain. Biaya bila arah visual tidak sesuai: iterasi pada view/latar yang modular.
- Checkpoint hanya menyimpan awal objektif aktif selama sesi. Konsekuensi yang dijelaskan UI: tidak ada continue lintas sesi dan cutscene yang dijeda mengulang objektif terakhir.
- Tidak memasang audio tanpa aset berizin yang jelas. SoundGroup volume berfungsi, tetapi tidak menghasilkan suara karena belum ada Sound; ambience/hover/selection audible masih pekerjaan lanjutan.
- Reviewer tidak menilai sentuh fisik dan scroll gamepad. Keduanya tetap belum terverifikasi; navigasi keyboard dan pointer emulator tidak menggantikannya.

## Menjalankan dan tahap berikutnya

Pada workspace dengan Script Sync aktif, tekan Play → MULAI → Mulai pada intro VS01. WASD/E untuk eksplorasi; Enter/Spasi untuk kartu narasi. MENU kembali ke menu utama. Di menu, panah memilih tombol dan Enter mengaktifkan pilihan; KEMBALI selalu tersedia pada panel.

Studio dikembalikan ke mode Edit dengan viewport default. ActiveScene, GameGui dan NarrativeEvent ada; tidak ada MenuEnvironment tersimpan di Edit karena latar dibangun lokal saat Play. Checkpoint RBXL lama tidak ditimpa dan belum diekspor ulang setelah menu; untuk memulihkan menu gunakan source terbaru melalui Script Sync, bukan RBXL lama sendirian.

Langkah berikutnya: uji joystick/tap/scroll pada Galaxy A07 fisik, lalu tambahkan ambience dan dua efek UI berizin serta dengarkan level volumenya. Setelah itu tinjau sumber arsip bersama Fahkri sebelum membuka chapter baru.

Tidak diuji: Luau type-check/lint terpisah, perangkat fisik, kontrol gamepad lengkap, multiplayer/streaming, audio audible, dan publikasi. Tidak ada DataStore atau klaim kelayakan konten sejarah final.

Perintah Git yang hanya mencakup pekerjaan menu:

```powershell
git add -- README.md src/client/GameClient src/server/Game/Bootstrap.server.luau src/server/Game/ChapterService.luau src/server/Game/Tests/MenuState.spec.luau docs/MAIN_MENU_RESULT.md docs/qa/main-menu-source-sync.json docs/superpowers/plans/2026-10-18-cinematic-menu.md docs/superpowers/specs/2026-10-18-cinematic-menu-design.md
git commit -m "feat: tambahkan menu utama sinematik"
git push -u origin feat/cinematic-main-menu
```
