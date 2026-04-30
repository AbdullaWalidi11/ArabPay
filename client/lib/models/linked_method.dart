class LinkedMethod {
  final String id;
  final String type; // 'bank' or 'wallet'
  final String provider;
  final String accountEnding;
  final String country;
  final String currency;
  final bool isActive;
  double balance;

  LinkedMethod({
    required this.id,
    required this.type,
    required this.provider,
    required this.accountEnding,
    required this.country,
    required this.currency,
    required this.isActive,
    this.balance = 5000.0, // Mock initial balance
  });

  factory LinkedMethod.fromJson(Map<String, dynamic> json) {
    return LinkedMethod(
      id: json['id'],
      type: json['type'],
      provider: json['provider'],
      accountEnding: json['account_ending'],
      country: json['country'],
      currency: json['currency'],
      isActive: json['is_active'],
      balance: (json['balance'] ?? 5000.0).toDouble(),
    );
  }
}
