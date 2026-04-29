class User {
  final String id;
  final String arabPayId;
  final String name;
  final double balance;
  final String currency;
  final bool isVerified;

  User({
    required this.id,
    required this.arabPayId,
    required this.name,
    required this.balance,
    required this.currency,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      arabPayId: json['arabpay_id'],
      name: json['name'],
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'],
      isVerified: json['is_verified'],
    );
  }
}
