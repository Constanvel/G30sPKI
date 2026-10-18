# 1965: Tujuh Perspektif

Prototipe game edukasi sejarah di Roblox Studio. Versi VS01 menyediakan satu ruangan greybox, tiga interaksi berurutan, panel narasi, cutscene kamera, dan ulang demo.

Menu utama sinematik menambahkan jalan perumahan malam low-poly, kamera bergerak halus, enam navigasi, checkpoint sesi, pengaturan volume/reduced motion, dan kredit. Arsip serta chapter yang belum tersedia ditandai secara jelas. Rincian implementasi dan batas pengujian ada di [laporan menu](docs/MAIN_MENU_RESULT.md).

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

## Git dan Studio

Remote proyek: [Constanvel/G30sPKI](https://github.com/Constanvel/G30sPKI).

Script Sync menghubungkan source lokal dengan Studio. Git menyimpan versi source setelah commit; perubahan baru dikirim ke GitHub saat push. Menyimpan atau menjalankan game di Studio tidak otomatis membuat commit maupun memublikasikan game.
