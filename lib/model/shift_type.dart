class ShiftType {
  final int id;
  final String description;

  ShiftType({this.id, this.description});

  factory ShiftType.fromMap(Map<String, dynamic> map) =>
      ShiftType(
        id: map['id'] as int,
        description: map['description'] as String,
      );
}