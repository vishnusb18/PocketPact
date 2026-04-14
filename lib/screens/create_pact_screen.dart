// Create Pact Screen
// Form for creating a new pact.
// Allows user to set pact name, description + goal amount, target date, and add members.
// Validates input and saves new pact.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePactScreen extends StatefulWidget {
  const CreatePactScreen({super.key});

  @override
  State<CreatePactScreen> createState() => _CreatePactScreenState();
}

class _CreatePactScreenState extends State<CreatePactScreen> {
  final _pactNameController   = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController   = TextEditingController();
  final _membersController    = TextEditingController();

  @override
  void dispose() {
    _pactNameController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  void _onCreatePact() {
    final pactName    = _pactNameController.text.trim();
    final description = _descriptionController.text.trim();
    final deadline    = _deadlineController.text.trim();

    if (pactName.isEmpty || description.isEmpty || deadline.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    // NOTE: rmbr to pass data to state / backend when ready.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6D4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6D4F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Center(
                child: Text(
                  'Create New Pact',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Pact name
              _buildLabel('Pact Name:'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _pactNameController,
                placeholder: 'Ex: "Super Savers"',
              ),
              const SizedBox(height: 28),

              // Describe pact + goal amount
              _buildLabel('Describe Pact & Goal Amount:'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _descriptionController,
                placeholder: 'Ex: "Save \$100"',
              ),
              const SizedBox(height: 28),

              // Deadline
              _buildLabel('Target Date (MM/DD/YYYY):'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _deadlineController,
                placeholder: 'MM/DD/YYYY',
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  _DateInputFormatter(),
                ],
              ),
              const SizedBox(height: 28),

              // Add members
              _buildLabel('Add members:'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _membersController,
                placeholder: 'Ex: "Charles Smith"',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 48),

              // Create pact button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onCreatePact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Pact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}

// auto formats date input as MM/DD/YYYY while typing for consistency.

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll('/', '');
    if (digitsOnly.length > 8) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digitsOnly[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
