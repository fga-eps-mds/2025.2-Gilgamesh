class UserModel {
  final int id;
  final String username;
  final String email;
  final String type; 
  final String? token; 

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.type,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      type: (json['is_ong'] == true) ? 'ONG' : 'DOADOR',
      token: json['token'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'type': type,
      'token': token,
    };
  }
}