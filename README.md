Nama : Evan Andrian

NPM : 2506539082

Kelas : PBP B

# MyPortfolio Mobile

## Deskripsi
MyPortfolio Mobile merupakan aplikasi mobile berbasis Flutter yang dibuat sebagai kelanjutan dari website portofolio pribadi saya. Aplikasi ini menampilkan identitas pemilik portofolio dan menu aksi untuk mengelola proyek dan pengalaman. Proyek ini dikembangkan secara bertahap mengikuti instruksi yang diberikan pada setiap penugasan.

Pada implementasi awal, aplikasi dibuat menggunakan Flutter dengan satu halaman utama yang berisi kartu informasi profil dan kartu menu aksi berwarna. Tampilan halaman dapat di-scroll sehingga tetap dapat digunakan pada layar yang tinggi atau lebarnya berbeda-beda, termasuk pada preview Chrome.

## Fitur
- Kartu informasi profil (NPM, Name, Class)
- Menu aksi portofolio: Lihat Proyek, Tambah Proyek, Lihat Pengalaman, Tambah Pengalaman, dan Logout
- Warna berbeda untuk setiap tombol menu
- SnackBar saat tombol ditekan

## Language
- Dart
- Flutter

## Struktur Proyek
```
myportofolio_mobile/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── experience_form.dart
│   │   ├── menu.dart
│   │   └── project_form.dart
│   └── widgets/
│       ├── item_card.dart
│       └── left_drawer.dart
├── test/
│   └── widget_test.dart
├── pubspec.yaml    # Konfigurasi dan dependensi proyek
└── README.md       # Dokumentasi proyek
```

## Cara Menjalankan
Prasyarat: [Flutter SDK](https://docs.flutter.dev/get-started/install) sudah terpasang dan `flutter doctor` tidak menunjukkan masalah berarti.

1. Clone repositori
   ```bash
   git clone https://github.com/TramplingArgumentt/myportofolio_mobile.git
   cd myportofolio_mobile
   ```
2. Unduh dependensi
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi
   ```bash
   # di browser Chrome
   flutter run -d chrome

   # atau di emulator/perangkat yang terhubung
   flutter run
   ```
4. Analisis kode (target: `No issues found!`)
   ```bash
   flutter analyze
   ```

## Setup
### Week 7 - 16 November 2026 (Tugas 7)
- Melanjutkan proyek Flutter dari Tutorial 08 dan memisahkan `MyHomePage` ke `menu.dart`
- Mengubah `MyHomePage` menjadi `StatelessWidget`
- Menambahkan 3 `InfoCard` yang berisi NPM, Name, dan Class
- Menambahkan 5 `ItemCard` dengan ikon dan warna berbeda melalui model `ItemHomepage`
- Menambahkan `SnackBar` yang menampilkan pesan sesuai tombol yang ditekan
- Memperbaiki *bottom overflowed* dengan `SingleChildScrollView` dan pengaturan scroll pada `GridView`

### Week 8 - 23 November 2026 (Tugas 8)
- Menambahkan formulir Pengalaman dan menyempurnakan formulir Proyek dengan validasi serta dialog ringkasan.
- Formulir Proyek memuat nama, deskripsi, Tags berupa teks dipisahkan koma, URL proyek, dan URL gambar.
- Menambahkan navigasi formulir dari kartu aksi dan drawer.
- Membuat formulir dapat digulir pada ruang layar terbatas; tanggal mulai Pengalaman menggunakan tanggal hari ini jika tidak diisi.
- Menjalankan `flutter analyze` dan `flutter test`. Analisis masih melaporkan dua info deprecation, sedangkan tes widget bawaan masih menguji counter dan gagal pada aplikasi ini.

### Tugas 7

1. Widget tree adalah struktur pohon yang terbentuk dari widget-widget Flutter yang saling bersarang. Akar pohon adalah widget yang dipanggil oleh `runApp()`, yaitu `MyApp` pada proyek ini, lalu bercabang ke widget di bawahnya hingga widget daun seperti `Text` dan `Icon`.

Hubungan parent-child berarti sebuah widget (parent) membungkus satu atau lebih widget lain (child) melalui properti seperti `child` atau `children`. Parent memberikan constraint (batas ukuran) dan menentukan posisi child, sedangkan child menentukan ukurannya sendiri dalam batas tersebut. Data juga mengalir dari parent ke child, misalnya melalui parameter konstruktor seperti `InfoCard(title: 'NPM', content: npm)` atau melalui `Theme.of(context)` yang diwariskan dari `MaterialApp`.

Pada proyek ini, pohonnya kurang lebih `MyApp` → `MaterialApp` → `MyHomePage` → `Scaffold` → `AppBar` dan `SingleChildScrollView` → `Padding` → `Column` → `Row` berisi 3 `InfoCard`, `Text`, dan `GridView` berisi `ItemCard`. Ketika sebuah widget dibangun ulang, hanya bagian pohon di bawahnya yang ikut dibangun ulang sehingga prosesnya efisien.

2. Widget yang digunakan pada proyek ini beserta fungsinya:
- `MyApp`: widget root aplikasi (`StatelessWidget`) yang mengembalikan `MaterialApp`.
- `MaterialApp`: menyediakan konfigurasi aplikasi bergaya Material seperti tema, judul, dan halaman awal (`home`).
- `MyHomePage`: halaman menu utama (`StatelessWidget`) yang menyusun seluruh tampilan.
- `Scaffold`: kerangka dasar halaman yang menyediakan `AppBar`, `body`, dan tempat tampil `SnackBar`.
- `AppBar`: bar judul di bagian atas halaman.
- `SingleChildScrollView`: membuat isi halaman dapat di-scroll agar tidak overflow pada layar yang pendek.
- `Padding`: memberi jarak di sekeliling child.
- `Column`: menyusun child secara vertikal.
- `Row`: menyusun child secara horizontal, dipakai untuk tiga `InfoCard`.
- `Center`: memusatkan child di dalam ruang yang tersedia.
- `SizedBox`: memberi jarak kosong dengan ukuran tetap antar-widget.
- `Text`: menampilkan teks.
- `GridView.count`: menyusun `ItemCard` dalam kisi dengan jumlah kolom tetap, yaitu 3 kolom.
- `InfoCard`: widget buatan sendiri untuk menampilkan judul dan isi informasi profil.
- `Card`: kartu bergaya Material dengan sudut membulat dan bayangan.
- `Container`: wadah serbaguna untuk mengatur ukuran dan padding.
- `ItemCard`: widget buatan sendiri untuk tombol menu berwarna dengan ikon dan teks.
- `Material`: menyediakan permukaan Material dengan warna latar dan sudut membulat, serta tempat efek ripple.
- `InkWell`: mendeteksi sentuhan (`onTap`) dan menampilkan efek ripple.
- `Icon`: menampilkan ikon dari `Icons`.
- `SnackBar`: pesan singkat di bagian bawah layar saat tombol ditekan.
- `ScaffoldMessenger`: mengelola dan menampilkan `SnackBar` pada `Scaffold` yang aktif.
- `Theme`: mengakses data tema, misalnya `colorScheme.primary` untuk warna `AppBar`.
- `MediaQuery`: membaca informasi layar, yaitu lebar layar untuk menentukan lebar `InfoCard`.

3. `MaterialApp` adalah widget tingkat tinggi yang membungkus kebutuhan dasar aplikasi bergaya Material Design, yaitu tema (`ThemeData`), judul aplikasi, halaman awal (`home`), sistem navigasi (`Navigator` dan `routes`), lokalisasi, dan arah teks. Widget ini juga menyiapkan `ScaffoldMessenger` dan `Overlay` yang dibutuhkan oleh `Scaffold`, `SnackBar`, dan dialog.

Karena seluruh widget turunan mengakses tema, navigasi, dan layanan tersebut melalui `BuildContext`, `MaterialApp` diletakkan di posisi paling atas agar seluruh halaman di bawahnya otomatis mewarisi konfigurasi yang sama. Tanpa `MaterialApp`, widget seperti `Scaffold` dan `AppBar` tidak mendapat tema maupun `Navigator` sehingga harus dikonfigurasi secara manual.

4. `StatelessWidget` tidak menyimpan state yang berubah. Tampilannya sepenuhnya ditentukan oleh konfigurasi dari konstruktor yang bersifat `final`. Jika tampilan ingin berubah, parent harus membuat ulang widget dengan data baru. `StatefulWidget` memiliki objek `State` terpisah yang bertahan selama widget hidup dan dapat berubah. Pemanggilan `setState()` memberi tahu Flutter untuk menjalankan `build()` ulang sehingga tampilan diperbarui.

`StatelessWidget` sebaiknya dipilih untuk tampilan statis atau yang hanya bergantung pada data dari parent, seperti `InfoCard`, `ItemCard`, dan `MyHomePage` pada proyek ini. `StatefulWidget` digunakan ketika tampilan harus berubah akibat interaksi atau data internal, misalnya counter, input form, checkbox, animasi, atau data yang dimuat secara asinkron.

5. `BuildContext` adalah penanda lokasi sebuah widget di dalam widget tree. Melalui `context`, widget dapat melihat ke atas pohon untuk menemukan widget leluhur dan data yang diwariskan, sehingga informasi dari leluhur dapat diakses tanpa perlu diteruskan secara manual.

Pada metode `build(BuildContext context)` di proyek ini, `Theme.of(context).colorScheme.primary` mengambil warna utama dari tema `MaterialApp`, `MediaQuery.of(context).size.width` mengambil lebar layar, dan `ScaffoldMessenger.of(context).showSnackBar(...)` mencari `ScaffoldMessenger` terdekat di atas pohon untuk menampilkan `SnackBar`. Karena `context` bergantung pada posisi widget, `context` dari widget yang berada di atas `Scaffold` tidak dapat menemukan `Scaffold` tersebut. Itulah sebabnya `ItemCard` memakai `context` miliknya sendiri yang berada di bawah `Scaffold`.

6. Hot reload menyuntikkan kode Dart yang baru diubah ke Dart VM yang sedang berjalan, lalu membangun ulang widget tree. State aplikasi dipertahankan sehingga prosesnya sangat cepat dan cocok untuk menyesuaikan tampilan seperti warna, teks, dan layout. Hot restart memuat ulang seluruh kode dan menjalankan `main()` dari awal sehingga semua state di-reset ke nilai awal. Prosesnya lebih lambat dibanding hot reload tetapi lebih cepat dibanding full restart, yaitu menghentikan aplikasi lalu menjalankan `flutter run` kembali.

Hot reload saja tidak cukup pada beberapa kasus. Hot restart diperlukan ketika mengubah isi `main()`, nilai variabel global atau static field beserta inisialisasinya, `initState()`, tipe enum atau generic type, atau mengubah widget dari `StatelessWidget` menjadi `StatefulWidget` dan sebaliknya. Full restart diperlukan ketika menambah atau mengubah dependensi di `pubspec.yaml`, menambah aset atau font baru, serta mengubah kode native atau konfigurasi platform seperti `AndroidManifest.xml` dan `Info.plist`.

### Tugas 8

1. `Navigator.push()` menambahkan route baru ke atas navigation stack tanpa menghapus halaman sebelumnya. Kartu **Tambah Proyek** dan **Tambah Pengalaman** menggunakannya untuk membuka formulir, sehingga tombol kembali menutup formulir dan menampilkan halaman sebelumnya. `Navigator.pushReplacement()` mengganti route yang sedang aktif; opsi **Home** di drawer memakainya agar halaman utama tampil menggantikan formulir. `Navigator.pop()` menghapus route teratas, misalnya menutup dialog ringkasan dan kembali ke formulir.

2. `Scaffold` menjadi kerangka halaman dan menampung bagian seperti `AppBar`, `Drawer`, serta isi halaman. Dengan pola yang sama pada halaman utama dan formulir, judul dan navigasi tetap berada di tempat yang konsisten. Warna indigo dipakai pada AppBar formulir dan header drawer; AppBar halaman utama menggunakan `colorScheme.primary` dari tema yang dibuat dengan seed indigo.

3. Formulir menempatkan input secara vertikal di dalam `Column`, dengan `Padding` di sekeliling tiap input dan tombol agar tidak berhimpitan. `SingleChildScrollView` membungkus isi formulir sehingga bagian bawah, termasuk tombol **Simpan**, tetap dapat dijangkau dengan menggulir saat tinggi layar berkurang atau keyboard terbuka.

4. `GlobalKey<FormState>` menghubungkan tombol **Simpan** dengan state dari `Form`, sehingga handler dapat memanggil `validate()` dan `save()`. `validate()` menjalankan setiap `validator`; jika ada yang mengembalikan pesan, pesan itu muncul di kolom terkait dan proses penyimpanan berhenti. Contohnya, nama yang kosong atau hanya berisi spasi ditolak. Jika semua valid, `save()` menjalankan callback `onSaved` untuk mengambil nilai sebelum dialog ringkasan ditampilkan. `keyboardType: TextInputType.url` hanya menyajikan papan ketik yang sesuai; pengguna masih dapat memasukkan URL yang salah, jadi pemeriksaan format tetap diperlukan.

## AI Disclosure:
### Tools
Claude, Copilot

### Penggunaan AI
AI saya gunakan untuk membantu menganalisis dan memperbaiki pesan *bottom overflowed by 147 pixels* yang muncul pada preview Chrome mode desktop, menjelaskan bagaimana implementasi `showDatePicker()` dan validasi input, menyusun draf jawaban pertanyaan reflektif, serta menyusun kerangka dokumentasi README ini. Logika dan struktur dasar aplikasi, yaitu pemisahan `menu.dart`, `InfoCard`, `ItemCard`, model `ItemHomepage`, dan `SnackBar`, saya kerjakan sendiri mengikuti Tutorial 08. Saya tetap memeriksa hasil saran AI dengan menjalankan ulang aplikasi di Chrome dan menjalankan `flutter analyze`, serta mencocokkan jawaban reflektif dengan kode proyek saya.

### Strategi Prompting
Strategi prompting yang digunakan adalah dengan menyertakan teks petunjuk tugas, isi `main.dart`, dan isi `menu.dart` kepada AI, ditambah penjelasan gejala spesifik berupa pesan overflow pada mode desktop Chrome. Saya juga menanyakan terlebih dahulu apakah masalah tersebut perlu ditangani pada aplikasi mobile. Untuk dokumentasi, saya memberikan README proyek Django sebelumnya sebagai acuan format.

### Keterbatasan AI
Pada percobaan pertama, AI menebak isi `menu.dart` dari struktur Tutorial 08 sebelum kode sebenarnya saya berikan, dan jawabannya baru akurat setelah kode asli dilampirkan. AI juga memberikan saran yang terlalu luas, seperti membatasi lebar dengan `ConstrainedBox`, mengubah lebar `InfoCard`, dan mengganti warna tombol, padahal masalah yang ingin saya perbaiki hanya bottom overflow. Selain itu, AI menggunakan sintaks yang bergantung pada versi Dart (dot-shorthand pada `colorScheme: .fromSeed(...)`), sehingga kompatibilitasnya perlu dicek pada versi Flutter yang terpasang.

### Perbaikan Manual
Saya meminta AI mengulang jawabannya dari awal dengan cakupan yang dibatasi hanya pada masalah bottom overflow, sehingga perubahan akhir hanya berupa `SingleChildScrollView` dan penyesuaian `GridView` (`primary: false` dan `NeverScrollableScrollPhysics`). Saya juga meminta format dokumentasi tanpa tabel agar sesuai dengan berkas `.md`.

### AI Chat Logs
https://claude.ai/share/d4ac2346-e55e-472a-b056-ffb717e63847

### Penggunaan AI pada Tugas 8
Copilot digunakan untuk membantu meninjau validasi formulir dan navigasi, serta menyusun draf jawaban reflektif. Saya mencocokkan saran dengan kode; Tags tetap berupa teks dipisahkan koma untuk ringkasan formulir dan belum dikirim ke backend. Saya juga menjalankan analisis dan tes; analisis masih melaporkan dua info deprecation dan tes widget bawaan masih perlu diperbarui.