# 📝 Ringkasan Update & Optimasi Proyek (FlashLingo)

Dokumen ini merangkum secara spesifik seluruh pembaruan, perbaikan, dan optimasi yang telah dilakukan pada kode proyek **FlashLingo** (`AppPrototype_FlashLingo`).

---

## 📌 Rangkuman Pembaruan per File

### 1. Konfigurasi Aplikasi & Native
* **`lib/main.dart`**
  * Menambahkan penguncian orientasi layar hanya pada mode tegak (*Portrait Up & Down*) via `SystemChrome.setPreferredOrientations` agar tampilan UI anak-anak tetap konsisten dan tidak rusak saat perangkat dimiringkan.
* **`android/app/src/main/AndroidManifest.xml`**
  * Mengubah label aplikasi dari `learn` menjadi `FlashLingo`.
  * Menambahkan izin `android.permission.INTERNET`.
* **`ios/Runner/Info.plist`**
  * Mengubah nama tampilan aplikasi (`CFBundleDisplayName`) menjadi `FlashLingo`.
  * Menghapus orientasi Landscape dari daftar `UISupportedInterfaceOrientations`.
* **`pubspec.yaml`**
  * Menyesuaikan batasan Dart SDK dari `^3.13.2` menjadi `^3.12.0` agar kompatibel dengan berbagai versi Flutter SDK di mesin pengembang.

---

### 2. Layer Data: `lib/data/progress_manager.dart`
* **Kondisi Awal:** 
  Tiap kali mengecek skor kategori (`getLevelScore`), status kelulusan (`hasPassedLevel`), atau daftar level selesai, aplikasi selalu membaca ulang string disk dari `SharedPreferences` dan memanggil `jsonDecode()`. Hal ini menyebabkan lag I/O saat merender banyak kartu kategori di halaman utama.
* **Pembaruan yang Dilakukan:**
  * Menambahkan in-memory cache `_cachedCompletedLevels` dan `_cachedLevelScores`.
  * Memindahkan parsing JSON ke konstruktor sehingga hanya dijalankan **satu kali** saat aplikasi pertama kali dibuka.
  * Mengembalikan data memori menggunakan `List.unmodifiable` dan `Map.unmodifiable`.
  * Menyimpan ke disk hanya jika skor baru lebih tinggi dari skor yang ada (`score > currentScore`).

---

### 3. Komponen Dasar: `lib/ui/widgets/`
* **`app_background.dart`**
  * **Sebelum:** Membungkus gambar background dengan widget `Opacity(opacity: 0.55, child: ...)` yang memicu proses render offscreen (*saveLayer*) di GPU.
  * **Sesudah:** Menghapus widget `Opacity` dan menggantinya dengan properti native `color: Color.fromRGBO(255, 255, 255, 0.55)` serta `colorBlendMode: BlendMode.modulate` langsung pada `Image.asset`. Rendering background kini dilakukan dalam satu tarikan kuas (single draw call).
* **`buttons.dart`**
  * **TactileScale:** Memperhalus animasi kembali tombol menggunakan kurva `Curves.elasticOut` (220ms) dan menambahkan haptic feedback halus (`HapticFeedback.lightImpact()`).
  * **ShakeWidget (Komponen Baru):** Membuat widget animasi goncangan berbasis osilasi sinus `sin(val * pi * 4)` lengkap dengan getaran `HapticFeedback.mediumImpact()` untuk memberi umpan balik saat anak melakukan kesalahan atau memilih level yang terkunci.

---

### 4. Halaman Menu Utama: `lib/ui/home_screen.dart`
* **Floating Logo:** Logo FlashLingo kini memiliki animasi melayang halus vertikal secara terus-menerus (`AnimatedBuilder` + `_floatAnimation`).
* **Staggered Scale Animation:** Kartu-kartu kategori tidak lagi muncul sekaligus, melainkan masuk bertahap dengan efek membal (`TweenAnimationBuilder` + `Curves.easeOutBack`).
* **Umpan Balik Kartu Terkunci:** Mengetuk level yang terkunci kini memicu animasi goyang (`ShakeWidget`) dan getaran haptic, menggantikan perilaku lama yang tidak merespon sama sekali.
* **Badge Persentase Bintang:** Menambahkan pill persentase penyelesaian (contoh: `24 / 27 (89%)`) di samping ikon bintang skor total.

---

### 5. Halaman Flashcard: `lib/ui/flashcard_screen.dart`
* **Dukungan Gesture Swipe:** Kartu flashcard kini dapat digeser langsung menggunakan jari (swipe kiri untuk *Next*, swipe kanan untuk *Prev*) menggunakan `onHorizontalDragEnd`.
* **Animasi Transisi Geser Kartu:** Menambahkan `AnimationController` untuk pergeseran horizontal saat berpindah kartu agar terasa seperti membalik kartu fisik.
* **Transisi Teks Kosakata:** Teks bahasa Inggris dan Indonesia kini bertransisi secara halus menggunakan `AnimatedSwitcher` (gabungan `ScaleTransition` dan `FadeTransition`).
* **Micro-Interactions & Haptics:** Ditambahkan getaran `HapticFeedback.selectionClick()` saat kartu berganti, dan indikator label visual *"Tap to flip" / "Tap to flip back"*.
* **Downsampling Memori Gambar:** Menambahkan `cacheWidth: 800` pada `Image.asset` agar gambar beresolusi tinggi tidak menghabiskan RAM perangkat saat di-decode.

---

### 6. Layar Kuis & Minigames: `lib/ui/quiz_screen.dart`
* **Optimasi GPU & Memori:**
  * Menurunkan intensitas efek blur pada modal hasil dari `sigma: 12` ke `sigma: 8` untuk meringankan beban GPU perangkat.
  * Menambahkan `cacheWidth: 500` pada gambar pilihan jawaban kuis.
* **Animasi Modal Hasil & Bintang:**
  * Dialog skor akhir muncul dengan animasi membal (`Curves.elasticOut`).
  * Ketiga bintang hasil kuis muncul bertahap (*staggered entrance*) satu per satu.
* **Peningkatan Minigame Drag & Drop:**
  * Kartu yang di-drag membesar menjadi scale 1.1x sebagai indikator sentuhan.
  * Kotak target yang berhasil dicocokkan menampilkan border hijau menyala (*glow*) dan animasi membal.
* **Peningkatan Minigame Scramble (Susun Huruf):**
  * Menyaring spasi, garis bawah, dan tanda hubung pada kata target dengan regex `.replaceAll(RegExp(r'[\s\-_]'), '')`.
  * Menghubungkan setiap tombol huruf ke `ShakeWidget`. Jika huruf yang dipilih salah, huruf tersebut akan bergetar dan menghasilkan haptic feedback.
* **Peningkatan Minigame Pick (Pilih Gambar):**
  * Gambar pilihan yang salah akan bergetar (*shake*).
  * Pertanyaan kata berganti secara dinamis dengan `AnimatedSwitcher`.
* **Pencegahan Memory Leak:**
  * Menambahkan validasi `if (!mounted) return;` pada seluruh penundaan waktu `Future.delayed` agar tidak terjadi error saat pemain keluar dari kuis di tengah permainan.

---

## 📊 Tabel Rekapitulasi Update

| Modul / File | Tipe Pembaruan | Rincian Utama |
| :--- | :--- | :--- |
| `AndroidManifest.xml` & `Info.plist` | Konfigurasi | Ganti label nama aplikasi ke FlashLingo & kunci Portrait iOS. |
| `main.dart` | Konfigurasi | Kunci orientasi Portrait secara programatik. |
| `progress_manager.dart` | Performa / Cache | In-memory cache, hapus parsing JSON berulang. |
| `app_background.dart` | Performa Render | Ganti `Opacity` dengan `BlendMode.modulate` (zero *saveLayer*). |
| `buttons.dart` | Fitur / Komponen | Tambah `ShakeWidget`, haptic feedback, perhalus kurva pegas. |
| `home_screen.dart` | Tampilan / UX | Floating logo, animasi masuk kartu, shake kartu terkunci, meter persen. |
| `flashcard_screen.dart` | Fitur / UX | Gesture swipe, transisi slide, animasi teks kosakata, `cacheWidth`. |
| `quiz_screen.dart` | Logika / Gamifikasi | Shake opsi salah, pop bintang kuis, border glow drag, guard `mounted`. |
| `pubspec.yaml` | Lingkungan | Fleksibilitas versi SDK Dart `^3.12.0`. |
