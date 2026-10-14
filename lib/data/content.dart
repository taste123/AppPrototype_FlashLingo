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
      img: 'assets/flashcardlevel1/hello.png',
    ),
    VocabItem(
      en: 'Hi',
      id: 'Hai',
      img: 'assets/flashcardlevel1/Hi and Bye.png',
    ),
    VocabItem(
      en: 'Goodbye',
      id: 'Selamat tinggal',
      img: 'assets/flashcardlevel1/Goodbye.png',
    ),
    VocabItem(
      en: 'Thank you',
      id: 'Terima kasih',
      img: 'assets/flashcardlevel1/Thankyou.png',
    ),
    VocabItem(
      en: 'Please',
      id: 'Tolong',
      img: 'assets/flashcardlevel1/Please.png',
    ),
    VocabItem(
      en: 'Bye',
      id: 'Selamat tinggal',
      img: 'assets/flashcardlevel1/Hi and Bye.png',
    ),
  ],
  'B2': [
    //warna
    VocabItem(
      en: 'Red',
      id: 'Merah',
      img: 'assets/flashcardlevel2/red.png',
    ),
    VocabItem(
      en: 'Blue',
      id: 'Biru',
      img: 'assets/flashcardlevel2/blue.png',
    ),
    VocabItem(
      en: 'Yellow',
      id: 'Kuning',
      img: 'assets/flashcardlevel2/yellow.png',
    ),
    VocabItem(
      en: 'Green',
      id: 'Hijau',
      img: 'assets/flashcardlevel2/green.png',
    ),
    VocabItem(
      en: 'Black',
      id: 'Hitam',
      img: 'assets/flashcardlevel2/black.png',
    ),
    VocabItem(
      en: 'White',
      id: 'Putih',
      img: 'assets/flashcardlevel2/white.png',
    ),
  ],
  'B3': [
    //angka
    VocabItem(
      en: 'One',
      id: 'Satu',
      img: 'assets/flashcardlevel3/1.png',
      backImg: 'assets/numbers/bisindo/satu.gif',
    ),
    VocabItem(
      en: 'Two',
      id: 'Dua',
      img: 'assets/flashcardlevel3/2.png',
      backImg: 'assets/numbers/bisindo/dua.gif',
    ),
    VocabItem(
      en: 'Three',
      id: 'Tiga',
      img: 'assets/flashcardlevel3/3.png',
      backImg: 'assets/numbers/bisindo/tiga.gif',
    ),
    VocabItem(
      en: 'Four',
      id: 'Empat',
      img: 'assets/flashcardlevel3/4.png',
      backImg: 'assets/numbers/bisindo/empat.gif',
    ),
    VocabItem(
      en: 'Five',
      id: 'Lima',
      img: 'assets/flashcardlevel3/5.png',
      backImg: 'assets/numbers/bisindo/lima.gif',
    ),
    VocabItem(
      en: 'Six',
      id: 'Enam',
      img: 'assets/flashcardlevel3/6.png',
      backImg: 'assets/numbers/bisindo/enam.gif',
    ),
    VocabItem(
      en: 'Seven',
      id: 'Tujuh',
      img: 'assets/flashcardlevel3/7.png',
      backImg: 'assets/numbers/bisindo/tujuh.gif',
    ),
    VocabItem(
      en: 'Eight',
      id: 'Delapan',
      img: 'assets/flashcardlevel3/8.png',
      backImg: 'assets/numbers/bisindo/delapan.gif',
    ),
    VocabItem(
      en: 'Nine',
      id: 'Sembilan',
      img: 'assets/flashcardlevel3/9.png',
      backImg: 'assets/numbers/bisindo/sembilan.gif',
    ),
    VocabItem(
      en: 'Ten',
      id: 'Sepuluh',
      img: 'assets/flashcardlevel3/10.png',
      backImg: 'assets/numbers/bisindo/sepuluh.gif',
    ),
  ],
  'B4': [
    //Tubuh dan Wajah
    VocabItem(
      en: 'Head',
      id: 'Kepala',
      img: dummyImg('👦🏻'),
      backImg: 'assets/body/bisindo/kepala.gif',
    ),
    VocabItem(
      en: 'Eye',
      id: 'Mata',
      img: dummyImg('👁️'),
      backImg: 'assets/body/bisindo/mata.gif',
    ),
    VocabItem(
      en: 'Nose',
      id: 'Hidung',
      img: 'assets/body/img/nose.png',
      backImg: 'assets/body/bisindo/hidung.gif',
    ),
    VocabItem(
      en: 'Mouth',
      id: 'Mulut',
      img: 'assets/body/img/mouth.png',
      backImg: 'assets/body/bisindo/mulut.gif',
    ),
    VocabItem(
      en: 'Hand',
      id: 'Tangan',
      img: 'assets/body/img/hand.png',
      backImg: 'assets/body/bisindo/tangan.gif',
    ),
    VocabItem(
      en: 'Leg',
      id: 'Kaki',
      img: 'assets/body/img/feet.png',
      backImg: 'assets/body/bisindo/kaki.gif',
    ),
  ],
  'B5': [
    //Sekolah
    VocabItem(en: 'Book', id: 'Buku', img: dummyImg('📚')),
    VocabItem(
      en: 'Pen',
      id: 'Pulpen',
      img: dummyImg('🖊️'),
      backImg: 'assets/school/bisindo/pulpen.gif',
    ),
    VocabItem(
      en: 'Bag',
      id: 'Tas',
      img: dummyImg('🎒'),
      backImg: 'assets/school/bisindo/tas.gif',
    ),
    VocabItem(
      en: 'Chair',
      id: 'Kursi',
      img: dummyImg('🪑'),
      backImg: 'assets/school/bisindo/kursi.gif',
    ),
    VocabItem(en: 'Table', id: 'Meja', img: 'assets/school/img/table.svg'),
    VocabItem(
      en: 'Teacher',
      id: 'Guru',
      img: 'assets/school/img/teacher.svg',
      backImg: 'assets/school/bisindo/guru.gif',
    ),
  ],
  'B6': [
    //Pakaian
    VocabItem(en: 'Hat', id: 'Topi', img: dummyImg('🎩')),
    VocabItem(en: 'Shirt', id: 'Kemeja', img: dummyImg('👕')),
    VocabItem(en: 'Pants', id: 'Celana', img: dummyImg('👖')),
    VocabItem(en: 'Shoes', id: 'Sepatu', img: dummyImg('👟')),
    VocabItem(en: 'Socks', id: 'Kaos kaki', img: dummyImg('🧦')),
    VocabItem(en: 'Dress', id: 'Gaun', img: dummyImg('👗')),
  ],
  'B7': [
    //Rumah
    VocabItem(en: 'House', id: 'Rumah', img: dummyImg('🏠')),
    VocabItem(en: 'Living room', id: 'Ruang tamu', img: dummyImg('🛋️')),
    VocabItem(en: 'Bedroom', id: 'Kamar tidur', img: dummyImg('🛏️')),
    VocabItem(en: 'Kitchen', id: 'Dapur', img: dummyImg('🍳')),
    VocabItem(en: 'Bathroom', id: 'Kamar mandi', img: dummyImg('🚿')),
    VocabItem(en: 'Garden', id: 'Taman', img: dummyImg('🌿')),
  ],
  'B8': [
    //Hewan
    VocabItem(
      en: 'Cat',
      id: 'Kucing',
      img: 'assets/animal/img/kucing.jpeg',
      backImg: 'assets/animal/bisindo/sl_cat.gif',
    ),
    VocabItem(
      en: 'Dog',
      id: 'Anjing',
      img: 'assets/animal/img/dog.png',
      backImg: 'assets/animal/bisindo/sl_dog.gif',
    ),
    VocabItem(
      en: 'Bird',
      id: 'Burung',
      img: 'assets/animal/img/bird.png',
      backImg: 'assets/animal/bisindo/sl_bird.gif',
    ),
    VocabItem(en: 'Fish', id: 'Ikan', img: dummyImg('🐟')),
    VocabItem(
      en: 'Monkey',
      id: 'Monyet',
      img: 'assets/animal/img/monkey.png',
      backImg: 'assets/animal/bisindo/sl_monkey.gif',
    ),
    VocabItem(
      en: 'Elephant',
      id: 'Gajah',
      img: 'assets/animal/img/elephant.png',
      backImg: 'assets/animal/bisindo/sl_elephant.gif',
    ),
  ],
  'B9': [
    //Keluarga dan Teman
    VocabItem(
      en: 'Father',
      id: 'Ayah',
      img: dummyImg('👨'),
      backImg: 'assets/family/bisindo/bapak.gif',
    ),
    VocabItem(
      en: 'Mother',
      id: 'Ibu',
      img: dummyImg('👩'),
      backImg: 'assets/family/bisindo/ibu.gif',
    ),
    VocabItem(en: 'Brother', id: 'Saudara laki-laki', img: dummyImg('👦')),
    VocabItem(en: 'Sister', id: 'Saudara perempuan', img: dummyImg('👧')),
    VocabItem(en: 'Grandfather', id: 'Kakek', img: dummyImg('👴')),
    VocabItem(en: 'Grandmother', id: 'Nenek', img: dummyImg('👵')),
  ],
  'B10': [
    //Waktu
    VocabItem(
      en: 'Morning',
      id: 'Pagi',
      img: dummyImg('🌅'),
      backImg: 'assets/time/bisindo/pagi.gif',
    ),
    VocabItem(
      en: 'Afternoon',
      id: 'Siang',
      img: dummyImg('☀️'),
      backImg: 'assets/time/bisindo/siang.gif',
    ),
    VocabItem(
      en: 'Evening',
      id: 'Sore',
      img: dummyImg('🌆'),
      backImg: 'assets/time/bisindo/sore.gif',
    ),
    VocabItem(
      en: 'Night',
      id: 'Malam',
      img: dummyImg('🌙'),
      backImg: 'assets/time/bisindo/malam.gif',
    ),
    VocabItem(
      en: 'Today',
      id: 'Hari ini',
      img: dummyImg('📅'),
      backImg: 'assets/time/bisindo/today.gif',
    ),
    VocabItem(
      en: 'Birthday',
      id: 'Ulang tahun',
      img: dummyImg('➡'),
      backImg: 'assets/time/bisindo/birthday.gif',
    ),
  ],
  'default': [
    VocabItem(en: 'Coming Soon', id: 'Segera Hadir', img: 'assets/logo.png'),
  ],
};
