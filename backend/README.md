# PocketPact Backend Server

Node.js/Express backend with Plaid API integration for bank account linking.

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd backend
npm install
```

### 2. Get Plaid Credentials

1. Go to **https://dashboard.plaid.com/signup**
2. Sign up for a **free Plaid account**
3. After signup, navigate to **Team Settings** → **Keys**
4. Copy the following:
   - `client_id` (looks like: `63f9a1234567890abcdef123`)
   - `sandbox secret` (looks like: `1234567890abcdef1234567890abcdef`)

### 3. Configure Environment

```bash
# Copy the example env file
cp .env.example .env
```

Edit `.env` and add your credentials:

```env
PLAID_CLIENT_ID=your_client_id_here
PLAID_SECRET=your_sandbox_secret_here
PLAID_ENV=sandbox
PORT=3000
```

### 4. Start the Server

```bash
npm start
```

For development with auto-reload:

```bash
npm run dev
```

You should see:

```
🚀 PocketPact Backend Server Started!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📡 Server running on: http://localhost:3000
🌍 Environment: sandbox
```

## 📡 API Endpoints

### Health Check

```http
GET /api/health
```

### Create Link Token

```http
POST /api/create_link_token
Content-Type: application/json

{
  "user_id": "user_123"
}
```

### Exchange Public Token

```http
POST /api/exchange_public_token
Content-Type: application/json

{
  "public_token": "public-sandbox-xxx",
  "user_id": "user_123"
}
```

### Get Transactions

```http
POST /api/transactions
Content-Type: application/json

{
  "access_token": "access-sandbox-xxx",
  "start_date": "2024-01-01",
  "end_date": "2024-01-31"
}
```

### Get Account Balance

```http
POST /api/balance
Content-Type: application/json

{
  "access_token": "access-sandbox-xxx"
}
```

## 🔧 Update Flutter App Configuration

After starting the backend, update `lib/config/plaid_config.dart`:

```dart
class PlaidConfig {
  static const String environment = 'sandbox';
  static const String clientId = 'YOUR_CLIENT_ID_HERE';
  static const String backendUrl = 'http://localhost:3000/api';  // Update this!
  
  static const List<String> products = ['transactions', 'auth'];
  static const List<String> countryCodes = ['US'];
  static const String language = 'en';
}
```

## 🧪 Testing with Plaid Sandbox

Plaid sandbox uses test credentials:

- **Username**: `user_good`
- **Password**: `pass_good`
- **PIN**: `1234` (if required)

Search for "First Platypus Bank" when testing.

## 🐛 Troubleshooting

### "Plaid credentials not configured"

Make sure you:
1. Created `.env` file (not `.env.example`)
2. Added your actual credentials (not the placeholder text)
3. Restarted the server after editing `.env`

### "CORS error" from Flutter app

The server has CORS enabled by default, but if testing from web:
- Make sure backend URL in Flutter config matches server address
- Check that server is running on port 3000

### "Invalid client_id or secret"

Double-check credentials from Plaid Dashboard:
- Go to Team Settings → Keys
- Copy the **sandbox** secret (not development or production)
- Client ID should be the same across all environments

## 📝 Next Steps

1. ✅ Start this backend server
2. ✅ Update Flutter app's `PlaidConfig` with backend URL
3. ✅ Run your Flutter app
4. ✅ Go to Settings → Link Bank Account
5. ✅ Test with Plaid sandbox credentials

## 🔒 Security Notes

⚠️ **Never commit `.env` to version control!**

For production:
- Use environment variables, not `.env` files
- Store access tokens in a secure database (currently in-memory)
- Implement proper authentication/authorization
- Use HTTPS
- Rate limit API endpoints
- Validate all user inputs

## 📚 Resources

- [Plaid Documentation](https://plaid.com/docs/)
- [Plaid Quickstart](https://plaid.com/docs/quickstart/)
- [Plaid API Reference](https://plaid.com/docs/api/)
