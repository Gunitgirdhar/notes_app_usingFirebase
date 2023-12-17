class NoteModel{
  String? title;
  String? body;
  String? id;

  NoteModel({ this.title, this.body,this.id});

  factory NoteModel.fromJson(Map<String,dynamic> json){// used to get the data
    return NoteModel(
        title: json['title'],
        body: json['body'],
       // id: json['id']);hume id set nhi krni bcoz it is auto generated but id get to krni hn toh isliye yha pe id mention kri aur set krte time nhi kri
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "body":body,
      "title":title
    };
}

}