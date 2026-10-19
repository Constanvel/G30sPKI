# Penggantian font menu

19 Oktober 2026. Baseline: `1784adfd3bc6da1cedbcbbf4038fe82d8e005fc1`.

Tipografi diarahkan ke cetakan arsip yang lebih tegas. Judul memakai serif berbobot; navigasi memakai huruf condensed yang lebih besar. Komposisi, warna, animasi dan lingkungan tetap dipertahankan.

## Berkas dan font

| Berkas | Perubahan |
| --- | --- |
| `src/client/GameClient/MenuStyle.luau` | Merriweather Bold untuk judul; Roboto Condensed Regular untuk isi dan Bold untuk kontrol |
| `src/client/GameClient/MainMenuView.luau` | Memakai FontFace untuk bobot yang tepat; menyesuaikan ukuran teks |
| `docs/TYPOGRAPHY_RESULT.md` | Hasil pengujian dan perintah Git |

Judul `1965`, judul panel, nomor chapter dan pesan utama arsip memakai Merriweather Bold. Subtitle dan tombol memakai Roboto Condensed Bold. Isi panel memakai Roboto Condensed Regular. Roboto Mono pada nomor navigasi/persentase tetap dipertahankan.

Ukuran navigasi berubah dari 15 menjadi 18 pada desktop, serta 13 menjadi 16 pada mode compact. Subtitle menjadi 22/16. Label lokasi dan versi naik satu ukuran. Judul panel menjadi 27/23 agar bobot serif yang lebih besar tetap muat tanpa mengubah posisi maupun ukuran panel.

Keluarga dan bobot font diverifikasi melalui TextService di Studio, kemudian FontFace hasil render diperiksa. Keduanya tersedia dari font bawaan Roblox; tidak ada plugin, font eksternal atau dependensi baru yang dipasang. Implementasi menggunakan [Font.fromName dan FontFace](https://create.roblox.com/docs/reference/engine/datatypes/Font).

## Validasi

- 100 assertion lulus: MenuPresentation 32, MenuSettings 39, MenuAnimation 24, MenuInput 5.
- Semua panel dibuka melalui input langsung: Settings, Chapters, Archive dan Credits; Kembali juga diuji.
- Screenshot desktop menu/Settings dan simulator Samsung/iPhone diperiksa.
- Samsung Galaxy A06 landscape: viewport 705×338; tidak ada teks menu terpotong.
- iPhone 17 Pro landscape: viewport 750×381; teks menu dan judul/pengaturan yang diperiksa muat.
- Fixture 360×560, 800×520 dan 1000×600: menu utama serta empat panel, total 15 kombinasi, tanpa TextFits gagal. Fixture portrait hanya menguji wrapping; orientasi game tetap landscape.
- Log client tidak mencatat MessageError selama sesi ini.
- Dua source lokal cocok dengan Source Studio setelah normalisasi BOM/CRLF/whitespace akhir. `git diff --check` lulus.

Studio dikembalikan ke Edit dan simulator dimatikan. Tekan Play untuk melihat menu baru. Source gameplay, kamera, animasi dan lingkungan tidak diubah pada pass ini.

Belum diuji pada ponsel fisik. Performa game dan seluruh alur chapter tidak diuji ulang untuk perubahan tipografi ini. Belum commit, push, atau Publish to Roblox.

## Git

Status, branch dan remote telah diperiksa. Jalankan dari `D:\1946-7-perspektif` setelah meninjau perubahan:

```powershell
git add -- src/client/GameClient/MenuStyle.luau src/client/GameClient/MainMenuView.luau docs/TYPOGRAPHY_RESULT.md
git commit -m "style: refine archival menu typography"
git push origin feat/cinematic-main-menu
```
