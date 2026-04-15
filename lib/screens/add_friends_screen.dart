// Add Friends Screen
// Form for adding money to a pact
// Allows user to enter contribution amount and optional note
// Updates pact progress and records transaction

import 'package:flutter/material.dart';

class AddFriendScreen extends StatelessWidget {
  const AddFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'PocketPact',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Requests'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(), // Content for Requests tab
            const Center(child: Text('Friends List')), // Placeholder for Friends tab
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFE6D4F7),
          elevation: 2,
          shape: const CircleBorder(side: BorderSide(color: Color(0xFF9D4EDD), width: 2)),
          child: const Icon(Icons.add, color: Color(0xFF7B2CBF), size: 30),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    // Data based on your screenshot
    final List<Map<String, String>> users = [
      {
        'name': 'TechGuru87',
        'handle': '@TechMaster',
        'bio': 'Tech enthusiast providing insights, tips, and reviews on the latest gadg...'
      },
      {
        'name': 'ArtisticSoul',
        'handle': '@SoulfulArt',
        'bio': 'Expressing my artistic journey through paintings, sketches, and cre...'
      },
      {
        'name': 'FitnessFreak',
        'handle': '@FitFreak',
        'bio': 'Dedicated to health and fitness, offering workout routines, nutrition a...'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Placeholder
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey.shade100,
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      users[index]['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      users[index]['handle']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      users[index]['bio']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Add Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D2D), // Charcoal color from mockup
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(70, 40),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
