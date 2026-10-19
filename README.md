# 1965: Tujuh Perspektif

Prototipe game edukasi sejarah di Roblox Studio. Versi VS01 menyediakan satu ruangan greybox, tiga interaksi berurutan, panel narasi, cutscene kamera, dan ulang demo.

Menu utama sinematik menampilkan latar artistik Lubang Buaya dengan mesh bertekstur dari proyek BARA 1946, Terrain lokal, kamera bergerak halus, enam navigasi, checkpoint sesi, pengaturan volume/reduced motion, dan kredit. Arsip serta chapter yang belum tersedia ditandai secara jelas. Perubahan terbaru dan batas pengujian ada di [laporan latar 3D](docs/REALISTIC_MENU_RESULT.md).

UI menu kini memakai desain editorial arsip, panel sesuai panjang isi, slider volume dan toggle aksesibilitas. Rincian desain serta QA tersedia pada [laporan UI](docs/EDITORIAL_UI_RESULT.md); pass ini tidak mengubah latar, lighting, kamera atau gameplay.

Polish animasi menambahkan intro bertahap, indikator navigasi bergerak, transisi panel yang dapat dialihkan, kamera bersiklus 28 detik dan variasi lembut pada dua lentera. Hasil pengujian serta batas performanya ada di [laporan animasi](docs/MENU_MOTION_RESULT.md).

Naskah dan aset masih placeholder teknis. Akurasi sejarah, input ponsel fisik, performa, dan kelayakan publikasi belum disahkan. Hasil pengujian tercatat di [laporan VS01](docs/VS01_RESULT.md).

## Struktur

| Folder | Tujuan |
| --- | --- |
| `src/shared/Shared/Shared` | `ReplicatedStorage.Shared` |
| `src/server/Game` | `ServerScriptService.Game` |
| `src/client/GameClient` | `StarterPlayer.StarterPlayerScripts.GameClient` |
| `tools/BuildVS01.luau` | Resep pembentukan greybox dan UI |
| `docs` | Desain, rencana, dan bukti pengujian |

Mapping mengikuti root Script Sync yang sudah terhubung pada workspace pengembangan. Jangan memindahkan folder source saat sync aktif.

## Menjalankan

Pada workspace pengembangan yang Script Sync-nya aktif, buka checkpoint lokal `backups/1965-tujuh-perspektif-vs01-final.rbxl` di Roblox Studio. Checkpoint tersebut merupakan baseline sebelum menu; source menu terbaru berasal dari folder `src` yang sudah tersinkron. Tekan Play, pilih MULAI pada menu, lalu Mulai pada intro chapter. Gunakan WASD dan E; Enter/Spasi melanjutkan panel narasi. Tombol MENU mengembalikan pemain ke menu utama dan menyediakan LANJUTKAN jika checkpoint sesi tersedia.

Berkas RBXL dan folder backups diabaikan Git. Clone repositori berisi source dan dokumentasi; map, GUI, serta konfigurasi Script Sync lokal tidak otomatis dipulihkan oleh Git. Builder menyimpan resep greybox/UI, tetapi bukan pengganti penuh checkpoint place dan menolak overwrite scene yang sudah ada.

UI dan lingkungan menu dibuat lokal dari source saat Play, sehingga tidak memerlukan model menu tersimpan di place. Tidak ada DataStore atau audio berizin yang dipasang; volume mengatur SoundGroup menu untuk integrasi audio berikutnya.

Mesh dan tekstur diunduh dari URI dalam `MenuAssetData.luau`; cache dingin memerlukan koneksi ke Roblox. Tidak perlu mengimpor model/script dari Creator Store. Saat memulihkan checkpoint lama, jalankan isi `tools/ConfigureMenuRenderer.luau` sekali melalui Command Bar mode Edit lalu simpan place untuk memakai renderer Realistic. Pengaturan Studio ini tidak dicakup Script Sync. Terrain menu dibuat hanya pada client, jauh di atas greybox; region tersebut dipulihkan ketika scene dibersihkan.

## Git dan Studio

Remote proyek: [Constanvel/G30sPKI](https://github.com/Constanvel/G30sPKI).

Script Sync menghubungkan source lokal dengan Studio. Git menyimpan versi source setelah commit; perubahan baru dikirim ke GitHub saat push. Menyimpan atau menjalankan game di Studio tidak otomatis membuat commit maupun memublikasikan game.
