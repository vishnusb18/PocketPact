// PocketPact Backend Server
// Handles Plaid API integration for bank account linking

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { Configuration, PlaidApi, PlaidEnvironments } = require('plaid');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Plaid Configuration
const configuration = new Configuration({
  basePath: PlaidEnvironments[process.env.PLAID_ENV || 'sandbox'],
  baseOptions: {
    headers: {
      'PLAID-CLIENT-ID': process.env.PLAID_CLIENT_ID,
      'PLAID-SECRET': process.env.PLAID_SECRET,
    },
  },
});

const plaidClient = new PlaidApi(configuration);

// In-memory storage for demo (use a database in production)
const accessTokens = new Map(); // Map<userId, accessToken>

// ============================================
// ENDPOINT 1: Create Link Token
// ============================================
app.post('/api/create_link_token', async (req, res) => {
  try {
    const { user_id } = req.body;
    
    if (!user_id) {
      return res.status(400).json({ error: 'user_id is required' });
    }

    const request = {
      user: {
        client_user_id: user_id,
      },
      client_name: 'PocketPact',
      products: ['transactions', 'auth'],
      country_codes: ['US'],
      language: 'en',
    };

    const response = await plaidClient.linkTokenCreate(request);
    
    console.log('✅ Link token created for user:', user_id);
    
    res.json({
      link_token: response.data.link_token,
      expiration: response.data.expiration,
    });
  } catch (error) {
    console.error('❌ Error creating link token:', error);
    res.status(500).json({
      error: 'Failed to create link token',
      details: error.response?.data || error.message,
    });
  }
});

// ============================================
// ENDPOINT 2: Exchange Public Token
// ============================================
app.post('/api/exchange_public_token', async (req, res) => {
  try {
    const { public_token, user_id } = req.body;
    
    if (!public_token) {
      return res.status(400).json({ error: 'public_token is required' });
    }

    const response = await plaidClient.itemPublicTokenExchange({
      public_token: public_token,
    });

    const accessToken = response.data.access_token;
    const itemId = response.data.item_id;

    // Store access token (in production, save to database)
    if (user_id) {
      accessTokens.set(user_id, accessToken);
      console.log('✅ Access token stored for user:', user_id);
    }

    console.log('✅ Public token exchanged successfully');
    console.log('   Item ID:', itemId);

    res.json({
      access_token: accessToken,
      item_id: itemId,
    });
  } catch (error) {
    console.error('❌ Error exchanging public token:', error);
    res.status(500).json({
      error: 'Failed to exchange public token',
      details: error.response?.data || error.message,
    });
  }
});

// ============================================
// ENDPOINT 3: Get Transactions
// ============================================
app.post('/api/transactions', async (req, res) => {
  try {
    const { access_token, start_date, end_date } = req.body;
    
    if (!access_token) {
      return res.status(400).json({ error: 'access_token is required' });
    }

    const request = {
      access_token: access_token,
      start_date: start_date || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      end_date: end_date || new Date().toISOString().split('T')[0],
    };

    const response = await plaidClient.transactionsGet(request);
    const transactions = response.data.transactions;

    console.log('✅ Retrieved', transactions.length, 'transactions');

    res.json({
      transactions: transactions,
      accounts: response.data.accounts,
      total_transactions: response.data.total_transactions,
    });
  } catch (error) {
    console.error('❌ Error fetching transactions:', error);
    res.status(500).json({
      error: 'Failed to fetch transactions',
      details: error.response?.data || error.message,
    });
  }
});

// ============================================
// ENDPOINT 4: Get Account Balance
// ============================================
app.post('/api/balance', async (req, res) => {
  try {
    const { access_token } = req.body;
    
    if (!access_token) {
      return res.status(400).json({ error: 'access_token is required' });
    }

    const response = await plaidClient.accountsBalanceGet({
      access_token: access_token,
    });

    const accounts = response.data.accounts;
    
    console.log('✅ Retrieved balance for', accounts.length, 'accounts');

    res.json({
      accounts: accounts.map(account => ({
        account_id: account.account_id,
        name: account.name,
        type: account.type,
        subtype: account.subtype,
        balance: {
          current: account.balances.current,
          available: account.balances.available,
          currency: account.balances.iso_currency_code,
        },
      })),
    });
  } catch (error) {
    console.error('❌ Error fetching balance:', error);
    res.status(500).json({
      error: 'Failed to fetch balance',
      details: error.response?.data || error.message,
    });
  }
});

// ============================================
// Health Check Endpoint
// ============================================
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'PocketPact Backend Server is running!',
    environment: process.env.PLAID_ENV || 'sandbox',
    timestamp: new Date().toISOString(),
  });
});

// ============================================
// Start Server
// ============================================
app.listen(PORT, '0.0.0.0', () => {
  console.log('');
  console.log('🚀 PocketPact Backend Server Started!');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`📡 Server running on: http://localhost:${PORT}`);
  console.log(`📱 Android Emulator: http://10.0.2.2:${PORT}`);
  console.log(`🌍 Environment: ${process.env.PLAID_ENV || 'sandbox'}`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('');
  console.log('📋 Available Endpoints:');
  console.log(`   GET  /api/health                  - Health check`);
  console.log(`   POST /api/create_link_token       - Create Plaid link token`);
  console.log(`   POST /api/exchange_public_token   - Exchange public token`);
  console.log(`   POST /api/transactions            - Get transactions`);
  console.log(`   POST /api/balance                 - Get account balance`);
  console.log('');
  
  if (!process.env.PLAID_CLIENT_ID || !process.env.PLAID_SECRET) {
    console.log('⚠️  WARNING: Plaid credentials not configured!');
    console.log('   Please set up your .env file with Plaid credentials');
    console.log('   See .env.example for instructions');
    console.log('');
  }
});

// Error handling
process.on('unhandledRejection', (error) => {
  console.error('❌ Unhandled rejection:', error);
});
