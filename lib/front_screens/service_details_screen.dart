import 'package:flutter/material.dart';


class ServiceDetailsScreen extends StatelessWidget {
  final String serviceName;

  const ServiceDetailsScreen(this.serviceName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
      ),
      body: Center(
        child: Text(
          'Details for $serviceName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}