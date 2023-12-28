import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kawtharuna/src/core/widgets/image/image_network_circle.dart';

/// General Image widget which can accept all image types url, svg and assets.
///
/// This widget has two major parameters. The [path] parameter is required and
/// used to determine the type of image after doing some check for some normal
/// standards. [isCircular] param is by default considered to be false hence
/// the image is rendered as a rectangle image and [radius] param will be ignored
/// with values of [width] and [height] in case they are passed. On the other hand
/// if the [isCircular] is true then the image will be interpreted as a circular
/// image and the size of it will depend on [radius] exclusively. The [borderRadius]
/// param will be meaningful just in case the image is not a circle one.
class AppImageWidget extends StatelessWidget {
  final String path;
  final Color? color;
  final double width;
  final double height;
  final double radius;
  final double borderRadius;
  final bool isCircular;
  final BoxFit boxFit;

  const AppImageWidget({
    required this.path,
    this.color,
    this.boxFit = BoxFit.cover,
    this.radius = 0.0,
    this.borderRadius = 0.0,
    this.width = 20.0,
    this.height = 20.0,
    this.isCircular = false,
    Key? key,
  }) : super(key: key);

  bool get isNetworkImage {
    return path.startsWith('http') ||
        path.startsWith('https') ||
        path.contains('http') ||
        path.contains('https');
  }

  bool get isSvgImage {
    return path.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    double? width;
    double? height;
    Widget? image;

    /// Setting up the size, position and styling.
    // if (isCircular) {
    //   width = width;
    //   height = height;
    // } else {
    width = this.width;
    height = this.height;
    // }

    /// Inferring image type upon the url or path.
    if (isNetworkImage) {
      image = ImageNetworkCircleWidget(
        imageUrl: path,
        boxFit: boxFit,
        imagePlaceHolderBackgroundColor: color,
      );
    } else if (isSvgImage) {
      image = SvgPicture.asset(
        path,
        height: height,
        width: width,
        color: color,
        fit: boxFit,
      );
    } else {
      image = Image.asset(
        path,
        height: height,
        width: width,
        color: color,
        fit: boxFit,
      );
    }

    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius > 0.0 ? borderRadius : 0.0,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: image,
      ),
    );

    return child;
  }
}