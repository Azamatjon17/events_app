import 'package:events_app/views/widgets/reminder_page.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.orange, size: 100),
              SizedBox(height: 20),
              Text(
                'Tabriklaymiz!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Siz Flutter Global Hakaton 2024 tadbiriga muvaffaqiyatli ro\'yxatdan o\'tdingiz.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReminderPage()),
                  );
                },
                child: Text('Eslatma Belgilash'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Bosh Sahifa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
