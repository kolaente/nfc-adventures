class ScannedNfcTag {
  final String uid;
  final String name;
  final DateTime scannedAt;

  ScannedNfcTag({
    required this.uid,
    required this.name,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory ScannedNfcTag.fromJson(Map<String, dynamic> json) {
    return ScannedNfcTag(
      uid: json['uid'],
      name: json['name'],
      scannedAt: DateTime.parse(json['scannedAt']),
    );
  }
}
