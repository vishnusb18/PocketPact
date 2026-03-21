# 🏦 Plaid Integration Setup Guide

Complete step-by-step guide to set up Plaid bank linking in PocketPact.

## 📋 Prerequisites

- Node.js 14+ installed
- Flutter app already set up
- Android emulator or physical device

## Part 1: Get Plaid Credentials (5 minutes)

### Step 1: Create Plaid Account

1. Go to **https://dashboard.plaid.com/signup**
2. Fill in the signup form:
   - Email
   - Password
   - Company name (can use "PocketPact Test")
   - Accept terms
3. Click **Sign Up**

### Step 2: Access Dashboard

After signup, you'll be in the Plaid Dashboard.

### Step 3: Get Your Credentials

1. Click on **Team Settings** (gear icon) in the left sidebar
2. Click on **Keys** tab
3. You'll see:
   ```
   client_id: 63f9a1234567890abcdef123
   
   Sandbox:
   secret: 1234567890abcdef1234567890abcdef
   ```

4. **Copy these values** - you'll need them!

   ✅ **client_id** - Same for all environments  
   ✅ **sandbox secret** - For development/testing

## Part 2: Backend Setup (5 minutes)

### Step 1: Navigate to Backend Folder

```powershell
cd backend
```

### Step 2: Install Dependencies

```powershell
npm install
```

This will install:
- express (web server)
- plaid (Plaid Node SDK)
- cors (cross-origin requests)
- dotenv (environment variables)

### Step 3: Create Environment File

```powershell
# Copy the example file
Copy-Item .env.example .env
```

### Step 4: Add Your Credentials

Open `backend\.env` in VS Code and edit:

```env
PLAID_CLIENT_ID=63f9a1234567890abcdef123
PLAID_SECRET=1234567890abcdef1234567890abcdef
PLAID_ENV=sandbox
PORT=3000
```

Replace the values with YOUR actual credentials from Plaid Dashboard!

### Step 5: Start the Server

```powershell
npm start
```

You should see:

```
🚀 PocketPact Backend Server Started!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📡 Server running on: http://localhost:3000
🌍 Environment: sandbox
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Available Endpoints:
   GET  /api/health                  - Health check
   POST /api/create_link_token       - Create Plaid link token
   POST /api/exchange_public_token   - Exchange public token
   POST /api/transactions            - Get transactions
   POST /api/balance                 - Get account balance
```

✅ **Leave this terminal running!** Your backend server needs to stay active.

### Step 6: Test the Server

Open a **new terminal** and test:

```powershell
curl http://localhost:3000/api/health
```

Should return:
```json
{
  "status": "ok",
  "message": "PocketPact Backend Server is running!",
  "environment": "sandbox"
}
```

## Part 3: Update Flutter App (2 minutes)

### Step 1: Update Plaid Config

Open `lib/config/plaid_config.dart` and update:

```dart
class PlaidConfig {
  static const String environment = 'sandbox';
  
  // Add your client_id from Plaid Dashboard
  static const String clientId = '63f9a1234567890abcdef123';  // ⬅️ UPDATE THIS
  
  // Backend URL is already set to Android emulator address
  static const String backendUrl = 'http://10.0.2.2:3000/api';
  
  static const List<String> products = ['transactions', 'auth'];
  static const List<String> countryCodes = ['US'];
  static const String language = 'en';
}
```

### Step 2: Verify Connection

The backend URL `http://10.0.2.2:3000/api` is special:
- `10.0.2.2` = localhost from Android emulator's perspective
- `3000` = port your backend is running on
- `/api` = API endpoint prefix

## Part 4: Test the Integration (5 minutes)

### Step 1: Start the App

Make sure:
1. ✅ Backend server is running (from Part 2, Step 5)
2. ✅ Android emulator is running
3. ✅ PlaidConfig has your real client_id

```powershell
cd ..  # Go back to project root if in backend/
flutter run -d emulator-5554
```

### Step 2: Navigate to Link Bank Account

In the app:
1. Tap **Settings** (bottom navigation, gear icon)
2. Tap **Link Bank Account** (first option under Account section)

You should see a screen with:
- Purple gradient card
- "Connect Your Bank" title
- Benefits list
- "Connect Bank Account" button

### Step 3: Test Bank Linking

1. Tap **Connect Bank Account** button
2. Plaid Link will open (blue Plaid interface)
3. Search for: **First Platypus Bank** (Plaid test bank)
4. Click on it
5. Use credentials:
   - Username: `user_good`
   - Password: `pass_good`
6. Select an account (checking or savings)
7. Click **Continue**

### Step 4: Verify Success

You should see:
- ✅ Green snackbar: "Bank account linked successfully!"
- ✅ Backend logs: "✅ Link token created", "✅ Public token exchanged"
- ✅ UI updates to show "Bank Account Connected"

## 🧪 Testing Scenarios

### Plaid Sandbox Test Accounts

| Username | Password | Behavior |
|----------|----------|----------|
| `user_good` | `pass_good` | ✅ Successful linking |
| `user_bad` | `pass_bad` | ❌ Invalid credentials |
| `user_custom` | `pass_good` | Multi-factor auth flow |

### Common Test Banks

- **First Platypus Bank** - Standard checking/savings
- **Tartan Bank** - Multiple account types
- **Houndstooth Bank** - Credit cards

## 🐛 Troubleshooting

### Backend Issues

#### "Cannot find module 'express'"
```powershell
cd backend
npm install
```

#### "Plaid credentials not configured"
- Check `.env` file exists (not `.env.example`)
- Verify client_id and secret are copied correctly
- Restart the server after editing `.env`

#### "EADDRINUSE: Port 3000 already in use"
```powershell
# Find and kill process on port 3000
Get-NetTCPConnection -LocalPort 3000 | Select-Object OwningProcess
Stop-Process -Id <PID>

# Or use a different port in .env
PORT=3001
```

### Flutter App Issues

#### "Failed to initialize Plaid Link"
- Backend not running → Start backend server
- Wrong backend URL → Verify `backendUrl` in PlaidConfig
- Network issues → Check emulator has internet

#### "Invalid client_id"
- Update `clientId` in `lib/config/plaid_config.dart`
- Copy from Plaid Dashboard → Team Settings → Keys

#### "Connection refused"
- Android emulator: Use `10.0.2.2` instead of `localhost`
- Physical device: Use your computer's IP (e.g., `192.168.1.100:3000`)

#### Plaid Link doesn't open
- Check plaid_flutter version in pubspec.yaml
- Run `flutter pub get`
- Check for errors in terminal

### Network Testing

Test backend from emulator's perspective:

```powershell
# In emulator terminal (adb shell)
curl http://10.0.2.2:3000/api/health
```

## 📱 Physical Device Setup

If testing on a physical device instead of emulator:

### Step 1: Find Your Computer's IP

```powershell
ipconfig
```

Look for IPv4 Address (e.g., `192.168.1.100`)

### Step 2: Update Flutter Config

```dart
static const String backendUrl = 'http://192.168.1.100:3000/api';
```

### Step 3: Allow Firewall Access

Windows Firewall may block connections. Allow Node.js when prompted.

## 🎯 Next Steps

After successful integration:

1. ✅ Test transaction fetching
2. ✅ Test balance checking
3. ✅ Implement in other screens (Dashboard, Pact Detail)
4. ✅ Add error handling for production
5. ✅ Set up proper database for access tokens
6. ✅ Move to Plaid Development environment when ready

## 📚 Resources

- [Plaid Documentation](https://plaid.com/docs/)
- [Plaid API Reference](https://plaid.com/docs/api/)
- [Plaid Flutter Package](https://pub.dev/packages/plaid_flutter)
- [Backend README](backend/README.md)

## ✅ Checklist

Before asking for help, verify:

- [ ] Backend server is running (green startup message)
- [ ] .env file exists with real credentials (not example)
- [ ] PlaidConfig has your real client_id
- [ ] Backend URL is correct for your setup (emulator vs device)
- [ ] Flutter app is running without errors
- [ ] Using Plaid sandbox test credentials (user_good / pass_good)

---

**Need help?** Check the troubleshooting section above or backend logs for detailed error messages!
