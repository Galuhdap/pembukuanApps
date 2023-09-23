class KeranjangModel {
    int? id, id_bahan;

  int? total;
  int? jumlah, stock;
  String? nama,deskripsi ,createdAt , updatedAt;

  KeranjangModel(
    {this.id,this.id_bahan, this.nama,this.deskripsi, this.stock, this.jumlah , this.total , this.createdAt , this.updatedAt}
  );

  factory KeranjangModel.fromJson(Map<String, dynamic> json){
    return KeranjangModel(
       id: json['id'],
       id_bahan: json['id_bahan'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      stock: json['stock'],
      jumlah: json['jumlah'],
      total: json['total'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}