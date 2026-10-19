# ENAM JAM: 1949
## Game Design Document (GDD)

**Versi:** 1.0 — Pre-production  
**Status:** Konsep disepakati, implementasi belum diverifikasi  
**Genre:** Cinematic Historical Campaign / Co-op FPS Adventure  
**Platform:** Roblox Studio  
**Bahasa pemrograman:** Luau  
**Jumlah pemain:** 1–4 pemain, kooperatif PvE  
**Art style:** Retro PS1-inspired 3D Low-Poly  
**Durasi campaign:** 25–35 menit  
**Target MVP:** 10–15 menit  
**Bahasa permainan:** Indonesia  
**Target:** Game edukasi sejarah yang dapat dimainkan dan dipresentasikan sebagai proyek sekolah

### Tim pengembang

| Anggota | Peran |
|---|---|
| Rainer | Lead Programmer & Project Integrator |
| Fahkri | Historical Researcher & Story Writer |
| Rama | 3D Artist & Level Designer |
| Raja | UI/UX & Sound Designer |

---

# 1. High Concept

ENAM JAM: 1949 adalah game campaign sejarah Indonesia yang mengangkat Serangan Umum 1 Maret 1949 di Yogyakarta.

Empat pemain memainkan karakter fiktif yang mengalami perkembangan peristiwa tersebut melalui misi kooperatif, eksplorasi lingkungan bersejarah, interaksi dengan NPC, tantangan arcade non-grafis, dan cutscene sinematik.

Campaign menggabungkan tiga pengalaman utama:

1. **Cinematic Storytelling:** Perjalanan cerita disampaikan melalui chapter, dialog, dan adegan sinematik yang mengikuti kronologi sejarah.
2. **Cooperative Gameplay:** Pemain menyelesaikan objektif bersama, membantu rekan, dan menghadapi tantangan PvE virtual.
3. **Historical Discovery:** Pemain membuka informasi, arsip, dan penjelasan tentang Serangan Umum 1 Maret 1949.

Slogan sementara:

"Enam jam yang membuktikan sebuah bangsa masih berdiri."

Game harus menyenangkan sebagai pengalaman multiplayer, tetapi tidak boleh mengubah hasil peristiwa sejarah.

## 1.1 Design Pillars

**Historical Authenticity**

Tanggal, tokoh, lokasi penting, dan hasil sejarah didasarkan pada referensi yang dapat diverifikasi.

**Four-Player Cooperation**

Misi dirancang agar kerja sama memberikan pengalaman lebih menarik, tetapi campaign tetap dapat diselesaikan satu pemain.

**Cinematic Immersion**

Gameplay dan cutscene membentuk satu pengalaman, bukan dua bagian yang terasa terpisah.

**Small Scope, High Polish**

Lebih baik memiliki satu chapter yang benar-benar matang daripada lima chapter yang belum selesai.

**Accessible Arcade Gameplay**

Mekanisme permainan dibuat intuitif dan non-grafis, tanpa mereproduksi detail penggunaan persenjataan atau taktik militer dunia nyata.

---

# 2. Historical Foundation

## 2.1 Fakta utama

Pada 19 Desember 1948, Belanda melancarkan Agresi Militer II dan menduduki Yogyakarta.

Sebagian pemimpin Republik Indonesia ditangkap, tetapi pemerintahan serta perjuangan Republik tetap berlanjut melalui berbagai jalur, termasuk Pemerintahan Darurat Republik Indonesia (PDRI).

Pada 1 Maret 1949, pasukan Republik melancarkan serangan di Yogyakarta sekitar pukul 06.00.

Pasukan Republik berhasil menguasai kota selama beberapa jam. Peristiwa tersebut kemudian dikenal sebagai Serangan Umum 1 Maret 1949 atau peristiwa enam jam di Yogyakarta.

Tujuan pentingnya adalah memperlihatkan bahwa Republik Indonesia dan kekuatan militernya masih ada, sekaligus mendukung perjuangan diplomatik.

Berita serangan menyebar melalui jaringan komunikasi, termasuk radio AURI dan saluran Republik lainnya, hingga menjangkau dunia internasional.

## 2.2 Ketentuan sejarah

Jangan menganggap seluruh dialog, karakter pendukung, lokasi kecil, dan rangkaian objektif game sebagai peristiwa nyata.

Setiap konten wajib memiliki salah satu kategori berikut:

| Kategori | Definisi | Contoh |
|---|---|---|
| FACT | Peristiwa yang didukung sumber sejarah | Serangan terjadi pada 1 Maret 1949 |
| TESTIMONY | Kesaksian atau uraian yang perlu diatribusikan | Keterangan mengenai pengalaman seseorang |
| FICTIONAL_ADAPTATION | Elemen yang dibuat untuk kebutuhan permainan | Empat karakter playable dan misi mereka |
| DISPUTED | Detail atau interpretasi yang berbeda antarsumber | Rincian waktu berakhirnya operasi |

Catatan khusus: sejumlah sumber museum dan pendidikan menyebut penarikan pasukan sekitar pukul 12.00, sementara Ensiklopedia Sejarah Indonesia mencatat pukul 15.00. Timeline final perlu mempertahankan informasi mengenai perbedaan ini. Jangan mengarang jam tertentu untuk adegan yang tidak memiliki rujukan.

## 2.3 Aturan narasi

- Tokoh sejarah tidak boleh diberi dialog fiktif yang disajikan sebagai kutipan autentik.
- Pemain tidak dapat mengubah hasil Serangan Umum.
- Karakter playable adalah tokoh rekaan, bukan pengganti tokoh sejarah.
- Latar kota boleh disederhanakan untuk permainan, tetapi tidak boleh diklaim sebagai replika Yogyakarta yang sepenuhnya akurat.
- Konten kekerasan harus non-grafis dan tidak sensasional.
- Setiap chapter menyertakan informasi sejarah yang relevan.

---

# 3. Player Experience

## 3.1 Alur pemain

Pemain memasuki game dan melihat main menu.

Pemain dapat memilih Mulai, Lanjutkan, Pilih Chapter, Arsip Sejarah, Pengaturan, atau Kredit.

Setelah memilih Mulai, pemain masuk ke lobby co-op.

Di lobby, pemain menunggu teman, memilih karakter, melihat briefing singkat, kemudian memulai campaign.

Ketika permainan dimulai, keempat pemain muncul pada lokasi pembuka yang sama dan mengikuti perkembangan cerita bersama.

Campaign memiliki satu progres misi bersama, bukan empat progres chapter terpisah.

## 3.2 Gameplay loop

Lobby → Briefing → Cutscene pembuka → Eksplorasi → Tantangan arcade / interaksi → Objektif bersama → Checkpoint → Cutscene akhir → Chapter berikutnya.

Setiap chapter harus memiliki:

- Tujuan utama yang jelas.
- Aktivitas gameplay.
- Minimal satu interaksi kooperatif yang bermakna.
- Perubahan suasana atau perkembangan cerita.
- Checkpoint.
- Penjelasan sejarah singkat.
- Transisi ke chapter selanjutnya.

## 3.3 Tingkat kesulitan

MVP menggunakan satu tingkat kesulitan standar.

Penyesuaian untuk 1–4 pemain difokuskan pada jumlah aktivitas, durasi, dan tantangan virtual, bukan kompleksitas mekanisme realistis.

Permainan tidak boleh membutuhkan tepat empat pemain untuk menyelesaikan suatu objektif.

---

# 4. Playable Characters

Empat karakter utama bersifat fiktif dan merupakan bagian dari adaptasi gameplay.

Nama karakter masih sementara.

| Karakter | Identitas | Kelebihan gameplay |
|---|---|---|
| Arga | Pemimpin kelompok | Berinteraksi dengan objektif cerita dan memandu informasi misi |
| Bima | Kurir | Mengelola dokumen, pesan, dan objektif komunikasi |
| Surya | Relawan medis | Membantu rekan dan berinteraksi dengan pos bantuan |
| Damar | Operator komunikasi | Menangani puzzle radio dan pencatatan informasi |

## 4.1 Shared Abilities

Semua pemain dapat:

- Bergerak dan mengeksplorasi map.
- Berinteraksi dengan objek.
- Mengikuti pertempuran virtual non-grafis.
- Membantu rekan yang tidak dapat melanjutkan sementara.
- Berkomunikasi melalui ping dan indikator UI.
- Mengaktifkan objektif umum.
- Mengikuti cutscene.
- Menerima informasi cerita.

## 4.2 Role Abilities

Perbedaan kemampuan tidak boleh menjadi penghalang bagi pemain solo.

Sebagai contoh, saat Operator Komunikasi tidak dipilih, pemain lain tetap dapat mengerjakan puzzle radio melalui interaksi biasa.

Kemampuan unik memberikan variasi atau kemudahan tertentu, bukan mengunci seluruh progres.

Tidak ada sistem kelas kompetitif atau keunggulan berbayar.

---

# 5. Campaign Structure

## PROLOG — KOTA YANG DIDUDUKI

**Latar:** Pinggiran Yogyakarta, menjelang 1 Maret 1949.  
**Durasi target:** 3 menit.  
**Fokus:** Pengenalan karakter, kondisi sejarah, dan gameplay dasar.

### Cerita

Keempat karakter bertemu di sebuah lokasi fiktif di pinggiran Yogyakarta.

Melalui percakapan, radio, dan dokumen, pemain diperkenalkan pada situasi Indonesia sesudah Agresi Militer Belanda II.

### Gameplay

- Pergerakan dan pengenalan kontrol.
- Mengikuti indikator objektif.
- Berinteraksi dengan radio.
- Membaca satu dokumen historis.
- Berbicara dengan NPC.
- Berkumpul di titik transisi chapter.

### Ending chapter

Cutscene memperlihatkan perubahan suasana menjelang pagi 1 Maret 1949.

### Fakta dan fiksi

FAKTA: Yogyakarta telah diduduki Belanda sejak Desember 1948.

FIKSI: Keempat karakter, percakapan, dan lokasi pertemuan mereka.

---

## CHAPTER 1 — FAJAR YOGYAKARTA

**Latar:** Yogyakarta, 1 Maret 1949.  
**Durasi target:** 5 menit.  
**Fokus:** Awal peristiwa dan pengenalan aktivitas kooperatif.

### Cerita

Campaign beralih menuju pagi 1 Maret.

Melalui adegan sinematik, pemain mengetahui bahwa Serangan Umum telah dimulai.

### Gameplay

- Eksplorasi kawasan kota.
- Tantangan PvE arcade non-grafis.
- Interaksi dengan objek cerita.
- Pengumpulan informasi.
- Objektif bersama.
- Checkpoint pertama.

### Momen sinematik

Kartu judul menampilkan:

YOGYAKARTA  
1 MARET 1949  
FAJAR

Perubahan suasana lingkungan dan musik mendukung awal chapter.

### Fakta dan fiksi

FAKTA: Serangan Umum dimulai sekitar pukul 06.00.

FIKSI: Jalur perjalanan, kelompok pemain, dan objektif kecil.

---

## CHAPTER 2 — ENAM JAM

**Latar:** Kawasan kota Yogyakarta yang disederhanakan.  
**Durasi target:** 7 menit.  
**Fokus:** Chapter utama dengan gameplay co-op paling intens.

### Cerita

Keempat karakter mengalami perkembangan Serangan Umum melalui beberapa adegan gameplay.

Chapter memperlihatkan perubahan keadaan kota serta pentingnya kerja sama antarkarakter.

### Gameplay

Tiga rangkaian aktivitas:

**Sequence A — City Arrival**

Pemain memasuki area utama dan menerima informasi perkembangan cerita.

**Sequence B — Cooperative Challenge**

Pemain menyelesaikan rangkaian objektif bersama dan menghadapi tantangan NPC virtual non-grafis.

**Sequence C — Historical Transition**

Setelah objektif selesai, adegan sinematik menunjukkan perkembangan Serangan Umum secara lebih luas.

### Variasi mekanik

- Objektif area.
- Interaksi dengan NPC.
- Bantuan rekan.
- Perubahan objektif berbasis cerita.
- Checkpoint setelah setiap sequence.

### Fakta dan fiksi

FAKTA: Pasukan Republik berhasil menguasai Yogyakarta sementara waktu.

FIKSI: Kelompok empat pemain, lokasi objektif kecil, dan pola pertemuan NPC.

Tidak boleh menyajikan aktivitas karakter fiktif sebagai penjelasan autentik operasi militer.

---

## CHAPTER 3 — KABAR UNTUK DUNIA

**Latar:** Pos komunikasi fiktif.  
**Durasi target:** 5 menit.  
**Fokus:** Kerja sama dan puzzle informasi.

### Cerita

Pemain mempelajari pentingnya penyebaran informasi tentang Serangan Umum.

Cerita memperlihatkan bahwa peristiwa tersebut bukan hanya penting di Yogyakarta, melainkan juga dalam perjuangan diplomatik.

### Gameplay

- Eksplorasi pos komunikasi.
- Mengumpulkan arsip.
- Menyusun urutan informasi.
- Mengaktifkan objektif radio dalam konteks permainan.
- Membuka fakta sejarah.
- Cutscene komunikasi.

### Puzzle

Pemain diberikan beberapa potongan dokumen dan diminta mengurutkan informasi berdasarkan tanggal atau urutan peristiwa yang telah dipelajari.

### Fakta dan fiksi

FAKTA: Berita Serangan Umum disebarkan melalui jaringan komunikasi dan radio Republik.

FIKSI: Empat karakter menjalankan sebuah pos komunikasi rekaan.

Game tidak boleh menyatakan bahwa keempat karakter fiktif merupakan pengirim berita sejarah yang asli.

---

## CHAPTER 4 — AKHIR OPERASI

**Latar:** Yogyakarta, tahap akhir Serangan Umum.  
**Durasi target:** 5 menit.  
**Fokus:** Penyelesaian campaign dan klimaks cerita.

### Cerita

Keempat karakter menerima perkembangan terakhir situasi.

Pemain harus menyelesaikan objektif penutup dan mengikuti akhir operasi sesuai sejarah.

### Gameplay

- Objektif bersama.
- Interaksi dengan NPC.
- Membantu rekan yang tertinggal.
- Menyelesaikan rangkaian misi terakhir.
- Cutscene penutup.

### Ending

Pemain menyaksikan penjelasan bahwa penguasaan Yogyakarta oleh pasukan Republik berlangsung sementara.

Cerita kemudian beralih ke penyebaran berita dan dampak politiknya.

### Fakta dan fiksi

FAKTA: Pasukan Republik tidak mempertahankan penguasaan Yogyakarta secara permanen pada 1 Maret 1949.

FIKSI: Perjalanan dan objektif penutup keempat karakter.

---

## EPILOG — REPUBLIK MASIH ADA

**Durasi target:** 3 menit.

Epilog menggunakan format museum interaktif.

Pemain melihat:
- Kronologi Desember 1948 hingga Maret 1949.
- Ringkasan Serangan Umum.
- Tokoh sejarah penting.
- Dampak terhadap perjuangan diplomatik.
- Penyebaran informasi internasional.
- Referensi yang digunakan.

Epilog menjelaskan bahwa 1 Maret kini diperingati sebagai Hari Penegakan Kedaulatan Negara berdasarkan Keputusan Presiden Nomor 2 Tahun 2022.

Akhir permainan menampilkan penghormatan kepada masyarakat dan para pejuang yang terdampak peristiwa sejarah.

---

# 6. Co-op Multiplayer Design

## 6.1 Session System

Satu sesi permainan mendukung 1–4 pemain.

MVP menggunakan lobby dalam satu server. Tidak perlu sistem matchmaking lintas server yang kompleks.

Keadaan sesi:

WAITING → READY → LOADING → PLAYING → CHAPTER_COMPLETE → FINISHED

Pemain yang masuk sebelum campaign dimulai dapat memilih karakter.

Pemain yang bergabung ketika chapter berlangsung dapat diarahkan ke checkpoint aman berikutnya apabila sistem mendukungnya.

## 6.2 Shared Objectives

Semua pemain dalam satu sesi melihat objektif utama yang sama.

Ketika sebuah objektif selesai, server memperbarui status dan mengirim perubahan kepada seluruh pemain.

Satu objektif tidak boleh diselesaikan berulang kali karena beberapa pemain berinteraksi hampir bersamaan.

## 6.3 Co-op Rules

- Campaign bisa dimainkan solo.
- Peran tidak mengunci penyelesaian misi.
- Pemain yang terputus koneksi tidak membatalkan progres seluruh tim.
- Chapter dapat dilanjutkan oleh pemain yang masih terhubung.
- Pemain yang kehilangan seluruh HP virtual memasuki keadaan tidak aktif sementara dan dapat kembali melalui bantuan rekan atau checkpoint.
- Tidak ada friendly fire dalam MVP.
- Tidak ada PvP.
- Tidak ada mekanik yang mendorong kompetisi berdasarkan jumlah korban.

## 6.4 Checkpoint Rules

Checkpoint merupakan progres bersama selama sesi.

Progres chapter yang terbuka disimpan per akun pemain melalui sistem penyimpanan Roblox jika sudah diimplementasikan dan diuji.

Untuk MVP, pemuatan ulang progres dapat dibuat sederhana terlebih dahulu.

---

# 7. Combat & NPC Experience

Game menggunakan mekanik pertempuran virtual arcade non-grafis dalam lingkungan fiktif yang terinspirasi sejarah.

Prioritas gameplay:
- Kontrol responsif.
- Pertemuan NPC yang mudah dipahami.
- Kejelasan feedback permainan.
- Tantangan yang tidak terlalu panjang.
- Kerja sama pemain.
- Transisi halus ke objektif berikutnya.

NPC menggunakan perilaku game sederhana, dengan status seperti Idle, Alert, Active, dan Inactive.

NPC bukan simulasi perilaku tempur manusia nyata.

Kekalahan NPC direpresentasikan melalui animasi non-grafis dan perubahan status gameplay, tanpa efek cedera eksplisit.

Tidak diperlukan reproduksi realistis penggunaan senjata, cedera, maupun operasi militer historis.

---

# 8. Level & Environment Design

## 8.1 Struktur Map

Satu campaign menggunakan beberapa area modular.

### Area A — Pinggiran Yogyakarta

Fungsi:
- Tutorial.
- Prolog.
- Pertemuan karakter.
- Briefing.

### Area B — Kota Yogyakarta

Fungsi:
- Chapter 1.
- Chapter 2.
- Objektif co-op.
- Cutscene perkembangan peristiwa.

### Area C — Pos Komunikasi

Fungsi:
- Chapter 3.
- Puzzle informasi.
- Dialog dan arsip.

### Area D — Area Penutup

Fungsi:
- Chapter 4.
- Penyelesaian cerita.
- Transisi epilog.

## 8.2 Historical Art Direction

Bangunan dan objek harus mencerminkan Yogyakarta sekitar tahun 1949.

Elemen yang dapat digunakan sebagai referensi:
- Bangunan kolonial.
- Rumah Jawa.
- Jalan dan lingkungan kota lama.
- Pasar dan bangunan perdagangan.
- Radio dan perlengkapan komunikasi sesuai masa.
- Papan informasi.
- Properti rumah tangga periode 1940-an.

Rekonstruksi tidak boleh menggunakan aset modern yang mencolok.

## 8.3 Visual Style

Retro PS1-inspired Low-Poly.

Karakteristik:
- Siluet bangunan jelas.
- Model sederhana.
- Tekstur ringan.
- Pencahayaan atmosferik.
- Palet warna alami dan redup.
- Efek sinematik secukupnya.
- Optimal untuk laptop pelajar.

Tidak perlu menerapkan efek pixelated ekstrem yang mengurangi keterbacaan.

---

# 9. UI/UX Design Specification

## 9.1 Design Identity

Arah antarmuka:

Historical Editorial + Military Archive + Cinematic Narrative.

Gunakan referensi arsip, dokumen sejarah, dan tata letak editorial untuk membangun identitas yang khas.

Hindari:
- UI generik Roblox.
- Panel transparan besar tanpa tujuan.
- Dashboard modern yang tidak sesuai tema.
- Neon berlebihan.
- Terlalu banyak efek glitch.
- Animasi berlebihan.
- Tombol yang terlalu kecil.
- Ruang kosong yang tidak terencana.

## 9.2 Warna

Palet awal, belum final:

| Fungsi | Warna |
|---|---|
| Background | #141713 |
| Secondary Surface | #20251F |
| Primary Text | #E8E1D0 |
| Secondary Text | #A6A99C |
| Historical Accent | #B7864B |
| Muted Divider | #44493F |
| Warning | #C89C54 |

Gunakan warna aksen secara konsisten, terutama untuk navigasi, pilihan aktif, dan informasi penting.

## 9.3 Main Menu

Menu utama:
- Mulai
- Lanjutkan
- Pilih Chapter
- Arsip Sejarah
- Pengaturan
- Kredit

Background menggunakan rekonstruksi artistik lingkungan Yogyakarta tahun 1949.

Jangan memakai background Lubang Buaya dari proyek 1965.

Judul utama:

ENAM JAM  
1949

Subtitle:

SERANGAN UMUM 1 MARET

## 9.4 Lobby UI

Informasi:
- Nama lobby.
- Jumlah pemain.
- Empat slot karakter.
- Status Ready.
- Ringkasan chapter.
- Tombol mulai.
- Status koneksi.
- Tombol kembali.

Lobby harus tetap nyaman dipakai walaupun hanya satu pemain.

## 9.5 Mission HUD

Elemen minimal:
- Nama chapter.
- Objektif aktif.
- Informasi progres.
- Status empat anggota tim.
- Indikator interaksi.
- Penanda checkpoint.
- Subtitle.

HUD tidak boleh terlalu ramai.

## 9.6 Chapter Transition

Setiap chapter menggunakan title card sinematik yang menampilkan lokasi, tanggal, dan nama chapter.

Konten sejarah yang muncul pada title card harus berasal dari sumber yang telah diverifikasi.

## 9.7 Settings

Fitur:
- Volume utama.
- Volume ambience.
- Volume efek.
- Sensitivitas kamera virtual.
- Pengaturan kualitas visual sederhana.
- Pengurangan gerakan kamera.
- Subtitles On/Off.

Pengaturan harus dapat digunakan, bukan sekadar tombol dekoratif.

## 9.8 Animation Principles

Gunakan:
- Fade.
- Slide pendek.
- Subtle typography reveal.
- Camera transition yang stabil.
- TweenService untuk UI.
- Easing konsisten.

Jangan gunakan animasi yang terlalu panjang atau menghambat kontrol pemain.

---

# 10. Audio & Cinematic Design

## 10.1 Audio

Kategori audio:
- Ambience desa.
- Ambience kota.
- Langkah kaki.
- Radio.
- Interaksi objek.
- Efek UI.
- Musik sinematik orisinal.
- Efek transisi chapter.

Semua audio harus legal digunakan dalam proyek.

## 10.2 Cinematic System

Dibutuhkan sistem cutscene yang mendukung:
- Perpindahan kamera.
- Subtitle.
- Perubahan fokus.
- Penguncian input sementara.
- Transisi ke gameplay.
- Sinkronisasi antar pemain.
- Pemulihan kontrol.

Untuk MVP, cutscene dapat berdurasi sekitar 10–30 detik.

Cutscene yang lebih panjang hanya digunakan jika ada kebutuhan cerita yang jelas.

## 10.3 Multiplayer Cutscene

Cutscene penting harus disinkronkan agar keempat pemain menerima perkembangan cerita yang sama.

Jika memungkinkan, tambahkan sistem skip bersama yang tidak merusak progres pemain.

---

# 11. Technical Architecture — Roblox

## 11.1 Prinsip

Gunakan Luau yang modular, terstruktur, dan mudah diuji.

Pisahkan:
- Shared configuration.
- Server gameplay logic.
- Client UI dan kamera.
- Mission data.
- Historical content.
- Asset management.

Server mengontrol status misi dan progres bersama.

Client menangani presentasi UI, audio lokal, dan kamera.

## 11.2 Recommended Modules

| Modul | Tanggung jawab |
|---|---|
| GameConfig | Pengaturan global |
| LobbyService | Status sesi dan ready player |
| CharacterRoleService | Pemilihan peran |
| MissionService | State dan progres campaign |
| ObjectiveService | Aktivitas objektif |
| NPCService | Status NPC virtual |
| CheckpointService | Checkpoint sesi |
| ProgressService | Data pemain |
| HistoricalData | Informasi sejarah |
| InteractionController | Interaksi lokal |
| CinematicController | Kamera dan cutscene |
| UIController | Tampilan antarmuka |
| AudioController | Suara dan transisi audio |

## 11.3 Suggested Folder Structure

ReplicatedStorage/
- Shared/
- Remotes/
- GameConfig/
- HistoricalData/

ServerScriptService/
- Services/
- GameServer/

ServerStorage/
- NPCTemplates/
- MissionAssets/

StarterPlayer/
- StarterPlayerScripts/
- Controllers/

StarterGui/
- MainMenu/
- LobbyUI/
- MissionHUD/
- HistoricalArchive/
- SettingsUI/

Workspace/
- Map/
- SpawnPoints/
- ObjectiveZones/
- CutsceneMarkers/

Struktur aktual harus disesuaikan dengan workspace yang sudah tersedia setelah diaudit.

## 11.4 Multiplayer Security

Setiap permintaan dari client yang memengaruhi progres harus diverifikasi oleh server.

Server wajib memeriksa:
- Identitas pemain.
- Status sesi.
- Ketersediaan objektif.
- Status penyelesaian sebelumnya.
- Validitas interaksi.

Hindari kepercayaan langsung pada data progres dari client.

## 11.5 Save System

Gunakan DataStoreService saat penyimpanan permanen dibutuhkan.

Data minimal:
- Chapter yang telah dibuka.
- Chapter tertinggi yang selesai.
- Pengaturan pemain yang perlu dipertahankan.
- Versi format data.

Simpan progres chapter, bukan seluruh keadaan dunia game.

---

# 12. Production Roadmap

| Minggu | Fokus | Deliverable |
|---|---|---|
| 1 | Riset dan fondasi | Master timeline, repo, project setup |
| 2 | Multiplayer | Lobby, karakter, shared mission |
| 3 | Gameplay prototype | Controller, NPC virtual, interaksi, checkpoint |
| 4 | Vertical Slice | Satu chapter playable lengkap |
| 5 | Campaign Expansion | Chapter prioritas, map, audio, UI |
| 6 | Testing & Polish | Validasi sejarah, QA, optimasi, presentasi |

Rencana ini bersifat estimasi. Jumlah fitur perlu dikurangi jika kapasitas tim tidak mencukupi.

---

# 13. Codex Implementation Backlog

Backlog dibagi menjadi P0, P1, dan P2.

P0 = Wajib untuk MVP.  
P1 = Dikerjakan setelah MVP stabil.  
P2 = Pengembangan tambahan jika waktu memungkinkan.

Estimasi menggunakan story point relatif, bukan jam pasti.

## EPIC A — Project Foundation

| ID | Task | Prioritas | SP |
|---|---|---|---|
| A-01 | Audit workspace dan source code | P0 | 2 |
| A-02 | Setup struktur Roblox dan Luau | P0 | 3 |
| A-03 | Konfigurasi Git / Rojo jika sesuai | P0 | 3 |
| A-04 | Shared GameConfig dan event contracts | P0 | 3 |

Acceptance:
Proyek dapat dibuka, dijalankan, dan tidak menghasilkan error inisialisasi yang menghalangi pengembangan.

## EPIC B — Multiplayer Foundation

| ID | Task | Prioritas | SP |
|---|---|---|---|
| B-01 | Implementasi sesi 1–4 pemain | P0 | 5 |
| B-02 | Lobby dan ready state | P0 | 5 |
| B-03 | Character selection | P1 | 3 |
| B-04 | Shared mission state | P0 | 5 |
| B-05 | Disconnect handling | P0 | 3 |
| B-06 | Late join checkpoint | P1 | 5 |

Acceptance:
Empat client dapat menjalankan satu sesi bersama dengan progres misi yang konsisten.

## EPIC C — Core Gameplay

| ID | Task | Prioritas | SP |
|---|---|---|---|
| C-01 | First-person controller | P0 | 5 |
| C-02 | Interaction system | P0 | 5 |
| C-03 | NPC arcade behavior | P0 | 5 |
| C-04 | Shared objective controller | P0 | 5 |
| C-05 | Checkpoint system | P0 | 5 |
| C-06 | Cooperative assistance | P1 | 5 |

Acceptance:
Pemain dapat menyelesaikan satu rangkaian objektif dari awal sampai akhir tanpa kehilangan kontrol atau mengalami progres ganda.

## EPIC D — Narrative Systems

| ID | Task | Prioritas | SP |
|---|---|---|---|
| D-01 | Dialogue system | P0 | 3 |
| D-02 | Subtitle component | P0 | 2 |
| D-03 | Cinematic camera controller | P0 | 5 |
| D-04 | Chapter transition | P0 | 3 |
| D-05 | Historical archive | P1 | 5 |

Acceptance:
Satu chapter memiliki opening, gameplay, dialog, cutscene, dan ending yang terhubung.

## EPIC E — User Interface

| ID | Task | Prioritas | SP |
|---|---|---|---|
| E-01 | Main menu | P0 | 3 |
| E-02 | Lobby UI | P0 | 5 |
| E-03 | Mission HUD | P0 | 5 |
| E-04 | Settings | P1 | 3 |
| E-05 | Chapter Selection | P1 | 3 |
| E-06 | Responsive polishing | P1 | 5 |

Acceptance:
Seluruh UI MVP terbaca jelas, memiliki state interaksi, dan tidak menghalangi gameplay.

## EPIC F — Map & Integration

| ID | Task | Prioritas | SP |
|---|---|---|---|
| F-01 | Greybox area pembuka | P0 | 3 |
| F-02 | Greybox area chapter pertama | P0 | 5 |
| F-03 | Integrasi map modular | P0 | 5 |
| F-04 | Penempatan marker objektif | P0 | 3 |
| F-05 | Lighting dan environment polish | P1 | 5 |

Acceptance:
Satu map playable memiliki spawn, interaksi, objektif, checkpoint, dan transisi cerita.

## EPIC G — Testing & Quality Assurance

| ID | Task | Prioritas | SP |
|---|---|---|---|
| G-01 | Solo playtest | P0 | 2 |
| G-02 | Four-client multiplayer test | P0 | 5 |
| G-03 | Mission regression test | P0 | 3 |
| G-04 | Performance profiling | P0 | 3 |
| G-05 | Mobile UI testing | P1 | 3 |
| G-06 | Historical review | P0 | 3 |
| G-07 | Final presentation build | P1 | 3 |

Acceptance:
Campaign MVP dapat diselesaikan pada pengujian 1, 2, dan 4 pemain tanpa blocker kritis.

---

# 14. Definition of Done

Sebuah task hanya boleh ditandai selesai jika:

1. Fitur sudah diimplementasikan.
2. Kode mengikuti struktur proyek.
3. Tidak ada error yang menghalangi fitur.
4. Fitur sudah diuji sesuai kemampuan lingkungan.
5. Tidak merusak fitur sebelumnya.
6. Perubahan didokumentasikan.
7. Hasil dapat diperiksa oleh anggota tim.

Jika pengujian hanya dilakukan melalui inspeksi kode, nyatakan dengan jelas bahwa runtime testing belum dilakukan.

---

# 15. Risiko Proyek

| Risiko | Tingkat | Mitigasi |
|---|---|---|
| Multiplayer desinkron | Tinggi | Server-authoritative state |
| Terlalu banyak fitur | Tinggi | Kunci scope MVP |
| Map belum selesai | Sedang | Greybox dan modular assets |
| NPC membebani performa | Sedang | Batas NPC aktif dan optimasi |
| Akurasi sejarah bermasalah | Tinggi | Master timeline dan sumber |
| Cutscene mengganggu gameplay | Sedang | Testing transisi dan kontrol |
| UI terasa generik | Sedang | Design system dan review visual |
| Integrasi Codex–Roblox gagal | Tinggi | Audit workflow sebelum coding |

---

# 16. Team Deliverables

## Rainer

- Struktur proyek teknis.
- Gameplay controller.
- Sistem co-op.
- Objective system.
- Integrasi seluruh aset.
- Debugging dan QA.
- Build final.

## Fahkri

- Ringkasan sejarah.
- Master timeline.
- Storyline setiap chapter.
- Dialog dan naskah cutscene.
- Klasifikasi fakta dan fiksi.
- Daftar referensi.
- Pemeriksaan akurasi.

## Rama

- Blockout map.
- Modular building kit.
- Lingkungan Yogyakarta 1949.
- Properti.
- Penataan dan optimasi scene.
- Asset inventory.

## Raja

- UI design system.
- Main menu.
- Lobby UI.
- Mission HUD.
- Subtitle design.
- Audio asset list.
- Pengaturan dan aksesibilitas.

---

# 17. Milestone Pertama — Vertical Slice

Nama milestone:

M01 — Four Players, One Mission

Target:
Satu chapter selama 10–15 menit yang dapat dimainkan dari awal sampai akhir.

Fitur wajib:
- Lobby 1–4 pemain.
- Ready system.
- Start mission.
- Pergerakan first-person.
- Interaksi.
- Satu rangkaian NPC arcade.
- Satu objektif bersama.
- Satu checkpoint.
- Mission HUD.
- Opening cutscene.
- Ending cutscene.
- Chapter complete screen.

Urutan demonstrasi:

1. Pemain bergabung.
2. Lobby memperlihatkan status semua pemain.
3. Host atau sistem memulai misi.
4. Opening singkat berjalan.
5. Semua pemain memasuki map.
6. Pemain menyelesaikan objektif bersama.
7. Checkpoint tersimpan.
8. Tantangan terakhir selesai.
9. Ending chapter dimainkan.
10. Layar Mission Complete muncul.

Milestone dinyatakan selesai apabila alur tersebut dapat diulang dalam playtest tanpa bug kritis.

---

# 18. First Codex Assignment

Task pertama untuk Codex:

Inspect the available Roblox Studio project and repository for ENAM JAM: 1949.

Do not assume any existing codebase belongs to this new project.

Do not modify or overwrite the previous 1965: Tujuh Perspektif project.

Review the Game Design Document and prepare an implementation-ready technical plan.

Required output:

1. Workspace audit.
2. Recommended Luau module architecture.
3. Shared multiplayer mission state design.
4. First vertical-slice implementation plan.
5. Proposed folder and file structure.
6. Task dependency analysis.
7. Multiplayer test strategy.
8. Potential technical limitations.
9. Exact next tasks to implement.

Constraints:

- Support 1–4 players.
- Use modular Luau.
- Keep important gameplay state server-authoritative.
- Preserve the distinction between historical facts and fictional gameplay.
- Use non-graphic arcade mechanics.
- Do not implement the entire campaign immediately.
- Ask for approval before destructive changes.
- Do not claim integration or testing success without verification.

After completing the audit, begin with the multiplayer and mission foundation only after the scope is approved.

---

# 19. Final Production Principles

ENAM JAM: 1949 must succeed as both a historical learning experience and a cooperative Roblox game.

Its identity is not defined by the quantity of combat encounters, but by the relationship between teamwork, historical storytelling, atmosphere, and meaningful player objectives.

The final experience should have:

- A clear historical beginning and ending.
- Four-player cooperation.
- Consistent retro visual direction.
- Cinematic storytelling.
- Varied gameplay.
- Stable multiplayer.
- Verifiable historical information.
- A reasonable scope for a four-person student team.

The initial development focus is the vertical slice, not the entire campaign.

END OF GAME DESIGN DOCUMENT — VERSION 1.0