# ENAM JAM: 1949 — Hasil migrasi

Tanggal pengujian: 19 Oktober 2026. Migrasi identitas, lobby dan prototipe prolog sudah diterapkan pada source tersinkron dan place pengembangan. Tidak ada commit, push atau publish.

## Perubahan

| Kelompok | Berkas utama | Hasil |
| --- | --- | --- |
| Identitas/data | shared/Shared/Shared/GameConfig, HistoricalData, Chapters, Narrative | Judul baru, empat peran, enam bagian kampanye, narasi prolog, sumber dan klasifikasi |
| Menu/lobby | MainMenuView, MainMenuController, LobbyController, MenuAnimationController, Bootstrap.local | Mulai membuka lobby, ready, host launch, fokus aman, aksesibilitas, panel baru |
| Latar | MenuEnvironment, MenuCameraController | Jalan kampung kota Yogyakarta menjelang fajar, fasad, jendela kayu, radio, peti, tembok rendah; tema sumur dihapus |
| Server | LobbyService, ChapterService, Bootstrap.server | Kapasitas empat, peran unik, validasi request/revision, satu progres regu, pause personal, checkpoint, host keluar |
| Place/builder | BuildPrologue.luau dan properti native | PrologueOutpost, HistoricalDocument, BriefingBoard, LobbyEvent, GUI template nonaktif saat Edit |
| Pengujian | client specs dan server/Game/Tests | Ekspektasi konten diperbarui, coverage lobby/progres/error ditambah |

Menu mempertahankan enam pilihan dan fungsi pengaturan yang sudah ada. Aset BARA 1946/Constancexz tetap diberi atribusi; asal aset bukan identitas proyek aktif. Peran belum memiliki kemampuan khusus.

Arsip menampilkan ringkasan tiga fakta bersumber, adaptasi fiksi karakter/pos, serta catatan perbedaan waktu penarikan. Rujukan:
- [Ensiklopedia Sejarah Indonesia](https://esi.kemenbud.go.id/wiki/Serangan_Umum_1_Maret_1949)
- [Dinas Kebudayaan DIY](https://budaya.jogjaprov.go.id/berita/detail/876-pelaksanaan-serangan-umum-1-maret-1949)
- [TNI Angkatan Udara](https://tni-au.mil.id/berita/detail/kopral-taruna-aau-napak-tilas-monumen-radio-auri)

## Bukti pengujian

Sesi Play baru memakai source final. Total 889 assertion pada 12 spec:

| Spec | Assertion lulus |
| --- | ---: |
| MenuPresentation | 34 |
| MenuSettings | 70 |
| MenuAnimation | 24 |
| MenuInput | 7 |
| SubmenuPresentation | 391 |
| Lobby client | 119 |
| MenuEnvironment | 98 |
| MenuCamera | 44 |
| SceneValidation | 12 |
| MenuState | 21 |
| Lobby server/shared progress | 36 |
| Foundation/interaksi | 33 |

Pengujian UI memakai ukuran desktop, portrait sempit dan landscape pendek melalui perubahan ukuran container di Studio; ini bukan bukti ponsel fisik atau emulator perangkat lengkap.

Alur input native yang berhasil:
- Chapters → prolog → Tinggalkan mengembalikan menu yang terlihat; broadcast nonmember tidak menutup submenu.
- Mulai → memilih Bima → Siap → Mulai prolog. GUI menu/lobby menghilang dan kamera kembali Custom.
- Enter membuka eksplorasi; WalkSpeed kembali 16.
- E pada dokumen, radio, briefing membuka narasi masing-masing, dengan kategori FACT atau FICTIONAL_ADAPTATION.
- Injeksi cameraFailed ketika cutscene memunculkan error. Kembali menu → lobby → ready → launch tetap bekerja.
- Pengulangan prolog setelah error menyelesaikan tiga interaksi, cutscene dan kartu Prolog selesai. Kamera kembali Custom.

Pergerakan ke dekat objek dipersiapkan lewat fixture posisi server; interaksi E tetap melalui input native dan validasi server. Uji Foundation memakai pemain nyata dan menguji penolakan jarak jauh, tembok, objek asing, ID salah, duplikasi, revision lama, serta karakter mati.

Service lobby diuji dengan empat identitas: kapasitas, peran ganda, payload, host, shared objective, menu personal, resume terbaru, host keluar, completion dan solo. Empat client Roblox nyata belum dijalankan.

31 sumber runtime cocok antara disk dan Studio setelah normalisasi CRLF/LF, diperiksa dengan panjang UTF-8 dan rolling hash. Ini pemeriksaan sinkronisasi, bukan hash keamanan.

Audit nama, source, teks UI, dan atribut seluruh place Edit tidak menemukan istilah identitas lama. Pencarian source aktif/tools/README juga bersih. Judul lokal DataModel dan ProjectTitle adalah ENAM JAM: 1949. GameGui.Enabled=false pada mode Edit.

Tidak ada error runtime aplikasi pada sesi final. Log memuat peringatan CorePackages Roblox dan pemilihan fokus/instrumentasi QA; ini tidak disebut sebagai log tanpa peringatan. Permintaan MenuCamera.spec sebelum memasuki gameplay pada sesi awal ditolak oleh prasyarat; pengujian diulang setelah launch dan lulus.

Review menemukan dan memperbaiki dua masalah: menu transparan setelah keluar lobby dari Chapters dan regu terkunci sesudah error terminal. Kedua jalur diverifikasi kembali di Play.

## Arsip dan batas penyimpanan

Arsip reversibel: D:\ProjectArchives\before-enam-jam-1949-20261019-ee4e5777.
Isi: workspace-before.zip, history.bundle, legacy-docs, legacy-backups, builder lama, dan salinan draft ENAM JAM yang sudah ada sebelum integrasi. Dokumen laporan versi lama dipindahkan, tidak ditulis ulang seolah-olah hasil QA baru. Riwayat Git tetap utuh.

Checkpoint place baru sudah disimpan pengguna dan diverifikasi di D:\1946-7-perspektif\backups\enam-jam-1949-lobby.rbxl. Berkas memiliki header Roblox, ukuran 156044 byte dan SHA-256 948043802231FFF84B4F55080372C12DC5ECEFEEDC355E43E020C6389553AE36. Nama tersimpan semula memiliki dua titik sebelum ekstensi dan telah dirapikan. Pemeriksaan ini memverifikasi keberadaan serta format berkas; pemulihan dengan membuka ulang salinan belum diuji. Source tetap tersimpan lewat Script Sync.

Path workspace tetap untuk menjaga koneksi Script Sync. Nama repository remote dan judul experience cloud masih memakai metadata sebelumnya; belum diganti atau dipublikasikan. src/enamjam adalah draft yang sudah ada dan tetap dipertahankan, tidak dieksekusi runtime.

Belum selesai: kampanye penuh/M01 10–15 menit, NPC dan arcade PvE, kemampuan unik peran, first-person final, audio, DataStore, matchmaking, riset final seluruh timeline, empat client nyata, touch/gamepad fisik, dan pengukuran performa perangkat.

## Git opsional — jalankan sendiri setelah meninjau perubahan

Branch terverifikasi: feat/enam-jam-1949. Origin terverifikasi ada. Perintah berikut hanya men-stage berkas lingkup migrasi; src/enamjam yang sudah ada tidak ikut.

```powershell
git add -- README.md docs src/client/GameClient src/server/Game src/shared/Shared/Shared tools/BuildVS01.luau tools/BuildPrologue.luau
git commit -m "feat: migrate menu and lobby to Enam Jam 1949"
git push -u origin feat/enam-jam-1949
```
