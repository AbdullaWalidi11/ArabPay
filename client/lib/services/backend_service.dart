import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/linked_method.dart';
import '../models/transaction.dart';
import '../models/routing_rules.dart';

class BackendService {
  Map<String, dynamic>? _mockData;
  final String baseUrl = 'http://127.0.0.1:3000';

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

  // ==========================================
  // REAL API CALL: Create Alias
  // ==========================================
  Future<Map<String, dynamic>?> createAlias(String requestedAlias) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'requestedAlias': requestedAlias}),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body); 
      } else {
        print('Backend rejected: ${response.body}');
        return null;
      }
    } catch (e) {
      print('HTTP Connection Error: $e');
      return null;
    }
  }

  // validateId with 1.2s delay
  Future<bool> validateId(String id) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Simulation: "ahmed", "ali", "sara", "ayman" are taken
    final normalized = id.toLowerCase().trim().replaceFirst('@arabpay', '');
    if (normalized == 'ahmed' || normalized == 'ali' || normalized == 'sara' || normalized == 'ayman') {
      return false; // Not unique
    }
    return true; // Unique
  }

  Future<Map<String, String>?> getReceiverInfo(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final normalizedId = id.replaceAll('@', '').toLowerCase().replaceFirst('arabpay', '');
    
    // 1. Static high-profile users
    final knownUsers = {
      'ahmed': {'name': 'Ahmed Al-Saud', 'status': 'Verified Member'},
      'sara': {'name': 'Sara Khalid', 'status': 'Trusted Member'},
      'ali': {'name': 'Ali Mansoor', 'status': 'Verified Member'},
      'hassan': {'name': 'Hassan Salem', 'status': 'Verified Member'},
      'faisal': {'name': 'Faisal Al-Fahad', 'status': 'Trusted Member'},
      'osama': {'name': 'Osama Bin Zaid', 'status': 'Verified Member'},
      'ayman': {'name': 'Ayman Mohammed', 'status': 'Verified Member'},
      'azzam': {'name': 'Azzam Al-Khatib', 'status': 'Verified Member'},
    };

    if (knownUsers.containsKey(normalizedId)) {
      return knownUsers[normalizedId];
    }

    // 2. Pattern-based fallback for "everyone" on the backend
    // If it looks like a valid alias, we "find" them
    if (normalizedId.length >= 3) {
      final capitalizedName = normalizedId[0].toUpperCase() + normalizedId.substring(1);
      return {
        'name': capitalizedName,
        'status': 'Verified Member',
      };
    }

    return null;
  }

  // encryptInstruction simulation
  Future<String> encryptInstruction(String payload) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Latency
    var bytes = utf8.encode(payload); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
