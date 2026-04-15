// Plaid Service
// Handles all Plaid bank linking functionality
// NOTE: This is a stub implementation. Complete it when backend is ready.
// 
// Required backend endpoints:
// - POST /create_link_token - Creates Plaid link token
// - POST /exchange_public_token - Exchanges public token for access token
// - POST /transactions - Fetches transactions
// - POST /balance - Gets account balance

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import '../config/plaid_config.dart';

class PlaidService {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'plaid_access_token';

  /// Complete bank linking flow
  /// Returns true if successful
  Future<bool> linkBankAccount({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      // Step 1: Get link token from backend
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connecting to Plaid...')),
        );
      }
      
      final linkToken = await getLinkTokenFromBackend(userId: userId);
      
      if (linkToken == null) {
        throw Exception('Failed to get link token from backend');
      }

      debugPrint('✅ Got link token: ${linkToken.substring(0, 20)}...');

      // Step 2: Set up stream listeners before creating Link
      StreamSubscription<LinkSuccess>? successSubscription;
      StreamSubscription<LinkExit>? exitSubscription;
      StreamSubscription<LinkEvent>? eventSubscription;

      try {
        // Listen to success events
        successSubscription = PlaidLink.onSuccess.listen((success) async {
          debugPrint('✅ Plaid Link Success!');
          debugPrint('   Public Token: ${success.publicToken.substring(0, 20)}...');
          debugPrint('   Metadata: ${success.metadata}');

          // Step 3: Exchange public token for access token
          final accessToken = await exchangePublicToken(success.publicToken);
          
          if (accessToken != null) {
            debugPrint('✅ Access token received and stored');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bank account linked successfully! 🎉'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            throw Exception('Failed to exchange token');
          }
        });

        // Listen to exit events
        exitSubscription = PlaidLink.onExit.listen((exit) {
          if (exit.error != null) {
            debugPrint('❌ Plaid Link Error: ${exit.error?.message}');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${exit.error?.message ?? "Unknown error"}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            debugPrint('ℹ️ User exited Plaid Link');
          }
        });

        // Listen to events (optional, for debugging)
        eventSubscription = PlaidLink.onEvent.listen((event) {
          debugPrint('Plaid Event: ${event.name}');
        });

        // Step 3: Create PlaidLink with configuration
        await PlaidLink.create(
          configuration: LinkTokenConfiguration(
            token: linkToken,
          ),
        );

        // Step 4: Open Plaid Link UI
        await PlaidLink.open();
      } finally {
        // Clean up subscriptions after a delay to allow events to be processed
        Future.delayed(const Duration(seconds: 5), () {
          successSubscription?.cancel();
          exitSubscription?.cancel();
          eventSubscription?.cancel();
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ Error linking bank account: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
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
