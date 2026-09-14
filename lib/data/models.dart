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

class VocabItem {
  final String en;
  final String id;
  final String img;
  final String? backImg;

  const VocabItem({
    required this.en,
    required this.id,
    required this.img,
    this.backImg,
  });
}
