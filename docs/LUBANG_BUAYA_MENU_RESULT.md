# Latar menu Lubang Buaya

Tanggal: 18 Oktober 2026. Baseline: 7a16f9b, branch feat/cinematic-main-menu.

Scope: ganti latar perumahan menjadi area semi-rural terbuka, label lokasi dan penyesuaian framing/atmosfer seperlunya. Pertahankan UI, navigasi, transisi, reduced motion, server/chapter dan naskah gameplay.

Desain: kiri gelap dan lapang untuk teks; jalur tanah sedikit membelok menuju area penting di kanan-tengah; pagar rendah, satu bangunan kayu sederhana dan shelter jauh; sumur hanya petunjuk kecil di dalam area terbuka, bukan objek dominan. Vegetasi membingkai tepi, dua lampu praktis hangat, terrain berupa primitive lokal. Tidak ada manusia, senjata, adegan kekerasan, dokumen rekaan, monumen modern atau label lokasi mikro yang diklaim autentik.

Rujukan identitas lokasi: [registri Lubang Buaya, Kemendikdasmen](https://referensi.data.kemdikbud.go.id/kebudayaan/kode/KB001815). Registri menempatkannya di Jakarta Timur; ini bukan sumber denah atau tampilan malam tahun1965. [Profil Museum Pancasila Sakti, Asosiasi Museum Indonesia](https://www.asosiasimuseumindonesia.org/anggota/87-museum-pancasila-sakti.html) memberi konteks situs sumur dan museum sekarang, bukan izin menyalin kompleks modern ke adegan1965. Tata letak, bangunan, vegetasi dan cahaya menu adalah pilihan artistik; belum merupakan rekonstruksi sejarah terverifikasi.

Kontrak teknis: gunakan MenuEnvironment.create() dan CameraAnchor yang sudah ada; seluruh geometri hanya lokal, anchored, tanpa collision/touch/query. Target maksimal180 BasePart, dua PointLight tanpa shadow, tanpa emitter atau callback render baru. UI hanya mengganti kicker/penjelasan kredit. Verifikasi melalui tes lingkungan dan suite menu yang ada, screenshot desktop/mobile, transisi gameplay dan pemeriksaan source disk–Studio.

## Implementasi

- Jalan, selokan, trotoar, deretan rumah dan tiang listrik lama diganti oleh tanah terbuka dengan jalur membelok, gundukan rendah, rumput bersudut, pohon jarang dan rumpun bambu.
- Bangunan kayu kecil di kanan dan shelter jauh di kiri memberi skala; pagar rendah membatasi bagian area, dua lentera hangat menerangi jalur dan bangunan.
- WellZone berupa bibir sumur rendah dengan bagian dalam gelap yang dangkal secara geometris. Letaknya di kanan-tengah, jauh dari kamera; tidak ada figur, senjata, interaksi atau penggambaran kekerasan.
- Kicker menjadi LUBANG BUAYA / JAKARTA. Kredit menjelaskan bahwa tata letak bukan replika denah1965. Judul, font, spacing, navigasi, versi, panel dan semua kontrol dipertahankan.
- Kamera direframe sedikit ke area terbuka. Drift berbasis dt, pembatalan tween dan reduced motion memakai controller yang sudah ada. Tone fog dibuat lebih netral, ambient dingin dan nilai tanah dinaikkan agar lingkungan tetap terbaca di malam hari.
- QA menemukan Baseplate gameplay2048×2048 menutupi tanah dekoratif yang semula berada di bawahY0. Latar dipindahkan ke origin lokal (1000,128,0), di atas Baseplate, dan fallback kamera disamakan. Baseplate serta map gameplay tidak diedit. Tes regresi memeriksa pemisahan elevasi ini.

## Berkas

| Berkas | Perubahan |
| --- | --- |
| src/client/GameClient/MenuEnvironment.luau | Pengganti latar; factory/lifecycle yang sama |
| src/client/GameClient/MenuCameraController.luau | Framing fallback dan tone cahaya/fog lokal |
| src/client/GameClient/MainMenuView.luau | Hanya dua string: kicker dan catatan kredit |
| src/client/GameClient/MenuEnvironment.spec.luau | Baru:17 assertion lingkungan dan isolasi gameplay |
| src/client/GameClient/MenuPresentation.spec.luau | Assertion label lokasi; struktur tes lama dipertahankan |
| docs/qa/lubang-buaya-menu-source-sync.json | 21 source dibandingkan dengan Studio |

Tidak mengubah source server/shared, chapter, naskah, Bootstrap, sistem navigasi atau animasi antarmuka. Tidak memasang aset eksternal. Latar tetap dibuat dari source pada client saat Play.

## Pengujian

| Pemeriksaan | Hasil |
| --- | --- |
| Foundation.spec | 33 assertion PASS |
| SceneValidation.spec | 12 assertion PASS |
| MenuState.spec | 21 assertion PASS |
| MenuPresentation.spec | 32 assertion PASS |
| MenuAnimation.spec | 6 assertion PASS |
| MenuInput.spec | 5 assertion PASS |
| MenuCamera.spec | 19 assertion PASS |
| MenuEnvironment.spec | 17 assertion PASS |
| Total suite final | 145 assertion PASS |
| Desktop | Screenshot final diperiksa; semua panel dibuka/ditutup |
| Galaxy A06 landscape | 32 assertion presentasi lulus; semua panel/Back dan TextFits isi panel lulus |
| MULAI dan kamera gameplay | Membuka intro, Custom/WalkSpeed16 kembali |
| MENU → LANJUTKAN | Checkpoint kedua tetap nyata; objektif radio dipulihkan |
| Alur VS01 penuh | Tiga narasi, cutscene dan penutup tercapai |
| Respawn di menu | Menu dan Scriptable camera tetap aktif, karakter baru hidup/terkunci |
| Log sesi final | MessageError client/server kosong |
| Source Sync | 21/21 source disk cocok dengan Studio sesudah normalisasi CRLF/LF |

Tes lingkungan pertama RED karena Location belum tersedia. Sesudah rework,16 assertion lulus. Regresi berikutnya mereproduksi tanah di bawah Baseplate; setelah isolasi elevasi,17 assertion lulus.

Pada satu QA awal, E dikirim sebelum prompt siap sehingga objektif pertama belum maju; pemeriksaan kelanjutan ikut gagal. Pengujian dihentikan dan diulang di sesi bersih dengan tunggu700ms setelah navigasi serta assertion setiap narasi. Alur final lengkap dan log di tabel berasal dari pengulangan yang berhasil, bukan sesi awal itu.

## Keterbacaan dan performa

Viewport desktop sekitar1188×658, area aman1188×600. Emulator A06 sekitar705×338, area aman705×280. Layout dan target44px yang sudah ada tidak berubah. Pada pemeriksaan desktop awal, zona sumur terproyeksi sekitarX705 dari lebar1188; bidang teks utama berakhir sekitarX449. Penyesuaian kecerahan berikutnya tidak mengubah framing.

Latar berisi145 BasePart/150 descendant instance, turun dari155 instance sebelumnya; dua PointLight dibanding tiga sebelumnya. Semuanya anchored, non-collidable/non-queryable, tanpa partikel atau shadow lampu. Tidak ada callback per-frame baru. Sampel120frame desktop pada sesi final: rata-rata16,66ms, p95 sekitar17,83ms. Ini observasi Studio, bukan jaminan FPS perangkat fisik.

Screenshot dalam chat: Lubang_Buaya_Menu_First, Lubang_Buaya_Menu_Isolated_Ground, Lubang_Buaya_Menu_Readability, Lubang_Buaya_A06 dan Lubang_Buaya_Final_PC. Screenshot tidak diekspor sebagai file di Git.

## Status dan batas

Studio dikembalikan ke Edit/default viewport. Tidak ada commit/push/publish, perubahan map gameplay, atau overwrite cadangan RBXL. Latar terbaru tersedia melalui source Script Sync; cadangan RBXL lama sendirian belum memuat source ini.

Belum diuji di ponsel fisik, gamepad fisik, portrait pada rework ini, atau MicroProfiler. Denah/detail1965 belum disahkan peneliti sejarah. Langkah berikutnya: review visual dengan Fahkri menggunakan rujukan situs/arsip yang ditinjau, lalu uji pada Galaxy A07 fisik. Jangan menambahkan monumen, papan museum atau detail modern dengan menganggapnya bagian dari lokasi1965.
