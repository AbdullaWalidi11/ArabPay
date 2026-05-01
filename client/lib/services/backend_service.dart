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
    final String response =
        await rootBundle.loadString('assets/data/mock_data.json');
    _mockData = json.decode(response);
  }

  Future<User> getUser() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/users/profile/ahmed123'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userMap = data['user'];
        return User(
          id: userMap['uuid'],
          arabPayId: userMap['alias'],
          name: userMap['displayName'],
          balance: 0.0, // We'll sum this from linked methods
          currency: "SAR",
          isVerified: userMap['verified'],
        );
      }
    } catch (e) {
      print("Fetch user error: $e");
    }

    // Fallback to mock
    if (_mockData == null) await init();
    return User.fromJson(_mockData!['user']);
  }

  Future<List<LinkedMethod>> getLinkedMethods() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/users/profile/ahmed123'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List methods = data['user']['linkedAccounts'];
        return methods.map((e) {
          return LinkedMethod(
            id: e['id'],
            type: e['type'],
            provider: e['provider'],
            accountEnding: e['id'].toString().length > 4
                ? e['id'].toString().substring(e['id'].toString().length - 4)
                : '0000',
            country: e['country'],
            currency: e['currency'],
            isActive: true,
            balance: (e['balance'] ?? 0).toDouble(),
          );
        }).toList();
      }
    } catch (e) {
      print("Fetch methods error: $e");
    }

    // Fallback to mock
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

  // ==========================================
  // REAL API CALL: Validate ID Availability
  // ==========================================
  Future<bool> validateId(String id) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Simulation: "ahmed", "ali", "sara", "ayman" are taken
    final normalized = id.toLowerCase().trim().replaceFirst('@arabpay', '');
    if (normalized == 'ahmed' ||
        normalized == 'ali' ||
        normalized == 'sara' ||
        normalized == 'ayman') {
      return false; // Not unique
    }
    return true; // Unique
  }

  Future<Map<String, String>?> getReceiverInfo(String id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/users/resolve/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'name': data['user']['displayName'],
          'status': data['user']['verified'] ? 'Verified Member' : 'Member',
          'country': data['user']['country']
        };
      }
      return null;
    } catch (e) {
      print('HTTP Connection Error: $e');
      return null;
    }
  }

  // ==========================================
  // REAL API CALL: Evaluate Transfer (Stage 2)
  // ==========================================
  Future<Map<String, dynamic>?> evaluateTransfer(
      String senderUuid, String receiverAlias) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/transfers/evaluate'),
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({'senderUuid': senderUuid, 'receiverAlias': receiverAlias}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('HTTP Connection Error: $e');
      return null;
    }
  }

  // encryptInstruction simulation
  Future<String> encryptInstruction(String payload) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Latency
    var bytes = utf8.encode(payload); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ==========================================
  // REAL API CALL: Link Account
  // ==========================================
  Future<Map<String, dynamic>?> linkAccount({
    required String uuid,
    required String type,
    required String provider,
    required String country,
    required String currency,
    double? balance,
    bool isPreferred = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/link-account'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uuid': uuid,
          'type': type,
          'provider': provider,
          'country': country,
          'currency': currency,
          'balance': balance,
          'isPreferred': isPreferred,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Link Account Error: $e');
      return null;
    }
  }

  // ==========================================
  // REAL API CALL: Execute Transfer (Stage 4)
  // ==========================================
  Future<Map<String, dynamic>?> executeTransfer({
    required String senderUuid,
    required String senderAccountId,
    required String receiverAlias,
    required String receiverAccountId,
    required double amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/transfers/execute'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'senderUuid': senderUuid,
          'senderAccountId': senderAccountId,
          'receiverAlias': receiverAlias,
          'receiverAccountId': receiverAccountId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Transfer failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('HTTP Connection Error: $e');
      return null;
    }
  }
}
