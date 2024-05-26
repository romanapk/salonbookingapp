import 'package:salonbookingapp/general/consts/consts.dart';

class RemovedStylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Removed Stylists'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('removedStylists')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No removed stylists'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var stylist =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(stylist['stylistName'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stylist['stylistEmail'] ?? ''),
                      ],
                    ),
                    onTap: () {
                      showStylistDetails(context, stylist);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showStylistDetails(BuildContext context, Map<String, dynamic> stylist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stylist['stylistName'] ?? 'No Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${stylist['stylistEmail'] ?? 'No Email'}'),
            Text('Phone: ${stylist['stylistPhone'] ?? 'No Phone'}'),
            Text('Address: ${stylist['stylistAddress'] ?? 'No Address'}'),
            Text('Category: ${stylist['stylistCategory'] ?? 'No Category'}'),
            Text('Service: ${stylist['stylistService'] ?? 'No Service'}'),
            Text('About: ${stylist['stylistAbout'] ?? 'No About'}'),
            Text('Timing: ${stylist['stylistTiming'] ?? 'No Timing'}'),
          ],
        ),
      ),
    );
  }
}
