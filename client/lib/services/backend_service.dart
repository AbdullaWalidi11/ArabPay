import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';

import '../models/user.dart';
import '../models/linked_method.dart';
import '../models/transaction.dart';
import '../models/routing_rules.dart';

class BackendService {
  Map<String, dynamic>? _mockData;

  Future<void> init() async {
    final String response = await rootBundle.loadString('assets/data/mock_data.json');
    _mockData = json.decode(response);
  }

  Future<User> getUser() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    if (_mockData == null) await init();
    return User.fromJson(_mockData!['user']);
  }

  Future<List<LinkedMethod>> getLinkedMethods() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_mockData == null) await init();
    return (_mockData!['linked_methods'] as List)
        .map((e) => LinkedMethod.fromJson(e))
        .toList();
  }

  Future<List<AppTransaction>> getRecentTransactions() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (_mockData == null) await init();
    return (_mockData!['recent_transactions'] as List)
        .map((e) => AppTransaction.fromJson(e))
        .toList();
  }

  Future<RoutingRules> getRoutingRules() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_mockData == null) await init();
    return RoutingRules.fromJson(_mockData!['routing_rules']);
  }

  // validateId with 1.2s delay
  Future<bool> validateId(String id) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Simulation: "ahmed" is taken
    if (id.toLowerCase() == 'ahmed') {
      return false; // Not unique
    }
    return true; // Unique
  }

  // encryptInstruction simulation
  Future<String> encryptInstruction(String payload) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Latency
    var bytes = utf8.encode(payload); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
