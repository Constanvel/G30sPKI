# Rencana implementasi menu sinematik

Untuk implementer: gunakan executing-plans, inline. User meminta inspeksi lalu implementasi langsung; tidak perlu konfirmasi desain ulang.

Goal: menu sinematik fungsional yang terintegrasi dengan VS01.
Architecture: state server yang sudah ada ditambah menu/checkpoint sesi; presentasi dibagi view, animasi, kamera/environment dan controller. Semua source melalui Script Sync.
Tech stack: Luau, Roblox GUI, TweenService, SoundGroup, kamera lokal; tanpa dependency/aset eksternal.
Spec: docs/superpowers/specs/2026-10-18-cinematic-menu-design.md.

## Batas dan review focus

- Tidak ada simpan permanen/audio berizin: jangan menampilkan progres atau audio palsu.
- Spam tombol panel dan snapshot terlambat harus berakhir pada panel terakhir tanpa tween tertinggal.
- Respawn/cutscene/menu saling bersaing: kamera dan server lock harus mengikuti revision terbaru.
- Startup tanpa scene/remote tidak boleh mengunci layar tanpa penjelasan dan retry.
- Landscape 705×338 dan portrait harus menyediakan tombol 44px, scroll dan jalan kembali tanpa clipping.

## Task 1 — State server

Files: ChapterService.luau, Bootstrap.server.luau, Tests/MenuState.spec.luau.
Interfaces: enterMenu(player,revision), startChapter(player,revision,id), resume(player,revision) → boolean; snapshot menambah hasCheckpoint/checkpointIndex.

- [x] Tulis MenuState.spec untuk initial menu, tidak ada checkpoint awal, wrong/stale revision, chapter asing, mulai, checkpoint objective2, resume, cutscene→menu/stale timer, completed dan cleanup.
- [x] Jalankan tes Edit melalui require; expected RED karena enterMenu belum tersedia.
- [x] Implementasikan service dan routing server; menu tidak divalidasi seperti scene gameplay, gerak terkunci.
- [x] Jalankan MenuState dan SceneValidation: expected semua PASS; Foundation di Play pada akhir.

## Task 2 — Presentasi dan integrasi client

Files: MainMenuController, MainMenuView, MenuAnimationController, MenuCameraController, MenuEnvironment, Bootstrap.local.luau.
Consumes: snapshot state di Task1. Produces: MainMenuController.new(player,request), show(state), hide(), isVisible(), destroy(); GUI bernama MainMenuGui.

- [x] Tulis MenuPresentation.spec yang menuntut 6 navigasi, empty archive, locked rows, volume dan reduced-motion, viewport bounds, camera cleanup; jalankan RED sebelum module tersedia.
- [x] Bangun environment lokal, view responsif, tween manager, kamera dan controller.
- [x] Hubungkan snapshot menu; tombol MENU memanggil enterMenu; lanjut nonaktif hanya jika checkpoint tidak ada. Jangan tutup menu sampai snapshot gameplay diterima.
- [x] Uji Play expected semua panel/request server bekerja; camera/FOV/Lighting pulih saat Mulai dan menu selama cutscene; remote failure terlihat.

## Task 3 — QA dan polish

- [x] Jalankan ulang 45 baseline + menu state/presentation; dua alur gameplay untuk memastikan progres tidak rusak.
- [x] Uji hover/klik, rapid panel switching, reduced motion, volume, respawn, missing scene dan koneksi; UI PC/landscape/portrait screenshots dan bounds. Fallback marker menu dibaca source, tidak diuji dengan penghapusan runtime.
- [x] Satu reviewer independen membaca source+spec, satu fix pass berbukti bila perlu.
- [x] Tulis docs/MAIN_MENU_RESULT.md, source-sync comparison, Git status/branch/remote dan perintah scoped. Tidak commit/push.

## Ledger

Ruling: memakai branch feat/cinematic-main-menu dalam folder aktif, karena memindah checkout memutus root Script Sync yang sudah teruji. Biaya: isolasi hanya branch, bukan folder; scene VS01 tidak diubah.
Ruling: brief eksplisit meminta langsung implementasi setelah inspeksi; desain dan rencana adalah keputusan implementasi yang dapat ditinjau, bukan approval gate tambahan.
Pre-flight: Task1 snapshot hasCheckpoint/checkpointIndex dipakai Task2; nama dan tipe sama. Task2 membangun GUI/latar dari source, Task3 dapat menguji Play tanpa ekspor map baru.

Builder check: tidak ada pertanyaan penting; reset tetap title dan revision baru melindungi timer lama.
Task1: complete, MenuState 21 assertion PASS sesudah RED enterMenu belum tersedia; SceneValidation 12 PASS.
Task2: PC initial MenuPresentation 26 PASS; semua empat panel, settings volume/reduced motion, Mulai camera/FOV/Lighting, menu objektif2/resume, cutscene→menu sesudah timer6detik, respawn di menu PASS. Baseline Foundation33 + SceneValidation12 tetap PASS. Tidak ada client MessageError pada sesi ini. Latar131 instance. Polish transisi keluar ditambah fade terkoordinasi; verifikasi akhir berikutnya.

Task3: complete. Suite final 33+12+21+26+4+5 =101 PASS; dua penyelesaian PC pada kode final PASS, respawn menu PASS, client/server MessageError kosong. Kamera Custom/FOV70/ClockTime14.5 pulih. 19 source disk dan Studio cocok. Emulator landscape705×338 dan portrait stress359×718 diperiksa; portrait memakai keyboard karena pointer virtual setelah rotasi tidak konsisten. Perangkat fisik dan gamepad lengkap tidak diklaim lulus.
Final: fixed Enter panel memicu Start tersembunyi — reproduksi langsung dan MenuInput RED→GREEN, suite101/101. Fallback memakai focusable panel aktif dan activate menolak tombol di luar panel.
Final: fixed konflik hover/reveal — MenuAnimation RED→GREEN4 assertion, tween diatur per properti dan overlay intro dibersihkan.
Ruling: tampilkan menu sebelum penantian remote — uji tanpa Remotes sebelumnya memperlihatkan menu tertunda; sesudah koreksi menu/panel tersedia cepat dan TouchGui tersembunyi. Biaya: gameplay masih memerlukan remote sehat dan restart Play bila penyiapan tidak tersedia.
Final: Ruling: review tidak menilai sentuh fisik dan scroll gamepad — tetap dicatat belum terverifikasi, karena pointer/keyboard emulator bukan bukti hardware. Biaya bila gagal: iterasi input pada perangkat sebenarnya.
Final: Ruling: audio belum tersedia — kontrol volume menerapkan SoundGroup, tanpa memalsukan playback atau ID; biaya: ambience/hover/selection audible belum terpenuhi sampai aset berizin dipasang.
Final: tidak ada minor dari reviewer yang ditunda. Tidak ada re-review kedua. Studio Edit/default viewport, scene dan remote asli dipulihkan; cadangan lama tidak ditimpa.
