import 'models.dart';

const List<Category> categoriesData = [
  Category(id: 'B1', level: 'Level 1', name: 'Greetings', colorHex: '#8B5A2B', imagePath: 'assets/menu/greetings.png'),
  Category(id: 'B2', level: 'Level 2', name: 'Colours', colorHex: '#B088CA', imagePath: 'assets/menu/colors.png'),
  Category(id: 'B3', level: 'Level 3', name: 'Numbers', colorHex: '#F4A261', imagePath: 'assets/menu/numbers.png'),
  Category(id: 'B4', level: 'Level 4', name: 'The body and the face', colorHex: '#A9D39E', imagePath: 'assets/menu/body.png'),
  Category(id: 'B5', level: 'Level 5', name: 'School', colorHex: '#7FB6D8', imagePath: 'assets/menu/school.png'),
  Category(id: 'B6', level: 'Level 6', name: 'Clothes', colorHex: '#7FB6D8', imagePath: 'assets/menu/clothes.png'),
  Category(id: 'B7', level: 'Level 7', name: 'The home', colorHex: '#E76F51', imagePath: 'assets/menu/home.svg'),
  Category(id: 'B8', level: 'Level 8', name: 'Animals', colorHex: '#73C2C8', imagePath: 'assets/menu/animals.png'),
  Category(id: 'B9', level: 'Level 9', name: 'Family & friends', colorHex: '#EB8B71', imagePath: 'assets/menu/familyFriends.png'),
  Category(id: 'B10', level: 'Level 10', name: 'Time', colorHex: '#2A9D8F', imagePath: 'assets/menu/time.png'),

];

String dummyImg(String emoji) => 'dummy:$emoji';

final Map<String, List<VocabItem>> vocabularyData = {
  'B1': [
    //sapaan
    VocabItem(
      en: 'Hello',
      id: 'Halo',
      img: 'assets/flashcardlevel1/img/hello.png',
    ),
    VocabItem(
      en: 'Happy Birthday',
      id: 'Selamat Ulang Tahun',
      img: 'assets/flashcardlevel1/img/happy birthday.jpg',
    ),
    VocabItem(
      en: 'Goodbye',
      id: 'Selamat tinggal',
      img: 'assets/flashcardlevel1/img/Goodbye.png',
    ),
    VocabItem(
      en: 'Thank you',
      id: 'Terima kasih',
      img: 'assets/flashcardlevel1/img/Thankyou.png',
    ),
    VocabItem(
      en: 'Please',
      id: 'Tolong',
      img: 'assets/flashcardlevel1/img/Please.png',
    ),
    VocabItem(
      en: 'Sorry',
      id: 'Maaf',
      img: 'assets/flashcardlevel1/img/sorry.jpg',
    ),
  ],
  'B2': [
    //warna
    VocabItem(
      en: 'Red',
      id: 'Merah',
      img: 'assets/flashcardlevel2/img/red.png',
    ),
    VocabItem(
      en: 'Blue',
      id: 'Biru',
      img: 'assets/flashcardlevel2/img/blue.png',
    ),
    VocabItem(
      en: 'Yellow',
      id: 'Kuning',
      img: 'assets/flashcardlevel2/img/yellow.png',
    ),
    VocabItem(
      en: 'Green',
      id: 'Hijau',
      img: 'assets/flashcardlevel2/img/green.png',
    ),
    VocabItem(
      en: 'Black',
      id: 'Hitam',
      img: 'assets/flashcardlevel2/img/black.png',
    ),
    VocabItem(
      en: 'White',
      id: 'Putih',
      img: 'assets/flashcardlevel2/img/white.png',
    ),
  ],
  'B3': [
    //angka
    VocabItem(
      en: 'One',
      id: 'Satu',
      img: 'assets/flashcardlevel3/img/1.png',
      backImg: 'assets/flashcardlevel3/bisindo/satu.gif',
    ),
    VocabItem(
      en: 'Two',
      id: 'Dua',
      img: 'assets/flashcardlevel3/img/2.png',
      backImg: 'assets/flashcardlevel3/bisindo/dua.gif',
    ),
    VocabItem(
      en: 'Three',
      id: 'Tiga',
      img: 'assets/flashcardlevel3/img/3.png',
      backImg: 'assets/flashcardlevel3/bisindo/tiga.gif',
    ),
    VocabItem(
      en: 'Four',
      id: 'Empat',
      img: 'assets/flashcardlevel3/img/4.png',
      backImg: 'assets/flashcardlevel3/bisindo/empat.gif',
    ),
    VocabItem(
      en: 'Five',
      id: 'Lima',
      img: 'assets/flashcardlevel3/img/5.png',
      backImg: 'assets/flashcardlevel3/bisindo/lima.gif',
    ),
    VocabItem(
      en: 'Six',
      id: 'Enam',
      img: 'assets/flashcardlevel3/img/6.png',
      backImg: 'assets/flashcardlevel3/bisindo/enam.gif',
    ),
    VocabItem(
      en: 'Seven',
      id: 'Tujuh',
      img: 'assets/flashcardlevel3/img/7.png',
      backImg: 'assets/flashcardlevel3/bisindo/tujuh.gif',
    ),
    VocabItem(
      en: 'Eight',
      id: 'Delapan',
      img: 'assets/flashcardlevel3/img/8.png',
      backImg: 'assets/flashcardlevel3/bisindo/delapan.gif',
    ),
    VocabItem(
      en: 'Nine',
      id: 'Sembilan',
      img: 'assets/flashcardlevel3/img/9.png',
      backImg: 'assets/flashcardlevel3/bisindo/sembilan.gif',
    ),
    VocabItem(
      en: 'Ten',
      id: 'Sepuluh',
      img: 'assets/flashcardlevel3/img/10.png',
      backImg: 'assets/flashcardlevel3/bisindo/sepuluh.gif',
    ),
  ],
  'B4': [
    //Tubuh dan Wajah
    VocabItem(
      en: 'Head',
      id: 'Kepala',
      img: 'assets/flashcardlevel4/img/head.jpg',
      backImg: 'assets/flashcardlevel1/bisindo/kepala.gif',
    ),
    VocabItem(
      en: 'Eye',
      id: 'Mata',
      img: 'assets/flashcardlevel4/img/eye.jpg',
      backImg: 'assets/flashcardlevel1/bisindo/mata.gif',
    ),
    VocabItem(
      en: 'Nose',
      id: 'Hidung',
      img: 'assets/flashcardlevel4/img/nose.jpg',
      backImg: 'assets/flashcardlevel1/bisindo/hidung.gif',
    ),
    VocabItem(
      en: 'Mouth',
      id: 'Mulut',
      img: 'assets/flashcardlevel4/img/mouth.jpg',
      backImg: 'assets/flashcardlevel1/bisindo/mulut.gif',
    ),
    VocabItem(
      en: 'Hand',
      id: 'Tangan',
      img: 'assets/flashcardlevel4/img/hand.jpg',
      backImg: 'assets/flashcardlevel1/bisindo/tangan.gif',
    ),
    VocabItem(
      en: 'Leg',
      id: 'Kaki',
      img: 'assets/flashcardlevel4/img/leg.jpg',
      backImg: 'assets/flashcardlevel1/bisindo/kaki.gif',
    ),
  ],
  'B5': [
    //Sekolah
    VocabItem(
      en: 'Book',
      id: 'Buku',
      img: 'assets/flashcardlevel5/img/book.jpg',
      backImg: 'assets/flashcardlevel5/bisindo/buku.gif',
    ),
    VocabItem(
      en: 'Pen',
      id: 'Pulpen',
      img: 'assets/flashcardlevel5/img/pen.jpg',
      backImg: 'assets/flashcardlevel5/bisindo/pulpen.gif',
    ),
    VocabItem(
      en: 'Bag',
      id: 'Tas',
      img: 'assets/flashcardlevel5/img/bag.jpg',
      backImg: 'assets/flashcardlevel5/bisindo/tas.gif',
    ),
    VocabItem(
      en: 'Chair',
      id: 'Kursi',
      img: 'assets/flashcardlevel5/img/chair.jpg',
      backImg: 'assets/flashcardlevel5/bisindo/kursi.gif',
    ),
    VocabItem(
      en: 'Table',
      id: 'Meja',
      img: 'assets/flashcardlevel5/img/table.jpg',
      backImg: 'assets/flashcardlevel5/bisindo/meja.gif',
    ),
    VocabItem(
      en: 'Teacher',
      id: 'Guru',
      img: 'assets/flashcardlevel5/img/teacher.jpg',
      backImg: 'assets/flashcardlevel5/bisindo/guru.gif',
    ),
  ],
  'B6': [
    //Pakaian
    VocabItem(
      en: 'Hat',
      id: 'Topi',
      img: 'assets/flashcardlevel6/img/hat.jpg',
    ),
    VocabItem(
      en: 'Shirt',
      id: 'Kemeja',
      img: 'assets/flashcardlevel6/img/shirt.jpg',
    ),
    VocabItem(
      en: 'Pants',
      id: 'Celana',
      img: 'assets/flashcardlevel6/img/pants.jpg',
    ),
    VocabItem(
      en: 'Shoes',
      id: 'Sepatu',
      img: 'assets/flashcardlevel6/img/shoes.jpg',
    ),
    VocabItem(
      en: 'Socks',
      id: 'Kaos kaki',
      img: 'assets/flashcardlevel6/img/socks.jpg',
    ),
    VocabItem(
      en: 'Dress',
      id: 'Gaun',
      img: 'assets/flashcardlevel6/img/dress.jpg',
    ),
  ],
  'B7': [
    //Rumah
    VocabItem(
      en: 'House',
      id: 'Rumah',
      img: 'assets/flashcardlevel7/img/House.jpg',
    ),
    VocabItem(
      en: 'Living room',
      id: 'Ruang tamu',
      img: 'assets/flashcardlevel7/img/livingroom.jpg',
    ),
    VocabItem(
      en: 'Bedroom',
      id: 'Kamar tidur',
      img: 'assets/flashcardlevel7/img/Bedroom.jpg',
    ),
    VocabItem(
      en: 'Kitchen',
      id: 'Dapur',
      img: 'assets/flashcardlevel7/img/Kitchen.jpg',
    ),
    VocabItem(
      en: 'Bathroom',
      id: 'Kamar mandi',
      img: 'assets/flashcardlevel7/img/Bathroom.jpg',
    ),
    VocabItem(
      en: 'Garden',
      id: 'Taman',
      img: 'assets/flashcardlevel7/img/Garden.jpg',
    ),
  ],
  'B8': [
    //Hewan
    VocabItem(
      en: 'Cat',
      id: 'Kucing',
      img: 'assets/flashcardlevel8/img/cat.jpg',
      backImg: 'assets/animal/bisindo/sl_cat.gif',
    ),
    VocabItem(
      en: 'Dog',
      id: 'Anjing',
      img: 'assets/flashcardlevel8/img/Dog.jpg',
      backImg: 'assets/animal/bisindo/sl_dog.gif',
    ),
    VocabItem(
      en: 'Bird',
      id: 'Burung',
      img: 'assets/flashcardlevel8/img/bird.jpg',
      backImg: 'assets/animal/bisindo/sl_bird.gif',
    ),
    VocabItem(
      en: 'Fish',
      id: 'Ikan',
      img: 'assets/flashcardlevel8/img/fish.jpg',
    ),
    VocabItem(
      en: 'Monkey',
      id: 'Monyet',
      img: 'assets/flashcardlevel8/img/Monkey.jpg',
      backImg: 'assets/animal/bisindo/sl_monkey.gif',
    ),
    VocabItem(
      en: 'Elephant',
      id: 'Gajah',
      img: 'assets/flashcardlevel8/img/elephant.jpg',
      backImg: 'assets/animal/bisindo/sl_elephant.gif',
    ),
  ],
  'B9': [
    //Keluarga dan Teman
    VocabItem(
      en: 'Father',
      id: 'Ayah',
      img: 'assets/flashcardlevel9/img/father.jpg',
      backImg: 'assets/flashcardlevel9/bisindo/bapak.gif',
    ),
    VocabItem(
      en: 'Mother',
      id: 'Ibu',
      img: 'assets/flashcardlevel9/img/mother.jpg',
      backImg: 'assets/flashcardlevel9/bisindo/ibu.gif',
    ),
    VocabItem(
      en: 'Older sibling',
      id: 'Kakak',
      img: 'assets/flashcardlevel9/img/oldersibling.jpg',
      backImg: 'assets/flashcardlevel9/bisindo/kakak.gif',
    ),
    VocabItem(
      en: 'Younger sibling',
      id: 'Adik',
      img: 'assets/flashcardlevel9/img/youngersibling.jpg',
      backImg: 'assets/flashcardlevel9/bisindo/adek.gif',
    ),
    VocabItem(
      en: 'Grandfather',
      id: 'Kakek',
      img: 'assets/flashcardlevel9/img/grandfather.jpg',
      backImg: 'assets/flashcardlevel9/bisindo/kakek.gif',
    ),
    VocabItem(
      en: 'Grandmother',
      id: 'Nenek',
      img: 'assets/flashcardlevel9/img/grandmother.jpg',
      backImg: 'assets/flashcardlevel9/bisindo/nenek.gif',
    ),
  ],
  'B10': [
    //Waktu
    VocabItem(
      en: 'Morning',
      id: 'Pagi',
      img: 'assets/flashcardlevel10/img/morning.jpg',
      backImg: 'assets/flashcardlevel10/bisindo/pagi.gif',
    ),
    VocabItem(
      en: 'Afternoon',
      id: 'Siang',
      img: 'assets/flashcardlevel10/img/afternoon.jpg',
      backImg: 'assets/flashcardlevel10/bisindo/siang.gif',
    ),
    VocabItem(
      en: 'Evening',
      id: 'Sore',
      img: 'assets/flashcardlevel10/img/evening.jpg',
      backImg: 'assets/flashcardlevel10/bisindo/sore.gif',
    ),
    VocabItem(
      en: 'Night',
      id: 'Malam',
      img: 'assets/flashcardlevel10/img/night.jpg',
      backImg: 'assets/flashcardlevel10/bisindo/malam.gif',
    ),
    VocabItem(
      en: 'Today',
      id: 'Hari ini',
      img: 'assets/flashcardlevel10/img/today.jpg',
      backImg: 'assets/flashcardlevel10/bisindo/today.gif',
    ),
    VocabItem(
      en: 'Birthday',
      id: 'Ulang tahun',
      img: 'assets/flashcardlevel10/img/Birthday.jpg',
      backImg: 'assets/flashcardlevel10/bisindo/birthday.gif',
    ),
  ],
  'default': [
    VocabItem(en: 'Coming Soon', id: 'Segera Hadir', img: 'assets/logo.png'),
  ],
};
