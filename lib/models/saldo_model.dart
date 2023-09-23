class SaldoModel {
  int? id;

  int? saldo;
  String?  createdAt, updatedAt;

  SaldoModel(
      {this.id,  this.saldo, this.createdAt, this.updatedAt});

  factory SaldoModel.fromJson(Map<String, dynamic> json) {
    return SaldoModel(
      id: json['id'],
      saldo: json['saldo'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
