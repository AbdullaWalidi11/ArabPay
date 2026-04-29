class RoutingRules {
  final double smallPaymentsThreshold;
  final String preferredSmallRoute;
  final String preferredLargeRoute;

  RoutingRules({
    required this.smallPaymentsThreshold,
    required this.preferredSmallRoute,
    required this.preferredLargeRoute,
  });

  factory RoutingRules.fromJson(Map<String, dynamic> json) {
    return RoutingRules(
      smallPaymentsThreshold: (json['small_payments_threshold'] as num).toDouble(),
      preferredSmallRoute: json['preferred_small_route'],
      preferredLargeRoute: json['preferred_large_route'],
    );
  }
}
