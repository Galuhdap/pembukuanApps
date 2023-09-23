class ProdukModel {
    int? id;


  int? stock, harga_pokok, harga_jual;
  String? nama,deskripsi,sku,satuan ,createdAt , updatedAt;

  ProdukModel(
    {this.id, this.nama,this.deskripsi,this.sku, this.stock ,this.satuan , this.harga_pokok,this.harga_jual, this.createdAt , this.updatedAt}
  );

  factory ProdukModel.fromJson(Map<String, dynamic> json){
    return ProdukModel(
       id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      sku: json['sku'],
      stock: json['stock'],
      satuan: json['satuan'],
      harga_pokok: json['harga_pokok'],
      harga_jual: json['harga_jual'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}