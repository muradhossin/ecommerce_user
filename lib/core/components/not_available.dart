import 'package:ecommerce_user/core/extensions/context.dart';
import 'package:flutter/material.dart';

class NotAvailable extends StatelessWidget {
  final double? borderRadius;
  const NotAvailable({super.key, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: const Center(
        child: Text('Not Available', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
