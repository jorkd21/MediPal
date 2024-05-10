import 'package:flutter/material.dart';

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  ImageDisplayPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Center(
        child: GestureDetector(
          child: InteractiveViewer(
            /*panEnabled: false,
            boundaryMargin: EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,*/
            child: Image.network(
              imageUrl,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Text('Error loading image');
              },
            ),
          ),
        ),
      ),
    );
  }
}
