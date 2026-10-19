# ENAM JAM: 1949 — Lingkup migrasi

Arahan terbaru pengguna mengizinkan migrasi workspace aktif dan mengganti lobby. Bagian penugasan awal GDD yang hanya meminta audit tidak dipakai untuk membatasi instruksi terbaru tersebut.

Urutan pelaksanaan:
1. Audit source, place, Script Sync dan draft baru; arsipkan workspace, place dan riwayat sebelum mengganti konten.
2. Ganti identitas, konfigurasi, daftar chapter, narasi, objek prolog dan kategori sumber sejarah.
3. Ganti latar menu menjadi jalan kampung kota Yogyakarta menjelang fajar. Pertahankan kamera, aksesibilitas, aset berizin, dan pemulihan Terrain.
4. Implementasikan lobby server-authoritative 1–4 pemain, peran unik, ready, host dan launch. Hubungkan menu dan progres bersama.
5. Uji modul, UI beberapa ukuran, input, launch, checkpoint, replay dan pemulihan error. Review sebelum menyatakan selesai.

Batas: ini migrasi identitas dan fondasi lobby/prolog. Bukan penyelesaian M01 10–15 menit. Tidak menambah sistem persenjataan, NPC, chapter penuh, DataStore, matchmaking atau kemampuan unik peran.

Kontrak: NarrativeEvent mengirim snapshot chapter personal dengan revision. LobbyEvent mengirim snapshot regu dan menerima role/ready/launch/leave. Perubahan objektif disebarkan ke anggota misi; menu tetap personal. Pemain yang kembali mengikuti progres regu terbaru. Server menolak request lama, peran ganda, anggota berlebih, launch nonhost, serta interaksi tidak sah.

Pengujian multipemain: unit service memakai empat identitas untuk kasus host keluar, input bersamaan, pause/resume, shared progress, dan solo. Sesi native satu client memverifikasi wiring UI/server. Empat client nyata, latensi jaringan, perangkat fisik dan performa harus diuji pada tahap berikutnya.
