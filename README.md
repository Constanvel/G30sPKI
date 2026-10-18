# 1965: Tujuh Perspektif

Prototipe game edukasi sejarah di Roblox Studio. Versi VS01 menyediakan satu ruangan greybox, tiga interaksi berurutan, panel narasi, cutscene kamera, dan ulang demo.

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

Pada workspace pengembangan, buka checkpoint lokal `backups/1965-tujuh-perspektif-vs01-final.rbxl` di Roblox Studio. Tekan Play, pilih Mulai, lalu gunakan WASD dan E. Enter/Spasi melanjutkan panel narasi.

Berkas RBXL dan folder backups diabaikan Git. Clone repositori berisi source dan dokumentasi; map, GUI, serta konfigurasi Script Sync lokal tidak otomatis dipulihkan oleh Git. Builder menyimpan resep greybox/UI, tetapi bukan pengganti penuh checkpoint place dan menolak overwrite scene yang sudah ada.

## Git dan Studio

Remote proyek: [Constanvel/G30sPKI](https://github.com/Constanvel/G30sPKI).

Script Sync menghubungkan source lokal dengan Studio. Git menyimpan versi source setelah commit; perubahan baru dikirim ke GitHub saat push. Menyimpan atau menjalankan game di Studio tidak otomatis membuat commit maupun memublikasikan game.
