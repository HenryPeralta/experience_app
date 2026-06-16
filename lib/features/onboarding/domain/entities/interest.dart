class Interest {
  final String id;
  final String title;
  final bool isSelected;

  const Interest({
    required this.id,
    required this.title,
    required this.isSelected,
  });

  Interest copyWith({
    String? id,
    String? title,
    bool? isSelected,
  }) {
    return Interest(
      id: id ?? this.id,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Interest &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
