class NfcTag {
  final String uid;
  final String name;
  final DateTime scannedAt;

  NfcTag({
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

  factory NfcTag.fromJson(Map<String, dynamic> json) {
    return NfcTag(
      uid: json['uid'],
      name: json['name'],
      scannedAt: DateTime.parse(json['scannedAt']),
    );
  }
}
