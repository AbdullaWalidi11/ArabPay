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
  List<Map<String, dynamic>>? configuredRoutingRules;

  bool isLoading = false;
  bool isCheckingAvailability = false;
  bool? isAliasAvailable;
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

  List<RoutingResult> evaluatedRoutes = [];
  Map<String, dynamic>? currentReceiverTarget;

  Future<void> evaluateTransfer(String receiverAlias) async {
    isLoading = true;
    error = null;
    notifyListeners();

    if (currentUser == null) return;

    final result = await _backendService.evaluateTransfer(currentUser!.id, receiverAlias);
    if (result != null && result['evaluation'] != null && result['evaluation']['success'] == true) {
      currentReceiverTarget = result['evaluation']['receiverTarget'];
      final List options = result['evaluation']['senderOptions'];
      
      evaluatedRoutes = options.map((opt) {
        return RoutingResult(
          method: LinkedMethod(
            id: opt['id'],
            type: opt['type'],
            provider: opt['provider'],
            currency: opt['currency'],
            country: opt['country'] ?? 'Unknown',
            accountEnding: opt['id'].toString().length > 4 ? opt['id'].toString().substring(opt['id'].toString().length - 4) : '0000',
            isActive: true,
            balance: (opt['balance'] ?? 0).toDouble(),
          ),
          fee: (opt['isRecommended'] ?? false) ? 0.0 : 5.0,
          estimatedTimeSeconds: 2.0,
          isOptimal: opt['isRecommended'] ?? false,
          matchReason: opt['matchReason'] ?? '',
        );
      }).toList();
    } else {
      error = "Failed to evaluate routes";
      evaluatedRoutes = [];
    }

    isLoading = false;
    notifyListeners();
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

  Future<bool> linkMethod({
    required String type,
    required String provider,
    required String country,
    required String currency,
    double? balance,
    bool isPreferred = false,
  }) async {
    if (currentUser == null) return false;
    
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await _backendService.linkAccount(
      uuid: currentUser!.id,
      type: type,
      provider: provider,
      country: country,
      currency: currency,
      balance: balance,
      isPreferred: isPreferred,
    );

    isLoading = false;
    if (result != null && result['account'] != null) {
      final newMethod = LinkedMethod.fromJson(result['account']);
      linkedMethods.add(newMethod);
      notifyListeners();
      return true;
    } else {
      error = "Failed to link account";
      notifyListeners();
      return false;
    }
  }

  void saveConfiguredRoutingRules(List<Map<String, dynamic>> rules) {
    configuredRoutingRules = rules.map((e) => Map<String, dynamic>.from(e)).toList();
    notifyListeners();
  }

  // Use BackendService for encryption simulation
  Future<String> encryptInstruction(String payload) async {
    isLoading = true;
    notifyListeners();
    try {
      return await _backendService.encryptInstruction(payload);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, String>?> verifyReceiver(String id) {
    return _backendService.getReceiverInfo(id);
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<void> checkAvailability(String id) async {
    if (id.isEmpty) {
      isAliasAvailable = null;
      notifyListeners();
      return;
    }

    isCheckingAvailability = true;
    error = null;
    notifyListeners();

    // Mock real-time check
    isAliasAvailable = await _backendService.validateId(id);
    
    isCheckingAvailability = false;
    notifyListeners();
  }

  void resetAvailability() {
    isAliasAvailable = null;
    isCheckingAvailability = false;
    notifyListeners();
  }

  void setAvailability(bool available) {
    isAliasAvailable = available;
    notifyListeners();
  }

  Future<bool> processTransaction({
    required double amount,
    required double fee,
    required LinkedMethod sourceMethod,
    required String receiverId,
    required String receiverName,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    
    // Simulate high-security processing
    await Future.delayed(const Duration(seconds: 2));

    final totalDeduction = amount + fee;

    bool success = false;
    if (sourceMethod.type == 'wallet' && currentUser != null) {
      if (currentUser!.balance >= totalDeduction) {
        updateBalance(currentUser!.balance - totalDeduction);
        success = true;
      } else {
        error = "Insufficient Wallet Balance";
      }
    } else {
      final methodIndex = linkedMethods.indexWhere((m) => m.id == sourceMethod.id);
      if (methodIndex != -1) {
        if (linkedMethods[methodIndex].balance >= totalDeduction) {
          linkedMethods[methodIndex].balance -= totalDeduction;
          success = true;
        } else {
          error = "Insufficient funds in ${sourceMethod.provider}";
        }
      }
    }

    if (success) {
      // Create a real transaction record
      final newTx = AppTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        date: DateTime.now(),
        amount: -amount, // Negative for outgoing
        currency: 'SAR',
        recipientId: receiverId,
        recipientName: receiverName,
        status: 'Completed',
        routeUsed: sourceMethod.provider,
      );
      
      recentTransactions.insert(0, newTx);
    }

    isLoading = false;
    notifyListeners();
    return success;
  }
}
