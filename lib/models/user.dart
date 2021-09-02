enum Roles {
  anonymous,
  admin,
  viewer
}


class User {

  User({required this.username,required this.password, this.token});

  String username="";
  String password="";
  String? token;

  List<Roles> roles=[];
  Roles selectedRole=Roles.anonymous;



  User.empty();

  User.fromDbMap(Map<String, dynamic> map) {
    if (map.containsKey("token")){
        this.token = (map['token']!=null)?map['password']:"";
    }
    this.username = (map['username']!=null)?map['password']:"";
    this.password = (map['password']!=null)?map['password']:"";
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = token!=null?token.toString():null;
    map["username"] = username;
    map["password"] = password;
    return map;
  }


  setResetRuoli(List<Roles> richRuols){
    richRuols.forEach((element) {
      this.roles.remove(element);
    });
    this.roles.addAll(richRuols);
  }

  setRuoli(List<Roles> richRuols){
    richRuols.forEach((element) {
      this.roles.remove(element);
    });
    this.roles.addAll(richRuols);
  }



}