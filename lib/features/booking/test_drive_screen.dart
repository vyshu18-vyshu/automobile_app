import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../utils/constants.dart';
import '../../widgets/primary_button.dart';

class TestDriveScreen extends StatelessWidget {
  const TestDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve car from arguments (could be passed in different ways, simplified here)
    final car = ModalRoute.of(context)?.settings.arguments as Car?;

    return Scaffold(
      appBar: AppBar(title: const Text("Book Test Drive")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppLayout.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (car != null) ...[
              Text(
                "Booking for: ${car.brand} ${car.model}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppLayout.paddingL),
            ],

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Preferred Date",
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: AppLayout.paddingM),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Preferred Time",
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: AppLayout.paddingM),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: AppLayout.paddingXL),
            PrimaryButton(
              text: "Confirm Booking",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Booking Request Sent!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
