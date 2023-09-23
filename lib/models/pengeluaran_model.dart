class PengeluaranModel {
    int? id;
  int? biaya;
  String? nama_pengeluaran, createdAt , updatedAt;

  PengeluaranModel(
    {this.id, this.nama_pengeluaran, this.biaya, this.createdAt , this.updatedAt}
  );

  factory PengeluaranModel.fromJson(Map<String, dynamic> json){
    return PengeluaranModel(
       id: json['id'],
      nama_pengeluaran: json['nama_pengeluaran'],
      biaya: json['biaya'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}