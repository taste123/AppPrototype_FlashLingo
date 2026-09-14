import 'models.dart';

const List<Category> categoriesData = [
  Category(id: 'B1', level: 'Level 1', name: 'Greetings', colorHex: '#8B5A2B', imagePath: 'assets/greetings.png'),
  Category(id: 'B2', level: 'Level 2', name: 'Colours', colorHex: '#B088CA', imagePath: 'assets/colors.png'),
  Category(id: 'B3', level: 'Level 3', name: 'Numbers', colorHex: '#F4A261', imagePath: 'assets/numbers.svg'),
  Category(id: 'B4', level: 'Level 4', name: 'The body and the face', colorHex: '#A9D39E', imagePath: 'assets/body.png'),
  Category(id: 'B5', level: 'Level 5', name: 'School', colorHex: '#7FB6D8', imagePath: 'assets/school.svg'),
  Category(id: 'B6', level: 'Level 6', name: 'Clothes', colorHex: '#7FB6D8', imagePath: 'assets/clothes.png'),
  Category(id: 'B7', level: 'Level 7', name: 'The home', colorHex: '#E76F51', imagePath: 'assets/home.svg'),
  Category(id: 'B8', level: 'Level 8', name: 'Animals', colorHex: '#73C2C8', imagePath: 'assets/animal.png'),
  Category(id: 'B9', level: 'Level 9', name: 'Family & friends', colorHex: '#EB8B71', imagePath: 'assets/familyFriends.png'),
  Category(id: 'B10', level: 'Level 10', name: 'Time', colorHex: '#2A9D8F', imagePath: 'assets/time.svg'),
];

String dummyImg(String emoji) => 'dummy:$emoji';

final Map<String, List<VocabItem>> vocabularyData = {
  'B1': [
    VocabItem(en: 'Hello', id: 'Halo', img: dummyImg('🤝')),
    VocabItem(en: 'Hi', id: 'Hai', img: dummyImg('😊')),
    VocabItem(en: 'Goodbye', id: 'Selamat tinggal', img: dummyImg('👋')),
    VocabItem(en: 'Thank you', id: 'Terima kasih', img: dummyImg('🙏')),
    VocabItem(en: 'Please', id: 'Tolong', img: dummyImg('🤲')),
    VocabItem(en: 'Bye', id: 'Dah', img: dummyImg('✌️')),
  ],
  'B2': [
    VocabItem(en: 'Red', id: 'Merah', img: dummyImg('🔴')),
    VocabItem(en: 'Blue', id: 'Biru', img: dummyImg('🔵')),
    VocabItem(en: 'Yellow', id: 'Kuning', img: dummyImg('🟡')),
    VocabItem(en: 'Green', id: 'Hijau', img: dummyImg('🟢')),
    VocabItem(en: 'Black', id: 'Hitam', img: dummyImg('⚫')),
    VocabItem(en: 'White', id: 'Putih', img: dummyImg('⚪')),
  ],
  'B3': [
    VocabItem(en: 'One', id: 'Satu', img: 'assets/numbers/n1.svg'),
    VocabItem(en: 'Two', id: 'Dua', img: 'assets/numbers/n2.svg'),
    VocabItem(en: 'Three', id: 'Tiga', img: 'assets/numbers/n3.svg'),
    VocabItem(en: 'Four', id: 'Empat', img: 'assets/numbers/n4.svg'),
    VocabItem(en: 'Five', id: 'Lima', img: 'assets/numbers/n5.svg'),
    VocabItem(en: 'Six', id: 'Enam', img: 'assets/numbers/n6.svg'),
    VocabItem(en: 'Seven', id: 'Tujuh', img: 'assets/numbers/n7.svg'),
    VocabItem(en: 'Eight', id: 'Delapan', img: 'assets/numbers/n8.svg'),
    VocabItem(en: 'Nine', id: 'Sembilan', img: 'assets/numbers/n9.svg'),
    VocabItem(en: 'Ten', id: 'Sepuluh', img: 'assets/numbers/n10.svg'),
  ],
  'B4': [
    VocabItem(en: 'Head', id: 'Kepala', img: dummyImg('')),
    VocabItem(en: 'Eye', id: 'Mata', img: dummyImg('👁️')),
    VocabItem(en: 'Nose', id: 'Hidung', img: 'assets/body/nose.png'),
    VocabItem(en: 'Mouth', id: 'Mulut', img: 'assets/body/mouth.png'),
    VocabItem(en: 'Hand', id: 'Tangan', img: 'assets/body/hand.png'),
    VocabItem(en: 'Leg', id: 'Kaki', img: 'assets/body/feet.png'),
  ],
  'B5': [
    VocabItem(en: 'Book', id: 'Buku', img: dummyImg('📚')),
    VocabItem(en: 'Pen', id: 'Pulpen', img: dummyImg('🖊️')),
    VocabItem(en: 'Bag', id: 'Tas', img: dummyImg('🎒')),
    VocabItem(en: 'Chair', id: 'Kursi', img: dummyImg('🪑')),
    VocabItem(en: 'Table', id: 'Meja', img: 'assets/school/table.svg'),
    VocabItem(en: 'Teacher', id: 'Guru', img: 'assets/school/teacher.svg'),
  ],
  'B6': [
    VocabItem(en: 'Hat', id: 'Topi', img: dummyImg('🎩')),
    VocabItem(en: 'Shirt', id: 'Kemeja', img: dummyImg('👕')),
    VocabItem(en: 'Pants', id: 'Celana', img: dummyImg('👖')),
    VocabItem(en: 'Shoes', id: 'Sepatu', img: dummyImg('👟')),
    VocabItem(en: 'Socks', id: 'Kaos kaki', img: dummyImg('🧦')),
    VocabItem(en: 'Dress', id: 'Gaun', img: dummyImg('👗')),
  ],
  'B7': [
    VocabItem(en: 'House', id: 'Rumah', img: dummyImg('🏠')),
    VocabItem(en: 'Living room', id: 'Ruang tamu', img: dummyImg('🛋️')),
    VocabItem(en: 'Bedroom', id: 'Kamar tidur', img: dummyImg('🛏️')),
    VocabItem(en: 'Kitchen', id: 'Dapur', img: dummyImg('🍳')),
    VocabItem(en: 'Bathroom', id: 'Kamar mandi', img: dummyImg('🚿')),
    VocabItem(en: 'Garden', id: 'Taman', img: dummyImg('🌿')),
  ],
  'B8': [
    VocabItem(en: 'Cat', id: 'Kucing', img: 'assets/animal/kucing.jpeg', backImg: 'assets/animal/sl_cat.gif'),
    VocabItem(en: 'Dog', id: 'Anjing', img: 'assets/animal/dog.png', backImg: 'assets/animal/sl_dog.gif'),
    VocabItem(en: 'Bird', id: 'Burung', img: 'assets/animal/bird.png', backImg: 'assets/animal/sl_bird.gif'),
    VocabItem(en: 'Fish', id: 'Ikan', img: dummyImg('🐟')),
    VocabItem(en: 'Monkey', id: 'Monyet', img: 'assets/animal/monkey.png', backImg: 'assets/animal/sl_monkey.gif'),
    VocabItem(en: 'Elephant', id: 'Gajah', img: 'assets/animal/elephant.png', backImg: 'assets/animal/sl_elephant.gif'),
  ],
  'B9': [
    VocabItem(en: 'Father', id: 'Ayah', img: dummyImg('👨')),
    VocabItem(en: 'Mother', id: 'Ibu', img: dummyImg('👩')),
    VocabItem(en: 'Brother', id: 'Saudara laki-laki', img: dummyImg('👦')),
    VocabItem(en: 'Sister', id: 'Saudara perempuan', img: dummyImg('👧')),
    VocabItem(en: 'Grandfather', id: 'Kakek', img: dummyImg('👴')),
    VocabItem(en: 'Grandmother', id: 'Nenek', img: dummyImg('👵')),
  ],
  'B10': [
    VocabItem(en: 'Morning', id: 'Pagi', img: dummyImg('🌅')),
    VocabItem(en: 'Afternoon', id: 'Siang', img: dummyImg('☀️')),
    VocabItem(en: 'Evening', id: 'Sore', img: dummyImg('🌆')),
    VocabItem(en: 'Night', id: 'Malam', img: dummyImg('🌙')),
    VocabItem(en: 'Today', id: 'Hari ini', img: dummyImg('📅')),
    VocabItem(en: 'Birthday', id: 'Ulang tahun', img: dummyImg('🎂')),
  ],
  'default': [
    VocabItem(en: 'Coming Soon', id: 'Segera Hadir', img: 'assets/logo.png'),
  ]
};
