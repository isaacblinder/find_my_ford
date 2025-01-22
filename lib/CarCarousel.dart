import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class  CarCarousel extends StatefulWidget {

  @override
  State<CarCarousel> createState() => _CarCarouselState();

}

class _CarCarouselState extends State<CarCarousel> {
    List carList = [];

    // retrieve data from firebase
    void getData() async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('cars/').get();
      if (snapshot.exists) {
          final data = snapshot.value;
          if (data != null) {
            setState(() {
            carList = data as List;
          });
          } 
          
      } else {
          print('No data available.');
      }
    }

    @override
    void initState() {
      super.initState();
      getData();
    }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          CarouselSlider(
              items: [for (final value in carList) CarouselItem(car: Car.fromJson(Map<String, dynamic>.from (value as Map)))],
            
              options: CarouselOptions(
                height: 800.0,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
          ),
        ],
      );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.car
  });

  final Car car;

  String get getFormattedPrice {
    var formatter = NumberFormat('#,##,000');
    return '\$${formatter.format(car.price)}';
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(   
          children: [
            SizedBox(height: 20),
            Container(
              height: 155,
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(car.imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
            spacing: 12,
            children: [
              SizedBox(height: 19),
              Text(car.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Theme.of(context).colorScheme.tertiaryContainer, shadows: [Shadow(color: Colors.grey, blurRadius: 5.0, offset: Offset(3.1, 3.1))])),
              CarDetails(getFormattedPrice: getFormattedPrice, car: car)
            ]
      ),
            ],
      ),
    );
  }
}

class CarDetails extends StatelessWidget {
  const CarDetails({
    super.key,
    required this.getFormattedPrice,
    required this.car,
  });

  final String getFormattedPrice;
  final Car car;

  @override
  Widget build(BuildContext context) {
    return Card(
      child:SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            child: Column(
              spacing: 4,
              children: [
                Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Price: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: getFormattedPrice),
                    ],
                  ),
                ),
              ),
                SizedBox(height: 2),
                Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Model: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${car.model}'),
                    ],
                  ),
                ),
              ),
                SizedBox(height: 35),
                RatingElement(rating: car.durability, attribute: 'Durability'),
                RatingElement(rating: car.mileage, attribute: 'Mileage'),
                RatingElement(rating: car.steering, attribute: 'Steering'),
                RatingElement(rating: car.towing, attribute: 'Towing'),
                RatingElement(rating: car.resaleValue, attribute: 'Resale Value'),
            ],),
          ),
        ),
    );
  }
}

class RatingElement extends StatelessWidget {
  const RatingElement({
    super.key,
    required this.rating,
    required this.attribute,
  });

  final int rating;
  final String attribute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(children: [
        SizedBox(width: 95, child: Text(attribute, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        SizedBox(width: 15),
        for (var i = 1; i <= rating; i += 1) Icon(
          Icons.star,
          shadows: [Shadow(color: Colors.grey, blurRadius: 5.0, offset: Offset(1, 1))],
          color: Colors.green,
          size: 20.0,
        ),
      ],),
    );
  }
}


// data types
class Car {
  final String imgUrl;
  final int model;
  final String name;
  final int price;
  final int durability;
  final int mileage;
  final int steering;
  final int towing;
  final int resaleValue;

  const Car({
    required this.imgUrl,
    required this.model,
    required this.name,
    required this.price,
    required this.durability,
    required this.mileage,
    required this.steering,
    required this.towing,
    required this.resaleValue,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
          imgUrl: json['imgUrl'],
          model: json["model"],
          name: json["name"],
          price: json["price"],
          durability: json["durability"],
          mileage: json["mileage"],
          steering: json["steering"],
          towing: json["towing"],
          resaleValue: json["resaleValue"]
        );
  }
}