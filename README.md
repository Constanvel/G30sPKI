# ENAM JAM: 1949

Game edukasi sejarah Roblox tentang Serangan Umum 1 Maret 1949 di Yogyakarta. Arah proyek mengikuti [GDD](docs/ENAM_JAM_GDD.md).

Implementasi saat ini: menu sinematik berlatar kampung kota menjelang fajar, lobby 1–4 pemain dengan pilihan Arga/Bima/Surya/Damar, status siap, host, serta prototipe prolog tiga interaksi dengan satu progres regu. Chapter lanjutan ditandai belum tersedia. Kemampuan khusus peran, NPC, pertempuran arcade, dan target durasi MVP belum selesai.

## Menjalankan

Gunakan place pengembangan yang sedang tersambung Script Sync. Play → Mulai → pilih peran → Siap → host memilih Mulai prolog. Pemain solo juga dapat mulai. Semua anggota regu dapat mengerjakan interaksi umum. Enter/Spasi melanjutkan narasi; E atau prompt sentuh memeriksa objek. MENU membuka menu personal; LANJUTKAN mengikuti progres regu terbaru.

State penting divalidasi server: kapasitas, peran unik, revision, status siap, host, urutan objektif, jarak, dan garis pandang. Checkpoint hanya hidup selama server berjalan. Satu server mendukung satu regu aktif; tidak ada matchmaking atau penyimpanan lintas server.

## Struktur aktif

| Lokasi | Tujuan |
| --- | --- |
| src/shared/Shared/Shared | ReplicatedStorage.Shared: konfigurasi, prolog, narasi, kategori sejarah |
| src/server/Game | Lobby, progres bersama, interaksi dan validasi server |
| src/client/GameClient | Menu, lobby, lingkungan, kamera dan UI narasi |
| tools/BuildPrologue.luau | Builder untuk place kosong; menolak menimpa scene/GUI |
| docs | GDD, lingkup implementasi dan hasil QA |

Jangan pindahkan direktori sumber saat Script Sync masih aktif. src/enamjam adalah draft terpisah yang sudah ada sebelum integrasi ini; runtime memakai tiga lokasi aktif pada tabel. Draft tersebut belum disatukan dan tidak membuktikan fitur sudah tersedia.

## Fakta dan adaptasi

Arga, Bima, Surya, Damar, pos pertemuan, dan urutan objektif merupakan FICTIONAL_ADAPTATION. Fakta pada arsip ditautkan ke Ensiklopedia Sejarah Indonesia, Dinas Kebudayaan DIY, dan TNI AU melalui HistoricalData. TESTIMONY dan DISPUTED dipisahkan; tidak ada kutipan rekaan tokoh sejarah. Perbedaan waktu penarikan pasukan tetap dicatat dan membutuhkan riset perbandingan.

Latar merupakan interpretasi artistik, bukan replika denah Yogyakarta. Mesh dan tekstur memakai aset BARA 1946 milik Constancexz; atribusi dipertahankan. Belum ada audio berlisensi yang dipasang. Cache aset dingin memerlukan jaringan Roblox.

## Penyimpanan

Script Sync menyimpan sumber, bukan map, GUI template, pengaturan place, atau metadata experience. Simpan salinan place baru setelah migrasi. GitHub dan judul experience publik tidak berubah otomatis. Tidak ada commit, push, atau publish pada pekerjaan ini.

Berkas versi sebelumnya dipindahkan ke arsip eksternal yang tercatat pada [laporan migrasi](docs/MIGRATION_RESULT.md). Riwayat Git tetap dapat dipulihkan. Lihat laporan tersebut untuk hasil uji dan batas yang belum diverifikasi.
