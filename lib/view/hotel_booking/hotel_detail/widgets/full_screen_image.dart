import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ));
  }
}

//=================================================================================================

class FullScreenImageChalet extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageChalet({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ));
  }
}
