class PenjualanModel {
    int? id;

  int? total, jumlah_produk, ongkos_kirim, biaya_lain, potongan_harga, subtotal ,total_produk;
  String? nama,nama_pembeli, tgl, produk, pembayaran ,createdAt , updatedAt;
 
  PenjualanModel(
    {this.id, this.nama,this.nama_pembeli,this.produk,this.jumlah_produk,this.total_produk,this.biaya_lain, this.pembayaran,this.subtotal , this.ongkos_kirim , this.potongan_harga ,this.tgl,this.total, this.createdAt , this.updatedAt}
  );

  factory PenjualanModel.fromJson(Map<String, dynamic> json){
    return PenjualanModel(
       id: json['id'],
      nama: json['nama'],
      nama_pembeli: json['nama_pembeli'],
      produk: json['produk'],
      jumlah_produk: json['jumlah_produk'],
      total_produk: json['total_produk'],
      subtotal: json['subtotal'],
      biaya_lain: json['biaya_lain'],
      ongkos_kirim: json['ongkos_kirim'],
      potongan_harga: json['potongan_harga'],
      tgl: json['tgl'],
      pembayaran: json['pembayaran'],
      total: json['total'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}