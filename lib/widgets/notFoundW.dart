import 'package:flutter/material.dart';

class NotFoundW {
  Container Error404(context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(MediaQuery.of(context).size.width >
                    MediaQuery.of(context).size.height
                ? 'assets/image/notFoundW/notFound2.png'
                : 'assets/image/notFoundW/notFound1.png'),
            fit: BoxFit.cover),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
