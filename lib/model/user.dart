class User {
  String username;
  String password;
  User({
    this.username,
    this.password,
});

  Map<String,dynamic> ToMap(){
    return {
      'username':username,
      'password':password,
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Username:'+username+',Password:'+password;
  }
}