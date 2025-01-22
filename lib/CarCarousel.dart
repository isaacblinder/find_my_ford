import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class  CarCarousel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          CarouselSlider(
              items: [
                CarouselItem(
                  imgUrl: 'https://www.motortrend.com/uploads/sites/10/2023/03/2023-ford-explorer-xlt-suv-angular-front.png?w=768&width=768&q=75&format=webp',
                  name: 'Ford Explorer',
                  price: 35000,
                  model: 2024,
                  ),
                CarouselItem(
                  imgUrl: 'https://www.germainfordofbeavercreek.com/static/dealer-18421/Lineup-2410-Expedition.png',
                  name: 'Ford Expedition',
                  price: 25000,
                  model: 2015,
                  ),
                CarouselItem(
                  imgUrl: 'https://pictures.dealer.com/fd-DIG_IMAGES/f13154c6bef2d5ed3390079535f77423.png?w=640&impolicy=downsize_bkpt&imdensity=1',
                  name: 'Ford F150',
                  price: 60000,
                  model: 2018,
                ),
              ],
            
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
    this.imgUrl = '',
    this.price = 0,
    this.name = '',
    this.model = 0
  });

  final String imgUrl;
  final int price;
  final String name;
  final int model;

  String get getFormattedPrice {
    var formatter = NumberFormat('#,##,000');
    return '\$${formatter.format(price)}';
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
                  image: NetworkImage(this.imgUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
            spacing: 12,
            children: [
              SizedBox(height: 19),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Theme.of(context).colorScheme.tertiaryContainer, shadows: [Shadow(color: Colors.grey, blurRadius: 5.0, offset: Offset(3.1, 3.1))])),
              CarDetails(getFormattedPrice: getFormattedPrice, model: model)
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
    required this.model,
  });

  final String getFormattedPrice;
  final int model;

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
                      TextSpan(text: '$model'),
                    ],
                  ),
                ),
              ),
                SizedBox(height: 35),
                RatingElement(rating: 4, attribute: 'Durability'),
                RatingElement(rating: 3, attribute: 'Mileage'),
                RatingElement(rating: 5, attribute: 'Steering'),
                RatingElement(rating: 5, attribute: 'Towing'),
                RatingElement(rating: 2, attribute: 'Resale Value'),
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
