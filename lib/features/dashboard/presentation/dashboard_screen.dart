import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text('Home'),
            Text('मुख्यपृष्ठ', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: const Center(
        child: Text('Dashboard Placeholder'),
      ),
    );
  }
}
