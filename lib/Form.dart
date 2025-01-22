import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();

}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // A key for managing the form
  String _name = ''; // Variable to store the entered name
  String _email = ''; // Variable to store the entered email
   late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Text _text(String text) => Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      );

  void _submitForm() async {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data
      // You can perform actions with the form data here and extract the details
      print('Name: $_name'); // Print the name
      print('Email: $_email'); // Print the email
    }
    _controllerCenter.play();
    await Future.delayed(const Duration(seconds: 2));
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, // Associate the form key with this Form widget
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'), // Label for the name field
                validator: (value) {
                  // Validation function for the name field
                  if (value!.isEmpty) {
                    return 'Please enter your name.'; // Return an error message if the name is empty
                  }
                  return null; // Return null if the name is valid
                },
                onSaved: (value) {
                  _name = value!; // Save the entered name
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'), // Label for the email field
                validator: (value) {
                  // Validation function for the email field
                  if (value!.isEmpty) {
                    return 'Please enter your email.'; // Return an error message if the email is empty
                  }
                  // You can add more complex validation logic here
                  return null; // Return null if the email is valid
                },
                onSaved: (value) {
                  _email = value!; // Save the entered email
                },
              ),
              SizedBox(height: 20.0),
              CircularSliderWidget(),
              ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
              ElevatedButton(
                onPressed: _submitForm, // Call the _submitForm function when the button is pressed
                child: Text('Submit'), // Text on the button
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CircularSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
          initialValue: 40, // Initial value
          max: 100, // Maximum value
          appearance: CircularSliderAppearance(
            customColors: CustomSliderColors(
              progressBarColors: [Colors.blue], // Customize progress bar colors
              trackColor: Colors.grey, // Customize track color
              shadowColor: Colors.green, // Customize shadow color
              shadowMaxOpacity: 0.2, // Set shadow maximum opacity
            ),
            customWidths: CustomSliderWidths(
              progressBarWidth: 12, // Set progress bar width
              trackWidth: 12, // Set track width
              shadowWidth: 20, // Set shadow width
            ),
            size: 150, // Set the slider's size
            startAngle: 150, // Set the starting angle
            angleRange: 240, // Set the angle range
            infoProperties: InfoProperties(
              // Customize label style
              mainLabelStyle: TextStyle(fontSize: 24, color: Colors.blue), 
              modifier: (double value) {
                // Display value as a percentage
                return '${value.toStringAsFixed(0)}%'; 
              },
            ),
            spinnerMode: false, // Disable spinner mode
            animationEnabled: true, // Enable animation
          ),
          onChange: (double value) {
            // Handle value change here
          },
        );
  }
}