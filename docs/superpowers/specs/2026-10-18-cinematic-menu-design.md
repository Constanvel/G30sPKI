# Desain menu sinematik

Dasar: brief user 18 Oktober 2026, diimplementasikan langsung sesuai instruksi user. Screenshot pencarian Google adalah moodboard beragam, bukan satu desain untuk disalin.

## Arah visual dan batas

Judul 1965 besar dalam serif krem, TUJUH PERSPEKTIF kecil berjarak di bawah; enam tombol teks rata kiri, indikator merah redup. Jalan perumahan malam low-poly dengan genteng, rumah plester sederhana, jendela hangat, pagar dan lampu jalan. Latar adalah rekonstruksi artistik, bukan klaim lokasi/detail historis terverifikasi. Tanpa kekerasan, horor berlebihan, aset eksternal atau logo baru.

Desktop: kolom navigasi di kiri, jalan dan fasad terbaca di kanan, metadata di bawah. Landscape sempit: judul lebih ringkas dan menu enam tombol dalam dua kolom, target sentuh minimal 44 pixel. Portrait: kolom menu bergulir. Panel isi memiliki area baca scroll, tombol kembali selalu terlihat. Insets perangkat diikuti; text tidak diperbesar global.

Intro sekitar 1,2 detik: hitam singkat, latar muncul, judul dan tombol stagger, metadata. Input tetap responsif. Hover/fokus/click memakai warna dan indikator dengan tween singkat tanpa bounce. Transisi panel fade/slide menggunakan satu generation token dan pembatalan tween, klik terakhir menang. Reduced motion menghilangkan drift, slide dan stagger serta mempersingkat fade.

## Integrasi

Server menambah fase menu pada ChapterService; reset() tetap membuka title untuk kompatibilitas tes lama. Pemain baru masuk menu tanpa checkpoint. startChapter(player,revision,id) hanya menerima vs01 dari menu; ID terkunci/asing ditolak. enterMenu(player,revision) membekukan progres dan menyimpan checkpoint awal objektif aktif; resume(player,revision) hanya menerima checkpoint sesi nyata. Menu dapat dibuka dari tombol MENU selama gameplay termasuk cutscene; timer lama ditolak revision. Saat selesai chapter, lanjutkan nonaktif. Respawn di menu tetap menu, respawn saat bermain tetap perilaku reset chapter yang ada. Tidak ada DataStore.

Enam navigasi: MULAI membuka intro VS01; LANJUTKAN nonaktif jika checkpoint sesi belum ada; PILIH CHAPTER menampilkan VS01 aktif dan enam POV lain berlabel terkunci/tanpa judul rekaan; ARSIP SEJARAH menampilkan empty state tanpa sumber yang disahkan; PENGATURAN berisi volume utama/ambience/UI dan reduced motion; KREDIT memakai tim yang ada di handover (Reiner, Fahkri, Rama, Raja), aset geometri asli dan font Roblox.

Belum ada Sound dalam proyek. Volume benar-benar diterapkan ke SoundGroup lokal menu, dengan status audio belum terpasang; tidak menebak asset ID. Aset audio berizin dapat dimasukkan melalui Sound anak group menu yang sesuai. Pengaturan berlaku selama sesi, tidak mengklaim tersimpan permanen.

## Struktur teknis

Gunakan root Script Sync yang aktif, tanpa Rojo atau dependency. Bootstrap client mengatur handoff ke MainMenuController. MainMenuView membuat GUI; MenuAnimationController mengelola tween dan transisi; MenuCameraController menangani kamera Scriptable, drift berbasis dt, simpan/pulihkan Lighting/FOV dan cleanup; MenuEnvironment membangun latar lokal terisolasi jauh dari ActiveScene. MainMenuController menyatukan panel, volume, reduced motion, error/loading dan request server. UI dan latar dibuat dari source sehingga tidak bergantung ekspor model baru.

Semua tombol memakai Activated dan fokus keyboard/gamepad. Return/Space hanya melanjutkan kartu gameplay ketika menu tertutup. Ready selalu dapat mengirim ulang snapshot; request gameplay ber-revision dan rate limit server. Klien menunggu snapshot sebelum menutup menu, timeout menampilkan retry. Remote/marker hilang memberi pesan jelas dan kamera fallback; karakter baru tidak merebut kamera menu. Tombol gameplay MENU adalah satu tambahan pada GameGui, tanpa mengubah isi/scene VS01.

## Bukti yang diwajibkan

TDD state menu/session checkpoint/stale revision/locked chapter; ulang 45 assertion baseline. Uji Play semua panel, spam klik, kembali, reduced motion, volume, mulai/lanjutkan, cutscene→menu, respawn, kamera/Lighting kembali, error scene. Screenshot PC dan emulator landscape sempit/portrait plus pengukuran bounds/TextFits/target sentuh. Catat runtime errors dan biaya frame sampel sebagai observasi Studio saja; tidak mengklaim FPS perangkat fisik. Tidak commit/push/publish otomatis.
