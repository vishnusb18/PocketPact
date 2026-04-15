// Plaid Configuration
// Contains Plaid API settings and environment configuration
// NOTE: In production, store these securely (environment variables, Firebase Remote Config, etc.)

class PlaidConfig {
  // Plaid Environment
  // Use 'sandbox' for development, 'production' for live
  static const String environment = 'sandbox';
  
  // Your Plaid Client ID (get from Plaid Dashboard)
  // Get from: https://dashboard.plaid.com/team/keys
  // TODO: Replace with your actual Plaid client_id after signing up
  static const String clientId = '69bf2031f69c58000c95f2b7';
  
  // Backend server URL for token exchange
  // This is YOUR Node.js server that communicates with Plaid
  // For local development: http://localhost:3000/api
  // For Android emulator: http://10.0.2.2:3000/api
  // For production: https://your-backend-server.com/api
  static const String backendUrl = 'http://10.0.2.2:3000/api';
  
  // Plaid Products to use
  static const List<String> products = ['transactions', 'auth'];
  
  // Country codes
  static const List<String> countryCodes = ['US'];
  
  // Language
  static const String language = 'en';
  
  // Webhook URL (optional, for transaction updates)
  static const String? webhookUrl = null;
  
  // Link customization
  static const String linkCustomizationName = 'PocketPact';
  
  // Is sandbox mode?
  static bool get isSandbox => environment == 'sandbox';
}
