# Editorial UI — rencana implementasi

Scope: MainMenuView, MenuAnimationController, MainMenuController bagian input/presentasi pengaturan, style UI dan spec terkait. Source environment, camera, lighting, server, audio playback, save/progression dan dialog tidak diubah. Checkout dipertahankan pada root Script Sync yang aktif.

1. Simpan fingerprint source yang dilindungi dan baca hierarchy runtime. Terapkan token charcoal/cream/copper, serif Bodoni untuk judul dan Gotham untuk kontrol.
2. Tata ulang brand/navigasi bernomor; panel mengikuti tinggi isi dan maksimal 620 px. Halaman chapter, arsip, kredit mempertahankan teks/data yang ada. Settings berisi tiga slider dan satu toggle; scroll hanya ketika viewport pendek.
3. Hubungkan drag mouse/touch, fokus, tombol panah/D-pad dan cleanup input. Gunakan setter volume yang sama ke SoundGroup sesi; tidak menambah persistence/audio.
4. Perbarui regression spec untuk slider/toggle/focus/layout dan arbitration tween. Uji native Play: seluruh panel/back, drag, keyboard, rapid input, reduced motion, handoff serta mobile landscape. Pastikan protected source tidak berubah.
5. Review perubahan UI, catat hasil/limit nyata, cek diff dan status Git. Tidak commit/push otomatis.
