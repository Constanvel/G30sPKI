# VS01 — Hasil Implementasi Teknis

Tanggal: 18 Oktober 2026, Asia/Jakarta.
Target: experience 1965: Tujuh Perspektif, Place ID 97995024632294.
Status: prototype teknis dapat dimainkan. Naskah sejarah, avatar/aset final, dan kelayakan rilis belum disahkan.

## Yang tersedia

- Cadangan awal RBXL dan metadata hash; file lama `1946.rbxl` tidak diubah.
- Script Sync tiga folder, dibuktikan disk → Studio dan Studio → disk menggunakan token berbeda; probe sementara sudah dibersihkan.
- Satu greybox rumah modular, dua meja, kartu pengenalan, radio placeholder, papan konteks, spawn dan dua marker kamera.
- Avatar Roblox default tanpa penampilan akun sebagai placeholder; movement dan kamera bawaan dipakai kembali.
- Tiga objektif berurutan, input E/native ProximityPrompt, narasi berlabel dramatisasi, title card, HUD dan tombol lanjut/ulang.
- Cutscene kamera enam detik, fade, penutup, restart demo dan reset chapter saat karakter respawn.
- Progres resmi pada server; validasi jarak, karakter hidup, ID, scene aktif, fase, revision, duplikasi, rate permintaan dan raycast penghalang.
- Pemeriksaan scene wajib: marker spawn/kamera harus BasePart, setiap objektif memiliki tepat satu prompt. Aset hilang menghasilkan pesan dan jalur Coba lagi; tidak menghasilkan sukses palsu.
- UI landscape dengan safe insets, area baca yang dapat digulir dan tombol 150×44. Joystick disembunyikan saat panel narasi terbuka.

## Struktur source aktual

| Lokasi disk | Instance Studio |
| --- | --- |
| src/shared/Shared/Shared | ReplicatedStorage.Shared |
| src/server/Game | ServerScriptService.Game |
| src/client/GameClient | StarterPlayer.StarterPlayerScripts.GameClient |

Lapisan folder Shared tambahan berasal dari konfigurasi Script Sync. Mapping ini sudah dibuktikan bekerja; jangan memindah root di disk saat sync aktif. Sepuluh berkas source final cocok antara disk dan Studio pada pemeriksaan 18 Oktober 2026 pukul 17:53 WIB; rincian di `docs/qa/vs01-source-sync.json`.

Model dan GUI tidak tercakup Script Sync. Cadangan hasil ekspor Studio diperlukan untuk keduanya. `tools/BuildVS01.luau` juga menyimpan resep pembentukan greybox/UI. Builder hanya untuk baseline yang belum memiliki ActiveScene/GameGui dan sengaja menolak overwrite.

## Bukti pengujian

| Pemeriksaan | Hasil |
| --- | --- |
| Foundation.spec pada pemain nyata di Studio Server | 33 assertion lulus |
| SceneValidation.spec | 12 assertion lulus |
| Dua penyelesaian PC berturut-turut pada kode final | Lulus: tiga interaksi E → narasi → cutscene → penutup → ulang |
| Kamera setelah cutscene | Kembali Custom |
| Reset karakter saat narasi | Title dan checkpoint chapter pulih |
| Reset saat cutscene | Title, kamera dan fade pulih; callback revision lama diabaikan |
| Objek wajib dihilangkan saat Play | Error terlihat; setelah objek dipulihkan, tombol Coba lagi membuka title |
| Seluruh scene dihilangkan saat Play | Error terlihat dan retry bekerja setelah scene dipulihkan |
| Marker CameraStart hilang saat cutscene | Tetap error setelah timer penutup; kamera pulih; tidak ada kartu sukses |
| Startup tanpa ActiveScene, remote tetap ada | Pesan kegagalan tampil, bukan loading menetap; scene editor dikembalikan sesudah uji |
| Emulator Samsung Galaxy A06 landscape | Alur mencapai penutup; title/body/error/penutup diperiksa visual; tombol 150×44, TextFits true |
| Input dalam emulator | Tombol narasi/ulang/retry diklik melalui virtual pointer; interaksi objek menggunakan E; navigasi melalui tool karakter |
| Input W | Karakter berpindah lebih dari satu stud; pemeriksaan dilakukan sebelum assertion joystick |
| Startup tanpa PlayerModule lama | Lulus setelah menghapus penantian 10 detik yang tidak diperlukan |
| Log sesi PC final | Tidak ada MessageError pada client maupun server |

Viewport yang tercatat: PC sekitar 1530×698; emulator ponsel 705×338 logical viewport, preset Galaxy A06 800×360. Galaxy A07 fisik belum digunakan. Studio dikembalikan ke mode Edit dan viewport default sesudah pengujian.

Pengujian dapat dijalankan ulang di Play mode pada Server lewat MCP/Command Bar yang sesuai:

```lua
local player = game.Players:GetPlayers()[1]
print(require(game.ServerScriptService.Game.Tests["Foundation.spec"])(player))
print(require(game.ServerScriptService.Game.Tests["SceneValidation.spec"])())
```

Foundation.spec menguji kondisi karakter mati di akhir; jalankan hanya dalam sesi Studio pengujian. Hentikan Play atau reset karakter setelahnya. Jangan menjalankan pengujian pada server produksi.

## Review dan koreksi

Satu reviewer terpisah membaca source dan menemukan tiga P2: loading tanpa scene, objektif hilang yang buntu, serta keberhasilan palsu jika marker kamera hilang. Ketiganya diperbaiki dalam satu tahap koreksi, diberi pengujian kelengkapan scene, dan diuji melalui alur runtime. Review tidak diulang; hasil koreksi dibuktikan dengan 45 assertion dan QA di atas.

Masalah lain yang ditemukan selama QA: joystick menimpa panel narasi dan penantian PlayerModule lama memperlambat startup. Keduanya diperbaiki dan diperiksa kembali. Beberapa assertion QA awal gagal karena pengecekan dilakukan sebelum pesan lintas client/server diterapkan, atau setelah title sudah beralih otomatis. Uji pemulihan diulang dengan memberi waktu penerapan pesan dan hasil akhir dicatat di tabel.

Satu assertion tambahan bahwa joystick harus tetap aktif sesudah input keyboard W gagal. Movement W sendiri berhasil. Uji tersebut mencampur input keyboard dan mode sentuh emulator; penyebab perubahan joystick belum dibuktikan. Jangan menganggapnya sebagai bukti input sentuh perangkat fisik lulus. Tap native ProximityPrompt dan gerakan joystick sentuh masih membutuhkan pengujian langsung.

Pada sesi awal terdapat warning FoundationProvider/UIBlox dari CorePackages Roblox. Pada sesi final tidak ada error runtime client/server. Lint/type-check Luau terpisah belum dijalankan; runtime sukses bukan klaim type-check bersih.

## Keputusan dan batas

- Source mengikuti root folder aktual Script Sync agar user tidak perlu mengulang mapping yang sudah bekerja. Biaya perubahan mapping kelak: rebind folder dan ulangi uji dua arah.
- PlayerModule diperlakukan opsional karena tidak ada pada PlayerScripts versi Studio ini. Penguncian gerak tetap dilakukan server. UI sentuh dan kamera ditangani controller lokal.
- Tidak ada Git repository, branch atau remote; worktree Git tidak berlaku. Tidak ada commit, push, atau publikasi.
- Review sengaja tidak menilai sejarah final, campaign, audio, save permanen, avatar final, multiplayer/streaming, durasi belajar dan performa fisik. Semuanya tetap pekerjaan fase berikutnya, bukan diam-diam dinyatakan selesai.
- Semua teks narasi adalah technical-placeholder/DRAMATIZATION, bukan kutipan atau fakta sejarah yang sudah disetujui. Tidak ada jam sejarah buatan atau adegan kekerasan.
- Durasi 3–5 menit tetap target; belum ada pengukuran pemain dengan naskah final. Demo teknis dapat diselesaikan lebih cepat jika teks dilewati.
- Batas satu pemain pada konfigurasi cloud belum diubah; pengujian memakai satu pemain. Co-op dan pergantian POV kedua belum dikerjakan.
- Tidak ada musik/voice-over karena aset berizin belum tersedia; tidak ditambahkan asset ID rekaan.
- Checkpoint saat ini hanya selama sesi. Continue lintas sesi dan DataStore belum dibuat.

## Checkpoint final

User mengonfirmasi ekspor final dari Studio. Berkas ditemukan di `D:\1965-tujuh-perspektif-vs01-final.rbxl`, lalu disalin tanpa overwrite ke `backups/1965-tujuh-perspektif-vs01-final.rbxl`. Salinan di D:\ tetap tersedia.

- Ukuran: 119.784 byte; header biner RBXL valid.
- SHA256: `6FD2ABD3941A06985EC99431846100D51D67A0EF66DF4DC9E9A2923CDB40BC5A`.
- Metadata: `backups/vs01-final-metadata.json`.
- Hash file awal `1946.rbxl` dan cadangan sebelum VS01 tetap sama.
- Checkpoint belum dibuka ulang untuk uji pemulihan. Pemeriksaan source membandingkan disk dengan Studio aktif, bukan mengekstrak source dari RBXL.

## Menjalankan demo

1. Buka experience yang teridentifikasi di Roblox Studio dan tekan Play.
2. Pilih Mulai, ikuti objektif kartu → radio → papan konteks.
3. Gunakan WASD dan E di PC; panel mendukung tombol klik/sentuh. Enter/Spasi juga melanjutkan panel.
4. Setelah cutscene, pilih Ulangi demo. Reset karakter memulai chapter dari awal.

Langkah berikutnya: uji sentuh pada ponsel fisik, minta Fahkri memeriksa profil/naskah sumber, lalu iterasi satu lokasi ini dengan Rama dan Raja. Jangan memperluas tujuh POV sebelum checkpoint teknis dan penanganan batas konten Roblox diterima.
