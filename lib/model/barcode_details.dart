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
