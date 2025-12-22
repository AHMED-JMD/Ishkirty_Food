class Managers {
  Managers({
    required this.adminId,
    required this.username,
    required this.phoneNum,
    required this.role,
    required this.shift,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String adminId;
  late final String username;
  late final int phoneNum;
  late final String role;
  late final String shift;
  late final String createdAt;
  late final String updatedAt;

  Managers.fromJson(Map<String, dynamic> json){
    adminId = json['admin_id'];
    username = json['username'];
    phoneNum = json['phoneNum'];
    role = json['role'];
    shift = json['shift'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['admin_id'] = adminId;
    _data['username'] = username;
    _data['phoneNum'] = phoneNum;
    _data['role'] = role;
    _data['shift'] = shift;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}