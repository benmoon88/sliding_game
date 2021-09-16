
// When ResetButton is called it builds the button that will shuffle all objects in the imageSlicer array.
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResetButton extends StatelessWidget {
  Function reset;
  ResetButton(this.reset);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: reset,
    child: Text("Reset"),
    style: ElevatedButton.styleFrom(
      primary: Colors.white,  // Background color of the button
      onPrimary: Colors.black, // when pressing the button, the fade that comes over it is this color
      fixedSize: Size(400, 100),
      enableFeedback: true,
    ),      
  );
}