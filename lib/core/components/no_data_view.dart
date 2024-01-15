import 'package:ecommerce_user/core/components/custom_image.dart';
import 'package:ecommerce_user/core/constants/dimensions.dart';
import 'package:ecommerce_user/core/extensions/image_path.dart';
import 'package:ecommerce_user/core/extensions/style.dart';
import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  final String message;
  const NoDataView({super.key, this.message = 'No data found'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(
            height: 200,
            width: 200,
            fit: BoxFit.fitWidth,
            imagePath: Images.noDataImage,
          ),
          const SizedBox(height: Dimensions.paddingMedium),

          Text(message, style: const TextStyle().regular.copyWith(fontSize: Dimensions.fontSizeSmall)),
        ],
      )
    );
  }
}
