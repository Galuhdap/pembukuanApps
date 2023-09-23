class KasModel {
  int? id;

  int? biaya;
  String? deskripsi, createdAt, updatedAt;

  KasModel(
      {this.id, this.deskripsi, this.biaya, this.createdAt, this.updatedAt});

  factory KasModel.fromJson(Map<String, dynamic> json) {
    return KasModel(
      id: json['id'],
      deskripsi: json['deskripsi'],
      biaya: json['biaya'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
