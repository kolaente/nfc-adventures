class Adventure {
  final String id;
  final String title;

  Adventure({
    required this.id,
    required this.title,
  });

  factory Adventure.fromJson(String id, String title) {
    return Adventure(
      id: id,
      title: title,
    );
  }
}
