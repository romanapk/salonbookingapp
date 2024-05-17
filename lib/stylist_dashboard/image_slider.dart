import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderss extends StatefulWidget {
  const ImageSliderss({super.key});

  @override
  _ImageSliderssState createState() => _ImageSliderssState();
}

class _ImageSliderssState extends State<ImageSliderss> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/images/3.jpeg',
      'assets/images/6.jpeg',
      'assets/images/1.jpeg',
      'assets/images/4.jpeg',
      'assets/images/5.jpeg',
      'assets/images/2.jpeg',
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), // Increased bottom padding
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 2000),
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            carouselController: _carouselController,
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.map((url) {
            int index = images.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
