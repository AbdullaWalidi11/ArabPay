import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/linked_method.dart';
import '../models/transaction.dart';
import '../models/routing_rules.dart';
import '../services/backend_service.dart';
import '../services/routing_engine.dart';

class AppProvider with ChangeNotifier {
  final BackendService _backendService = BackendService();
  RoutingEngine? routingEngine;

  User? currentUser;
  List<LinkedMethod> linkedMethods = [];
  List<AppTransaction> recentTransactions = [];
  RoutingRules? routingRules;

  bool isLoading = false;
  String? error;

  Future<void> loadInitialData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _backendService.init();
      currentUser = await _backendService.getUser();
      linkedMethods = await _backendService.getLinkedMethods();
      recentTransactions = await _backendService.getRecentTransactions();
      routingRules = await _backendService.getRoutingRules();

      routingEngine = RoutingEngine(
        rules: routingRules!,
        linkedMethods: linkedMethods,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  RoutingResult? getRouteResult(double amount) {
    return routingEngine?.determineBestRoute(amount);
  }

  Future<bool> claimIdentity(String requestedId) async {
    isLoading = true;
    notifyListeners();

    bool isUnique = await _backendService.validateId(requestedId);
    
    if (isUnique && currentUser != null) {
      currentUser = User(
        id: currentUser!.id,
        arabPayId: requestedId.contains('@arabpay') ? requestedId : '$requestedId@arabpay',
        name: '', // Removing name as requested
        balance: currentUser!.balance,
        currency: currentUser!.currency,
        isVerified: currentUser!.isVerified,
      );
    }
    
    isLoading = false;
    notifyListeners();
    return isUnique;
  }
  
  void updateBalance(double newBalance) {
    if (currentUser != null) {
      currentUser = User(
        id: currentUser!.id,
        arabPayId: currentUser!.arabPayId,
        name: currentUser!.name,
        balance: newBalance,
        currency: currentUser!.currency,
        isVerified: currentUser!.isVerified,
      );
      notifyListeners();
    }
  }

  void addLinkedMethod(LinkedMethod method) {
    linkedMethods.add(method);
    notifyListeners();
  }

  // Use BackendService for encryption simulation
  Future<String> encryptInstruction(String payload) {
    return _backendService.encryptInstruction(payload);
  }
}
