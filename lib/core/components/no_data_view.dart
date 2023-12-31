import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/core/extensions/image_path.dart';
import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  const NoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomImage(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.6,
        fit: BoxFit.fitWidth,
        imagePath: Images.noData,
      )
    );
  }
}
