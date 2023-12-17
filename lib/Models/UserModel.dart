class UserModel {
  String? name;
  String? id;
  String? email;
  String? imgUrl="";
  UserModel({this.email, this.id, this.name, this.imgUrl });


  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json['name'],
      email: json['email'],
      id: json['id'],
      imgUrl: json['imgUrl']

    );
  }

  Map<String, dynamic> toJson(){
    return {

      "email": email,
      "name": name,
      "id":id,
      "imgUrl":imgUrl
    };
  }
}