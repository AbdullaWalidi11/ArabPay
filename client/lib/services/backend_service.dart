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

  // ==========================================
  // REAL API CALL: Validate ID Availability
  // ==========================================
  Future<bool> validateId(String id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/users/resolve/$id'));
      // If 404, it means it's available! If 200, it's taken.
      return response.statusCode == 404;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // REAL API CALL: Get Receiver Info
  // ==========================================
  Future<Map<String, dynamic>?> getReceiverInfo(String id) async {
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
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // REAL API CALL: Save Contact
  // ==========================================
  Future<bool> saveContact(
      String uuid, String targetAlias, String customName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/save-contact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uuid': uuid,
          'targetAlias': targetAlias,
          'customName': customName,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // encryptInstruction simulation
  Future<String> encryptInstruction(String payload) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Latency
    var bytes = utf8.encode(payload); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
