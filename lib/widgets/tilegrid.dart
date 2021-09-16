// When Grid() is called it builds the specified sized gamegrid for the Sliding puzzle
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TileGrid extends StatelessWidget {
  var images = [];
  var size; var imageToRemove; var gridSize;
  Function clickTile;
  TileGrid(this.images, this.imageToRemove, this.size, this.gridSize, this.clickTile); // Now we can use this in other classes that inherit from us!

  @override
  Widget build(BuildContext context) {
    var height = size.height;

    return Container(                 // container that contains the grid of tiles (images)
      height: height * 0.7,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            mainAxisSpacing: 5, // spacing between grid boxes
            crossAxisSpacing: 5,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            if (images[index] != imageToRemove) {
              return Tile(images[index], (){      // create buttons (itemCount)
                    clickTile(index);
                  });
            } else {
              return SizedBox(
                child: Card(
                  color: Colors.white12,
                )
              );
            }
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Tile extends StatelessWidget { // the widget that handles each tile that is created
  Function click;
  var picture;

  Tile(this.picture, this.click);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: click,
    style: ElevatedButton.styleFrom(
      primary: Colors.white,
      onPrimary: Colors.black87,
      padding: EdgeInsets.all(10),
      enableFeedback: true,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        picture,
      ],
    ),
  );
}