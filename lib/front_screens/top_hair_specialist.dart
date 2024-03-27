import 'package:flutter/material.dart';
import 'package:salonbookingapp/Utils/app_style.dart';

class TopHairSpecialist extends StatelessWidget {
  const TopHairSpecialist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            color: Styles.orangeColor,
            padding: const EdgeInsets.all(6),
            child: const Text(
              'Top Hair Specialist',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Styles.textColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildArtistCircle(context, 'assets/images/St 1.jpeg'),
              _buildArtistCircle(context, 'assets/images/St 2.jpeg'),
              _buildArtistCircle(context, 'assets/images/St 3.jpeg'),
              _buildArtistCircle(context, 'assets/images/St 4.jpeg'),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement your booking logic here
              _showBookFavArtistDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.orangeColor,
            ),
            child: const Text(
              'Book Fav Artist',
              style: TextStyle(color: Styles.textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistCircle(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        _showSelectedArtistDialog(context, imagePath);
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Styles.orangeColor,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> _showSelectedArtistDialog(
      BuildContext context, String imagePath) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Perform booking logic here
                  _showBookFavArtistDialog(context);
                },
                child: const Text('Book This Artist'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBookFavArtistDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmed'),
          content:
              const Text('You have successfully booked your favorite artist!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
