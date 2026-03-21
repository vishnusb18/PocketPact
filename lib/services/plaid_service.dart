// Plaid Service
// Handles all Plaid bank linking functionality
// NOTE: This is a stub implementation. Complete it when backend is ready.
// 
// Required backend endpoints:
// - POST /create_link_token - Creates Plaid link token
// - POST /exchange_public_token - Exchanges public token for access token
// - POST /transactions - Fetches transactions
// - POST /balance - Gets account balance

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/plaid_config.dart';

class PlaidService {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'plaid_access_token';

  // TODO: Implement Plaid Link integration using plaid_flutter package
  // Check plaid_flutter documentation for exact API calls
  
  /// Complete bank linking flow
  /// Returns true if successful
  Future<bool> linkBankAccount({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      // TODO: Implement the following steps:
      // 1. Get link token from backend
      // 2. Open Plaid Link UI with LinkConfiguration
      // 3. On success, exchange public token for access token
      // 4. Store access token securely
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plaid integration coming soon! Backend required.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      
      // For demo purposes, simulate linking
      await Future.delayed(const Duration(seconds: 1));
      await _storage.write(key: _accessTokenKey, value: 'demo_token_12345');
      
      return true;
    } catch (e) {
      debugPrint('Error linking bank account: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      return false;
    }
  }

  /// Get link token from backend
  Future<String?> getLinkTokenFromBackend({required String userId}) async {
    try {
      final response = await http.post(
        Uri.parse('${PlaidConfig.backendUrl}/create_link_token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['link_token'] as String?;
      }
      debugPrint('Failed to get link token: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Error getting link token: $e');
      return null;
    }
  }

  /// Exchange public token for access token
  Future<String?> exchangePublicToken(String publicToken) async {
    try {
      final response = await http.post(
        Uri.parse('${PlaidConfig.backendUrl}/exchange_public_token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'public_token': publicToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['access_token'] as String?;
        
        if (accessToken != null) {
          await _storage.write(key: _accessTokenKey, value: accessToken);
        }
        
        return accessToken;
      }
      debugPrint('Failed to exchange token: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('Error exchanging public token: $e');
      return null;
    }
  }

  /// Get transactions from backend
  Future<List<Map<String, dynamic>>> getTransactions({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final accessToken = await _storage.read(key: _accessTokenKey);
      if (accessToken == null) return [];

      final response = await http.post(
        Uri.parse('${PlaidConfig.backendUrl}/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'access_token': accessToken,
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['transactions'] ?? []);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      return [];
    }
  }

  /// Get account balance from backend
  Future<Map<String, dynamic>?> getAccountBalance() async {
    try {
      final accessToken = await _storage.read(key: _accessTokenKey);
      if (accessToken == null) return null;

      final response = await http.post(
        Uri.parse('${PlaidConfig.backendUrl}/balance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'access_token': accessToken}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching balance: $e');
      return null;
    }
  }

  /// Check if user has linked account
  Future<bool> hasLinkedAccount() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    return accessToken != null;
  }

  /// Remove linked account
  Future<void> unlinkAccount() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }
}
