class Onboarding {
  final String title;
  final String subtitle;
  final String image;

  const Onboarding({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Onboarding &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          image == other.image;

  @override
  int get hashCode => title.hashCode ^ image.hashCode;
}
