class SaldopenjualanModel {
  int? id;

  int? total, ongkir;
  String?  createdAt, updatedAt;

  SaldopenjualanModel(
      {this.id,  this.total,this.ongkir, this.createdAt, this.updatedAt});

  factory SaldopenjualanModel.fromJson(Map<String, dynamic> json) {
    return SaldopenjualanModel(
      id: json['id'],
      total: json['total'],
      ongkir: json['ongkir'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}