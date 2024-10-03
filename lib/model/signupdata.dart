class SignupData {
  String? name;
  String? username; // for phone number in this case
  String? password;
  String? confirmPassword;
  String? email;
  String? roles;
  String? userProfile;
  int? id;

  SignupData({
    this.name,
    this.username,
    this.password,
    this.confirmPassword,
    this.email,
    this.userProfile,
  
  }) : roles = 'User';

  SignupData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        username = json['username'],
        password = json['password'],
        confirmPassword = json['confirmPassword'],
        email = json['email'],
        roles = json['roles'] ?? 'User',
        userProfile = json['userProfile'],
        id = json['id'];
      
        

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['userProfile'] = this.userProfile;
    return data;
  }
}
