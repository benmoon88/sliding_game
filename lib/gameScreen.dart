import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'widgets/resetbutton.dart';
import 'widgets/tilegrid.dart';


// Build the board in which the game is played
class GameScreen extends StatefulWidget {
  @override
  _GameScreen createState() => _GameScreen();
}

class _GameScreen extends State<GameScreen> {
  Uint8List imageIsNowNumbers;
  List<Image> slicedImages = [];
  int GRIDSIZE = 3, TILETOREMOVE = 0; // Total Gridsize or choose which tile dissapears from the grid.
  Image imageToRemove; Image rememberImageToRemove;
  var file = "assets/felix.jpg";

  // These widget overrides occur everytime a new state is detected.
  @override
  Widget build(BuildContext context) {
    // makes sure the grid is loaded before loading the widget
    if (slicedImages.length != GRIDSIZE*GRIDSIZE) {
      loadAsset(file); // if this is put here instead of an initial state, can add a value slider in the future to change gridSize when reload button is pressed.
      return Center(child: CircularProgressIndicator(
        value: null,
        backgroundColor: Colors.black87,
        color: Colors.red,
      ));
    }
    else {
      final size = MediaQuery.of(context).size; // gets the size of the screen
      return SafeArea(
        child: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.black87, // background colour
          child: Column(
            children: <Widget>[
              TileGrid(slicedImages, imageToRemove, size, GRIDSIZE, clickTile),
              ResetButton(reset)
            ],
          ),
        ),
      );
    }
  }

  // this loads the specified image into an array of integers, such that the image can be spliced into the grid size.
  void loadAsset(var file) async {
    Uint8List imageIsNowNumbers = (await rootBundle.load(file)).buffer.asUint8List(); // converts image to bytes
    await setState(() => slicedImages = imageSlicer(imageIsNowNumbers));
  }
  
  List<Image> imageSlicer(List<int> input) {
    // convert the list of bytes into an Image
    img.Image image = img.decodeImage(input);
    int x = 0, y = 0;
    int width = (image.width / GRIDSIZE).floor();
    int height = (image.height / GRIDSIZE).floor(); // can adjust these weights with globals later to make board size adjustable.
    // split image to parts
    List<img.Image> parts = [];
    for (int i = 0; i < GRIDSIZE; i++) {
      for (int j = 0; j < GRIDSIZE; j++) {
        parts.add(img.copyCrop(image, x, y, width, height));
        x += width;
      } x = 0; y += height;
    }
    // encode image parts back into Image widgets for display (img.Image is not a widget, just used to encode/decord images, or to manipulate images)
    List<Image> output = [];
    for (var eachImage in parts) {
      output.add(Image.memory(img.encodeJpg(eachImage)));
    } 
    this.imageToRemove = output[TILETOREMOVE];
    this.rememberImageToRemove = output[TILETOREMOVE];
    return output;
  }

  void clickTile(index) {             // This part destroyed my mind     
    // image or image index cannot be below 0 or above the total grid size.
    //                                             check if the empty tile's (rememberImageToRemove) is not greater then or less than the total gridsize and                                                            
    if (  index - 1         >=  0                     && slicedImages[index - 1]        == rememberImageToRemove     && index % GRIDSIZE        != 0 ||   // left of the clicked tile
          index + 1         <   (GRIDSIZE*GRIDSIZE)   && slicedImages[index + 1]        == rememberImageToRemove     && (index + 1) % GRIDSIZE  != 0 ||   // right of the clicked tile
        ( index - GRIDSIZE  >=  0                     && slicedImages[index - GRIDSIZE] == rememberImageToRemove) ||                                      // above the clicked tile
        ( index + GRIDSIZE  <   (GRIDSIZE*GRIDSIZE)   && slicedImages[index + GRIDSIZE] == rememberImageToRemove))                                        // below the clicked tile
      {
      setState(() { // move the clicked tile to empty tile, and empty tile to the clicked tile.
        slicedImages[slicedImages.indexOf(imageToRemove)] = slicedImages[index];
        slicedImages[index] = imageToRemove;
      });
    } else { print("UserError: Wrong tile selected"); }
  }

  void reset() {
    // this will create a new state (shuffling the pictures)
    setState(() {
      slicedImages.shuffle();
    });
  }
}