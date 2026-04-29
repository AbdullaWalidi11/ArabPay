class AppTransaction {
  final String id;
  final DateTime date;
  final double amount;
  final String currency;
  final String recipientId;
  final String recipientName;
  final String status;
  final String routeUsed;

  AppTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.currency,
    required this.recipientId,
    required this.recipientName,
    required this.status,
    required this.routeUsed,
  });

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    return AppTransaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      recipientId: json['recipient_id'],
      recipientName: json['recipient_name'],
      status: json['status'],
      routeUsed: json['route_used'],
    );
  }
}
