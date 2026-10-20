# Environment menu Yogyakarta 1949

Tujuan: membangun latar jalan kota tua saat matahari terbit dengan empat pejuang membelakangi kamera, sesuai arahan visual pengguna. UI dan flow lobby tetap.

## Keputusan implementasi

- MenuEnvironment.create() tetap menjadi satu entry point dan mengembalikan model dekoratif di origin terisolasi (1000,128,0).
- Ganti kampung lama dengan fasad toko modular, arcade kolonial, atap genteng, jalan bertekstur, curb/drain, tugu bergaya Pal Putih, kabel listrik, sepeda, gerobak, pohon BARA yang sudah dimiliki, dan bendera merah putih. Detail bangunan belakang lebih sederhana.
- Empat figur memakai part yang di-anchor, pakaian dan tas yang berbeda, tanpa Humanoid, script, tool, atau collision gameplay. Jalan di tempat sangat lembut melalui metadata motion.
- CameraAnchor utama menghadap jalan; komposisi memberi ruang di kiri bagi UI yang sudah ada. Lighting pagi hanya diterapkan selama kamera menu aktif dan dikembalikan ketika Mulai.
- Satu callback animasi yang sudah ada menangani drift, beberapa limb, dan bendera. Reduced motion membekukan semuanya. Tidak ada voxel Terrain yang ditulis.

## Berkas

1. MenuEnvironment.luau: builder scene dan helper modular lokal.
2. MenuEnvironment.spec.luau: kontrak scene, landmark, empat figur, isolasi, anggaran part/mesh/effect, tidak menulis terrain.
3. MenuCameraController.luau: golden hour, motion terbatas, pemulihan effect dan pose.
4. MenuCamera.spec.luau: drift, reduced motion, repeat start, lighting/effect/pose restoration.
5. docs/YOGYAKARTA_MENU_ENVIRONMENT.md dan bukti QA: hierarchy, kamera, parameter, batas validasi, perintah Git terarah.

## Urutan dan verifikasi

1. Cadangkan empat source lama. Periksa referensi dan state Studio.
2. Ubah kontrak test untuk persyaratan baru, lalu builder dan camera profile.
3. Pasang source ke Studio; uji create/destroy serta kamera. Lihat tangkapan Play dengan UI asli; sesuaikan framing dan skala berdasarkan hasil nyata.
4. Uji beberapa rasio area pandang, masuk lobby, reduced motion, kembalinya lighting, dan lifecycle berulang. Periksa console dan source parity. Kembali ke Edit.

## Review focus

- Judul tetap terbaca dan figur/tugu tidak tertutup UI pada kamera utama.
- Scene decorative tidak merusak terrain/map lobby atau input.
- Bendera dan gait tidak terakumulasi; reduced motion dan stop mengembalikan pose/lighting.
- Tidak ada asset baru dari marketplace, dependency, commit, push, atau Publish. Asset pohon memakai manifest BARA yang sudah ada. Toko/figur/landmark adalah geometri orisinal dan rekonstruksi artistik.
