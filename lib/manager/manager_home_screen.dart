import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salonbookingapp/manager/removeacceptedstylist.dart';
import 'package:velocity_x/velocity_x.dart';

class ManagerHomeScreen extends StatefulWidget {
  @override
  _ManagerHomeScreenState createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Stylists'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            tabs: [
              Tab(text: 'Requests'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: [
            buildPendingStylists(context),
            buildAcceptedStylists(context),
            buildRejectedStylists(context),
          ],
        ),
      ),
    );
  }

  Widget buildPendingStylists(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('pendingStylists').snapshots(),
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
                    onPressed: () => rejectStylistRequest(context, doc.id),
                  ),
                ],
              ),
              onTap: () {
                showStylistDetails(context, stylist);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildAcceptedStylists(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('acceptedStylists').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator().centered();
        }
        if (snapshot.hasError) {
          return Text('Something went wrong').centered();
        }
        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Text('No accepted stylists').centered();
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var stylist = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(stylist['stylistName']),
              subtitle: Text(stylist['stylistEmail']),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeAcceptedStylist(
                    context, doc.id, stylist['stylistName']),
              ),
              onTap: () {
                showStylistDetails(context, stylist);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget buildRejectedStylists(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('rejectedStylists').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator().centered();
        }
        if (snapshot.hasError) {
          return Text('Something went wrong').centered();
        }
        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Text('No rejected requests').centered();
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var stylist = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(stylist['stylistName']),
              subtitle: Text(stylist['stylistEmail']),
              onTap: () {
                showStylistDetails(context, stylist);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void showStylistDetails(BuildContext context, Map<String, dynamic> stylist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stylist['stylistName']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${stylist['stylistEmail']}'),
            Text('Phone: ${stylist['stylistPhone']}'),
            Text('Address: ${stylist['stylistAddress']}'),
            Text('Category: ${stylist['stylistCategory']}'),
            Text('Service: ${stylist['stylistService']}'),
            Text('Base Price: ${stylist['stylistAbout']}'),
            Text('Timing: ${stylist['stylistTiming']}'),
            if (stylist.containsKey('certificateUrl'))
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CertificateViewScreen(
                          imageUrl: stylist['certificateUrl']),
                    ),
                  );
                  // Navigate or show a larger view of the certificate image
                  // Example: Navigator.push(...);
                },
                child: Image.network(
                  stylist['certificateUrl'],
                  width: 200, // Adjust size as needed
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
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
            .collection('acceptedStylists')
            .doc(requestId)
            .set(stylist);
        await stylistDoc.delete();
      }
    } catch (e) {
      // Handle errors
    }
  }

  void rejectStylistRequest(BuildContext context, String requestId) async {
    // Display a confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Reject'),
        content: Text('Are you sure you want to reject this stylist request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        var stylistDoc = FirebaseFirestore.instance
            .collection('pendingStylists')
            .doc(requestId);
        var stylistData = await stylistDoc.get();

        if (stylistData.exists) {
          var stylist = stylistData.data() as Map<String, dynamic>;
          stylist['status'] = 'rejected';

          await FirebaseFirestore.instance
              .collection('rejectedStylists')
              .doc(requestId)
              .set(stylist);
          await stylistDoc.delete();
        }
      } catch (e) {
        // Handle errors
      }
    }
  }

  void removeAcceptedStylist(
      BuildContext context, String stylistId, String stylistName) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Removal'),
        content: Text('Are you sure you want to remove this stylist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Your existing code to remove the accepted stylist
        await FirebaseFirestore.instance
            .collection('acceptedStylists')
            .doc(stylistId)
            .delete();
        // Also add the stylist to the 'removedStylists' collection
        await FirebaseFirestore.instance
            .collection('removedStylists')
            .doc(stylistId)
            .set({
          'stylistName': stylistName, // Add other fields as needed
          // Add other fields as needed
        });
        // Navigate to the removed stylists screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RemovedStylistsScreen()),
        );
      } catch (e) {
        // Handle errors
      }
    }
  }
}

class CertificateViewScreen extends StatelessWidget {
  final String imageUrl;

  CertificateViewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificate'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain, // Adjust the fit as needed
        ),
      ),
    );
  }
}
