import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Eslatma kuni',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '14 09 2024',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Eslatma vaqti',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '09:00',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle reminder logic here
                },
                child: Text('Eslatish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
