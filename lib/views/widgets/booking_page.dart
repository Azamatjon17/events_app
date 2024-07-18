import 'package:events_app/views/widgets/success_page.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int seats = 0;
  String? paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ro\'yxatdan O\'tish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Joylar sonini tanlang', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (seats > 0) seats--;
                    });
                  },
                ),
                Text(seats.toString(), style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      seats++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('To\'lov turini tanlang', style: TextStyle(fontSize: 18)),
            RadioListTile<String>(
              title: const Text('Click'),
              value: 'Click',
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Payme'),
              value: 'Payme',
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Naqd'),
              value: 'Naqd',
              groupValue: paymentMethod,
              onChanged: (value) {
                setState(() {
                  paymentMethod = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuccessPage()),
                );
              },
              child: Text('Keyingi'),
            ),
          ],
        ),
      ),
    );
  }
}
