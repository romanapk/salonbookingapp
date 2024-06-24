import '../../Utils/app_style.dart';
import '../../general/consts/consts.dart';

class StylistNotificationsPage extends StatelessWidget {
  const StylistNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Notifications'),
      //   backgroundColor: Styles.bgColor, // Set app background color for app bar
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching notifications: ${snapshot.error}',
                style: TextStyle(color: Styles.textColor), // Set text color
              ),
            );
          }

          var notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications',
                style: TextStyle(color: Styles.textColor), // Set text color
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              var notificationData =
                  notification.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                color: Styles.darkColor, // Set card background color
                child: ListTile(
                  title: Text(
                    notificationData['message'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Styles.textColor, // Set text color
                    ),
                  ),
                  subtitle: Text(
                    'Received: ${_formatTimestamp(notificationData['timestamp'])}',
                    style: TextStyle(
                      color: Styles.textColor
                          .withOpacity(0.7), // Set text color with opacity
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    return timestamp.toDate().toString();
  }
}
