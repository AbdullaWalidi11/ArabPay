import '../models/routing_rules.dart';
import '../models/linked_method.dart';

class RoutingResult {
  final LinkedMethod method;
  final double fee;
  final double estimatedTimeSeconds;

  RoutingResult({
    required this.method,
    required this.fee,
    required this.estimatedTimeSeconds,
  });
}

class RoutingEngine {
  final RoutingRules rules;
  final List<LinkedMethod> linkedMethods;

  RoutingEngine({
    required this.rules,
    required this.linkedMethods,
  });

  RoutingResult determineBestRoute(double amount) {
    LinkedMethod selectedMethod;
    double fee = 0.0;
    double estimatedTimeSeconds = 0.0;

    if (amount <= rules.smallPaymentsThreshold) {
      selectedMethod = linkedMethods.firstWhere(
        (m) => m.id == rules.preferredSmallRoute,
        orElse: () => linkedMethods.firstWhere((m) => m.type == 'wallet', orElse: () => linkedMethods.first),
      );
      // Small payments: 1.0 SAR flat fee
      fee = 1.0;
      estimatedTimeSeconds = 2.0; 
    } else {
      selectedMethod = linkedMethods.firstWhere(
        (m) => m.id == rules.preferredLargeRoute,
        orElse: () => linkedMethods.firstWhere((m) => m.type == 'bank', orElse: () => linkedMethods.first),
      );
      // Large payments: 0.5% fee + 5.0 SAR flat
      fee = 5.0 + (amount * 0.005); 
      estimatedTimeSeconds = 5.0; 
    }

    return RoutingResult(
      method: selectedMethod,
      fee: fee,
      estimatedTimeSeconds: estimatedTimeSeconds,
    );
  }
}
