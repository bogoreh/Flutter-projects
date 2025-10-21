class MemoryCard {
  final int id;
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id,
      imagePath: imagePath,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}