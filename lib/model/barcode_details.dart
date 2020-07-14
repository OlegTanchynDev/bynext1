class BarcodeDetails {
  final int id;
  final int status;
  final int type;
  final String barcode;

  const BarcodeDetails({
    this.id,
    this.status,
    this.type,
    this.barcode,
  });

  factory BarcodeDetails.fromMap(Map<String, dynamic> map) {
    return BarcodeDetails(
      id: map['id'] as int,
      status: map['status'] as int,
      type: map['type'] as int,
      barcode: map['barcode'] as String,
    );
  }
}

class OrderNote{
  final String text;
  final String image;
  final DateTime addedOn;

  OrderNote({
    this.text,
    this.image,
    this.addedOn,
  });

  factory OrderNote.fromMap(Map<String, dynamic> map){
    return OrderNote(
      text: map['text'] as String,
      image: map['image'] as String,
      addedOn: DateTime.tryParse(map['added_on'] as String),
    );
  }
}