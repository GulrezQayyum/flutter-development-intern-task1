class UserProfile {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String city;
  final String companyName;


  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.city,
    required this.companyName,
});

  String get avatarUrl =>   'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E88E5&color=fff&size=256';


  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final company = json['company'] as Map<String, dynamic>? ?? {};
    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      city: address['city'] as String? ?? '',
      companyName: company['name'] as String? ?? '',
    );
  }
}