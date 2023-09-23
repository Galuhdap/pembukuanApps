class PembelianModel {
    int? id;

  int? jmlh_brng;
  int? harga;
  String? nama_barang,satuan ,createdAt , updatedAt;

  PembelianModel(
    {this.id, this.nama_barang, this.satuan , this.jmlh_brng, this.harga, this.createdAt , this.updatedAt}
  );

  factory PembelianModel.fromJson(Map<String, dynamic> json){
    return PembelianModel(
       id: json['id'],
      nama_barang: json['nama_barang'],
      satuan: json['satuan'],
      jmlh_brng: json['jmlh_brng'],
      harga: json['harga'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}