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
    error = null;
    notifyListeners();

    // 1. Hit the real Node.js Express backend!
    final responseData = await _backendService.createAlias(requestedId);
    
    if (responseData != null && currentUser != null) {
      // 2. Extract the real generated data from the Node.js response
      final backendUser = responseData['user'];
      
      // 3. Update the Flutter state with the REAL backend data
      currentUser = User(
        id: backendUser['uuid'],              // The real generated UUID!
        arabPayId: backendUser['alias'],      // formatted 'ali@arabpay'
        name: backendUser['displayName'],     // The auto-capitalized name!
        balance: currentUser!.balance,        // Keep mock balance for now
        currency: currentUser!.currency,
        isVerified: currentUser!.isVerified,
      );
      
      isLoading = false;
      notifyListeners();
      return true; // Success! Flutter will navigate to the Success screen.
    }
    
    isLoading = false;
    error = 'Alias is already taken or server is offline';
    notifyListeners();
    return false;
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
