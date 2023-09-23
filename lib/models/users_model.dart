class UserModel {
  int? id;

  int? status;
  String? nama, alamat, prov,email, kota , notelp, createdAt , updatedAt;

  UserModel(
    {this.id, this.nama , this.alamat , this.notelp ,this.email, this.prov, this.kota ,this.status, this.createdAt , this.updatedAt}
  );

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
       id: json['id'],
      nama: json['nama'],
      notelp: json['notelp'],
      email: json['email'],
      alamat: json['alamat'],
      prov: json['prov'],
      kota: json['kota'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}