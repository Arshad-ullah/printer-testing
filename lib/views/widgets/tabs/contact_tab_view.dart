import 'package:flutter/material.dart';

class ContactTabView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController roleController;

  const ContactTabView({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.roleController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: const Icon(Icons.badge, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: const Icon(Icons.phone, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: roleController,
                  decoration: InputDecoration(
                    labelText: 'Role / Title',
                    prefixIcon: const Icon(Icons.work_outline, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
