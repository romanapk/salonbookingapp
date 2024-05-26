import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ManagerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Stylists'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pendingStylists')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator().centered();
          }
          if (snapshot.hasError) {
            return Text('Something went wrong').centered();
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text('No pending requests').centered();
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var stylist = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(stylist['stylistName']),
                subtitle: Text(stylist['stylistEmail']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => approveStylistRequest(doc.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => rejectStylistRequest(doc.id),
                    ),
                  ],
                ),
                onTap: () {
                  // Show stylist details
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(stylist['stylistName']),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Email: ${stylist['stylistEmail']}'),
                          Text('Phone: ${stylist['stylistPhone']}'),
                          Text('Address: ${stylist['stylistAddress']}'),
                          Text('Category: ${stylist['stylistCategory']}'),
                          Text('Service: ${stylist['stylistService']}'),
                          Text('About: ${stylist['stylistAbout']}'),
                          Text('Timing: ${stylist['stylistTiming']}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void approveStylistRequest(String requestId) async {
    try {
      var stylistDoc = FirebaseFirestore.instance
          .collection('pendingStylists')
          .doc(requestId);
      var stylistData = await stylistDoc.get();

      if (stylistData.exists) {
        var stylist = stylistData.data() as Map<String, dynamic>;
        stylist['status'] = 'approved';

        await FirebaseFirestore.instance
            .collection('stylists')
            .doc(requestId)
            .set(stylist);
        await stylistDoc.delete();

        // Notify stylist that their request has been approved
      }
    } catch (e) {
      // Handle errors
    }
  }

  void rejectStylistRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('pendingStylists')
          .doc(requestId)
          .update({'status': 'rejected'});
      // Optionally, notify stylist that their request has been rejected
    } catch (e) {
      // Handle errors
    }
  }
}
