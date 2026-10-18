# 1965: Tujuh Perspektif — Audit dan Rancangan Awal

Tanggal: 18 Oktober 2026, Asia/Jakarta.
Status: usulan untuk ditinjau Reiner; belum menjadi persetujuan implementasi.
Dasar konsep: handover pengguna versi 1.0, disalin ke `docs/MASTER_CONTEXT.txt`.
Pemeriksaan Studio hanya membaca data. Belum ada kode gameplay, pemasangan alat, perubahan place, commit, atau publikasi pada pekerjaan ini.
Pemeriksaan rancangan oleh peninjau terpisah: tidak ada pertanyaan penting tersisa. Hash salinan handover cocok dengan lampiran asli; hash place lokal tetap sama setelah penulisan dokumen.

## 1. Pemahaman proyek

Game edukasi sejarah sekolah dengan eksplorasi third-person, tujuh POV, narasi sinematik, dan investigasi. Engine Roblox Studio, bahasa Luau, sasaran PC dan mobile, visual retro PS1 low-poly. Hasil sejarah tidak dapat diubah pemain. Kekerasan terhadap korban tidak menjadi mekanik permainan.

POV yang diminta: Ahmad Yani, R. Suprapto, S. Parman, M.T. Haryono, D.I. Panjaitan, Sutoyo Siswomiharjo, dan Pierre Tendean. Daftar ini bukan urutan waktu. Urutan penyajian harus dipisahkan dari tanggal kejadian; perpindahan antarperistiwa yang berdekatan diberi penjelasan tanpa mengarang jam.

Alur yang diminta: prolog 30 September 1965 → tujuh POV pada peristiwa dini hari 1 Oktober → konteks Lubang Buaya → pencarian 1–3 Oktober → penemuan lokasi sumur 3 Oktober → pengangkatan 4 Oktober → epilog pemakaman 5 Oktober. Ini struktur dari brief; rincian adegan dan urutan tujuh POV belum dikunci secara historis.

Target: prototype 3–5 menit; MVP 12–18 menit dengan dua POV dan satu segmen investigasi; versi lengkap 30–45 menit dengan tujuh POV, pencarian, penemuan, dan epilog. MVP harus diberi penanda sebagai cuplikan, bukan keseluruhan kisah tujuh korban.

Pembagian peran dari handover:

| Anggota | Tanggung jawab |
| --- | --- |
| Reiner | Lead programmer, integrasi, keputusan desain, pengujian Studio |
| Fahkri | Riset, master timeline, profil korban, naskah dan atribusi |
| Rama | Rumah modular, map, properti periode, collision, pencahayaan |
| Raja | UI PC/mobile, subtitle, title card, ambience dan audio berizin |
| Codex | Pemrograman, arsitektur, integrasi, debugging dan verifikasi sesuai scope |

Proyek BARA-1946 tidak menjadi sumber kode atau aset. Nama folder dan nama berkas lokal tidak membuktikan asal isinya.

## 2. Audit workspace dan Studio

| Area | Hasil pemeriksaan |
| --- | --- |
| Folder lokal | `D:\1946-7-perspektif`; pada awal audit hanya berisi `1946.rbxl` |
| Berkas place lokal | 74.210 byte; hubungan dengan place cloud belum dibuktikan; tidak dibuka, diimpor, atau diubah |
| Git | `git status` dan `git remote -v` melaporkan bukan repositori Git; branch dan remote belum tersedia |
| Source lokal | Tidak ditemukan `.luau`, `.lua`, konfigurasi Rojo, manifest dependensi, build, atau pengujian |
| Alat di PATH | Git tersedia; Rojo, Rokit, Aftman, Lune, Luau, StyLua, Selene tidak ditemukan di PATH yang diperiksa |
| Koneksi Studio | MCP menjangkau dua instance; satu tanpa nama dan satu bernama `1965: Tujuh Perspektif` |
| Target audit | Studio ID `081f47b0-4675-482d-81d4-b1ed58e91b01`; mode Edit |
| Identitas cloud | Place ID `97995024632294`; Universe ID `10771684268`; creator type User; nama DataModel `Place2` |
| Workspace target | Terrain, Baseplate, SpawnLocation, Camera; belum ada rumah atau map chapter |
| Kode target | Tidak ada Script, LocalScript, atau ModuleScript yang ditemukan |
| Penyimpanan kode/aset | ReplicatedStorage, ServerScriptService, ServerStorage kosong; StarterPlayerScripts dan StarterCharacterScripts kosong |
| UI/audio | StarterGui dan SoundService kosong; tidak ditemukan GUI, Sound, MeshPart, Model, atau PackageLink di akar konten game yang diperiksa |
| Lighting | Sky, SunRays, Atmosphere, Bloom, DepthOfField bawaan; belum membuktikan art direction sudah dibuat |

Place ID dan Universe ID membuktikan target terhubung dengan experience cloud. Ini tidak membuktikan setiap edit terbaru sudah tersimpan, experience terbuka untuk publik, atau file lokal identik dengan cloud. Team Create, anggota kolaborator, konfigurasi perangkat, dan akses API penyimpanan belum diperiksa. Tidak ada bukti sinkronisasi source lokal aktif; akses MCP bukan sinkronisasi file.

Aset milik editor/CoreGui tidak dihitung sebagai UI/aset game. Tidak ada alasan untuk menyalin model atau skrip dari instance Studio kedua yang identitasnya belum jelas.

Sidik SHA256 awal `1946.rbxl`: `074B24649D0A7CA8B313CF96E903469138A6136F965D8F5CBFB9F255ECBD66C2`.

## 3. Temuan kelayakan platform

[Roblox Community Standards, bagian Real-World Sensitive Events](https://about.roblox.com/community-standards) melarang rekreasi atau imitasi peristiwa sensitif nyata, termasuk kekerasan massal, pelanggaran HAM, dan kejahatan sensasional. Larangan ini terpisah dari ketentuan gore.

Penilaian untuk proyek ini: rekonstruksi penculikan/pembunuhan korban nyata berisiko langsung bertentangan dengan aturan tersebut. Status edukasi dan penyajian tanpa gore tidak otomatis memberi pengecualian. Ini penilaian risiko berdasarkan aturan, bukan keputusan moderasi khusus terhadap place ini.

Usulan milestone di bawah hanya menguji eksplorasi dan narasi non-kekerasan. Itu belum menjamin kelayakan publikasi tema lengkap. Jangan menganggap server privat atau rating usia sebagai pengecualian aturan. Jangan memakai perubahan nama untuk menyamarkan konten.

Reiner perlu memutuskan penanganan bagian rekonstruksi sebelum produksi adegan sensitif: meninjau penyajian dokumenter yang sesuai aturan, atau membahas platform lain bila rekonstruksi asli harus dipertahankan. Konsep tujuh POV dan engine dalam brief belum diubah oleh dokumen ini. Tidak ada komunikasi ke Roblox yang dilakukan.

## 4. Master timeline kerja dan aturan bukti

Ini register riset awal, bukan master timeline final atau naskah siap tampil. `FACT`, `TESTIMONY`, `DRAMATIZATION` adalah jenis klaim; status pemeriksaan disimpan terpisah. Menemukan klaim di satu publikasi resmi tidak membuat seluruh interpretasi sumber itu menjadi fakta pasti.

| ID | Tanggal/rentang kerja | Peristiwa atau kebutuhan adegan | Jenis | Bukti/status |
| --- | --- | --- | --- | --- |
| H00 | 30 September 1965 | Prolog Jakarta | DRAMATIZATION untuk aktivitas gameplay | Konteks politik, radio, dan surat kabar spesifik belum diteliti; jangan mengarang siaran atau judul koran |
| H01 | 1 Oktober 1965, dini hari | Ahmad Yani, M.T. Haryono, D.I. Panjaitan gugur di kediaman masing-masing | FACT, kandidat | Disebut dalam [modul Sejarah Polri, hlm. cetak 160/PDF 168](https://siapsespimpolri.id/assets/files/modul/3_SEJARAH_POLRI_DI_INDOSESIA_pdf-1770967981.pdf#page=168); butuh sumber pembanding per tokoh |
| H02 | 1 Oktober 1965, dini hari | Suprapto, Parman, Sutoyo, Pierre Tendean dibawa hidup; Nasution selamat | FACT, kandidat | Sumber sama, hlm. cetak 160; jam, dialog dan urutan antarrumah belum diterima sebagai final |
| H03 | 1 Oktober 1965 | Keterkaitan korban dengan Lubang Buaya dan sumur | FACT, kandidat | Sumber sama; rincian pergerakan dan nasib tiap tokoh perlu pencocokan tersendiri |
| H04 | 1–3 Oktober 1965 | Pengumpulan informasi pencarian | TESTIMONY untuk kesaksian; DRAMATIZATION untuk petugas fiktif | Sumber asli kesaksian Sukitman dan urutan pemeriksaan belum diperoleh; dialog wawancara belum boleh ditulis sebagai kutipan |
| H05 | 3 Oktober 1965 | Lokasi sumur ditemukan; informasi Sukitman berperan | FACT, kandidat | [Masykuri, Pierre Tendean, 1983/1984, hlm. cetak 88/PDF 101](https://repositori.kemendikdasmen.go.id/8364/1/PIERE%20TENDEAN.pdf#page=101) dan modul Polri hlm. 161/PDF 169 mendukung tanggal dan peran umum; komando operasional dan jam belum dikunci |
| H06 | 4 Oktober 1965 | Pengangkatan korban | FACT, kandidat | [Pierre Tendean, hlm. cetak 88–89/PDF 101–102; reproduksi pidato bertanggal 4 Oktober pada lampiran III](https://repositori.kemendikdasmen.go.id/8364/1/PIERE%20TENDEAN.pdf#page=101); cari arsip audiovisual/dokumen sezaman pembanding |
| H07 | 5 Oktober 1965 | Pemakaman di TMP Kalibata | FACT, kandidat | [Pierre Tendean, hlm. cetak 93–94/PDF 106–107](https://repositori.kemendikdasmen.go.id/8364/1/PIERE%20TENDEAN.pdf#page=106); sumber primer pembanding masih diperlukan |
| H08 | 1965–1966 | Konteks dampak politik dan kemanusiaan untuk epilog | Belum dirinci | Kajian Komnas HAM, arsip, dan penelitian historiografi belum ditelaah pada audit ini |

Kepastian tanggal H05–H07: dukungan awal ditemukan; belum mendapat peninjauan Fahkri. Kepastian jam, detail kesaksian, tanggung jawab menyeluruh, dan motif: belum diputuskan. Tanggal luas bukan izin untuk menciptakan detail adegan.

Urutan presentasi yang diusulkan: prolog → kelompok tujuh POV pada rentang dini hari yang bertumpang tindih → konteks Lubang Buaya → pencarian → penemuan → pengangkatan → epilog. Urutan internal tujuh POV tetap pending. Ahmad Yani sebagai bahan vertical slice merupakan pilihan produksi, bukan klaim beliau korban pertama.

Tugas riset Fahkri sebelum naskah dikunci:

1. Buat satu catatan per klaim dengan nama sumber, penulis, tanggal terbit, halaman/timecode, bukti, atribusi, kepastian, versi berbeda, dan hasil peninjauan.
2. Verifikasi profil tujuh tokoh, jabatan, pangkat saat kejadian dan pangkat anumerta secara terpisah. Lampiran keputusan dalam buku di atas menjadi petunjuk awal; periksa dokumen keputusan aslinya.
3. Verifikasi denah dan properti rumah per periode. Kondisi museum sekarang tidak otomatis sama dengan rumah 1965.
4. Cocokkan arsip sezaman dengan dokumentasi museum dan kajian lain; periksa ketergantungan sumber agar dua tulisan yang menyalin buku sama tidak dihitung sebagai dua bukti independen.
5. Untuk klaim yang berbeda, pertahankan atribusi atau hilangkan detail yang belum dapat dipastikan. Jangan mengisi kekosongan dengan ucapan terakhir atau kesaksian buatan.

## 5. Arsitektur minimum yang diusulkan

Rekomendasi Codex, belum diimplementasikan: campaign dimainkan satu pemain per server pada prototype. Progres tetap disimpan per pemain. Co-op dan sinkronisasi cutscene antarpemain berada di luar milestone awal. Mode ini perlu diterima bersama scope, karena memengaruhi scene dan pengujian.

Gunakan movement, kamera third-person, dan kontrol sentuh Roblox sebagai titik awal. Tulis penggantinya hanya jika pengujian menemukan kebutuhan nyata. Gunakan ProximityPrompt untuk interaksi, TweenService untuk transisi sederhana, dan RemoteEvent terbatas untuk komunikasi. Rancangan mengikuti [pemisahan script dan lokasi Roblox](https://create.roblox.com/docs/scripting/locations).

Struktur instance yang direncanakan; diagram ini belum berarti folder sudah dibuat:

```text
ReplicatedStorage
  Shared
    Chapters
    Narrative
    Timeline
    Sources
  Remotes
    NarrativeEvent
ServerScriptService
  Game
    Bootstrap (Script)
    ChapterService (ModuleScript)
    InteractionService (ModuleScript)
ServerStorage
  Scenes
    AhmadYaniHouse (Model)
  Characters
    AhmadYani (Model)
Workspace
  ActiveScene (Model)
StarterPlayer
  StarterPlayerScripts
    GameClient
      Bootstrap (LocalScript)
      NarrativeController (ModuleScript)
      CinematicController (ModuleScript)
StarterGui
  GameGui (ScreenGui)
SoundService
  Ambience (Sound)
```

Tanggung jawab dan alur:

- ChapterService memegang state resmi per pemain: chapterId, objectiveIndex, phase, dan sceneVersion. Objektif dan checkpoint sesi awal cukup berada di modul ini.
- InteractionService menerima trigger prompt dan memvalidasi pemain, karakter hidup, jarak server, objek milik scene aktif, urutan objektif, serta duplikasi/rate permintaan. Prompt atau remote dari client tidak dipercaya sebagai bukti progres.
- NarrativeController menampilkan title card, subtitle, narator, tombol lanjut dan HUD. Tombol keyboard maupun sentuh memanggil jalur yang sama.
- CinematicController menangani kamera, fade, dan kunci input sementara. Pembatalan, respawn, dan error selalu memulihkan kamera serta kontrol. Server tetap membatasi progres selama fase transisi.
- Pergantian POV mula-mula ditangani ChapterService; POVController terpisah dibuat ketika POV kedua benar-benar membutuhkan logika sendiri.
- InvestigationService, ArchiveService, CheckpointService persisten dan AudioController tersendiri ditambahkan pada tahap penggunaannya, bukan sebagai modul kosong sejak awal.

Alur state: Loading → TitleCard → Exploring → PresentingNarrative → Exploring → ClosingCinematic → Completed → chapter berikutnya. Server menerima konfirmasi client hanya untuk melanjutkan state yang sudah diizinkan, bukan menerima pilihan chapter atau objektif sembarang. Transisi punya batas waktu dan pemulihan; jangan menunggu acknowledgement client tanpa akhir.

Scene disimpan sebagai template Model di ServerStorage; server menyiapkan satu ActiveScene dan spawn marker sebelum memindahkan karakter. Data scene menentukan rig, spawn dan camera marker; hindari koordinat acak tersebar di script. Saat pergantian, putus koneksi event lama dan bersihkan state scene. Bila rig final belum tersedia, gunakan rig placeholder berlabel. Bila scene wajib hilang, tampilkan kegagalan yang bisa dipulihkan, jangan tandai chapter selesai.

Satu place cukup untuk prototype dan MVP. Teleport lintas place dan streaming dunia besar ditunda. Tidak ada free model berisi script atau dependensi framework yang perlu ditambahkan untuk kebutuhan ini.

## 6. Format data cerita, timeline dan sumber

Data berbentuk tabel Luau sederhana dalam ModuleScript. Pisahkan urutan gameplay dari waktu sejarah. Konten yang terlihat client boleh berada di ReplicatedStorage; state penyelesaian resmi tetap di server.

| Kumpulan data | Field minimum |
| --- | --- |
| Chapters | id stabil, presentationOrder, povId, sceneId, spawnMarker, titleCard, objectiveIds, closingCinematicId, nextChapterId, timelineEventIds |
| Objectives | id, interactionId, instruction, narrativeId; disimpan sebagai daftar dalam chapter, belum perlu modul layanan sendiri |
| Narrative | id, speaker, lines, kind: FACT/TESTIMONY/DRAMATIZATION, sourceIds, reviewStatus |
| Timeline | id, dateStart, dateEnd, timeText opsional, timePrecision, location, characterIds, overlapGroup opsional, claim, kind, sourceIds, certainty, alternativeAccounts, reviewStatus |
| Sources | id, title, author/institution, publicationDate, locator: halaman/timecode, url, evidenceNote, accessedOn |
| Profil tokoh pada perluasan | id, displayName, rankAtEvent, posthumousRank, roleAtEvent, sourceIds |

Tanggal disimpan sebagai `YYYY-MM-DD`; rentang tidak diratakan menjadi jam palsu. `timeText` boleh tidak ada. `presentationOrder` tidak digunakan untuk mengurutkan sejarah. `sourceIds` harus merujuk sumber yang benar-benar ada. Satu blok narasi dengan campuran jenis klaim dipecah menjadi beberapa blok berlabel.

Status pemeriksaan: `needs-research`, `sourced`, `approved`. Hanya `approved` yang boleh masuk build presentasi. Narator ditulis sebagai narator; dialog tokoh asli memerlukan sumber dan atribusi yang sesuai. Aktivitas membaca atau memegang radio yang tidak terdokumentasi dilabeli DRAMATIZATION.

## 7. Workflow kode dan kolaborasi

Rekomendasi awal: Studio memegang map, model dan UI; [Script Sync bawaan](https://create.roblox.com/docs/scripting/sync) menyelaraskan folder kode ke disk. [Rojo](https://create.roblox.com/docs/projects/external-tools) menjadi pilihan jika nanti seluruh proyek perlu dikelola dari file. Script Sync tidak menyinkronkan model dan UI; keduanya tetap perlu penyimpanan place/kolaborasi Studio. Jangan gunakan dua mekanisme sync pada pohon script yang sama.

Mapping yang direncanakan: ReplicatedStorage.Shared → `src/shared`, ServerScriptService.Game → `src/server`, StarterPlayerScripts.GameClient → `src/client`. ModuleScript memakai `.luau`, entry server `.server.luau`, entry LocalScript `.local.luau`. Map dan karakter tetap di Studio.

Setup setelah scope diterima: pastikan target Studio benar, buat cadangan place terbaru, pilih folder kode, aktifkan sync, lakukan satu perubahan teks non-gameplay dan buktikan hasil dua arah, lalu pulihkan teks. Periksa konflik sebelum memilih versi. Rencana ini belum dijalankan.

Git khusus proyek dapat dibuat setelah hubungan folder dengan place dikonfirmasi. Jangan menambahkan remote rekaan atau memakai remote BARA-1946. Commit/push tetap dilakukan hanya atas instruksi Reiner. Tidak ada perintah push yang valid saat repo, branch dan remote belum ada.

Reiner menangani integrasi kode; Rama mengerjakan map; Raja mengerjakan UI/audio; Fahkri mengirim konten dengan ID dan bukti. Untuk satu script yang sama, satu editor aktif pada satu waktu. Handoff model mencantumkan nama, pivot, skala, collision, spawn/camera marker dan hak penggunaan aset.

## 8. Roadmap prioritas dan dependensi

| ID | Kelompok/fase | Pekerjaan | Bergantung pada | Selesai jika |
| --- | --- | --- | --- | --- |
| P0 | Integrasi, fase 0 | Terima scope slice, target Studio, mode satu pemain dan penanganan risiko konten | Audit ini | Keputusan tertulis Reiner; tidak menganggap seluruh campaign disetujui |
| P1 | Narrative, fase 0 | Register bukti, profil Ahmad Yani, konteks tanggal, narasi awal dan label dramatisasi | P0 | Konten slice diperiksa Fahkri; klaim terbuka ditahan dari build |
| P2 | Foundation, fase 1 | Cadangan, mapping Script Sync, struktur minimum, uji dua arah; tetapkan folder proyek | P0 | Source dan Studio cocok tanpa mengubah aset lama |
| P3 | Assets, fase 1–2 | Satu greybox rumah, rig placeholder, tiga properti dan marker | P0; referensi P1 untuk detail historis | Jalur dapat dilalui, pivot/collision benar; detail belum sah diberi label placeholder |
| P4 | Gameplay, fase 1 | Movement bawaan, prompt tervalidasi server, objektif dan state chapter | P2; P3 untuk uji ruang | Tiga interaksi berurutan; spam/objek salah tidak memajukan progres |
| P5 | UI/UX, fase 1–2 | HUD, prompt PC/sentuh, narasi, title card, fade | P2, kontrak P4 | Teks terbaca, kontrol bisa disentuh dan tidak menutupi movement |
| P6 | Audio, fase 2 | Satu ambience dan efek interaksi sederhana | P3, P5 | Aset berizin; loop tidak bertumpuk; slice tetap selesai bila audio gagal |
| P7 | Integration, fase 2 | Narasi disetujui, cutscene, kontrol terkunci/pulih, kartu penutup | P1, P3, P4, P5; P6 jika tersedia | Alur slice 3–5 menit dapat diulang tanpa softlock |
| P8 | Testing, fase 2 | PC, emulator mobile, respawn, pengulangan prompt, marker hilang, review sejarah | P7 | Kriteria milestone di bawah lulus dengan catatan bukti; perangkat nyata dilaporkan terpisah |
| P9 | Gameplay/Narrative, fase 3 | Dua POV, pergantian rig/lokasi, satu investigasi dan ending cuplikan | P8 diterima; konten kedua dan keputusan platform selesai | MVP 12–18 menit; reset tidak mencampur progres POV |
| P10 | Integration, fase 3 | Checkpoint lintas sesi, Continue, kegagalan baca/tulis dan validasi versi data | P9; akses DataStore teruji | Kegagalan load tidak menimpa progres lama dengan data awal; error save dilaporkan dan dicoba ulang secara terbatas |
| P11 | Seluruh kelompok, fase 4 | Tujuh POV, bagian Lubang Buaya, pencarian, penemuan, epilog dan arsip | MVP stabil; seluruh naskah ditinjau; kelayakan platform diputuskan | Campaign 30–45 menit dapat diselesaikan; hasil sejarah tetap |
| P12 | Testing, fase 5 | Profiling PC/mobile, audit lisensi, review sejarah/konten dan polish | P11 | Bukti performa dan pengujian akhir; tidak menyatakan lolos moderasi tanpa hasil resmi |

Fahkri, Rama dan Raja dapat mengerjakan bahan masing-masing setelah kontrak konten/marker disepakati. Rencana itu tidak berarti mengirim pesan atau tugas kepada anggota tim pada audit ini. QA berjalan setiap fase; fase 5 bukan awal pengujian.

Untuk DataStore nanti: akses hanya server; validasi schemaVersion dan chapter yang dikenal; simpan checkpoint stabil, gunakan operasi pembaruan yang menjaga data lama, serta tangani kegagalan dan penutupan server. Prototype awal hanya checkpoint sesi; menu Continue tidak ditampilkan seolah penyimpanan permanen sudah ada. Lihat [Data stores Roblox](https://create.roblox.com/docs/cloud-services/data-stores).

## 9. Milestone pertama yang diusulkan

Nama kerja: `VS01 — Pengenalan Ahmad Yani`, target pengalaman 3–5 menit. Durasi merupakan sasaran uji pemain, bukan estimasi waktu pengerjaan. Bukan rekonstruksi autentik kegiatan pribadi beliau.

Alasan pemilihan: satu lokasi membatasi produksi map; pola eksplorasi, narasi, objektif dan cutscene dapat dipakai POV berikutnya. Pilihan ini belum menetapkan urutan chapter final. Persetujuan milestone tidak berarti persetujuan seluruh tujuh chapter.

Alur konkret:

1. Title card berisi nama tokoh, kediaman, dan konteks tanggal yang disetujui; tidak menampilkan jam yang belum terbukti.
2. Pemain mengendalikan satu rig placeholder sebagai representasi Ahmad Yani di satu area rumah; title card menjelaskan bagian aktivitas merupakan dramatisasi.
3. Tiga interaksi berurutan: kartu profil di meja → properti radio dengan narasi penjelas → papan konteks. Ketiganya perangkat pembelajaran; jangan diklaim sebagai benda/aktivitas asli. Audio siaran sejarah tidak dibuat tanpa sumber.
4. HUD memperbarui satu objektif aktif; narasi memiliki nama pembicara, tombol lanjut dan label sumber/jenis konten.
5. Setelah semua interaksi, kamera menyorot ruang selama transisi singkat, lalu fade. Tidak ada penyerbu, penculikan, tembakan, jenazah atau adegan pembunuhan pada usulan slice ini.
6. Kartu ringkasan yang kontennya telah ditinjau dan penanda akhir demo. Menguji state transisi ke chapter penutup tanpa mengklaim POV kedua atau pergantian karakter sudah dibuat.

Kriteria penerimaan:

- Reiner menyetujui scope ini dan meninjau risiko platform; Fahkri menerima teks yang dipakai.
- Satu karakter dan satu area dapat dimainkan sampai selesai; movement dan kamera PC/sentuh bekerja.
- Tiga prompt bekerja dengan E dan sentuhan; urutan salah, spam, dan interaksi di luar jarak ditolak server tanpa progres ganda.
- Narasi dan objective tidak bertumpuk; judul, tanggal dan label dramatisasi konsisten. Semua klaim yang ditampilkan punya sourceId dan status approved.
- Cutscene memulihkan kamera dan kontrol saat selesai maupun dibatalkan oleh respawn. Kegagalan aset wajib memiliki pesan/pemulihan tanpa menyelesaikan objektif palsu.
- Reset karakter mengulang chapter aktif dari checkpoint sesi yang ditentukan; memulai ulang demo membersihkan koneksi, prompt dan audio lama.
- Dua penyelesaian berurutan di Studio tanpa error runtime atau softlock; satu uji reset saat narasi dan satu saat cutscene.
- UI diperiksa pada viewport PC dan emulator ponsel landscape; uji ponsel fisik, termasuk Galaxy A07 bila tersedia, dicatat tersendiri.
- Sasaran awal 30 FPS pada perangkat mobile uji; angka ini target desain, belum hasil pengukuran. Catat perangkat, viewport dan hasil MicroProfiler saat implementasi.
- Satu pemeriksaan otomatis kecil untuk urutan objektif dan validasi ID chapter/sumber; pemeriksaan gameplay dan input tetap melalui Studio.

Yang ditunda dari milestone: tujuh rumah, POV kedua, investigasi lengkap, combat, AI NPC, voice-over, inventory umum, framework tambahan, save permanen dan publikasi. Sistem tersebut baru dibuat jika fase penggunaannya sudah diterima.

## 10. Langkah pertama dan batas laporan

Rekomendasi: setelah scope VS01 diterima, mulai P1 dan P2; rakit greybox hanya setelah target dan kontrak marker jelas. Jangan langsung membuat ketujuh chapter. Jangan mengganti atau mengimpor `1946.rbxl` sebelum identitasnya dipastikan.

Pertanyaan keputusan untuk Reiner: apakah scope VS01 non-kekerasan, mode satu pemain, dan workflow Script Sync di atas diterima sebagai tahap pertama? Kelayakan publikasi rekonstruksi penuh tetap keputusan terpisah yang harus diselesaikan sebelum produksi adegan sensitif.

Belum dijalankan: Playtest, pengujian mobile fisik, pemeriksaan Team Create/visibility, pembuktian Script Sync, build, penyimpanan DataStore, dan validasi sejarah lengkap. Bukti saat ini cukup untuk menyatakan kondisi awal proyek, bukan kesiapan gameplay atau kelayakan rilis Roblox.
