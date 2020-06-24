class User{
  String userId;
  String name;
  String image;
  String status;
  String thumb_image;

  User({this.userId, this.name, this.image, this.status, this.thumb_image});



  void setUid(String uid){this.userId=uid;}
  String getUid(){return userId;}

  void setName(String name){this.name=name;}
  String getName(){return name;}

  void setImage(String image){this.image=image;}
  String getImage(){return image;}

  void setStatus(String status){this.status=status;}
  String getStatus(){return status;}


}