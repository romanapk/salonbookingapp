import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RescheduleAppointmentPage extends StatefulWidget {
  final DocumentSnapshot notification;

  const RescheduleAppointmentPage({Key? key, required this.notification})
      : super(key: key);

  @override
  _RescheduleAppointmentPageState createState() =>
      _RescheduleAppointmentPageState();
}

class _RescheduleAppointmentPageState extends State<RescheduleAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _dayController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _dayController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _rescheduleAppointment() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance.collection('appointments').add({
          'appBy': FirebaseAuth.instance.currentUser?.uid,
          'appDay': _dayController.text,
          'appTime': _timeController.text,
          'appName': widget.notification['appName'],
          'appMobile': widget.notification['appMobile'],
          'appMsg': widget.notification['appMsg'],
          'appWith': widget.notification['appWith'],
          'appStylistName': widget.notification['appStylistName'],
          'appStylistNum': widget.notification['appStylistNum'],
          'status': 'pending',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment rescheduled successfully')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reschedule appointment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reschedule Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dayController,
                decoration: const InputDecoration(labelText: 'Day'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a day';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _rescheduleAppointment,
                child: const Text('Reschedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
