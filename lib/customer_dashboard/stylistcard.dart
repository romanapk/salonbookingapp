import 'package:flutter/material.dart';
import 'package:salonbookingapp/customer_dashboard/stylists.dart';

class StylistCard extends StatelessWidget {
  final Stylist stylist;

  const StylistCard({required this.stylist});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(stylist.name),
        subtitle: Text(stylist.category),
        trailing: Text('${stylist.distance.toStringAsFixed(1)} km'),
        onTap: () {
          // Handle onTap event if needed
        },
      ),
    );
  }
}
