class UserDetails {
  String? id;
  String? name;
  String? phoneNumber;

  UserDetails({this.id, this.name, this.phoneNumber});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
      };

  static UserDetails fromJson(Map<dynamic, dynamic> json) => UserDetails(
        id: json['id'] as String?,
        name: json['name'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
      );

  @override
  String toString() {
    return 'UserInfo{id: $id, name: $name, phoneNumber: $phoneNumber}';
  }
}
