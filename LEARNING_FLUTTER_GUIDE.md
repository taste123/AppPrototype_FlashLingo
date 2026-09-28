# 📱 Panduan Belajar Flutter dari Dasar (Project-Based Learning)
> **Studi Kasus Nyata:** Aplikasi *FlashLingo* (`AppPrototype_FlashLingo`)

Panduan ini disusun khusus untuk tim yang ingin mempelajari pemrograman mobile dengan **Flutter & Dart** dari nol, langsung berbasis kode nyata yang ada di proyek FlashLingo.

---

## 📑 Daftar Isi
1. [Pengenalan Flutter & Konsep Dasar](#1-pengenalan-flutter--konsep-dasar)
2. [Anatomi Struktur Folder Proyek](#2-anatomi-struktur-folder-proyek)
3. [Entry Point & Inisialisasi Aplikasi (`main.dart`)](#3-entry-point--inisialisasi-aplikasi-maindart)
4. [StatelessWidget vs StatefulWidget](#4-statelesswidget-vs-statefulwidget)
5. [Struktur Data & Model (`models.dart` & `content.dart`)](#5-struktur-data--model-modelsdart--contentdart)
6. [Penyimpanan Lokal Offline (`progress_manager.dart`)](#6-penyimpanan-lokal-offline-progress_managerdart)
7. [Hirarki UI & Widget Layouting](#7-hirarki-ui--widget-layouting)
8. [Animasi & Interaktivitas Tingkat Lanjut](#8-animasi--interaktivitas-tingkat-lanjut)
9. [Navigasi Antar Halaman](#9-navigasi-antar-halaman)
10. [Tantangan Latihan Mandiri (Hands-on Challenges)](#10-tantangan-latihan-mandiri-hands-on-challenges)

---

## 1. Pengenalan Flutter & Konsep Dasar

### Apa itu Flutter?
Flutter adalah framework open-source buatan Google untuk membangun aplikasi multi-platform (Android, iOS, Web, Desktop) dari **satu basis kode (single codebase)** menggunakan bahasa pemrograman **Dart**.

### Filosofi Inti: *"Everything is a Widget"*
Di Flutter, hampir semua elemen visual dan fungsional adalah **Widget**:
* **Visual:** Tombol (`ElevatedButton`), Teks (`Text`), Gambar (`Image`).
* **Layout:** Penataan posisi baris (`Row`), kolom (`Column`), tumpukan (`Stack`).
* **Struktur/Tema:** Kerangka layar (`Scaffold`), pembungkus aplikasi (`MaterialApp`).
* **Interaksi:** Pendeteksi sentuhan (`GestureDetector`).

---

## 2. Anatomi Struktur Folder Proyek

Buka folder proyek di editor Anda:

```
AppPrototype_FlashLingo/
├── android/            # Kode & konfigurasi spesifik native Android (Gradle, Manifest)
├── ios/                # Kode & konfigurasi spesifik native iOS (Xcode, Info.plist)
├── assets/             # Gambar, ikon SVG, dan ilustrasi
├── lib/                # KODE UTAMA DART ANDA (95% waktu kerja di sini)
│   ├── data/           # Layer data: model, data statis, storage manager
│   │   ├── content.dart
│   │   ├── models.dart
│   │   └── progress_manager.dart
│   ├── ui/             # Layer tampilan antarmuka
│   │   ├── widgets/    # Komponen reusable (tombol kustom, background)
│   │   ├── flashcard_screen.dart
│   │   ├── home_screen.dart
│   │   └── quiz_screen.dart
│   └── main.dart       # Titik awal eksekusi aplikasi
├── pubspec.yaml        # Konfigurasi dependensi (packages), font, dan aset
└── README.md
```

> **Catatan Tim:** File `pubspec.yaml` mirip seperti `package.json` di Node.js atau `pom.xml` di Java. Setiap menambah library/package baru, tambahkan di bawah `dependencies:` lalu jalankan `flutter pub get`.

---

## 3. Entry Point & Inisialisasi Aplikasi (`main.dart`)

Setiap aplikasi Flutter diawali dari fungsi `main()`. Mari bedah [lib/main.dart](file:///C:/AppPrototype_FlashLingo/lib/main.dart):

```dart
void main() async {
  // 1. Memastikan binding framework Flutter sudah siap sebelum memanggil native API
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Mengunci orientasi layar agar selalu tegak (Portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Inisialisasi data lokal (Shared Preferences) sebelum UI pertama kali digambar
  final progressManager = await ProgressManager.init();

  // 4. Menjalankan Root Widget aplikasi
  runApp(MyApp(progressManager: progressManager));
}
```

### Konsep `MaterialApp`:
`MaterialApp` adalah widget pembungkus utama yang menyediakan navigasi, tema warna global, dan font:
```dart
class MyApp extends StatelessWidget {
  final ProgressManager progressManager;
  const MyApp({super.key, required this.progressManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashLingo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menentukan font bawaan aplikasi secara global
        textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme),
      ),
      // Layar pertama yang dibuka saat aplikasi jalan
      home: HomeScreen(progressManager: progressManager),
    );
  }
}
```

---

## 4. StatelessWidget vs StatefulWidget

Ini adalah pemahaman paling fundamental di Flutter:

| Karakteristik | `StatelessWidget` | `StatefulWidget` |
| :--- | :--- | :--- |
| **Sifat Data** | Statis / Tidak berubah setelah dibuat | Dinamis / Bisa berubah saat aplikasi berjalan |
| **Pemicu Render Ulang** | Parameter dari parent berubah | Memanggil fungsi `setState()` |
| **Contoh di FlashLingo** | `AppBackground`, `RoundButton` | `HomeScreen`, `FlashcardScreen`, `QuizScreen` |

### Siklus Hidup (*Lifecycle*) `StatefulWidget`:
1. `initState()`: Dijalankan **sekali** saat widget pertama kali dibuat (bagus untuk inisialisasi controller, timer, atau animasi).
2. `build(BuildContext context)`: Dijalankan untuk menggambar tampilan. Dipanggil ulang setiap kali Anda mengeksekusi `setState(() { ... })`.
3. `dispose()`: Dijalankan saat widget dihancurkan/ditutup (wajib membersihkan `AnimationController` agar tidak terjadi *memory leak*).

---

## 5. Struktur Data & Model (`models.dart` & `content.dart`)

Lihat [lib/data/models.dart](file:///C:/AppPrototype_FlashLingo/lib/data/models.dart):

```dart
class Category {
  final String id;
  final String level;
  final String name;
  final String colorHex;
  final String imagePath;

  const Category({
    required this.id,
    required this.level,
    required this.name,
    required this.colorHex,
    required this.imagePath,
  });
}
```
* **Immutability (`final`):** Semua nilai atribut tidak bisa diubah sembarangan setelah objek dibuat, mencegah *bug* data yang tidak sengaja termutasi.
* **Constructor `const`:** Mengoptimasi memori karena objek yang sama tidak akan dialokasikan ulang di RAM.

Data kosakata disimpan rapi dalam bentuk koleksi di [lib/data/content.dart](file:///C:/AppPrototype_FlashLingo/lib/data/content.dart).

---

## 6. Penyimpanan Lokal Offline (`progress_manager.dart`)

FlashLingo tidak memerlukan internet karena data progres disimpan di storage internal HP menggunakan package `shared_preferences`.

Lihat [lib/data/progress_manager.dart](file:///C:/AppPrototype_FlashLingo/lib/data/progress_manager.dart):
1. **Pola Singleton / Inisialisasi Asinkron:**
   ```dart
   static Future<ProgressManager> init() async {
     final prefs = await SharedPreferences.getInstance();
     return ProgressManager(prefs);
   }
   ```
2. **Menyimpan Progres dalam Format JSON String:**
   ```dart
   Future<void> markLevelCompleted(String categoryId, int score) async {
     if (!_cachedCompletedLevels.contains(categoryId)) {
       _cachedCompletedLevels.add(categoryId);
       // Konversi List Dart menjadi teks JSON dan simpan ke disk
       await _prefs.setString(progressKey, jsonEncode(_cachedCompletedLevels));
     }
   }
   ```
3. **Memory Caching:** 
   Data dibaca ke variabel memori (`_cachedCompletedLevels`) sehingga saat UI membutuhkan status level (`isLevelUnlocked`), UI membacanya secara instan tanpa jeda I/O disk.

---

## 7. Hirarki UI & Widget Layouting

Bagaimana cara menyusun elemen di Flutter? Mari pelajari pola di FlashLingo:

### A. Menumpuk Elemen (`Stack` & `Positioned`)
Dipakai di [home_screen.dart](file:///C:/AppPrototype_FlashLingo/lib/ui/home_screen.dart) pada kartu level:
```dart
Stack(
  children: [
    Container(...), // Kartu utama
    if (!unlocked) 
      Positioned.fill(child: ...), // Lapisan gembok terkunci di atas kartu
    if (passed)
      Positioned(top: -8, right: -8, child: ...), // Bintang nilai di pojok atas
  ],
)
```

### B. Grid Responsif (`SliverGrid`)
Menampilkan daftar kategori 2 kolom yang bisa di-scroll:
```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,      // 2 kolom
    crossAxisSpacing: 24,   // Jarak horizontal
    mainAxisSpacing: 24,    // Jarak vertikal
    childAspectRatio: 1,    // Rasio lebar:tinggi kotak (1:1 / persegi)
  ),
  delegate: SliverChildBuilderDelegate((context, index) {
    return _CategoryCard(...);
  }, childCount: categoriesData.length),
)
```

---

## 8. Animasi & Interaktivitas Tingkat Lanjut

Di FlashLingo, pengalaman pengguna (*feel & UX*) terasa premium karena sentuhan animasi interaktif di [lib/ui/widgets/buttons.dart](file:///C:/AppPrototype_FlashLingo/lib/ui/widgets/buttons.dart):

### A. Animasi Efek Sentuh Membal (`TactileScale`)
Setiap kali tombol ditekan, tombol mengecil sedikit (scale 0.95) dan membal kembali saat dilepas (mirip tombol di iOS):
```dart
ScaleTransition(
  scale: _scaleAnimation,
  child: widget.child,
)
```
Disertai getaran taktil halus:
```dart
HapticFeedback.lightImpact();
```

### B. Animasi Goyang saat Error / Terkunci (`ShakeWidget`)
Menggunakan fungsi sinus matematika ($sin(x)$) untuk menggeser widget ke kiri dan ke kanan secara cepat saat user mengetuk level yang masih terkunci.

### C. Efek 3D Flip Kartu di [flashcard_screen.dart](file:///C:/AppPrototype_FlashLingo/lib/ui/flashcard_screen.dart)
Menggunakan transformasi matriks 3D:
```dart
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001) // Efek perspektif kedalaman 3D
    ..rotateY(angle),        // Rotasi sudut horizontal
  alignment: Alignment.center,
  child: ...,
)
```

---

## 9. Navigasi Antar Halaman

Berpindah dari `HomeScreen` ke `FlashcardScreen`:

```dart
void _openCategory(Category category) async {
  // Buka halaman baru dengan animasi slide bawaan platform
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => FlashcardScreen(
        category: category,
        progressManager: widget.progressManager,
      ),
    ),
  );

  // Kode di bawah ini dieksekusi saat user kembali (Back) dari FlashcardScreen
  // Memperbarui tampilan jika ada level baru yang terbuka / skor baru
  if (mounted) setState(() {});
}
```

---

## 10. Tantangan Latihan Mandiri (Hands-on Challenges)

Ajak anggota tim Anda untuk mencoba tantangan bertahap ini:

### 🟢 Latihan 1: Menambah Kosakata Baru (Level Pemula)
1. Buka [lib/data/content.dart](file:///C:/AppPrototype_FlashLingo/lib/data/content.dart).
2. Temukan list `'B1'`.
3. Tambahkan satu kata baru, misalnya:
   ```dart
   VocabItem(en: 'Good morning', id: 'Selamat pagi', img: dummyImg('🌅')),
   ```
4. Simpan file dan lakukan Hot Reload (`r` di terminal) untuk melihat kartu baru muncul otomatis!

### 🟡 Latihan 2: Ubah Durasi atau Efek Animasi (Level Menengah)
1. Buka [lib/ui/flashcard_screen.dart](file:///C:/AppPrototype_FlashLingo/lib/ui/flashcard_screen.dart).
2. Cari `_flipController` di `initState()`. Ubah durasi dari `550ms` ke `350ms` atau ganti kurva animasi dari `Curves.easeInOutCubic` menjadi `Curves.elasticOut`.
3. Rasakan perbedaannya saat kartu dibalik!

### 🔴 Latihan 3: Tambah Fitur "Pronunciation" Suara (Level Lanjut)
1. Tambahkan package `flutter_tts` di `pubspec.yaml`.
2. Tambahkan ikon speaker kecil 🔊 di kartu flashcard.
3. Ketika ditekan, panggil fungsi `flutterTts.speak(item.en)` untuk memperdengarkan suara pelafalan bahasa Inggris.

---

*Selamat belajar! Flutter sangat menyenangkan jika dipelajari langsung dengan mengeksplorasi kode aplikasi yang sudah berjalan.*
